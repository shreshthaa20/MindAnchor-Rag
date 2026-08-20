import os

def search_brown(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        lines = f.readlines()
                        for idx, line in enumerate(lines):
                            if 'brown' in line.lower() or '0xffa52a' in line.lower() or '0xff8b4513' in line.lower():
                                print(f"Found in {filepath} (Line {idx+1}): {line.strip()}")
                except Exception as e:
                    pass

if __name__ == "__main__":
    search_brown(r"c:\Users\shres\OneDrive\Desktop\mindmate\mindmate\lib")
