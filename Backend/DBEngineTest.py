import psycopg2
mydb = psycopg2.connect(database="postgres",
                        host="db.cfzgdevqdufdyilypaha.supabase.co",
                        user="postgres",
                        password="u=fH]Cu&)2u4^hS",
                        port="5432")

query = "SELECT * FROM app_user"
cnx = mydb.cursor()
cnx.execute(query)
print([x for x in cnx])
cnx.close()
mydb.close()