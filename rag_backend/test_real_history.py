import psycopg
from app.config import settings
from app.services.rag_service import chat_completion

def test_real_history():
    print(f"Connecting to database {settings.DB_NAME}...")
    try:
        conn = psycopg.connect(
            host=settings.DB_HOST,
            port=settings.DB_PORT,
            user=settings.DB_USER,
            password=settings.DB_PASSWORD,
            dbname=settings.DB_NAME
        )
    except Exception as e:
        print("Database connection failed:", e)
        return

    # Let's find a user who has messages
    with conn.cursor() as cur:
        cur.execute("SELECT DISTINCT user_id FROM chat_messages LIMIT 5;")
        users = [r[0] for r in cur.fetchall()]
        print("Users with chat messages:", users)
        
        if not users:
            print("No chat history found in database.")
            conn.close()
            return
            
        for user_id in users:
            print(f"\n--- Testing for User ID {user_id} ---")
            cur.execute(
                """
                SELECT role, content
                FROM chat_messages
                WHERE user_id = %s AND chat_type = 'companion'
                ORDER BY created_at DESC
                LIMIT 12
                """,
                (user_id,)
            )
            rows = cur.fetchall()
            rows.reverse()
            
            history = [{"role": r[0], "content": r[1]} for r in rows]
            print(f"History length: {len(history)}")
            print("History content preview:")
            for h in history[:3]:
                print(f"  {h['role']}: {h['content'][:50]}...")
                
            try:
                print("Calling chat_completion...")
                answer = chat_completion(user_id, "companion", history)
                print("Success! Response repr:", repr(answer))
            except Exception as e:
                import traceback
                print("Failed:")
                traceback.print_exc()
                
    conn.close()

if __name__ == "__main__":
    test_real_history()
