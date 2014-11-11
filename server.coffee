require "newrelic"

express = require('express')
config = require('yaml-config')

$ENV = process.env.NODE_ENV || "dev"
config = config.readConfig("./configs.yml", $ENV)

$PORT = Number(process.env.PORT) || config.server.port

app = express()

app
.use(express.static(__dirname + "/www"))
.listen($PORT)

console.log "server [#{$ENV}] run on port #{$PORT}"