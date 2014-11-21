require "newrelic"

express = require('express')
MobileDetect = require('mobile-detect')
config = require('yaml-config')


$ENV = process.env.NODE_ENV || "dev"
config = config.readConfig("./configs.yml", $ENV)

$PORT = Number(process.env.PORT) || config.server.port

app = express()

app
.use((req, res, next) ->
  if req.path == "/"
    md = new MobileDetect(req.headers['user-agent'])
    console.log ">>>server.coffee:20", md.mobile()
    if !md.mobile()
      res.redirect("/d")
      return
  next()
)
.use("/d", express.static(__dirname + "/www/index.d.html"))
.use(express.static(__dirname + "/www"))
.listen($PORT)

console.log "server [#{$ENV}] run on port #{$PORT}"