#import db_sqlite

#[var dbConn = open("tweeter.db", "", "", "")

dbConn.exec(sql"""
    CREATE TABLE IF NOT EXISTS User(
        username text PRIMARY KEY
    );
""")

dbConn.exec(sql"""
    CREATE TABLE IF NOT EXISTS Following(
        follower text,
        followed_user text,
        PRIMARY KEY(follower, followed_user)
        FOREIGN KEY(follower) REFERENCES User(username),
        FOREIGN KEY(followed_user) REFERENCES User(username)
    );
""")

dbConn.exec(sql"""
    CREATE TABLE IF NOT EXISTS Message(
        username text,
        time integer,
        msg text NOT NULL,
        FOREIGN KEY(username) REFERENCES User(username)
    );
""")

echo("Database created successfully!")
dbConn.close()]#

import database

var db = newDatabase()
db.setup()
echo("Database created successfully!")
db.close()