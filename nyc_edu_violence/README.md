# Analysis of NYC Shooting Incidents and Socioeconomic Indicators

This repository contains a comprehensive data analysis project focused on understanding the correlations between shooting incidents, educational outcomes, and economic factors across the five boroughs of New York City (Bronx, Brooklyn, Manhattan, Queens, and Staten Island).

## 📊 Project Overview

The goal of this project is to analyze historical shooting incident data from the NYPD and investigate how these events relate to public school graduation rates, dropout rates, and economic need indices. 

### Key Research Questions
* Does the graduation or dropout rate affect the volume of shooting incidents per capita in a borough?
* Are there specific months or times of day when shootings are more frequent?
* Is there a correlation between the Economic Need Index (ENI) of K-12 schools and the frequency of shootings?
* How do victim demographics vary across different incident locations?

---

## 📂 Data Sources

This project aggregates data from several official NYC and State repositories:
* **NYPD Shooting Incident Data (Historic):** Comprehensive list of every shooting incident that occurred in NYC from 2006 through the previous calendar year.
* **NYSED Graduation Rate Data (2023):** Statistics on high school graduation and dropout rates by county/borough.
* **NYC School Economic Need Index:** Data providing insight into the financial support required by students and families.
* **City Population Data:** 2022 population figures for the five boroughs to enable per-capita normalization.

---

## 🛠️ Features & Methodology

The Jupyter Notebook (`nyc_analysis.ipynb`) includes the following technical implementations:

### 1. Data Cleaning & Integration
* **CSV Parsing:** Cleaning the NYPD dataset to focus on date, time, and borough.
* **Web Scraping:** Utilizing `BeautifulSoup` and `requests` to extract graduation rates and population data directly from HTML tables.
* **JSON Processing:** Extracting Mean Economic Need Indices using the NYC Open Data API.

### 2. Analytical Insights
* **Education vs. Safety:** Analyzes the link between graduation/dropout rates and incidents per capita.
* **Temporal Trends:** Identifies peak shooting hours (notably late-night windows) and seasonal fluctuations.
* **Demographic Analysis:** Examines victim profiles across different boroughs.
* **Economic Correlation:** Maps the "Economic Need Index" against incident counts to visualize socioeconomic influence.

---

## 🚀 Getting Started

### Prerequisites
To run the analysis locally, ensure you have the following installed:
* Python 3.x
* Jupyter Notebook
* Pandas
* Matplotlib / Seaborn
* BeautifulSoup4
* Requests

### Installation
1. Clone the repository:
   ```bash
   git clone [https://github.com/your-username/nyc-shooting-analysis.git](https://github.com/your-username/nyc-shooting-analysis.git)
