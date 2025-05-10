--Имя + текущий класс
CREATE VIEW student_current_class AS
SELECT 
  s.name    AS student_name,
  c.name    AS class_name
FROM students s
JOIN classes c USING (classid);


--Самая низкая оценка 
CREATE OR REPLACE VIEW student_min_mark AS
SELECT DISTINCT ON (s.studentid)
  s.studentid,
  s.name        AS student_name,
  c.name        AS class_name,
  t.name        AS subject,
  m.value       AS min_mark,
  l.lessondate  AS when_received
FROM students s
JOIN classes  c ON s.classid   = c.classid
JOIN marks    m ON m.studentid = s.studentid
JOIN lessons  l ON m.lessonid  = l.lessonid
JOIN teachers t ON l.teacherid = t.teacherid
ORDER BY 
  s.studentid,
  m.value ASC,
  l.lessondate;


select * from student_current_class;
select * from student_min_mark;