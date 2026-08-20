import google.generativeai as genai
import os
from dotenv import load_dotenv

# Load env
load_dotenv()

key = os.getenv("GEMINI_API_KEY")
print("Key exists:", bool(key))
if key:
    genai.configure(api_key=key)
    try:
        print("Generation models:")
        for m in genai.list_models():
            if 'generateContent' in m.supported_generation_methods:
                print(f"Name: {m.name}, Display: {m.display_name}")
    except Exception as e:
        print("Error listing models:", e)
else:
    print("No GEMINI_API_KEY found.")
