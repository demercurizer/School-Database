from faker import Faker
import psycopg2

fake = Faker()
conn = psycopg2.connect(dbname="project", user="postgres", password="postgres", host="localhost")
cur = conn.cursor()

cur.execute("SELECT COALESCE(MAX(studentid), 0) FROM Students;")
next_id, = cur.fetchone()
next_id += 1

for _ in range(1000):
    # generate a consecutive or random ID
    studentid = next_id
    next_id += 1

    cur.execute(
        """
        INSERT INTO Students(studentid, classid, name, email)
        VALUES (%s, %s, %s, %s)
        """,
        (studentid, fake.random_int(1,5), fake.name(), fake.email())
    )

conn.commit()
cur.close()
conn.close()
