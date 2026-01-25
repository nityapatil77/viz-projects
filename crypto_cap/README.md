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

### Install dependencies

```bash
pip install pandas requests
```

---

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

> ⚠️ **Do NOT commit your real API key to GitHub.**
> Consider using environment variables for production use.

---

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

---

## Output

The CSV file includes:

* Cryptocurrency metadata
* Market metrics (price, volume, market cap, etc.)
* A `timestamp` column indicating when the data was collected

This format is useful for:

* Time-series analysis
* Price tracking
* Volatility studies
* Dashboarding in Tableau, Power BI, or Python

---

## Notes & Best Practices

* CoinMarketCap API has **rate limits** — adjust `sleep(20)` and loop count if needed
* For long-running jobs, consider:

  * Using a scheduler (cron)
  * Storing data in a database instead of CSV
* Use environment variables to securely manage API keys

---

## Disclaimer

This project is for **educational and analytical purposes only** and does not constitute financial advice.

---

If you want, I can also:

* Add an **environment variable version** of the script
* Refactor this into a **class-based or production-ready structure**
* Help you write a **portfolio-style GitHub description** for recruiters
