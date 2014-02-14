express = require 'express'
app = express()

app.configure () ->
  app.set 'port', process.env.PORT||3000
  app.use express.logger('dev') # log every request to the console
  app.use express.urlencoded()
  app.use express.json()
  app.use express.methodOverride() # simulate DELETE and PUT
  if app.get('env')=='development' then app.use express.errorHandler()
  if app.get('env')=='production' then

app.listen app.get('port'), () ->
  console.log "Server listening on port #{app.get('port')}"

module.exports = app
