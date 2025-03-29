-- Создание таблицы Teachers
CREATE TABLE Teachers (
    TeacherID INTEGER PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(200) NOT NULL
);

-- Создание таблицы Classes
CREATE TABLE Classes (
    ClassID INTEGER PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(200) NOT NULL
);

-- Создание таблицы Students
CREATE TABLE Students (
    StudentID INTEGER PRIMARY KEY AUTO_INCREMENT,
    ClassID INTEGER,
    Name VARCHAR(200) NOT NULL,
    Email VARCHAR(255),
    PhoneNumber VARCHAR(50),
    CONSTRAINT fk_students_class
        FOREIGN KEY (ClassID)
        REFERENCES Classes(ClassID)
        ON DELETE SET NULL  -- при удалении класса связь сбрасывается
);

-- Создание таблицы Lessons
CREATE TABLE Lessons (
    LessonID INTEGER PRIMARY KEY AUTO_INCREMENT,
    ClassID INTEGER NOT NULL,
    TeacherID INTEGER NOT NULL,
    LessonDate DATE NOT NULL,
    LessonStartTime TIME,  -- время начала урока
    CONSTRAINT fk_lessons_class
        FOREIGN KEY (ClassID)
        REFERENCES Classes(ClassID)
        ON DELETE CASCADE,  -- при удалении класса удаляются уроки
    CONSTRAINT fk_lessons_teacher
        FOREIGN KEY (TeacherID)
        REFERENCES Teachers(TeacherID)
        ON DELETE CASCADE   -- при удалении учителя удаляются уроки
);

-- Создание таблицы Marks
-- Удалён столбец TeacherID, т.к. он может быть получен через таблицу Lessons (Lessons.TeacherID)
CREATE TABLE Marks (
    MarkID INTEGER PRIMARY KEY AUTO_INCREMENT,
    StudentID INTEGER NOT NULL,
    LessonID INTEGER NOT NULL,
    Value INTEGER CHECK (Value >= 1 AND Value <= 10),
    CONSTRAINT fk_marks_student
        FOREIGN KEY (StudentID)
        REFERENCES Students(StudentID)
        ON DELETE CASCADE,  -- при удалении студента удаляются оценки
    CONSTRAINT fk_marks_lesson
        FOREIGN KEY (LessonID)
        REFERENCES Lessons(LessonID)
        ON DELETE CASCADE   -- при удалении урока удаляются оценки
);

-- Создание таблицы истории студентов (Students_history)
-- Здесь добавлены два поля: OldClassID и NewClassID, отражающие изменение класса
CREATE TABLE Students_history (
    ID INTEGER PRIMARY KEY AUTO_INCREMENT,
    StudentID INTEGER NOT NULL,
    OldClassID INTEGER NOT NULL,  -- класс, в котором студент был ранее
    NewClassID INTEGER NOT NULL,  -- класс, в который студент перешёл
    HistoryDate DATE NOT NULL,
    CONSTRAINT fk_history_student
        FOREIGN KEY (StudentID)
        REFERENCES Students(StudentID)
        ON DELETE CASCADE,
    CONSTRAINT fk_history_oldclass
        FOREIGN KEY (OldClassID)
        REFERENCES Classes(ClassID)
        ON DELETE CASCADE,
    CONSTRAINT fk_history_newclass
        FOREIGN KEY (NewClassID)
        REFERENCES Classes(ClassID)
        ON DELETE CASCADE
);
