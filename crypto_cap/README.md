# Crypto Market Data Collector (CoinMarketCap API)

This project pulls real-time cryptocurrency market data from the **CoinMarketCap Pro API** at regular intervals and stores the results in a CSV file for analysis.

The script is designed to repeatedly query the API, normalize the JSON response into a Pandas DataFrame, timestamp each pull, and append the data to a local CSV file.

---

## Features

* Fetches latest cryptocurrency listings from CoinMarketCap
* Collects price and market data in USD
* Normalizes nested JSON into a flat Pandas DataFrame
* Appends data to a CSV file for time-series analysis
* Automatically timestamps each API pull
* Built-in error handling for connection issues

---

## Technologies Used

* Python
* Pandas
* Requests
* CoinMarketCap Pro API

## Prerequisites
You must get the API key from https://coinmarketcap.com/ to run this code. 

### Steps to get API key:
1. Go to https://coinmarketcap.com/
2. Scroll to the bottom of the page and find Crypto API under products.
3. Press Get Started for Free and create an account.
4. Copy the API key.

Before running the script, make sure you have:

* Python 3.8+
* A **CoinMarketCap Pro API key**
* Required Python packages installed

## Setup

1. **Clone the repository**

```bash
git clone https://github.com/nityapatil77/viz-projects.git
cd viz-projects/crypto_cap
```

2. **Add your API key**

Replace the placeholder in the script:

```python
'X-CMC_PRO_API_KEY': 'api_key'
```

with your actual CoinMarketCap API key.

## How It Works

* The script calls the `/v1/cryptocurrency/listings/latest` endpoint
* Pulls data for the top 15 cryptocurrencies by market cap
* Converts prices to USD
* Runs every **20 seconds**
* Executes **333 times** (~1 hour and 51 minutes of data)
* Appends results to `API.csv` on each run

Each row represents a snapshot of the crypto market at a specific timestamp.

---

## Running the Script

```bash
python main.py
```

You’ll see console output like:

```
Run 1 completed
Run 2 completed
...
```

The code is set to run 333 times, which is the maximum that the API will allow you to pull in a day. You can __stop the code__ at any point in the first block and the rest of the code will use the API.csv file up until that point that is saved in your local Desktop.

---

## Output

The CSV file includes:

* Cryptocurrency metadata
* Market metrics (price, volume, market cap, etc.)
* A `timestamp` column indicating when the data was collected

## Current Data Visualizations

This project transforms API snapshots into market visualizations using **Seaborn, Matplotlib, and Plotly**. The following visualizations are included in the Jupyter Notebook:

### 1. Multi-Interval Performance Analysis (Point Plot)

This chart tracks how the top 15 assets perform across different time horizons (1h, 24h, 7d, 30d, 60d, and 90d). It utilizes a "stacked" data transformation to compare short-term volatility against long-term trends in a single view.

* **Key Insight:** Identifies which assets are maintaining momentum versus those experiencing short-term "pumps."

### 2. Real-Time Price Tracking (Interactive Time-Series)

An interactive line chart built with __Plotly__ that allows users to hover over specific data points to see the exact USD price at a high-frequency (20-second) resolution. This graph visualizes __micro-trends__ and instant market reactions during the data collection window.

### 3. Market Sentiment: 24h Change (Bar Chart)

A sorted bar chart displaying the percentage change of the top assets over the last 24 hours. This graph provides an immediate __heat check__ on the market to see if the session is overall bullish (green) or bearish (red).

### 4. Liquidity & Volatility (Bubble Scatter Plot)

A sophisticated scatter plot mapping **Market Cap** (Size) against **24h Volume** (Activity). The "bubbles" are color-coded and sized by price change. This graph highlights __outlier__ coins—those with low market caps but massive trading volume, which often signals high volatility or institutional interest.

### 5. Asset Correlation Matrix (Heatmap)

A statistical heatmap that calculates the correlation coefficient between the price movements of the top 15 cryptocurrencies. This graph show the essential need for portfolio diversification; it reveals how closely __Altcoins__ (like Solana or Cardano) follow the price action of Bitcoin.

---

### Implementation Details

* **Data Reshaping:** Uses `df.stack()` and `df.reset_index()` to transform wide-format API data into long-format data suitable for advanced statistical plotting.
* **Logarithmic Scaling:** Applied to Market Cap and Volume charts to ensure Bitcoin and Ethereum do not dwarf the scale, making smaller assets visible.
* **Interactivity:** Integrated Plotly to allow for dynamic zooming and asset filtering.

---

## Notes

* CoinMarketCap API has **rate limits** — adjust `sleep(20)` and loop count if needed
