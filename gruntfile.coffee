module.exports = (grunt) ->

  grunt.initConfig
    "phonegap-build":
      release:
        options:
          archive: ".release/pgb-src/pgb-src.zip"
          appId: "1118217"
          timeout : 1000 * 60 * 5
          user:
            email: "max.putilov@gmail.com"
            password: "exodus123"
          download:
            winphone: ".release/pgb-built/wp8/surf-better-pgb.xap"
            android: ".release/pgb-built/android/surf-better-pgb.apk"
          keys:
            android:
              key_pw: "prodigy123"
              keystore_pw: "prodigy123"

  grunt.loadNpmTasks "grunt-phonegap-build"

  grunt.registerTask "default", "phonegap-build:release"

  return