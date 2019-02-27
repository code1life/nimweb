#? stdtmpl(subsChar = '$', metaChar = '#', toString = "xmltree.escape") #toString ==> line14 dom96<> ==> dom96&lt;&gt;
#import "../database"
#import xmltree
#import times
#
#proc renderUser*(user: User): string =
<!-- test HTML annotation (dispear at compile period) -->
#  result = ""
<!-- test HTML annotation (keep after compile) -->
<div id="user">
<!-- test HTML annotation (here is also OK) -->
    <h1>${user.username}</h1>
    <span>Following: ${$user.following.len}</span>
</div>
#end proc
#
#proc renderUser*(user: User, currentUser: User): string =
<!-- Instead of making the renderUser procedure more complicated => overload -->
#  result = ""
<div>
<!-- overload renderUser procedure that takes an additional parameter called currentUser -->
    <h1>${user.username}</h1>
    <span>Following: ${$user.following.len}</span>
    #if user.username notin currentUser.following:
    <form action="follow" method="post">
        <input type="hidden" name="follower" value="${currentUser.username}">
        <input type="hidden" name="target" value="${user.username}">
        <input type="submit" value="Follow">
    </form>
    #end if
</div>
#end proc
#
#proc renderMessages*(messages: seq[Message]): string =
#  result = ""
<div id="message">
    #for message in messages:
    <div>
        <a href="/${message.username}">${message.username}</a>
        <span>${message.time.getGMTime().format("HH:mm MMMM d',' yyyy")}</span>
        <h3>${message.msg}</h3><br>
    </div>
    #end for
</div>
#end proc
#
#when isMainModule:
#  echo renderUser(User(username: "dom96<>", following: @["adam","bob"]))
#  echo renderMessages(@[Message(username: "dom96", time: getTime(), msg: "Hello World!"),
#                        Message(username: "dom96", time: getTime(), msg: "Testing")])
#end when