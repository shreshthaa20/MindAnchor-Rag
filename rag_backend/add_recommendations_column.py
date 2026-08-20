import psycopg
from app.config import settings

def add_column():
    print(f"Connecting to database {settings.DB_NAME} to add recommendations column...")
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
        try:
            print("Adding recommendations column to chat_messages table...")
            cur.execute(
                """
                ALTER TABLE chat_messages
                ADD COLUMN IF NOT EXISTS recommendations JSONB DEFAULT '[]';
                """
            )
            print("Column added successfully.")
        except Exception as e:
            print("Failed to add column:", e)

    conn.close()

if __name__ == "__main__":
    add_column()
