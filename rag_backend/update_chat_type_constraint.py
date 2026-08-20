import psycopg
from app.config import settings

def update_constraint():
    print(f"Connecting to database {settings.DB_NAME} to update chat_type constraint...")
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
            # Check existing constraints
            print("Dropping old constraint...")
            cur.execute(
                """
                ALTER TABLE chat_messages
                DROP CONSTRAINT IF EXISTS chat_messages_chat_type_check;
                """
            )
                        print("Adding new constraint supporting wellness guide chat type...")
            cur.execute(
                """
                ALTER TABLE chat_messages
                ADD CONSTRAINT chat_messages_chat_type_check
                CHECK (chat_type IN ('wellness_guide'));
                """
            )
            print("Constraint updated successfully.")
        except Exception as e:
            print("Failed to update constraint:", e)

    conn.close()

if __name__ == "__main__":
    update_constraint()
