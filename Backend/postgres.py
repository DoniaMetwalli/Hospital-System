import psycopg2

conn = psycopg2.connect(database="postgres",
                        host="db.cfzgdevqdufdyilypaha.supabase.co",
                        user="postgres",
                        password="u=fH]Cu&)2u4^hS",
                        port="5432")
cursor = conn.cursor()
# cursor.execute("DELETE FROM patient where patient_id > 1000000;")
# cursor.execute("DELETE FROM app_user where user_id > 1000000 and user_type = 'p';")
# conn.commit()
cursor.execute('select * from dialysis_machine;')
print(cursor.fetchall())