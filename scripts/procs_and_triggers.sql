-- Процедура: перевод студента в новый класс с записью в историю
CREATE OR REPLACE PROCEDURE move_student_to_class(
  p_studentid   INTEGER,
  p_new_classid INTEGER
)
LANGUAGE plpgsql AS $$
DECLARE
  next_id INTEGER;
BEGIN
  SELECT COALESCE(MAX(id),0) + 1 INTO next_id FROM Students_history;
  INSERT INTO Students_history(id, StudentID, OldClassID, NewClassID, HistoryDate)
  SELECT next_id, s.StudentID, s.ClassID, p_new_classid, current_date
    FROM Students s
   WHERE s.StudentID = p_studentid;
  UPDATE Students SET ClassID = p_new_classid WHERE StudentID = p_studentid;
END;
$$;

-- Функция: средний балл по студенту
CREATE OR REPLACE FUNCTION get_student_avg_mark(p_studentid INTEGER)
RETURNS NUMERIC(5,2)
LANGUAGE plpgsql AS $$
DECLARE
  avg_mark NUMERIC(5,2);
BEGIN
  SELECT AVG(Value)::NUMERIC(5,2) INTO avg_mark FROM Marks WHERE StudentID = p_studentid;
  RETURN avg_mark;
END;
$$;

-- Функция: средний балл по классу
CREATE OR REPLACE FUNCTION get_class_avg_mark(p_classid INTEGER)
RETURNS NUMERIC(5,2)
LANGUAGE plpgsql AS $$
DECLARE
  avg_mark NUMERIC(5,2);
BEGIN
  SELECT AVG(m.Value)::NUMERIC(5,2) INTO avg_mark
    FROM Marks m
    JOIN Students s ON m.StudentID = s.StudentID
   WHERE s.ClassID = p_classid;
  RETURN avg_mark;
END;
$$;

-- Триггер: логирование смены класса
CREATE OR REPLACE FUNCTION trg_fn_log_class_change()
RETURNS trigger
LANGUAGE plpgsql AS $$
DECLARE
  next_id INTEGER;
BEGIN
  IF OLD.ClassID IS DISTINCT FROM NEW.ClassID THEN
    -- вычисляем следующий id
    SELECT COALESCE(MAX(id),0) + 1
      INTO next_id
      FROM Students_history;
    -- вставляем с этим id
    INSERT INTO Students_history(id, StudentID, OldClassID, NewClassID, HistoryDate)
    VALUES(next_id, NEW.StudentID, OLD.ClassID, NEW.ClassID, current_date);
  END IF;
  RETURN NEW;
END;
$$;

-- Триггер: валидация оценки
CREATE OR REPLACE FUNCTION trg_fn_validate_mark()
RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.Value < 1 OR NEW.Value > 10 THEN
    RAISE EXCEPTION 'Mark value % out of allowed range 1..10', NEW.Value;
  END IF;
  RETURN NEW;
END;
$$;
CREATE TRIGGER trg_marks_validate
  BEFORE INSERT OR UPDATE ON Marks
  FOR EACH ROW
  EXECUTE PROCEDURE trg_fn_validate_mark();

-- Триггер: установка времени урока по умолчанию
CREATE OR REPLACE FUNCTION trg_fn_default_lesson_time()
RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.LessonStartTime IS NULL THEN
    NEW.LessonStartTime := TIME '09:00:00';
  END IF;
  RETURN NEW;
END;
$$;
CREATE TRIGGER trg_lessons_default_time
  BEFORE INSERT ON Lessons
  FOR EACH ROW
  EXECUTE PROCEDURE trg_fn_default_lesson_time();





-- 1) Перевод студента в новый класс и запись в историю
CALL move_student_to_class(7, 3);

SELECT * 
FROM Students_history 
WHERE StudentID = 7 
ORDER BY HistoryDate DESC;

-- Проверить, что у студента в основной таблице ClassID = 3
SELECT StudentID, ClassID 
FROM Students 
WHERE StudentID = 7;

-- 2) Проверка средней оценки конкретного студента
-- 3) Проверка средней оценки по классу
SELECT 
  get_student_avg_mark(7)   AS avg_mark_for_student_7,
  get_class_avg_mark(3)     AS avg_mark_for_class_3;
