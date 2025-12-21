# Analysis of NYC Shooting Incidents and Socioeconomic Indicators

This repository contains a data analysis project focused on understanding the correlations between shooting incidents, educational outcomes, and economic factors across the five boroughs of New York City (Bronx, Brooklyn, Manhattan, Queens, and Staten Island).

## 📊 Project Overview

The goal of this project is to analyze historical shooting incident data from the NYPD and investigate how these events relate to public school graduation rates, dropout rates, and economic need indices. 

### Key Research Questions
* **Education & Crime:** Does the graduation or dropout rate affect the volume of shooting incidents per capita in a borough?
* **Temporal Patterns:** Are there specific months or times of day when shootings are more frequent?
* **Economic Influence:** Is there a correlation between the Economic Need Index (ENI) of K-12 schools and the frequency of shootings?
* **Demographics:** How do victim demographics (specifically gender) vary across different incident locations and socioeconomic environments?

---

## 📂 Data Sources

This project aggregates data from several official NYC and State repositories:
* **NYPD Shooting Incident Data (Historic):** Comprehensive list of every shooting incident that occurred in NYC. [Source](https://data.cityofnewyork.us/Public-Safety/NYPD-Shooting-Incident-Data-Historic-/833y-fsy8)
* **NYSED Graduation Rate Data (2023):** Statistics on high school graduation and dropout rates by county. [Source](https://data.nysed.gov/)
* **NYC School Economic Need Index:** Data providing insight into the financial support required by students and families. [Source](https://data.cityofnewyork.us/resource/2a5f-5ryi.json)
* **City Population Data:** 2022 population figures for the five boroughs to enable per-capita normalization. [Source](https://www.citypopulation.de/en/usa/newyorkcity/)

---

## 🛠️ Features & Methodology

The Jupyter Notebook (`nyc_analysis.ipynb`) includes the following technical implementations:

### 1. Data Collection & Cleaning
* **CSV Parsing:** Cleaning the NYPD dataset by removing unnecessary geospatial coordinates and focusing on borough-level statistics.
* **Web Scraping:** Using `BeautifulSoup` and `requests` to extract graduation rates and population figures from HTML tables.
* **API/JSON Integration:** Extracting Economic Need Indices directly from NYC Open Data.

### 2. Analytical Insights
* **Socioeconomic Impact:** Analyzing how poverty levels (ENI) and student circumstances (foster care, economic disadvantage) influence exposure to violence.
* **Peak Times:** Identifying significant surges in incidents during summer months and late-night/early-morning hours (10 PM – 3 AM).
* **Gender Disparity:** Confirming that males are disproportionately affected by shooting incidents across all five boroughs.

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
   git clone [https://github.com/nityapatil77/nyc-shooting-analysis.git](https://github.com/nityapatil77/nyc-shooting-analysis.git)
2. Navigate to the project directory:
   '''bash
   cd nyc-shooting-analysis
3. Install the required libraries:
   ''' bash
   pip install pandas matplotlib beautifulsoup4 requests seaborn
4. Ensure that 'NYPD_Shooting_Incident_Data__Historic_.csv' file is in the project directory.
5. Launch the Jupyter notebook
   '''bash
   jupyter notebook nyc_analysis.ipynb

### Youtube Video
For a detailed walkthrough of the findings and the code implementation, you can view the video presentation here: [YouTube Presentation Link]([url](https://youtu.be/X_j19JvANpI?si=oNCjzKrfUfnuY2_9)
