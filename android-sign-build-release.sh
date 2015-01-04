jarsigner="C:/Program Files (x86)/Java/jdk1.7.0_55/bin/jarsigner"
keytool="C:/Program Files (x86)/Java/jdk1.7.0_55/bin/keytool"
zipalign="C:/Program Files (x86)/Android/android-sdk/build-tools/21.1.2/zipalign"

ionic build android --release
"$keytool" -genkey -v -keystore platforms/android/ant-build/my-release-key.keystore -alias alias_name -keyalg RSA -keysize 2048 -validity 10000
"$jarsigner" -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore platforms/android/ant-build/my-release-key.keystore platforms/android/ant-build/CordovaApp-release-unsigned.apk alias_name
rm .release/local-built/android/RideBetter.apk
"$zipalign" -v 4 platforms/android/ant-build/CordovaApp-release-unsigned.apk .release/local-built/android/RideBetter.apk