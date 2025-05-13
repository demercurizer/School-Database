-- 1) Индекс на столбец studentid в таблице Marks
CREATE INDEX IF NOT EXISTS idx_marks_studentid
  ON Marks(studentid);

-- 2) Индекс на столбец lessondate в таблице Lessons
CREATE INDEX IF NOT EXISTS idx_lessons_lessondate
  ON Lessons(lessondate);
