# 🎬 Netflix Content Strategy Analysis

## 📌 Project Overview
This project performs an **Exploratory Data Analysis (EDA)** on a comprehensive Netflix dataset containing movies and TV shows. The goal is to uncover patterns in content production, geographic distribution, and viewer targeting to understand Netflix's evolving business strategy.

## 📊 Key Insights
* **The Shift to Serialized Content:** While movies still make up the majority of the library, the growth rate of TV Shows has outpaced movies since 2015, indicating a focus on long-term subscriber retention.
* **Global Diversification:** India and the UK are the largest producers outside the US. The prevalence of "International" genres suggests a successful global expansion strategy.
* **Target Audience:** A significant majority of content is rated **TV-MA** or **TV-14**, positioning Netflix as a leader in mature, prestige programming compared to family-focused competitors.
* **Duration Optimization:** The most common movie length is between **90–110 minutes**, suggesting Netflix optimizes for "one-sitting" viewing experiences.

## 🛠️ Tools & Technologies
* **Python 3.x**
* **Pandas:** Data cleaning and manipulation.
* **Matplotlib & Seaborn:** Data visualization using Netflix-branded color schemes.
* **Jupyter Notebook:** For interactive development and storytelling.

## 🧼 Data Cleaning Process
To ensure the integrity of the analysis, the following steps were taken:
1.  **Date Standardizing:** Converted the `date_added` column from strings to `datetime` objects.
2.  **Handling Missing Values:** Imputed "Unknown" for missing countries and "No Data" for directors/cast.
3.  **String Parsing:** Exploded the `listed_in` column to separate multi-genre titles for accurate counting.
4.  **Feature Engineering:** Extracted numeric values from the `duration` column (e.g., converting "90 min" to `90`) to allow for statistical plotting.

## 📈 Visualizations
### 1. Content Distribution
*A pie chart showing the ratio of Movies (approx. 70%) to TV Shows (approx. 30%).*

### 2. Growth Trends
*A line graph showing the explosion of content added to the platform starting around 2016.*

### 3. Top Genres
*A bar chart identifying International Movies, Dramas, and Comedies as the most frequent categories.*

## 🚀 How to Run
1. Clone this repository: `git clone https://github.com/your-username/netflix-analysis.git`
2. Install dependencies: `pip install pandas matplotlib seaborn`
3. Download the dataset from Kaggle and place it in the project directory.
4. Run the script: `python netflix_analysis.py`

---
**Author:** Nitya Patil  
**Connect:** [Your LinkedIn Profile Link]
