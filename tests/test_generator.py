def test_generator_inserted_1000(db_conn):
    cur = db_conn.cursor()
    cur.execute("SELECT COUNT(*) FROM Students;")
    total, = cur.fetchone()
    assert total >= 1000

def test_recent_students_have_data(db_conn):
    cur = db_conn.cursor()
    cur.execute("""
        SELECT studentid, name, email 
        FROM Students 
        ORDER BY studentid DESC 
        LIMIT 5
    """)
    rows = cur.fetchall()
    assert len(rows) == 5
    for sid, name, email in rows:
        assert name and email
