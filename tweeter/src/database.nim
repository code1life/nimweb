import times
import db_sqlite
import strutils

type
  User* = object # represent information about a single specific user
    username*: string
    following*: seq[string]
  
  Message* = object # represent information about a single specific message
    username*: string
    time*: Time #floating-point time field
    msg*: string

# The User, Message types map pretty well to User and Message tabls.

#[
    database module needs to provide procedures that return such objects.
    Once those objects are returned, it’s simply a case of turning the information stored in those objects into HTML
]#

  Database* = ref object
    db: DbConn # DbConn object should be saved in a custom Database object so that it can be changed if required in the future.

proc newDatabase* (filename = "tweeter.db"): Database =
  new result
  result.db = open(filename, "", "", "")

proc post*(database: Database, message: Message) =
  if message.msg.len > 140:
    raise newException(ValueError, "Message has to be less than 140 characters.")
  database.db.exec(sql"""
    INSERT INTO Message Values (?,?,?);
  """, message.username, $message.time.toUnix(), message.msg) # toSeconds() ==> toUnix()

proc follow*(database: Database, follower: User, user: User) =
  database.db.exec(sql"""
    INSERT INTO Following Values(?,?);
  """, follower.username, user.username)

proc create*(database: Database, user: User) = 
  database.db.exec(sql"""
    INSERT INTO User Values(?);
  """, user.username)

proc findUser*(database: Database, username: string, user: var User): bool =
  let row = database.db.getRow(sql"SELECT username FROM User WHERE username = ?;", username)
  if row[0].len == 0: return false
  else: user.username = row[0]

  let following = database.db.getAllRows(sql"SELECT followed_user FROM Following WHERE follower = ?;", username)
  user.following = @[]
  for row in following:
    if row[0].len != 0:
      user.following.add(row[0]) # ???
  return true

proc findMessages*(database: Database, usernames: seq[string], limit = 10): seq[Message] =
  result = @[]
  if usernames.len == 0: return
  var whereClause = " WHERE "
  for i in 0 .. usernames.len - 1:
    whereClause.add("username = ? ")
    if i != usernames.len - 1:
      whereClause.add("or ")
  let messages = database.db.getAllRows(
      sql("SELECT username, time, msg FROM Message" & whereClause & "ORDER by time DESC LIMIT " & $limit), 
      usernames
  )
  for row in messages:
    result.add(Message(username: row[0], time: fromUnix(row[1].parseInt), msg: row[2])) # fromSeconds() ==> fromUnix()

proc close*(database: Database)=
  database.db.close()

proc setup*(database: Database) =
  database.db.exec(sql"""
    CREATE TABLE IF NOT EXISTS User(
      username text PRIMARY KEY
    );
  """)
  database.db.exec(sql"""
    CREATE TABLE IF NOT EXISTS Following(
      follower text,
      followed_user text,
      PRIMARY KEY(follower, followed_user),
      FOREIGN KEY(follower) REFERENCES User(username),
      FOREIGN KEY(followed_user) REFERENCES User(username)
    );
  """)
  database.db.exec(sql"""
    CREATE TABLE IF NOT EXISTS Message(
      username text,
      time integer,
      msg text NOT NULL,
      FOREIGN KEY(username) REFERENCES User(username)
    );
  """)

  