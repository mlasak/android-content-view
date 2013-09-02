# Three steps to integrate chromium ContentShell (advanced Web browsing) into your Android project

Follow this three steps be able to build a simple chromium based Web browser from your eclipse dev environment.

## 1. BUILD/TEST chromium for Android (target content_shell_apk)

First information source on this: https://code.google.com/p/chromium/wiki/AndroidBuildInstructions
Invaluable hints from various people: https://github.com/pwnall/chromeview/blob/master/crbuild/vm-build.md or https://github.com/davisford/android-chromium-view/

For the following it is assumed that the chromium code is within $chromiumpath

```
$ cd $chromiumpath
$ gclient sync
$ cd src
$ . build/android/envsetup.sh
$ android_gyp
$ ninja -C out/Debug -j8 content_shell_apk
```

After successfull build, test the created APK on your device

```
adb install $chromiumpath/src/out/Debug/apks/ContentShell.apk
```

## 2. PATCH/MODIFY/REBUILD ContentShell

Do your changes to the chromium code, rebuild incrementally with...

```
$ cd $chromiumpath/src
$ ninja -C out/Debug -j8 content_shell_apk
```

...and test again on your device.


## 3. EXTRACT Android Projects for integration with your project

Place the ```project-sceletons.zip``` and ```create_android_projects.sh``` in $chromiumpath, and execute:

```
$ cd $chromiumpath
$ ./create_android_projects.sh Debug
```

...or alternatively if you have build the Release version of ContentShell before:

```
$ cd $chromiumpath
$ ./create_android_projects.sh Release
```

On success you will find an archive ```crexport.zip``` containing all needed library projects and the sample application project ```shell_apk``` to be able to build a simple chromium based Web browser in your eclipse environment.

Open all projects in the same workspace and make sure that under your project properties > Android in the Library section ```net```, ```base```, ```content```, ```eyes-free```, ```media```, ```ui``` and ```shell``` are listed.

## Hints

- Q: How to change the appearance/chrome of the browsing ui? A: Modify the shell/res/layout/shell_view.xml and related/referencing files.


# License

Contributed to the webinos project.

The webinos platform is licensed under the Apache 2.0 license. See http://www.apache.org/licenses/LICENSE-2.0 for more datails.


