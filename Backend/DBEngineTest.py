import mysql.connector

mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="123456789"
)
mydb.connect(database = 'classicmodels')
query = "SELECT * FROM customers"
cnx = mydb.cursor()
cnx.execute(query)
print([x for x in cnx])
cnx.close()
mydb.close()