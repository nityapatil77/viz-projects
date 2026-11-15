"""
MGT 4074 Final Project: Crypto prices vs. regulatory announcements
Event study + regression comparison of regulation vs. macro factors.

Install:  pip install yfinance pandas numpy matplotlib statsmodels requests
Run:      python crypto_event_study.py
Output:   ./output/  (PNG charts + CSV tables)

DATA SOURCES (all free, no API key needed)
  - yfinance (Yahoo Finance): daily price/volume for BTC, ETH, SOL, COIN, ^GSPC, ^VIX
  - FRED CSV endpoint:        10-yr Treasury yield (DGS10)
  - Coinbase Exchange API:    hourly BTC/ETH/SOL candles for the Sept 15 intraday chart
  - congress.gov API (optional, needs free key): confirm legislative dates
"""

import os
from datetime import datetime, timedelta, timezone

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import requests
import statsmodels.api as sm
import yfinance as yf

# ----------------------------------------------------------------------------
# CONFIG: edit these
# ----------------------------------------------------------------------------
START = "2024-06-01"
END = datetime.today().strftime("%Y-%m-%d")

CRYPTO = {"BTC-USD": "Bitcoin", "ETH-USD": "Ethereum", "SOL-USD": "Solana", "COIN": "Coinbase"}
CONTROLS = {"^GSPC": "SP500", "^VIX": "VIX"}

# VERIFY every date against congress.gov before submitting. Add more as you find them.
EVENTS = {
    "GENIUS Senate passes (2025-06-17)": "2025-06-17",
    "CLARITY House passes (2025-07-17)": "2025-07-17",
    "GENIUS signed into law (2025-07-18)": "2025-07-18",
    "CLARITY Senate cloture fails (2026-09-15)": "2026-09-15",
}

# Intraday chart: set the actual time of the cloture vote result (UTC) once you know it.
INTRADAY_DATE = "2026-09-15"
INTRADAY_EVENT_UTC = "2026-09-15 14:19"  # placeholder, update

EST_WINDOW = (-130, -11)  # estimation window, trading days relative to event
EVENT_WINDOWS = {"CAR[-1,+1]": (-1, 1), "CAR[0,+5]": (0, 5)}

OUT = "output"
os.makedirs(OUT, exist_ok=True)
plt.rcParams.update({"figure.dpi": 130, "axes.grid": True, "grid.alpha": 0.3})


# ----------------------------------------------------------------------------
# 1. DATA
# ----------------------------------------------------------------------------
def get_yf(tickers):
    raw = yf.download(list(tickers), start=START, end=END, auto_adjust=True, progress=False)
    return raw["Close"], raw["Volume"]


def get_fred(series_id="DGS10"):
    url = f"https://fred.stlouisfed.org/graph/fredgraph.csv?id={series_id}"
    df = pd.read_csv(url)
    df.columns = ["date", series_id]
    df["date"] = pd.to_datetime(df["date"])
    df[series_id] = pd.to_numeric(df[series_id], errors="coerce")
    return df.set_index("date")[series_id]


def get_coinbase_hourly(product, day, pad_days=1):
    """Hourly candles from Coinbase Exchange public API (max 300 per request)."""
    d = pd.Timestamp(day, tz="UTC")
    start, end = d - timedelta(days=pad_days), d + timedelta(days=pad_days + 1)
    url = f"https://api.exchange.coinbase.com/products/{product}/candles"
    params = {"granularity": 3600, "start": start.isoformat(), "end": end.isoformat()}
    r = requests.get(url, params=params, timeout=30)
    r.raise_for_status()
    df = pd.DataFrame(r.json(), columns=["time", "low", "high", "open", "close", "volume"])
    df["time"] = pd.to_datetime(df["time"], unit="s", utc=True)
    return df.sort_values("time").set_index("time")


def build_panel():
    px, vol = get_yf(list(CRYPTO) + list(CONTROLS))
    dgs10 = get_fred("DGS10")

    # Align everything to US trading days (crypto weekend moves roll into Monday)
    days = px["^GSPC"].dropna().index
    px = px.reindex(days).ffill()
    vol = vol.reindex(days)
    # crypto volume: sum weekend volume into the next trading day
    raw_vol = yf.download(list(CRYPTO), start=START, end=END, auto_adjust=True, progress=False)["Volume"]
    for t in ["BTC-USD", "ETH-USD", "SOL-USD"]:
        s = raw_vol[t].dropna()
        grp = np.searchsorted(days.values, s.index.values)  # map each calendar day to next trading day
        grp = np.clip(grp, 0, len(days) - 1)
        vol[t] = pd.Series(s.values, index=days[grp]).groupby(level=0).sum().reindex(days)

    rets = np.log(px).diff()
    factors = pd.DataFrame({
        "SPX": rets["^GSPC"],
        "dVIX": px["^VIX"].diff(),
        "dRATE": dgs10.reindex(days).ffill().diff(),
    })
    return px, vol, rets[list(CRYPTO)], factors


# ----------------------------------------------------------------------------
# 2. EVENT STUDY
# ----------------------------------------------------------------------------
def event_idx(index, date):
    """Position of first trading day on/after event date."""
    return int(index.searchsorted(pd.Timestamp(date)))


