import sqlite3


conn = sqlite3.connect("users.db")

# You can also supply the special name :memory: to create a temporary database in RAM
# conn = sqlite3.connect(':memory:')

c = conn.cursor()

c.execute("CREATE TABLE user (name text, age integer)")
c.execute("INSERT INTO user VALUES ('User A', 42)")
c.execute("INSERT INTO user VALUES ('User B', 43)")

conn.commit()
c.execute("SELECT * FROM user")
print(c.fetchall())
conn.close()
