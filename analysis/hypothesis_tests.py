from scipy.stats import ttest_ind, pearsonr, f_oneway
import pandas as pd
import psycopg2

conn = psycopg2.connect(dbname="project", user="postgres", password="postgres", host="localhost")

# Гипотеза 1: t-тест между двумя классами
df = pd.read_sql("SELECT value, s.classid FROM Marks m JOIN Students s ON m.studentid=s.studentid", conn)
group1 = df[df['classid']==1]['value']
group2 = df[df['classid']==2]['value']
stat, p = ttest_ind(group1, group2)
print('t-test между классами 1 и 2: p=', p)

# Гипотеза 2: корреляция уроки vs балл
df2 = pd.read_sql("SELECT s.studentid, COUNT(m.markid) AS lessons, AVG(m.value) AS avg_mark FROM Marks m JOIN Students s ON m.studentid=s.studentid GROUP BY s.studentid", conn)
corr, p = pearsonr(df2['lessons'], df2['avg_mark'])
print('Корреляция уроки–баллы: r=', corr, 'p=', p)

# Гипотеза 3: ANOVA по дням недели
df3 = pd.read_sql("SELECT EXTRACT(DOW FROM l.lessondate) AS dow, m.value FROM Marks m JOIN Lessons l ON m.lessonid=l.lessonid", conn)
groups = [group['value'].values for name, group in df3.groupby('dow')]
stat, p = f_oneway(*groups)
print('ANOVA по дню недели: p=', p)

conn.close()
