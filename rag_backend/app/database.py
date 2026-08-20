import psycopg
from contextlib import contextmanager
from .config import settings

@contextmanager
def get_db_connection():
    sslmode = "disable" if settings.DB_HOST == "localhost" else "require"
    conn = psycopg.connect(
        host=settings.DB_HOST,
        port=settings.DB_PORT,
        user=settings.DB_USER,
        password=settings.DB_PASSWORD,
        dbname=settings.DB_NAME,
        sslmode=sslmode
    )
    try:
        yield conn
    finally:
        conn.close()
        
