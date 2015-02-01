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
pack = require("./package.json")
ngAnnotate = require "gulp-ng-annotate"
uglify = require "gulp-uglify"
concat = require "gulp-concat"
runSequence = require "run-sequence"
minifyCSS = require "gulp-minify-css"
mainBowerFiles = require "main-bower-files"
manifest = require "gulp-manifest"

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
    version : pack.version
    i18n : 
      ru : resources : str : resources_str_ru
      en : resources : str : resources_str_en
  gulp.src("./src/jade/index.jade")
  .pipe(plumber())
  .pipe(jade(pretty : false, locals : locals))
  .pipe(concat("index.html"))
  .pipe(gulp.dest("./www"))

gulp.task "jade.d", ->
  locals =
    env : config.env
    version : pack.version
    i18n : 
      ru : resources : str : resources_str_ru
      en : resources : str : resources_str_en
  gulp.src("./src/jade/index.d.jade")
  .pipe(plumber())
  .pipe(jade(pretty : false, locals : locals))
  .pipe(concat("index.d.html"))
  .pipe(gulp.dest("./www"))


buildCoffee = ->
  stream = gulp.src(["./src/coffee/app.coffee", "./src/coffee/**/*.coffee"])
  .pipe(plumber())
  .pipe(coffee(bare: true))
  .pipe(concat("app.js"))
  .pipe(gulp.dest("assets/app/js/"))

gulp.task "create-app-config", ->

  clientOpts =
    apiUrl : config.client.apiUrl
    auth : config.client.auth
    env : $ENV
    pushKeys : config.client.pushKeys

  gulp.src("./app.config.template")
  .pipe(template(clientOpts))
  .pipe(concat("app.config.coffee"))
  .pipe(gulp.dest("./src/coffee"))


gulp.task "build-coffee",  ["create-app-config"], buildCoffee
gulp.task "coffee",  buildCoffee

gulp.task "watch-jade", ["jade"], ->
  gulp.watch "./src/jade/**/*.jade", ["jade"]

gulp.task "watch-coffee", ["build-coffee"], ->
  gulp.watch "./src/coffee/**/*.coffee", ["coffee"]

gulp.task "watch-assets", ->
  lrServer.listen 35729, (err) ->
    if err
      console.log err
  gulp.watch ["./www/app.js", "./www/css/*.css", "./www/index.html"], (file) ->
    lrServer.changed body : files: [file.path]

gulp.task "nodemon", ->
  nodemon(script : "./server.coffee")

gulp.task "build-minify-app", ["build-coffee"], ->
  gulp.src("assets/app/js/app.js").pipe(ngAnnotate()).pipe(uglify()).pipe(gulp.dest("./.build"))

gulp.task "build-minify-fix", ->
  gulp.src("assets/fix/js/ionic.bundle.js").pipe(uglify()).pipe(gulp.dest("./.build"))

gulp.task "build-minify-js", ["build-minify-app", "build-minify-fix"]

gulp.task "build-js", ["build-minify-js"], ->
  gulp.src([
    "./.build/ionic.bundle.js",
    "./assets/js/angular-cache/dist/angular-cache.min.js",
    "./assets/js/ng-file-upload-shim/angular-file-upload-all.min.js",
    "./assets/js/mobile-detect/mobile-detect.min.js",
    "./assets/js/moment/min/moment.min.js",
    "./assets/js/moment/locale/ru.js",
    "./assets/js/oauth-js/dist/oauth.min.js",
    "./assets/js/angular-moment/angular-moment.min.js",
    "./.build/app.js"
  ])
  .pipe(concat("app.bundle.js"))
  .pipe(gulp.dest("./www"))

gulp.task "minify-css", ->
  gulp.src(["./assets/css/desktop.css", "./assets/css/style.css", "./assets/css/chart.css"])
  .pipe(minifyCSS())
  .pipe(gulp.dest('./.build/'))

gulp.task "build-minify-css", ["minify-css"], ->
  gulp.src( ".build/desktop.css"  )
  .pipe(gulp.dest("www/css"))

gulp.task "build-css", ["build-minify-css"], ->
  gulp.src( [
      "assets/css/ionic.min.css",
      "assets/css/ionicons.min.css",
      ".build/style.css",
      ".build/chart.css"
    ]
  )
  .pipe(concat("app.bundle.css"))
  .pipe(gulp.dest("www/css"))


gulp.task "copy-fonts", ->
  gulp.src( "assets/css/fonts/*")
  .pipe(gulp.dest("www/fonts"))

gulp.task "copy-img", ->
  gulp.src( "assets/img/**/*")
  .pipe(gulp.dest("www/img"))

gulp.task "build-www-assets", ["build-css", "build-js", "jade", "copy-fonts", "copy-img"]

gulp.task "clean-www", ->
  gulp.src("www", read : false).pipe(clean())

gulp.task 'manifest-www', ->
  gulp.src([ "www/**/*" ]).pipe(manifest(
    hash: true
    preferOnline: true
    network: ['http://*','https://*','*']
    filename: 'app.manifest'
    exclude: 'app.manifest')).pipe gulp.dest('www')

gulp.task "build-www", ->
  runSequence "clean-www", "build-www-assets", "manifest-www"

###
gulp.task "bundle-lib", ->
  gulp.src(mainBowerFiles())
  .pipe(gulp.dest('www/lib-bundle'))
####

gulp.task "dev-server", ["watch-jade", "watch-coffee", "watch-assets", "nodemon"]
gulp.task "build", ["jade", "build-coffee"]

############### pgb-clean #################

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

#######
