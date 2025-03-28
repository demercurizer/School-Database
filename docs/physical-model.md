## Таблица Teachers

| **Column Name** | **Data Type**  | **Nullable** | **Key** | **Constraints / Notes**   |
|-----------------|----------------|--------------|---------|---------------------------|
| TeacherID       | INTEGER        | NOT NULL     | PK      | Primary Key               |
| Name            | VARCHAR(200)   | NOT NULL     |         |                           |

---

## Таблица Classes

| **Column Name** | **Data Type**  | **Nullable** | **Key** | **Constraints / Notes**   |
|-----------------|----------------|--------------|---------|---------------------------|
| ClassID         | INTEGER        | NOT NULL     | PK      | Primary Key               |
| Name            | VARCHAR(200)   | NOT NULL     |         |                           |

---

## Таблица Students

| **Column Name** | **Data Type**  | **Nullable**         | **Key** | **Constraints / Notes**                                             |
|-----------------|----------------|----------------------|---------|-----------------------------------------------------------------------|
| StudentID       | INTEGER        | NOT NULL             | PK      | Primary Key                                                           |
| ClassID         | INTEGER        | Nullable             | FK      | References Classes(ClassID); ON DELETE SET NULL (при удалении класса)  |
| Name            | VARCHAR(200)   | NOT NULL             |         |                                                                       |

---

## Таблица Lessons

| **Column Name** | **Data Type**  | **Nullable** | **Key** | **Constraints / Notes**                                                        |
|-----------------|----------------|--------------|---------|--------------------------------------------------------------------------------|
| LessonID        | INTEGER        | NOT NULL     | PK      | Primary Key                                                                    |
| ClassID         | INTEGER        | NOT NULL     | FK      | References Classes(ClassID); ON DELETE CASCADE (при удалении класса)             |
| TeacherID       | INTEGER        | NOT NULL     | FK      | References Teachers(TeacherID); ON DELETE CASCADE (при удалении учителя)         |
| LessonDate      | DATE           | NOT NULL     |         |                                                                                |

---

## Таблица Marks

| **Column Name** | **Data Type**  | **Nullable** | **Key** | **Constraints / Notes**                                                                 |
|-----------------|----------------|--------------|---------|-----------------------------------------------------------------------------------------|
| MarkID          | INTEGER        | NOT NULL     | PK      | Primary Key                                                                             |
| StudentID       | INTEGER        | NOT NULL     | FK      | References Students(StudentID); ON DELETE CASCADE (при удалении студента удаляются оценки)|
| TeacherID       | INTEGER        | NOT NULL     | FK      | References Teachers(TeacherID); ON DELETE CASCADE (при удалении учителя удаляются оценки) |
| LessonID        | INTEGER        | NOT NULL     | FK      | References Lessons(LessonID); ON DELETE CASCADE (при удалении урока удаляются оценки)     |
| Value           | INTEGER        | NOT NULL     |         | CHECK (Value >= 1 AND Value <= 10)                                                        |

---

## Таблица Students_history

| **Column Name** | **Data Type**  | **Nullable** | **Key** | **Constraints / Notes**                                                        |
|-----------------|----------------|--------------|---------|--------------------------------------------------------------------------------|
| ID              | INTEGER        | NOT NULL     | PK      | Primary Key                                                                    |
| StudentID       | INTEGER        | NOT NULL     | FK      | References Students(StudentID); ON DELETE CASCADE                                |
| ClassID         | INTEGER        | NOT NULL     | FK      | References Classes(ClassID); ON DELETE CASCADE                                   |
| HistoryDate     | DATE           | NOT NULL     |         |                                                                                |

