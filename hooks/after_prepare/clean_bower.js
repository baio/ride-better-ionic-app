#!/usr/bin/env node

var fs = require('fs');
var path = require('path');

// no need to configure below
var rootdir = process.argv[2];

var libsdirAndroid = rootdir + "/platforms/android/assets/www/lib";
var libsdirWP8 = rootdir + "/platforms/wp8/www/lib";


var filesToNotRemove = [
    'ionic.bundle.min.js',
    "moment.min.js",
    "ru.js",
    "angular-moment.min.js",
    "angular-cache.min.js"
];


cleanDir = function(dirPath) {
    try { var files = fs.readdirSync(dirPath); }
    catch(e) { return; }
    if (files.length > 0)
        for (var i = 0; i < files.length; i++) {
            var filePath = dirPath + '/' + files[i];
            if (fs.statSync(filePath).isFile())
            {
                if (filesToNotRemove.indexOf(files[i]) == -1)
                {
                    fs.unlinkSync(filePath);
                }
            }
            else
                cleanDir(filePath);
        }
    //fs.rmdirSync(dirPath);
};

cleanDir(libsdirAndroid);
cleanDir(libsdirWP8);

