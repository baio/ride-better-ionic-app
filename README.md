Ionic App Base
=====================

gcloud config set compute/zone europe-west1-b
gcloud preview container clusters create rb-satge --num-nodes 3 --machine-type n1-standard-1

 gcloud compute forwarding-rules list

sudo docker run -d -p 80:8080 \
-e "NODE_ENV=gce_stage" \
-e "PORT=8080" \
-e "NEW_RELIC_LICENSE_KEY=cdc04e9a1643f8b59cbfe567de85e9fa2e7e39f8" \
gcr.io/rb_gce/ride-better-web-app

baio/ride-better-web-app

!!! gloud add forwarding rule here by "createExternalLoadBalancer": true or manualy, then you mast manually check allow http traffic on instances !!!
!!! Is Lang and Culture must be setup on rootRoute ???? since resources.str - is compromise to not use filters !!!

```
 gcloud compute firewall-rules create http-port-80 --allow=tcp:80 --target-tags k8s-ride-better-managed-node
  "scripts": {
    "start": "node_modules/.bin/coffee server.coffee"/*,
    "postinstall": "bower install && gulp build"*/
  },

```

#Global insatlled npm packages

```
gulp
nodemon
coffee-script
```

A starting project for Ionic that optionally supports
using custom SCSS.

## Using this project

We recommend using the `ionic` utility to create new Ionic projects that are based on this project but use a ready-made starter template.

For example, to start a new Ionic project with the default tabs interface, make sure the `ionic` utility is installed:

```bash
$ sudo npm install -g ionic
```

Then run:

```bash
$ sudo npm install -g ionic
$ ionic start myProject tabs
```

More info on this can be found on the Ionic [Getting Started](http://ionicframework.com/getting-started) page.

## Installation

While we recommend using the `ionic` utility to create new Ionic projects, you can use this repo as a barebones starting point to your next Ionic app.

To use this project as is, first clone the repo from GitHub, then run:

```bash
$ cd ionic-app-base
$ sudo npm install -g cordova ionic gulp
$ npm install
$ gulp install
```

## Using Sass (optional)

This project makes it easy to use Sass (the SCSS syntax) in your projects. This enables you to override styles from Ionic, and benefit from
Sass's great features.

Just update the `./scss/ionic.app.scss` file, and run `gulp` or `gulp watch` to rebuild the CSS files for Ionic.

Note: if you choose to use the Sass method, make sure to remove the included `ionic.css` file in `index.html`, and then uncomment
the include to your `ionic.app.css` file which now contains all your Sass code and Ionic itself:

```html
<!-- IF using Sass (run gulp sass first), then remove the CSS include above
<link href="css/ionic.app.css" rel="stylesheet">
-->
```

## Updating Ionic

To update to a new version of Ionic, open bower.json and change the version listed there.

For example, to update from version `1.0.0-beta.4` to `1.0.0-beta.5`, open bower.json and change this:

```
"ionic": "driftyco/ionic-bower#1.0.0-beta.4"
```

To this:

```
"ionic": "driftyco/ionic-bower#1.0.0-beta.5"
```

After saving the update to bower.json file, run `gulp install`.

Alternatively, install bower globally with `npm install -g bower` and run `bower install`.

#### Using the Nightly Builds of Ionic

If you feel daring and want use the bleeding edge 'Nightly' version of Ionic, change the version of Ionic in your bower.json to this:

```
"ionic": "driftyco/ionic-bower#master"
```

Warning: the nightly version is not stable.


## Issues
Issues have been disabled on this repo, if you do find an issue or have a question consider posting it on the [Ionic Forum](http://forum.ionicframework.com/).  Or else if there is truly an error, follow our guidelines for [submitting an issue](http://ionicframework.com/contribute/#issues) to the main Ionic repository. On the other hand, pull requests are welcome here!

## Ions And Screens

###Android

####Paths

```
platforms/android/res/drawable/icon.png
platforms/android/res/drawable-hdpi/icon.png

platforms/android/res/drawable-land-hdpi/screen.png
platforms/android/res/drawable-land-ldpi/screen.png
platforms/android/res/drawable-land-mdpi/screen.png
platforms/android/res/drawable-land-xhdpi/screen.png

platforms/android/res/drawable-ldpi/icon.png
platforms/android/res/drawable-mdpi/icon.png

platforms/android/res/drawable-port-hdpi/screen.png
platforms/android/res/drawable-port-ldpi/screen.png
platforms/android/res/drawable-port-mdpi/screen.png
platforms/android/res/drawable-port-xhdpi/screen.png

platforms/android/res/drawable-xhdpi/icon.png
```

###Sizes

```
96x96
72x72

800x480
320x200
480x320
1280x720

36x36
48x48

480x800
200x320
320x480
720x1280

96x96
```

###Windows Phone

####Paths

```
platforms/wp8/ApplicationIcon.png
platforms/wp8/Background.png
platforms/wp8/SplashScreenImage.jpg
```

####Sizes

```
62x62
173x173
480x800
```

### Run icon / screen builder

```
sh gen-icon.sh src-icon.jpg lightblue
sh gen-screen.sh src-icon.jpg lightblue

###WEINRE

`weinre --boundHost 172.30.99.102 --httpPort 9090`

