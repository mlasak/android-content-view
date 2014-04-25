#!/bin/bash
 
# Contributed to the webinos project.
# License: http://www.apache.org/licenses/LICENSE-2.0 

sceletons="project-sceletons.zip"
 
echo "Exports all needed ContentShell resources and library projects."
echo "---------------------------------------------------------------"
if [ -z $1 ]; then
 echo "place this script and project-sceletons.zip next to your chromium 'src' folder"
 echo "run this script after successfull 'ninja -C out/Debug -j8 content_shell_apk' build"
 echo "run with: ./$0 Debug"
 echo "or: ./$0 Release"
 exit
else
 echo "packing build type... " $1
fi
 
#setup clean export directory
rm -rf export
rm -f crexport.zip
if [ -f $sceletons ] 
then
 echo "$sceletons found."
else
 echo "$sceletons missing."
 exit
fi
mkdir -p export
unzip project-sceletons.zip -d export

#base
echo "exporting base..."
scp -r src/base/android/java/src/* export/base/src
rm export/base/src/org/chromium/base/*.template
scp -r src/out/$1/gen/templates/org/chromium/base/* export/base/src/org/chromium/base
scp src/out/$1/lib.java/jsr_305_javalib.jar export/base/libs

#content
mkdir -p export/content/src/org/chromium/content/
mkdir -p export/content/res/values/
mkdir -p export/content/src/org/chromium/content/app/
mkdir -p export/content/libs/
scp -r src/content/public/android/java/src/* export/content/src
scp -r src/content/public/android/java/res/* export/content/res
rm export/content/src/org/chromium/content/common/common.aidl
rm export/content/src/org/chromium/content/common/*.template
rm export/content/src/org/chromium/content/browser/*.template
scp -r src/out/$1/gen/content_java/res_grit/values/* export/content/res/values
scp -r src/out/$1/gen/templates/org/chromium/content/* export/content/src/org/chromium/content
scp -r src/out/$1/lib.java/guava_javalib.jar export/content/libs
#selection of native lib for the loader
scp -r src/out/$1/content_shell_apk/native_libraries_java/NativeLibraries.java export/content/src/org/chromium/content/app
 
#eyes-free
mkdir -p export/eyes-free/src/
scp -r src/third_party/eyesfree/src/android/java/src/* export/eyes-free/src
rm -rf export/eyes-free/src/com/googlecode/eyesfree/braille/.git/

#media
mkdir -p export/media/src/
scp -r src/media/base/android/java/src/* export/media/src

#net
mkdir -p export/net/src/org/chromium/net/
rm -rf $PROJ/src/org/chromium/net/*
scp -r src/net/android/java/src/* export/net/src
scp -r src/out/$1/gen/templates/org/chromium/net/* export/net/src/org/chromium/net

#ui
mkdir -p export/ui/src/org/chromium/ui/
mkdir -p export/ui/res/values/
scp -r src/ui/android/java/src/* export/ui/src
scp -r src/ui/android/java/res/* export/ui/res
scp -r src/out/$1/gen/ui_java/res_grit/values/* export/ui/res/values

#shell
mkdir -p export/shell/src/org/chromium/
mkdir -p export/shell/res/
scp -r src/content/shell/android/java/src/* export/shell/src
scp -r src/content/shell/android/java/res/* export/shell/res

#shell_apk 
mkdir -p export/shell_apk/src/org/chromium/
mkdir -p export/shell_apk/res/
scp -r src/content/shell/android/shell_apk/src/org/chromium/* export/shell_apk/src/org/chromium
scp -r src/content/shell/android/shell_apk/res/* export/shell_apk/res
cp src/content/shell/android/shell_apk/AndroidManifest.xml export/shell_apk
rm -rf export/shell_apk/res/layout/.svn
rm -rf export/shell_apk/src/org/chromium/content_shell_apk/.svn
 
#libs
mkdir -p export/shell_apk/libs/armeabi-v7a/
scp -r src/out/$1/content_shell_apk/libs/armeabi-v7a/* export/shell_apk/libs/armeabi-v7a
 
#pak
mkdir -p export/shell_apk/assets/
scp -r src/out/$1/content_shell/assets/* export/shell_apk/assets
 
#zip it
zip -r crexport.zip export
 
if [ -f crexport.zip ]; then
 echo "crexport.zip created."
fi
echo "done."
