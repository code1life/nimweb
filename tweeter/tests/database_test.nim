import database
import os, times

when isMainModule:
  removeFile("tweeter_test.db")
  var db = newDatabase("tweeter_test.db")
  db.setup()
  db.create(User(username: "dom96"))
  db.create(User(username: "nim_lang"))
  db.post(Message(username: "nim_lang", time: getTime() - 4.minutes, msg: "Hello Nim"))
  db.post(Message(username: "nim_lang", time: getTime(), msg: "Nim 0.19.4 has released"))

  var dom: User
  doAssert db.findUser("dom96", dom)
  var nim: User
  doAssert db.findUser("nim_lang", nim)
  db.follow(dom, nim)

  doAssert db.findUser("dom96", dom)

  let messages = db.findMessages(dom.following)
  echo(messages)
