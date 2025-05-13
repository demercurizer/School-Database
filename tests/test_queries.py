import pytest
from decimal import Decimal

def exec_fetchall(db_conn, sql):
    cur = db_conn.cursor()
    cur.execute(sql)
    rows = cur.fetchall()
    cur.close()
    return rows

def exec_fetchone(db_conn, sql):
    cur = db_conn.cursor()
    cur.execute(sql)
    row = cur.fetchone()
    cur.close()
    return row

def test_teachers_with_lessons(db_conn):
    """1. Учителя, которые провели хотя бы один урок."""
    rows = exec_fetchall(db_conn, """
        SELECT t.teacherid FROM Teachers t
        JOIN Lessons l ON t.teacherid = l.teacherid
        GROUP BY t.teacherid HAVING COUNT(*)>0;
    """)
    assert len(rows) > 0, "Должен вернуть минимум одного учителя"  # пример простого assert :contentReference[oaicite:6]{index=6}

def test_students_class5_high_mark(db_conn):
    """2. Студенты класса 5 с оценкой >8."""
    row = exec_fetchone(db_conn, """
        SELECT s.studentid FROM Students s
        WHERE s.classid=5 AND EXISTS(
            SELECT 1 FROM Marks m WHERE m.studentid=s.studentid AND m.value>8
        ) LIMIT 1;
    """)
    assert row is not None, "Должен найти хотя бы одного студента"  # verifying EXISTS logic :contentReference[oaicite:7]{index=7}

def test_student_lesson_info(db_conn):
    """3. Информация о студентах и количестве уроков."""
    rows = exec_fetchall(db_conn, """
        SELECT CONCAT(s.name,' - ',c.name,' (Total Lessons: ',
                      (SELECT COUNT(*) FROM Marks m
                       JOIN Lessons ls ON m.lessonid=ls.lessonid
                       WHERE m.studentid=s.studentid),')')
        FROM Students s LEFT JOIN Classes c ON s.classid=c.classid;
    """)
    assert all("Total Lessons:" in r[0] for r in rows), "Каждая строка должна содержать 'Total Lessons:'"

def test_insert_teacher_once(db_conn):
    """4. Вставка учителя, если ещё нет."""
    # Удалим старые тестовые записи
    db_conn.cursor().execute("DELETE FROM Teachers WHERE teacherid=42;")
    db_conn.commit()
    # Попытка вставить
    db_conn.cursor().execute("""
        INSERT INTO Teachers(TeacherID,Name)
        SELECT 42,'Тест' WHERE NOT EXISTS(
            SELECT 1 FROM Teachers WHERE TeacherID=42
        ) LIMIT 1;
    """)
    db_conn.commit()
    row = exec_fetchone(db_conn, "SELECT name FROM Teachers WHERE teacherid=42;")
    assert row[0] == 'Тест', "Должен вставиться новый учитель"

def test_update_student_name(db_conn):
    """5. Обновление имени студента."""
    db_conn.cursor().execute(
        "UPDATE Students SET Name=CONCAT(Name,'_upd') WHERE studentid=15;"
    )
    db_conn.commit()
    name, = exec_fetchone(db_conn, "SELECT name FROM Students WHERE studentid=15;")
    assert name.endswith('_upd'), "Имя должно быть обновлено"

def test_delete_empty_class(db_conn):
    """6. Удаление пустого класса."""
    # Добавим пустой класс
    db_conn.cursor().execute("INSERT INTO Classes(classid,name) VALUES(999,'Temp');")
    db_conn.commit()
    # Попытка удалить
    db_conn.cursor().execute("DELETE FROM Classes WHERE classid=999 AND NOT EXISTS(SELECT 1 FROM Students WHERE classid=999) AND NOT EXISTS(SELECT 1 FROM Lessons WHERE classid=999);")
    db_conn.commit()
    row = exec_fetchone(db_conn, "SELECT 1 FROM Classes WHERE classid=999;")
    assert row is None, "Пустой класс должен быть удалён"

def test_get_marks_for_student7(db_conn):
    """7. Оценки студента 7."""
    rows = exec_fetchall(db_conn, """
        SELECT m.value,l.lessondate,
         (SELECT t.name FROM Teachers t WHERE t.teacherid=l.teacherid)
        FROM Marks m JOIN Lessons l ON m.lessonid=l.lessonid
        WHERE m.studentid=7;
    """)
    assert len(rows) > 0, "Должны быть оценки для студента 7"


def test_avg_mark_per_class(db_conn):
    rows = exec_fetchall(db_conn, """
        SELECT c.ClassID,
               (SELECT AVG(m.Value)
                FROM Marks m
                JOIN Students s ON m.StudentID = s.StudentID
                WHERE s.ClassID = c.ClassID)
        FROM Classes c;
    """)
    # Допускаем Decimal, float или None
    assert all(
        r[1] is None or isinstance(r[1], (float, Decimal))
        for r in rows
    ), "Средние баллы должны быть Decimal, float или NULL"
    
def test_history_for_student15(db_conn):
    """9. История изменений для студента 15."""
    rows = exec_fetchall(db_conn, """
        SELECT historydate FROM Students_history WHERE studentid=15 ORDER BY historydate DESC;
    """)
    assert rows and rows[0][0] is not None, "Должна быть хотя бы одна запись в истории"  # verifying non-empty history

def test_teachers_without_lessons(db_conn):
    """10. Учителя без уроков."""
    rows = exec_fetchall(db_conn, """
        SELECT t.teacherid FROM Teachers t
        LEFT JOIN Lessons l ON t.teacherid=l.teacherid
        WHERE l.lessonid IS NULL;
    """)
    # Проверяем, что возвращается список (может быть пустым)
    assert isinstance(rows, list), "Результат запроса — список кортежей"

