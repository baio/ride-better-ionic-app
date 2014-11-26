#!/usr/bin/env node

//
// This hook copies various resource files 
// from our version control system directories 
// into the appropriate platform specific location
//


// configure all the files to copy.  
// Key of object is the source file, 
// value is the destination location.  
// It's fine to put all platforms' icons 
// and splash screen files here, even if 
// we don't build for all platforms 
// on each developer's box.


var filestocopy = [
    //wp 8
    {
        "res/.res/screen/480x800.jpg":
            "platforms/wp8/SplashScreenImage.jpg"
    },
    {
        "res/.res/icon/173.png":
            "platforms/wp8/Background.png"
    },
    {
        "res/.res/icon/62.png":
            "platforms/wp8/ApplicationIcon.png"
    },
    //android
    {
        "res/.res/icon/96.png":
            "platforms/android/res/drawable/icon.png"
    },
    {
        "res/.res/icon/72.png":
            "platforms/android/res/drawable-hdpi/icon.png"
    },
    {
        "res/.res/screen/800x480.png":
            "platforms/android/res/drawable-land-hdpi/screen.png"
    },

    {
        "res/.res/screen/320x200.png":
            "platforms/android/res/drawable-land-ldpi/screen.png"
    },
    {
        "res/.res/screen/480x320.png":
            "platforms/android/res/drawable-land-mdpi/screen.png"
    },
    {
        "res/.res/screen/1280x720.png":
            "platforms/android/res/drawable-land-xhdpi/screen.png"
    },

    {
        "res/.res/icon/36.png":
            "platforms/android/res/drawable-ldpi/icon.png"
    },
    {
        "res/.res/icon/48.png":
            "platforms/android/res/drawable-mdpi/icon.png"
    },
    {
        "res/.res/screen/480x800.png":
            "platforms/android/res/drawable-port-hdpi/screen.png"
    },

    {
        "res/.res/screen/200x320.png":
            "platforms/android/res/drawable-port-ldpi/screen.png"
    },
    {
        "res/.res/screen/320x480.png":
            "platforms/android/res/drawable-port-mdpi/screen.png"
    },
    {
        "res/.res/screen/720x1280.png":
            "platforms/android/res/drawable-port-xhdpi/screen.png"
    },
    {
        "res/.res/icon/96.png":
            "platforms/android/res/drawable-xhdpi/icon.png"
    },// ios
    {
        "res/.res/icon/40.png":
            "platforms/ios/Ride Better/Resources/icons/icon-40.png",
        "res/.res/icon/80.png":
            "platforms/ios/Ride Better/Resources/icons/icon-40@2x.png",
        "res/.res/icon/50.png":
            "platforms/ios/Ride Better/Resources/icons/icon-50.png",
        "res/.res/icon/100.png":
            "platforms/ios/Ride Better/Resources/icons/icon-50@2x.png",
        "res/.res/icon/60.png":
            "platforms/ios/Ride Better/Resources/icons/icon-60.png",
        "res/.res/icon/120.png":
            "platforms/ios/Ride Better/Resources/icons/icon-60@2x.png",
        "res/.res/icon/76.png":
            "platforms/ios/Ride Better/Resources/icons/icon-76.png",
        "res/.res/icon/152.png":
            "platforms/ios/Ride Better/Resources/icons/icon-76@2x.png",
        "res/.res/icon/29.png":
            "platforms/ios/Ride Better/Resources/icons/icon-small.png",
        "res/.res/icon/58.png":
            "platforms/ios/Ride Better/Resources/icons/icon-small@2x.png",
        "res/.res/icon/72.png":
            "platforms/ios/Ride Better/Resources/icons/icon-72.png",
        "res/.res/icon/144.png":
            "platforms/ios/Ride Better/Resources/icons/icon-72@2x.png",
        "res/.res/icon/57.png":
            "platforms/ios/Ride Better/Resources/icons/icon.png",
        "res/.res/icon/114.png":
            "platforms/ios/Ride Better/Resources/icons/icon@2x.png",

        "res/.res/screen/640x1136.png":
            "platforms/ios/Ride Better/Resources/splash/Default-568h@2x~iphone.png",
        "res/.res/screen/2048x1536.png":
            "platforms/ios/Ride Better/Resources/splash/Default-Landscape@2x~ipad.png",
        "res/.res/screen/1024x768.png":
            "platforms/ios/Ride Better/Resources/splash/Default-Landscape~ipad.png",
        "res/.res/screen/1536x2048.png":
            "platforms/ios/Ride Better/Resources/splash/Default-Portrait@2x~ipad.png",
        "res/.res/screen/768x1024.png":
            "platforms/ios/Ride Better/Resources/splash/Default-Portrait~ipad.png",
        "res/.res/screen/640x960.png":
            "platforms/ios/Ride Better/Resources/splash/Default@2x~iphone.png",
        "res/.res/screen/320x480.png":
            "platforms/ios/Ride Better/Resources/splash/Default~iphone.png"
    }


];

var fs = require('fs');
var path = require('path');

// no need to configure below
var rootdir = process.argv[2];

filestocopy.forEach(function(obj) {
    Object.keys(obj).forEach(function(key) {
        var val = obj[key];
        var srcfile = path.join(rootdir, key);
        var destfile = path.join(rootdir, val);
        //console.log("copying "+srcfile+" to "+destfile);
        var destdir = path.dirname(destfile);
        if (fs.existsSync(srcfile) && fs.existsSync(destdir)) {
            fs.createReadStream(srcfile).pipe(
                fs.createWriteStream(destfile));
        }
    });
});
