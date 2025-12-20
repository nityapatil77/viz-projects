import json
import ssl
import urllib.request
from datetime import datetime
from pathlib import Path

# 1. CONFIGURATION
JSON_FILE = Path("/path/to/jsonfile/here")
OUTPUT_DIR = Path("/where/you/want/memories/saved")

# Bypass SSL for certain network environments
ssl._create_default_https_context = ssl._create_unverified_context

def get_filename(date_str, media_type, existing_names):
    dt = datetime.strptime(date_str, "%Y-%m-%d %H:%M:%S UTC")
    base_name = dt.strftime("%Y-%m-%d_%H-%M-%S")
    extension = ".mp4" if media_type.lower() == "video" else ".jpg"
    
    filename = f"{base_name}{extension}"
    counter = 1
    
    while filename in existing_names:
        filename = f"{base_name}_{counter}{extension}"
        counter += 1
        
    return filename

def download_memories():
    # create directory if it doesn't exist
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    
    # JSON data
    try:
        with open(JSON_FILE, "r", encoding="utf-8") as f:
            data = json.load(f)
    except FileNotFoundError:
        print(f"Error: Could not find {JSON_FILE}")
        return

    media_items = data.get("Saved Media", [])
    # track existing files to avoid overwriting/duplicates
    existing_names = set(f.name for f in OUTPUT_DIR.iterdir())
    
    print(f"Found {len(media_items)} items. starting download...")

    for item in media_items:
        url = item.get("Media Download Url")
        date_str = item.get("Date")
        media_type = item.get("Media Type", "image")

        if not url or not date_str:
            continue

        filename = get_filename(date_str, media_type, existing_names)
        save_path = OUTPUT_DIR / filename

        try:
            # Using a cleaner request header can sometimes prevent blocks
            opener = urllib.request.build_opener()
            opener.addheaders = [('User-agent', 'Mozilla/5.0')]
            urllib.request.install_opener(opener)
            
            urllib.request.urlretrieve(url, save_path)
            existing_names.add(filename)
            print(f"Downloaded: {filename}")
            
        except Exception as e:
            print(f"Failed to download {filename}: {e}")

    print("\nAll available memories processed!")

if __name__ == "__main__":
    download_memories()