import os
from dotenv import load_dotenv
import psycopg2

load_dotenv()

project_id = "eiynfrgezfyncoqaemfr"
db_password = os.getenv("DB_PASSWORD")
if not db_password:
    raise SystemExit("DB_PASSWORD missing in .env")

sql_file = "SQL/add_clue_state_and_phased_hints.sql"
with open(sql_file, "r", encoding="utf-8") as f:
    sql = f.read()

hosts = [
    (f"db.{project_id}.supabase.co", 5432, "postgres"),
    ("aws-0-eu-central-1.pooler.supabase.com", 6543, f"postgres.{project_id}"),
    ("aws-0-eu-central-1.pooler.supabase.com", 5432, "postgres"),
]

connection = None
for host, port, user in hosts:
    try:
        print(f"Trying {host}:{port} as {user}...")
        connection = psycopg2.connect(
            host=host,
            port=port,
            dbname="postgres",
            user=user,
            password=db_password,
            connect_timeout=8,
        )
        print("Connected.")
        break
    except Exception as exc:
        print(f"Connection failed: {exc}")

if connection is None:
    raise SystemExit("Could not connect to Supabase Postgres.")

cursor = connection.cursor()
try:
    cursor.execute(sql)
    connection.commit()
    print("Migration executed successfully.")

    cursor.execute("""
        SELECT
            COUNT(*) AS total_hints,
            COUNT(hint_phase_1) AS with_phase_1,
            COUNT(hint_phase_2) AS with_phase_2,
            COUNT(hint_phase_3) AS with_phase_3
        FROM scenario_hints;
    """)
    result = cursor.fetchone()
    print(f"Verification scenario_hints counts: total={result[0]}, p1={result[1]}, p2={result[2]}, p3={result[3]}")

    cursor.execute("SELECT COUNT(*) FROM agent_clue_state;")
    state_count = cursor.fetchone()[0]
    print(f"Verification agent_clue_state rows: {state_count}")
finally:
    cursor.close()
    connection.close()
