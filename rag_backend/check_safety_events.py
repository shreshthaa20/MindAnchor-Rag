import psycopg
from app.config import settings

def check_events():
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

    with conn.cursor() as cur:
        # Check safety events
        cur.execute("SELECT id, user_id, event_type, risk_level, source, message_preview, created_at FROM safety_events ORDER BY created_at DESC LIMIT 5;")
        rows = cur.fetchall()
        print("\n--- Recent Safety Events ---")
        if not rows:
            print("No safety events logged.")
        for r in rows:
            print(f"ID: {r[0]} | User: {r[1]} | Type: {r[2]} | Risk: {r[3]} | Source: {r[4]} | Created: {r[6]}")
            print(f"  Preview: {r[5]}")
            
    conn.close()

if __name__ == "__main__":
    check_events()
