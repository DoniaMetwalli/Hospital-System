import psycopg2

conn = psycopg2.connect(database="postgres",
                        host="db.cfzgdevqdufdyilypaha.supabase.co",
                        user="postgres",
                        password="u=fH]Cu&)2u4^hS",
                        port="5432")
cursor = conn.cursor()
cursor.execute("select * from test;")
print(
    cursor.fetchall()
)

