import os
import pandas as pd
import matplotlib.pyplot as plt
import psycopg2
from matplotlib.ticker import MultipleLocator, MaxNLocator
import numpy as np

OUT_DIR = "graphs"
os.makedirs(OUT_DIR, exist_ok=True)

conn = psycopg2.connect(
    dbname="project",
    user="postgres",
    password="postgres",
    host="localhost"
)

#1. Гистограмма оценок, привязанная к целым
df_marks = pd.read_sql("SELECT value FROM Marks", conn)

# границы корзин: 5.5–6.5, 6.5–7.5, …, 9.5–10.5
bins = np.arange(5.5, 11.0, 1.0)

fig, ax = plt.subplots()
ax.hist(df_marks['value'], bins=bins, edgecolor='black', align='mid')
ax.set_title('Распределение оценок (bins = целые)')
ax.set_xlabel('Оценка')
ax.set_ylabel('Количество учеников')

# X — только целые 6,7,8,9,10
ax.xaxis.set_major_locator(MultipleLocator(1))
ax.xaxis.set_minor_locator(MultipleLocator(1))
ax.set_xticks([6,7,8,9,10])

# Y — целые
ax.yaxis.set_major_locator(MaxNLocator(integer=True))

plt.tight_layout()
plt.savefig(f"{OUT_DIR}/histogram_marks_integer_bins.png")
plt.clf()

# 2. Линейный график динамики среднего балла по датам
df_date = pd.read_sql(
    """
    SELECT lessondate, AVG(value)::float AS avg_mark
    FROM Marks m
    JOIN Lessons l USING (lessonid)
    GROUP BY lessondate
    ORDER BY lessondate
    """,
    conn
)
fig, ax = plt.subplots()
ax.plot(df_date['lessondate'], df_date['avg_mark'], marker='o')
ax.set_title('Динамика среднего балла по дате урока')
ax.set_xlabel('Дата урока')
ax.set_ylabel('Средний балл')
plt.xticks(rotation=45)

ax.yaxis.set_major_locator(MaxNLocator(integer=True))

plt.tight_layout()
plt.savefig(f"{OUT_DIR}/line_avg_by_date.png")
plt.clf()

# 3. Гипотеза: определить самого «халявного» учителя
df_teacher = pd.read_sql(
    """
    SELECT t.teacherid,
           t.name                      AS teacher_name,
           AVG(m.value)::float         AS avg_mark
    FROM Marks m
    JOIN Lessons l ON m.lessonid = l.lessonid
    JOIN Teachers t ON l.teacherid = t.teacherid
    GROUP BY t.teacherid, t.name
    ORDER BY avg_mark DESC
    """,
    conn
)
fig, ax = plt.subplots()
df_teacher.head(10).plot(
    x='teacher_name',
    y='avg_mark',
    kind='bar',
    ax=ax,
    legend=False
)
ax.set_title('Топ-10 учителей по среднему баллу (гипотеза «халявщика»)')
ax.set_xlabel('Имя учителя')
ax.set_ylabel('Средний балл')
plt.xticks(rotation=45, ha='right')

ax.yaxis.set_major_locator(MaxNLocator(integer=True))

plt.tight_layout()
plt.savefig(f"{OUT_DIR}/bar_top10_teachers_avg.png")
plt.clf()

conn.close()

print(f"Графики сохранены в папке «{OUT_DIR}/»")
