# Snapchat Memories Downloader

## Project Overview
Snapchat introduced a **5GB** limit on memories. This severely limits the storage of those who have been using Snapchat for several years, such as myself. To fix this problem, you can download all of your memories to your hard drive!

## How To Use
* Open Snapchat. Navigate to Settings -> Privacy Controls -> My Data.
* Under "Select Data to Include," click **Export Your Memories**
* Snapchat will email you a link. This link may take several hours to arrive.
* Download the ZIP file containing your exported data.
* Extract the ZIP file and locate the JSON folder. Click the JSON folder to access the JSON file to use with this script.

## How It Works
* **Automated Parsing:** Extracts "Saved Media" metadata directly from Snapchat’s 'memories_history.json'.
* **Smart File Naming:** Automatically renames files based on the original capture date (e.g., '2023-05-12_14-30-05.jpg') for better organization.
* **Format Detection:** Distinguishes between `.mp4` and `.jpg` based on the media type specified in the JSON.
* **Duplicate Prevention:** Checks the destination folder to ensure files aren't redownloaded if the script is restarted.
* **SSL Handling:** Includes custom SSL context handling to ensure secure downloads across different OS environments.

## Tools Used
* **Python 3.x**
* **JSON:** For parsing the Snapchat metadata.
* **urllib:** To handle asynchronous media downloads from Snapchat's servers.
* **OS & Datetime:** For file path management and chronological naming.

## Setup & Usage
1. Download the following file:
    ```python
    python3 snap_download.py
3. **Configure Paths:** Open the script and update the following variables:
   ```python
   JSON_FILE = Path("/path/to/jsonfile/here")
   OUTPUT_DIR = Path("/where/you/want/memories/saved")
