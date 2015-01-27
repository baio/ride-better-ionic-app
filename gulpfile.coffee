"use strict"

gulp = require("gulp")
gutil = require("gulp-util")
bower = require("bower")
concat = require("gulp-concat")
#sass = require("gulp-sass")
#minifyCss = require("gulp-minify-css")
rename = require("gulp-rename")
clean = require("gulp-clean")
template = require "gulp-template"
nodemon = require "nodemon"
sh = require("shelljs")
paths = sass: ["./scss/**/*.scss"]
plumber = require "gulp-plumber"
coffee = require "gulp-coffee"
jade = require "gulp-jade"
lr = require "tiny-lr"
zip = require "gulp-zip"
resources_str_ru = require("./resources/ru/strings_ru.json")
resources_str_en = require("./resources/en/strings_en.json")

mainBowerFiles = require "main-bower-files"

require("gulp-grunt")(gulp)

yamlConfig = require "yaml-config"
traverse = require "traverse"

$ENV = process.argv.slice(3)[0]
if $ENV
  $ENV = $ENV.replace "--", ""
else
  $ENV = process.env.NODE_ENV_BUILD  || process.env.NODE_ENV

if !$ENV
  console.log gutil.colors.cyan("NODE_ENV not set neither param not passed, exit")
  process.exit(1)
  return
else
  console.log "$ENV is set to #{$ENV}"

config = yamlConfig.readConfig('./configs.yml', $ENV)


traverse(config).forEach (x) ->
  if typeof x == "string" and x[0] == "$"
    @update process.env[x[1..]]

if typeof config.client.apiUrl == "object"
  config.client.apiUrl = "//" + config.client.apiUrl.host + ":" +  config.client.apiUrl.port

if typeof config.client.auth.apiUrl == "object"
  config.client.auth.apiUrl = "//" + config.client.auth.apiUrl.host + ":" +  config.client.auth.apiUrl.port


lrServer = lr()

gulp.task "default", ["dev-server"]

gulp.task "jade", ["jade.d", "jade.m"]

gulp.task "jade.m", ->
  locals = 
    env : config.env
    version : require("./package.json").version
    i18n : 
      ru : resources : str : resources_str_ru
      en : resources : str : resources_str_en
  gulp.src("./src/jade/index.jade")
  .pipe(plumber())
  .pipe(jade(pretty : true, locals : locals))
  .pipe(concat("index.html"))
  .pipe(gulp.dest("./www"))

gulp.task "jade.d", ->
  locals =
    env : config.env
    version : require("./package.json").version
    i18n : 
      ru : resources : str : resources_str_ru
      en : resources : str : resources_str_en
  gulp.src("./src/jade/index.d.jade")
  .pipe(plumber())
  .pipe(jade(pretty : true, locals : locals))
  .pipe(concat("index.d.html"))
  .pipe(gulp.dest("./www"))


buildCoffee = ->
  gulp.src(["./src/coffee/app.coffee", "./src/coffee/**/*.coffee"])
  .pipe(plumber())
  .pipe(coffee(bare: true))
  .pipe(concat("app.js"))
  .pipe(gulp.dest("./www"))

gulp.task "build-coffee",  ["create-app-config"], buildCoffee
gulp.task "coffee",  buildCoffee


gulp.task "watch-jade", ["jade"], ->
  gulp.watch "./src/jade/**/*.jade", ["jade"]

gulp.task "watch-coffee", ["build-coffee"], ->
  gulp.watch "./src/coffee/**/*.coffee", ["coffee"]

gulp.task "sass", (done) ->
  gulp.src("./scss/ionic.app.scss").pipe(sass()).pipe(gulp.dest("./www/css/")).pipe(minifyCss(keepSpecialComments: 0)).pipe(rename(extname: ".min.css")).pipe(gulp.dest("./www/css/")).on "end", done
  return

gulp.task "watch-sass", ["sass"], ->
  gulp.watch paths.sass, ["sass"]
  return

gulp.task "watch-assets", ->
  lrServer.listen 35729, (err) ->
    if err
      console.log err
  gulp.watch ["./www/app.js", "./www/css/*.css", "./www/index.html"], (file) ->
    lrServer.changed body : files: [file.path]

gulp.task "nodemon", ->
  nodemon(script : "./server.coffee")

gulp.task "install", ["git-check"], ->
  bower.commands.install().on "log", (data) ->
    gutil.log "bower", gutil.colors.cyan(data.id), data.message
    return

gulp.task "git-check", (done) ->
  unless sh.which("git")
    console.log "  " + gutil.colors.red("Git is not installed."), "\n  Git, the version control system, is required to download Ionic.", "\n  Download git here:", gutil.colors.cyan("http://git-scm.com/downloads") + ".", "\n  Once git is installed, run '" + gutil.colors.cyan("gulp install") + "' again."
    process.exit 1
  done()
  return

gulp.task "create-app-config", ->

  clientOpts =
    apiUrl : config.client.apiUrl
    auth : config.client.auth
    env : $ENV

  gulp.src("./app.config.template")
  .pipe(template(clientOpts))
  .pipe(concat("app.config.coffee"))
  .pipe(gulp.dest("./src/coffee"))

gulp.task "pgb-clean", ->
  gulp.src(".release/pgb-src", read : false).pipe(clean())

gulp.task "pgb-build", ["build", "pgb-clean"],  (done) ->
  gulp.src("./www/**/*").pipe(gulp.dest(".release/pgb-src"))
  gulp.src("./config.xml").pipe(gulp.dest(".release/pgb-src"))
  gulp.src("./res/.res/**/*").pipe(gulp.dest(".release/pgb-src/res"))
  gulp.src("./www/.pgbomit").pipe(gulp.dest(".release/pgb-src/res"))
  gulp.src("./www/.pgbomit").pipe(gulp.dest(".release/pgb-src/lib"))
  setTimeout done, 5000

gulp.task "pgb-zip", ["pgb-build"], ->
  gulp.src('.release/pgb-src/**/*').pipe(zip('pgb-src.zip')).pipe(gulp.dest('.release/pgb-src'))

gulp.task "pgb-release", ["pgb-zip"], ->
  gulp.run("grunt-phonegap-build")

gulp.task "bundle-lib", ->
  gulp.src(mainBowerFiles())
  .pipe(gulp.dest('www/lib-bundle'))

gulp.task "dev-server", ["bundle-lib", "watch-jade", "watch-coffee", "watch-assets", "nodemon"]
gulp.task "build", ["bundle-lib", "jade", "build-coffee"]

