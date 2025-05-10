## Таблица Teachers

| **Column Name** | **Data Type**   | **Nullable** | **Key** | **Constraints / Notes**                  |
|-----------------|-----------------|--------------|---------|------------------------------------------|
| TeacherID       | INTEGER         | NOT NULL     | PK      | Primary Key, AUTO_INCREMENT              |
| Name            | VARCHAR(200)    | NOT NULL     |         |                                          |

---

## Таблица Classes

| **Column Name** | **Data Type**   | **Nullable** | **Key** | **Constraints / Notes**                  |
|-----------------|-----------------|--------------|---------|------------------------------------------|
| ClassID         | INTEGER         | NOT NULL     | PK      | Primary Key, AUTO_INCREMENT              |
| Name            | VARCHAR(200)    | NOT NULL     |         |                                          |

---

## Таблица Students

| **Column Name** | **Data Type**   | **Nullable** | **Key** | **Constraints / Notes**                                                           |
|-----------------|-----------------|--------------|---------|-----------------------------------------------------------------------------------|
| StudentID       | INTEGER         | NOT NULL     | PK      | Primary Key, AUTO_INCREMENT                                                       |
| ClassID         | INTEGER         | Nullable     | FK      | Foreign Key: References Classes(ClassID); ON DELETE SET NULL                        |
| Name            | VARCHAR(200)    | NOT NULL     |         |                                                                                   |
| Email           | VARCHAR(255)    | NOT NULL     |         | Рекомендуется UNIQUE, если email должен быть уникальным                           |
| PhoneNumber     | VARCHAR(50)     |              |         |                                                                                   |

---

## Таблица Lessons

| **Column Name**    | **Data Type**  | **Nullable** | **Key** | **Constraints / Notes**                                                          |
|--------------------|----------------|--------------|---------|----------------------------------------------------------------------------------|
| LessonID           | INTEGER        | NOT NULL     | PK      | Primary Key, AUTO_INCREMENT                                                      |
| ClassID            | INTEGER        | NOT NULL     | FK      | Foreign Key: References Classes(ClassID); ON DELETE CASCADE                        |
| TeacherID          | INTEGER        | NOT NULL     | FK      | Foreign Key: References Teachers(TeacherID); ON DELETE CASCADE                       |
| LessonDate         | DATE           | NOT NULL     |         |                                                                                  |
| LessonStartTime    | TIME           |              |         | Время начала урока                                                               |

---

## Таблица Marks

| **Column Name** | **Data Type**  | **Nullable** | **Key** | **Constraints / Notes**                                                                     |
|-----------------|----------------|--------------|---------|---------------------------------------------------------------------------------------------|
| MarkID          | INTEGER        | NOT NULL     | PK      | Primary Key, AUTO_INCREMENT                                                                 |
| StudentID       | INTEGER        | NOT NULL     | FK      | Foreign Key: References Students(StudentID); ON DELETE CASCADE                                |
| LessonID        | INTEGER        | NOT NULL     | FK      | Foreign Key: References Lessons(LessonID); ON DELETE CASCADE                                   |
| Value           | INTEGER        | NOT NULL     |         | CHECK (Value >= 1 AND Value <= 10)                                                            |

> **Примечание**: Поле TeacherID удалено, так как преподаватель определяется через таблицу Lessons.

---

## Таблица Students_history

| **Column Name** | **Data Type**  | **Nullable** | **Key** | **Constraints / Notes**                                                                         |
|-----------------|----------------|--------------|---------|-------------------------------------------------------------------------------------------------|
| ID              | INTEGER        | NOT NULL     | PK      | Primary Key, AUTO_INCREMENT                                                                     |
| StudentID       | INTEGER        | NOT NULL     | FK      | Foreign Key: References Students(StudentID); ON DELETE CASCADE                                           |
| OldClassID      | INTEGER        | NULL         | FK      | Foreign Key: References Classes(ClassID); ON DELETE CASCADE (класс, в котором студент был ранее)         |
| NewClassID      | INTEGER        | NULL         | FK      | Foreign Key: References Classes(ClassID); ON DELETE CASCADE (класс, в который студент перешёл)           |
| HistoryDate     | DATE           | NOT NULL     |         |                                                                                                 |