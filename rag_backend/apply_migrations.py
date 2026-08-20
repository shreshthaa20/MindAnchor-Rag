import os
import psycopg
from app.config import settings

def apply_migrations():
    db_dir = r"c:\Users\shres\OneDrive\Desktop\mindmate\mindmate\backend\src\database"
    migration_files = sorted([f for f in os.listdir(db_dir) if f.endswith(".sql")])

    print(f"Connecting to database {settings.DB_NAME}...")
    try:
        sslmode = "disable" if settings.DB_HOST == "localhost" else "require"
        conn = psycopg.connect(
            host=settings.DB_HOST,
            port=settings.DB_PORT,
            user=settings.DB_USER,
            password=settings.DB_PASSWORD,
            dbname=settings.DB_NAME,
            sslmode=sslmode
        )
        conn.autocommit = True
    except Exception as e:
        print("Database connection failed:", e)
        return

    with conn.cursor() as cur:
        for filename in migration_files:
            filepath = os.path.join(db_dir, filename)
            print(f"Applying migration: {filename}...")
            try:
                with open(filepath, "r", encoding="utf-8") as f:
                    sql = f.read()
                # Split commands by semicolon or execute as a whole block
                cur.execute(sql)
                print(f"Successfully applied {filename}")
            except Exception as e:
                print(f"Failed to apply {filename}:", e)
    
    conn.close()

if __name__ == "__main__":
    apply_migrations()
