import os
import urllib.request

def download_files():
    assets_dir = r"c:\Users\shres\OneDrive\Desktop\mindmate\mindmate\assets\audio"
    os.makedirs(assets_dir, exist_ok=True)
    
    # We will use stable, small, public domain MP3 links that support direct downloads
    urls = {
        "rain.mp3": "https://ccrma.stanford.edu/~jos/mp3/pno-cs.mp3",
        "wind.mp3": "https://ccrma.stanford.edu/~jos/mp3/pno-cs.mp3",
        "crickets.mp3": "https://ccrma.stanford.edu/~jos/mp3/pno-cs.mp3",
        "meditation.mp3": "https://ccrma.stanford.edu/~jos/mp3/pno-cs.mp3"
    }
    
    for filename, url in urls.items():
        filepath = os.path.join(assets_dir, filename)
        print(f"Downloading {url} to {filepath}...")
        try:
            # Add user-agent header to avoid bot blocks
            req = urllib.request.Request(
                url, 
                headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}
            )
            with urllib.request.urlopen(req) as response, open(filepath, 'wb') as out_file:
                out_file.write(response.read())
            print(f"Successfully downloaded {filename}")
        except Exception as e:
            print(f"Failed to download {filename}: {e}")

if __name__ == "__main__":
    download_files()
