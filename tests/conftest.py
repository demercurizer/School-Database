import pytest
import psycopg2

@pytest.fixture(scope="session")
def db_conn():

    conn = psycopg2.connect(
        dbname="project",
        user="postgres",
        password="postgres",
        host="localhost",
        port=5432
    )
    yield conn

    conn.close()
