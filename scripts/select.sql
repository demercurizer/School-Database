-- 1. Выбрать всех учителей
SELECT * FROM Teachers;

-- 2. Найти студентов из класса с ID = 5
SELECT * FROM Students 
WHERE ClassID = 5;

-- 3. Получить имена студентов с названиями их классов
SELECT s.Name AS StudentName, c.Name AS ClassName
FROM Students s
JOIN Classes c ON s.ClassID = c.ClassID;

-- 4. Добавить нового учителя
INSERT INTO Teachers (TeacherID, Name)
VALUES (101, 'Иванова Мария Сергеевна');

-- 5. Обновить имя студента
UPDATE Students
SET Name = 'Петров Алексей'
WHERE StudentID = 42;

-- 6. Удалить класс и все связанные данные (каскадное удаление)
DELETE FROM Classes 
WHERE ClassID = 10;

-- 7. Получить все оценки студента с ID = 7
SELECT m.Value, l.LessonDate, t.Name AS TeacherName
FROM Marks m
JOIN Lessons l ON m.LessonID = l.LessonID
JOIN Teachers t ON m.TeacherID = t.TeacherID
WHERE m.StudentID = 7;

-- 8. Посчитать средний балл по каждому классу
SELECT c.ClassID, c.Name, AVG(m.Value) AS AverageMark
FROM Classes c
JOIN Students s ON c.ClassID = s.ClassID
JOIN Marks m ON s.StudentID = m.StudentID
GROUP BY c.ClassID, c.Name;

-- 9. Найти историю изменений для студента с ID = 15
SELECT sh.HistoryDate, c.Name AS OldClass
FROM Students_history sh
JOIN Classes c ON sh.ClassID = c.ClassID
WHERE sh.StudentID = 15
ORDER BY sh.HistoryDate DESC;

-- 10. Выбрать учителей без проведенных уроков
SELECT t.*
FROM Teachers t
LEFT JOIN Lessons l ON t.TeacherID = l.TeacherID
WHERE l.LessonID IS NULL;