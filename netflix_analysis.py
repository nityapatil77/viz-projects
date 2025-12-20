import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Set visual style
sns.set_style("whitegrid")
netflix_colors = ['#E50914', '#221f1f'] # Official Netflix branding colors

# 1. LOAD DATA
# Ensure your path is correct
try:
    df = pd.read_csv('/Users/nityapatil/Downloads/netflix_titles.csv')
    print("Data loaded successfully!")
except FileNotFoundError:
    print("File not found. Please check the path.")

# 2. DATA CLEANING
# Convert date_added to datetime and extract year
df['date_added'] = pd.to_datetime(df['date_added'].str.strip())
df['year_added'] = df['date_added'].dt.year

# Fill missing values
df['country'] = df['country'].fillna('Unknown')
df['cast'] = df['cast'].fillna('No Data')
df['director'] = df['director'].fillna('No Data')

# 3. ANALYSIS: MOVIE VS TV SHOW DISTRIBUTION
plt.figure(figsize=(8, 6))
plt.pie(df['type'].value_counts(), labels=df['type'].value_counts().index, 
        autopct='%1.1f%%', colors=netflix_colors, startangle=140, explode=(0.05, 0))
plt.title('Content Type Distribution: Movies vs TV Shows')
plt.show()

# 4. ANALYSIS: TOP 10 GENRES (Handling the "Comma-Separated" strings)
# This "explodes" the genres so we can count each one individually
genres = df['listed_in'].str.split(', ').explode()
top_genres = genres.value_counts().head(10)

plt.figure(figsize=(12, 6))
sns.barplot(x=top_genres.values, y=top_genres.index, palette='Reds_r')
plt.title('Top 10 Genres on Netflix')
plt.xlabel('Number of Titles')
plt.show()

# 5. ANALYSIS: RATINGS (Target Audience)
plt.figure(figsize=(12, 6))
sns.countplot(data=df, x='rating', order=df['rating'].value_counts().index, palette='viridis')
plt.title('Content by Rating (Target Audience)')
plt.xticks(rotation=45)
plt.show()

# 6. ANALYSIS: MOVIE DURATIONS OVER TIME
# Filter for movies, remove ' min', and convert to integer
movies_df = df[df['type'] == 'Movie'].copy()
movies_df = movies_df.dropna(subset=['duration'])
movies_df['duration_min'] = movies_df['duration'].str.replace(' min', '').astype(int)

plt.figure(figsize=(12, 6))
sns.lineplot(data=movies_df, x='release_year', y='duration_min', color='#E50914')
plt.title('Trend of Movie Durations Over Release Years')
plt.xlabel('Release Year')
plt.ylabel('Duration (Minutes)')
plt.xlim(1980, 2021) # Focusing on modern era for clarity
plt.show()

# 7. ANALYSIS: CONTENT GROWTH TRENDS
growth = df.groupby(['year_added', 'type']).size().reset_index(name='count')

plt.figure(figsize=(12, 6))
sns.lineplot(data=growth, x='year_added', y='count', hue='type', palette=netflix_colors, linewidth=2.5)
plt.title('Content Added per Year: Movies vs TV Shows')
plt.ylabel('New Titles Added')
plt.xlabel('Year Added to Platform')
plt.show()