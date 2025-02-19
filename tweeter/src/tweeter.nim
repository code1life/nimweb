# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
#[
when isMainModule:
  echo("Hello, World!")
]#


import asyncdispatch
import jester
import database, views/user, views/general
import times

let db = newDatabase()

proc userLogin(db: Database, request: Request, user: var User): bool =
  if request.cookies.hasKey("username"):
    if not db.findUser(request.cookies["username"], user):
      user = User(username: request.cookies["username"], following: @[])
      db.create(user)
    return true
  else:
    return false

routes:
  get "/":
    #resp "Hello World!"
    #resp renderMain(renderLogin())
    #[if request.cookies.hasKey("username"):
      var user: User
      if not db.findUser(request.cookies["username"], user):
        user = User(username: request.cookies["username"], following: @[])
        db.create(user)
      let messages = db.findMessages(user.following & user.username)
      resp renderMain(renderTimeline(user.username, messages))
    else:
      resp renderMain(renderLogin())]#
    var user: User
    if db.userLogin(request, user):
      let messages = db.findMessages(user.following & user.username)
      resp renderMain(renderTimeline(user.username, messages))
    else:
      resp renderMain(renderLogin())

  post "/login":
    setCookie("username", @"username", getTime().getGMTime() + 3.hours)
    redirect("/")

  post "/createMessage":
    let message = Message(
      username: @"username",
      time: getTime(),
      msg: @"message"
    )
    db.post(message)
    redirect("/")
  
  get "/@name":
    cond '.' notin @"name"
    var user: User
    if not db.findUser(@"name", user):
      halt "User not found"
    
    let messages = db.findMessages(@[user.username])

    var currentUser: User
    if db.userLogin(request, currentUser):
      resp renderMain(renderUser(user, currentUser) & renderMessages(messages))
    else:
      resp renderMain(renderUser(user) & renderMessages(messages))

  post "/follow":
    var follower: User
    var target: User
    if not db.findUser(@"follower", follower):
      halt "Follower not found"
    if not db.findUser(@"target", target):
      halt "Follow target not found"
    db.follow(follower, target)
    redirect(uri("/" & @"target"))

runForever()