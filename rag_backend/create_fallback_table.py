import psycopg
from app.config import settings

def create_fallback_table():
    print(f"Connecting to database {settings.DB_NAME} to create fallback table...")
    try:
        conn = psycopg.connect(
            host=settings.DB_HOST,
            port=settings.DB_PORT,
            user=settings.DB_USER,
            password=settings.DB_PASSWORD,
            dbname=settings.DB_NAME
        )
        conn.autocommit = True
    except Exception as e:
        print("Database connection failed:", e)
        return

    with conn.cursor() as cur:
        # Create knowledge_base table with TEXT embedding instead of vector
        print("Creating knowledge_base table with TEXT embedding...")
        cur.execute(
            """
            CREATE TABLE IF NOT EXISTS knowledge_base (
              id SERIAL PRIMARY KEY,
              user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
              category VARCHAR(80) NOT NULL DEFAULT 'General Wellness',
              title VARCHAR(160) NOT NULL,
              content TEXT NOT NULL,
              source TEXT,
              tags TEXT[] NOT NULL DEFAULT '{}',
              is_curated BOOLEAN NOT NULL DEFAULT false,
              embedding TEXT NOT NULL,
              created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
              updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
            );
            """
        )
        print("Table knowledge_base created successfully.")

        # Apply 004_wellness_guide migration modifications
        print("Applying 004_wellness_guide modification...")
        try:
            cur.execute("ALTER TABLE knowledge_base ALTER COLUMN user_id DROP NOT NULL;")
            print("Successfully completed 004_wellness_guide setup.")
        except Exception as e:
            print("Failed 004_wellness_guide modification:", e)

    conn.close()

if __name__ == "__main__":
    create_fallback_table()
