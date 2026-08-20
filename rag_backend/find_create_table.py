import os

def find_create_table():
    root = r"c:\Users\shres\OneDrive\Desktop\mindmate\mindmate"
    for dirpath, dirnames, filenames in os.walk(root):
        if "node_modules" in dirpath or ".git" in dirpath or "build" in dirpath or ".dart_tool" in dirpath:
            continue
        for f in filenames:
            if f.endswith((".sql", ".ts", ".js", ".json", ".dart")):
                path = os.path.join(dirpath, f)
                try:
                    with open(path, "r", encoding="utf-8", errors="ignore") as file:
                        content = file.read()
                        if "create table" in content.lower():
                            print(f"Found in {path}")
                except Exception:
                    pass

find_create_table()
