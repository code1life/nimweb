### Tweeter
A simplified version of Twitter

### Features
 * Posting messages up to 140 characters
 * Subscribing to another user's posts
 * Viewing the messages posted by users you're following

### Goal
Learn the basic of web development in Nim
 * How web application projects are structured
 * How to store data in a SQL database
 * How to use Nim's templating language
 * How to use Jester web framework
 * How the resulting application can be deployed on a server

### MVC Architecture
When developing web applications, it's useful to abstract database operations into a separate module (database module).

HTML will need to be generated based on the data provided by the database module. 
2 separate views containing procedures to generate HTML : one for the front page and the other for the timelines of different users.

the main source code file that includes the routes will act as the controller.
It will receive HTTP requests from the web browser, and, based on those requests, it will perform the following actions:
 * Retrieve the appropriate data from the db
 * Build the HTML code based on that data
 * Send the generated HTML code back to the requesting web browser

### Starting the project
This section describes the first steps in beginning the project, including:
 * Setting up Tweeter's directory structure
 * Initializing a Nimble package
 * Building a simple Hello World Jester web application

### Storing data in a database
Redis, MongoDB -> NoSQL, they implement their own language, which typically isn't as mature or sophisticated as SQL.
MySQL -> db_mysql module
SQLite -> db_sqlite
PostgreSQL -> db_postgres

Store following info in database
 * Messages posted by users with metadata including the user that posted the mesage and the time it was posted.
 * Information about specific users, including their usernames and the names of users that they're following.

3 actions in Tweeter will trigger data to be added to the database:
 * Posting a new message
 * Following a user
 * Creating an account

### Developing the web application's view
The controller acts as a link joining the view and model components together, so it’s best to implement the view first.

convert information ==> HTML
 * building up a string based on data (%)
   eg: `return "<div><h1>$1</h1><span>Following:$2</span></div>" % [user.username, $user.following.len]`
   draw back:
   * error prone
   * ampersands or < can't escaped.
   * security risk
 * htmlgen module
   defines a DSL for generating HTML
    eg:
    import htmlgen
    proc renderUser(user: User): string =
      return `div`(
        h1(user.username),
        span("Following: ", $user.following.len)
      )
   
   only userfull when generated HTML is small
 * filters
  Filters allow you to mix Nim code together with any other code. 
  eg: 
    #? stdtmpl(subsChar = '$', metaChar = '#', toString = "xmltree.escape") 
    #import "../database"
    #
    #proc renderUser*(user: User): string =
    #  result = ""
    <div id = "user">
        <h1>${user.username}</h1>
        <span>${$user.following.len}</span>
    </div>
    #end proc
    #
    #when isMainModule:
    #  echo renderUser(User(username: "dom96", following: @["adam","bob"]))
    #end when



### Developing the controller
ties the database and views together

When a page is requested, Jester will check the *public* directory (under the project's main directory) for any files that match the page requested.
If the requested page exists in the public directory, Jester will send that page to the browser.
The public directory is known as the static file directory. This directory is set to public by default, but it can be configured using the setStaticDir procedure or in a settings block.



### Something Should Deep into
Auto-compilation - when the page changed, should compile completely


### Deploying the web application