def event_study(rets, vol, factors):
    rows = []
    for ev_name, ev_date in EVENTS.items():
        for tkr in CRYPTO:
            i0 = event_idx(rets.index, ev_date)
            if i0 + 6 >= len(rets) or i0 + EST_WINDOW[0] < 0:
                continue
            est = slice(i0 + EST_WINDOW[0], i0 + EST_WINDOW[1] + 1)
            y = rets[tkr].iloc[est]
            X = sm.add_constant(factors.iloc[est])
            ok = y.notna() & X.notna().all(axis=1)
            model = sm.OLS(y[ok], X[ok]).fit()
            sigma = np.sqrt(model.scale)

            row = {"event": ev_name, "asset": CRYPTO[tkr], "est_R2": model.rsquared}
            for wname, (a, b) in EVENT_WINDOWS.items():
                w = slice(i0 + a, i0 + b + 1)
                Xw = sm.add_constant(factors.iloc[w], has_constant="add")
                expected = model.predict(Xw)
                ar = rets[tkr].iloc[w] - expected
                car = ar.sum()
                row[wname] = car
                row[wname + "_t"] = car / (sigma * np.sqrt(len(ar)))

            # volume ratio: event window avg vs prior 30-day avg
            pre = vol[tkr].iloc[i0 - 30:i0 - 1].mean()
            row["vol_ratio[0,+1]"] = vol[tkr].iloc[i0:i0 + 2].mean() / pre

            # realized vol (annualized): 5d after vs 20d before
            pre_v = rets[tkr].iloc[i0 - 20:i0].std() * np.sqrt(252)
            post_v = rets[tkr].iloc[i0:i0 + 5].std() * np.sqrt(252)
            row["vol_pre20"], row["vol_post5"] = pre_v, post_v
            row["vol_change"] = post_v / pre_v
            rows.append(row)
    res = pd.DataFrame(rows)
    res.to_csv(f"{OUT}/event_study_results.csv", index=False)
    return res


# ----------------------------------------------------------------------------
# 3. HYPOTHESIS TEST: does adding event dummies explain more than macro factors?
# ----------------------------------------------------------------------------
def regression_test(rets, factors):
    d = pd.DataFrame(index=rets.index)
    d["event_dummy"] = 0
    for ev_date in EVENTS.values():
        i0 = event_idx(rets.index, ev_date)
        d.iloc[i0:i0 + 2, d.columns.get_loc("event_dummy")] = 1  # day 0 and +1

    out = []
    for tkr in CRYPTO:
        for label, f in [("return", rets[tkr]), ("abs_return", rets[tkr].abs())]:
            df = pd.concat([f.rename("y"), factors, d], axis=1).dropna()
            Xm = sm.add_constant(df[["SPX", "dVIX", "dRATE"]])
            Xf = sm.add_constant(df[["SPX", "dVIX", "dRATE", "event_dummy"]])
            m_macro = sm.OLS(df["y"], Xm).fit(cov_type="HC1")
            m_full = sm.OLS(df["y"], Xf).fit(cov_type="HC1")
            out.append({
                "asset": CRYPTO[tkr], "dependent": label,
                "R2_macro_only": m_macro.rsquared, "R2_with_events": m_full.rsquared,
                "R2_gain": m_full.rsquared - m_macro.rsquared,
                "event_coef": m_full.params["event_dummy"], "event_p": m_full.pvalues["event_dummy"],
                "SPX_coef": m_full.params["SPX"], "SPX_p": m_full.pvalues["SPX"],
                "dVIX_p": m_full.pvalues["dVIX"], "dRATE_p": m_full.pvalues["dRATE"],
                "n": int(m_full.nobs),
            })
    res = pd.DataFrame(out)
    res.to_csv(f"{OUT}/regression_results.csv", index=False)
    return res


# ----------------------------------------------------------------------------
# 4. CHARTS
# ----------------------------------------------------------------------------
def plot_rebased(px):
    """Price rebased to 100 at t=-1, [-10, +10] trading days, one panel per event."""
    fig, axes = plt.subplots(2, 2, figsize=(13, 8), sharey=False)
    for ax, (ev_name, ev_date) in zip(axes.ravel(), EVENTS.items()):
        i0 = event_idx(px.index, ev_date)
        w = px.iloc[max(i0 - 10, 0):i0 + 11]
        base = px.iloc[i0 - 1]
        for tkr in CRYPTO:
            ax.plot(range(-10, -10 + len(w)), 100 * w[tkr] / base[tkr], label=CRYPTO[tkr])
        ax.axvline(0, color="k", ls="--", lw=1)
        ax.set_title(ev_name, fontsize=10)
        ax.set_xlabel("Trading days from event")
        ax.set_ylabel("Price (t=-1 = 100)")
    axes[0, 0].legend()
    fig.suptitle("Price reaction around regulatory events", fontweight="bold")
    fig.tight_layout()
    fig.savefig(f"{OUT}/01_rebased_prices.png")
    plt.close(fig)


