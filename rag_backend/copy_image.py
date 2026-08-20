import shutil
import os
import time

def copy_file():
    src = r"C:\Users\shres\.gemini\antigravity\brain\c2274b3c-bb94-402e-a001-d4fda9e15496\downward_dog_1783006576212.png"
    dest = r"c:\Users\shres\OneDrive\Desktop\mindmate\mindmate\assets\yoga\downward_dog.png"
    
    print(f"Copying {src} to {dest}...")
    for i in range(5):
        try:
            shutil.copy2(src, dest)
            print("Successfully copied!")
            break
        except Exception as e:
            print(f"Attempt {i+1} failed: {e}")
            time.sleep(1)

if __name__ == "__main__":
    copy_file()
