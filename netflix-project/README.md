# Netflix Content Strategy Analysis

## Project Overview
This project performs an **EDA** on a comprehensive Netflix dataset containing movies and TV shows. The goal is to uncover patterns in content production, geographic distribution, and viewer targeting to understand Netflix's evolving business strategy.

## Key Insights
* **The Shift to Serialized Content:** While movies still make up the majority of the library, the growth rate of TV Shows has outpaced movies since 2015, indicating a focus on long-term subscriber retention.
* **Global Diversification:** India and the UK are the largest producers outside the US. The prevalence of "International" genres suggests a successful global expansion strategy.
* **Target Audience:** A significant majority of content is rated **TV-MA** or **TV-14**, positioning Netflix as a leader in mature, prestige programming compared to family-focused competitors.
* **Duration Optimization:** The most common movie length is between **90–110 minutes**, suggesting Netflix optimizes for "one-sitting" viewing experiences.

## Tools & Technologies
* **Python 3.x**
* **Pandas, Numpy**
* **Matplotlib & Seaborn**
* **Jupyter Notebook**

## Data Cleaning Process
To ensure the integrity of the analysis, the following steps were taken:
1. Converted the 'date_added' column from strings to 'datetime' objects for data standardization.
2. Imputed "Unknown" for missing countries and "No Data" for directors/cast to handle missing values 
3. Exploded the 'listed_in' column to separate multi-genre titles for accurate counting.
4. Extracted numeric values from the 'duration' column (e.g., converting "90 min" to '90') to allow for statistical plotting.

## Visualizations
### 1. Content Distribution
<img width="600" height="400" alt="Figure_1" src="https://github.com/user-attachments/assets/cd0289c3-e1dc-4f98-bfac-d212459bb90f" />

### 2. Growth Trends
<img width="600" height="300" alt="Figure_5" src="https://github.com/user-attachments/assets/57025bb0-252a-46a6-b1b7-236e0393cbc9" />

### 3. Top Genres
<img width="600" height="300" alt="Figure_2" src="https://github.com/user-attachments/assets/641b918b-afbb-4a1b-b917-eb5750daf237" />

## How to Run
1. clone the repository: 'git clone https://github.com/your-username/netflix-analysis.git'
2. install dependencies: 'pip install pandas matplotlib seaborn'
3. download the dataset from kaggle and place it in the python file (netflix_titles.csv)
4. run the script: 'python netflix_analysis.py'
