from app.database import get_db_connection

def clear_knowledge_base():
    print("Connecting to database...")
    with get_db_connection() as conn:
        conn.autocommit = True
        print("Deleting all previous documents from the knowledge_base table...")
        with conn.cursor() as cur:
            cur.execute("DELETE FROM knowledge_base;")
            
        print("Successfully removed all previous data from the knowledge base!")

if __name__ == "__main__":
    try:
        clear_knowledge_base()
    except Exception as e:
        print(f"Error clearing database: {e}")
        import sys
        sys.exit(1)
