-- 1. Выбрать учителей, которые провели хотя бы один урок, и вывести имя с количеством проведённых уроков
SELECT 
    t.TeacherID,
    t.Name AS TeacherName,
    COUNT(l.LessonID) AS TotalLessons
FROM Teachers t
JOIN Lessons l ON t.TeacherID = l.TeacherID
GROUP BY t.TeacherID, t.Name
HAVING COUNT(l.LessonID) > 0;

-- 2. Найти студентов из класса с ID = 5, у которых есть хотя бы одна оценка выше 8
SELECT s.StudentID, s.Name
FROM Students s
WHERE s.ClassID = 5
  AND EXISTS (
      SELECT 1 
      FROM Marks m
      WHERE m.StudentID = s.StudentID
        AND m.Value > 8
  );

-- 3. Получить имена студентов с названиями их классов и общее количество уроков, которые посещал студент
SELECT 
    s.StudentID,
    CONCAT(s.Name, ' - ', c.Name, ' (Total Lessons: ', 
           (SELECT COUNT(*) FROM Marks m JOIN Lessons ls ON m.LessonID = ls.LessonID 
            WHERE m.StudentID = s.StudentID), ')') AS StudentInfo
FROM Students s
LEFT JOIN Classes c ON s.ClassID = c.ClassID;

-- 4. Добавить нового учителя только если учитель с таким именем еще не существует
INSERT INTO Teachers (TeacherID, Name)
SELECT 42, 'Иванова Мария Сергеевна'
WHERE NOT EXISTS (
  SELECT 1 FROM Teachers WHERE Name = 'Иванова Мария Сергеевна'
)
LIMIT 1;


-- 5. Обновить имя студента с ID = 42, добавив постфикс к первой части имени
UPDATE Students
SET Name = 
  concat(Name, ' ', 1)
WHERE StudentID = 15;

-- 6. Удалить класс с ID = 10, если в нем нет студентов и уроков
DELETE FROM Classes
WHERE ClassID = 10
  AND NOT EXISTS (
      SELECT 1 FROM Students WHERE ClassID = 10
  )
  AND NOT EXISTS (
      SELECT 1 FROM Lessons WHERE ClassID = 10
  );

-- 7. Получить все оценки студента с ID = 7, включая дату урока и имя преподавателя
SELECT 
    m.Value, 
    l.LessonDate, 
    (SELECT t.Name FROM Teachers t WHERE t.TeacherID = l.TeacherID) AS TeacherName
FROM Marks m
JOIN Lessons l ON m.LessonID = l.LessonID
WHERE m.StudentID = 7;

-- 8. Посчитать средний балл по каждому классу
SELECT 
    c.ClassID, 
    c.Name,
    (SELECT AVG(m.Value)
     FROM Marks m
     JOIN Students s ON m.StudentID = s.StudentID
     WHERE s.ClassID = c.ClassID) AS AverageMark
FROM Classes c;

-- 9. Найти историю изменений для студента с ID = 15, выводя названия старого и нового классов
SELECT 
    sh.HistoryDate,
    (SELECT Name FROM Classes WHERE ClassID = sh.OldClassID) AS OldClass,
    (SELECT Name FROM Classes WHERE ClassID = sh.NewClassID) AS NewClass
FROM Students_history sh
WHERE sh.StudentID = 15
ORDER BY sh.HistoryDate DESC;

-- 10. Выбрать учителей, у которых не проведено ни одного урока
SELECT t.*
FROM Teachers t
LEFT JOIN Lessons l ON t.TeacherID = l.TeacherID
WHERE l.LessonID IS NULL;