def plot_car(res):
    for wname in EVENT_WINDOWS:
        piv = res.pivot(index="event", columns="asset", values=wname) * 100
        ax = piv.plot(kind="bar", figsize=(11, 5), width=0.8)
        ax.axhline(0, color="k", lw=0.8)
        ax.set_ylabel("Cumulative abnormal return (%)")
        ax.set_title(f"{wname}: abnormal returns after controlling for S&P 500, VIX, rates")
        plt.xticks(rotation=20, ha="right")
        plt.tight_layout()
        plt.savefig(f"{OUT}/02_{wname.replace('[', '').replace(']', '').replace(',', '_')}.png")
        plt.close()


def plot_volume_heatmap(res):
    piv = res.pivot(index="event", columns="asset", values="vol_ratio[0,+1]")
    fig, ax = plt.subplots(figsize=(8, 4))
    im = ax.imshow(piv.values, cmap="RdYlGn_r", vmin=0.5, vmax=2.5, aspect="auto")
    ax.set_xticks(range(len(piv.columns)), piv.columns)
    ax.set_yticks(range(len(piv.index)), piv.index, fontsize=8)
    for i in range(piv.shape[0]):
        for j in range(piv.shape[1]):
            ax.text(j, i, f"{piv.values[i, j]:.2f}x", ha="center", va="center", fontsize=9)
    ax.grid(False)
    fig.colorbar(im, label="Volume vs. prior 30-day avg")
    ax.set_title("Trading volume on event days (1.0x = normal)")
    fig.tight_layout()
    fig.savefig(f"{OUT}/03_volume_heatmap.png")
    plt.close(fig)


def plot_rolling_vol(rets):
    fig, ax = plt.subplots(figsize=(12, 5))
    for tkr in ["BTC-USD", "ETH-USD", "SOL-USD"]:
        ax.plot(rets.index, rets[tkr].rolling(20).std() * np.sqrt(252), label=CRYPTO[tkr])
    for name, d in EVENTS.items():
        ax.axvline(pd.Timestamp(d), color="k", ls="--", lw=0.8)
    ax.set_ylabel("20-day realized vol (annualized)")
    ax.set_title("Rolling volatility with regulatory events (dashed)")
    ax.legend()
    fig.tight_layout()
    fig.savefig(f"{OUT}/04_rolling_volatility.png")
    plt.close(fig)


def plot_intraday():
    products = {"BTC-USD": "Bitcoin", "ETH-USD": "Ethereum", "SOL-USD": "Solana"}
    fig, axes = plt.subplots(2, 1, figsize=(12, 7), sharex=True, gridspec_kw={"height_ratios": [3, 1]})
    ev_ts = pd.Timestamp(INTRADAY_EVENT_UTC, tz="UTC")
    btc_vol = None
    for p, name in products.items():
        df = get_coinbase_hourly(p, INTRADAY_DATE)
        axes[0].plot(df.index, 100 * df["close"] / df["close"].iloc[0], label=name)
        if p == "BTC-USD":
            btc_vol = df["volume"]
    axes[0].axvline(ev_ts, color="k", ls="--", label="Cloture vote")
    axes[0].set_ylabel("Price (first hour = 100)")
    axes[0].set_title(f"Hourly Coinbase prices around {INTRADAY_DATE}")
    axes[0].legend()
    axes[1].bar(btc_vol.index, btc_vol.values, width=0.03, color="gray")
    axes[1].axvline(ev_ts, color="k", ls="--")
    axes[1].set_ylabel("BTC volume")
    fig.tight_layout()
    fig.savefig(f"{OUT}/05_intraday_sept15.png")
    plt.close(fig)


def plot_r2(reg):
    r = reg[reg["dependent"] == "abs_return"].set_index("asset")
    ax = r[["R2_macro_only", "R2_gain"]].plot(kind="bar", stacked=True, figsize=(8, 5),
                                              color=["#999999", "#d62728"])
    ax.set_ylabel("R-squared (|daily return|)")
    ax.set_title("Variance explained: macro factors vs. added regulatory-event days")
    ax.legend(["Macro (S&P, VIX, rates)", "Added by event dummy"])
    plt.xticks(rotation=0)
    plt.tight_layout()
    plt.savefig(f"{OUT}/06_r2_decomposition.png")
    plt.close()


# ----------------------------------------------------------------------------
# MAIN
# ----------------------------------------------------------------------------
if __name__ == "__main__":
    print("Downloading data...")
    px, vol, rets, factors = build_panel()
    px[list(CRYPTO)].to_csv(f"{OUT}/prices.csv")

    print("Running event study...")
    res = event_study(rets, vol, factors)
    print(res.round(3).to_string(index=False))

    print("\nRunning regression comparison...")
    reg = regression_test(rets, factors)
    print(reg.round(4).to_string(index=False))

    print("\nMaking charts...")
    plot_rebased(px[list(CRYPTO)])
    plot_car(res)
    plot_volume_heatmap(res)
    plot_rolling_vol(rets)
    plot_r2(reg)
    try:
        plot_intraday()
    except Exception as e:
        print(f"Intraday chart skipped: {e}")
    print(f"Done. See ./{OUT}/")
