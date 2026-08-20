import sys
import os

# Add parent dir to path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.services.rag_service import generate_wellness_guide, semantic_search
from app.config import settings

print("Database Config:")
print(f"Host: {settings.DB_HOST}")
print(f"Name: {settings.DB_NAME}")
print(f"User: {settings.DB_USER}")
print(f"Gemini Key Exists: {bool(settings.GEMINI_API_KEY)}")

try:
    print("\nTesting semantic search...")
    res_search = semantic_search(1, "stress", limit=1)
    print("Search OK, results count:", len(res_search))
except Exception as e:
    print("Search Failed:")
    import traceback
    traceback.print_exc()

try:
    print("\nTesting generate wellness guide...")
    res = generate_wellness_guide(1, "I feel stressed out and tired")
    print("Wellness Guide OK:", res["answer"][:100])
except Exception as e:
    print("Wellness Guide Failed:")
    import traceback
    traceback.print_exc()
