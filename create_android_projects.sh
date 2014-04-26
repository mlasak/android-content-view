#!/bin/bash
 
# Contributed to the webinos project.
# License: http://www.apache.org/licenses/LICENSE-2.0 

sceletons="project-sceletons.zip"
 
echo "Exports all needed ContentShell/ChromeShell resources and library projects."
echo "---------------------------------------------------------------------------"
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
echo "base ..."
scp -r src/base/android/java/src/* export/base/src
rm export/base/src/org/chromium/base/*.template
scp -r src/out/$1/gen/templates/org/chromium/base/* export/base/src/org/chromium/base
scp src/out/$1/lib.java/jsr_305_javalib.jar export/base/libs
scp -r src/out/$1/content_shell_apk/native_libraries_java/NativeLibraries.java export/base/src/org/chromium/base/library_loader/NativeLibraries.java

#base
echo "base (chrome shell) ..."
scp -r src/base/android/java/src/* export/base/src
rm export/base/src/org/chromium/base/*.template
scp -r src/out/$1/gen/templates/org/chromium/base/* export/base/src/org/chromium/base
scp src/out/$1/lib.java/jsr_305_javalib.jar export/base/libs
scp -r src/out/$1/chrome_shell_apk/native_libraries_java/NativeLibraries.java export/base/src/org/chromium/base/library_loader/NativeLibraries.java

#content
echo "content ..."
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

#eyes-free
echo "eyes-free ..."
mkdir -p export/eyes-free/src/
scp -r src/third_party/eyesfree/src/android/java/src/* export/eyes-free/src
rm -rf export/eyes-free/src/com/googlecode/eyesfree/braille/.git/

#media
echo "media ..."
mkdir -p export/media/src/
scp -r src/media/base/android/java/src/* export/media/src
scp -r src/out/$1/gen/templates/org/chromium/media/* export/media/src/org/chromium/media

#net
echo "net ..."
mkdir -p export/net/src/org/chromium/net/
rm -rf $PROJ/src/org/chromium/net/*
scp -r src/net/android/java/src/* export/net/src
scp -r src/out/$1/gen/templates/org/chromium/net/* export/net/src/org/chromium/net
rm export/net/src/org/chromium/net/IRemoteAndroidKeyStoreInterface.aidl

#ui
echo "ui ..."
mkdir -p export/ui/src/org/chromium/ui/
mkdir -p export/ui/res/values/
scp -r src/ui/android/java/src/* export/ui/src
scp -r src/ui/android/java/res/* export/ui/res
scp -r src/out/$1/gen/ui_java/res_grit/values/* export/ui/res/values
scp -r src/out/$1/gen/templates/org/chromium/ui/* export/ui/src/org/chromium/ui

#shell
echo "shell ..."
mkdir -p export/shell/src/org/chromium/
mkdir -p export/shell/res/
scp -r src/content/shell/android/java/src/* export/shell/src
scp -r src/content/shell/android/java/res/* export/shell/res

#shell_apk 
echo "shell_apk ..."
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

### Chrome Shell Project

#chrome_shell_apk
echo "chrome_shell_apk ..."
mkdir -p export/chrome_shell_apk/assets/
mkdir -p export/chrome_shell_apk/src/org/chromium
mkdir -p export/chrome_shell_apk/res
scp -r src/chrome/android/shell/java/src/* export/chrome_shell_apk/src
scp -r src/chrome/android/shell/java/AndroidManifest.xml export/chrome_shell_apk
scp -r src/chrome/android/shell/res/* export/chrome_shell_apk/res

#java
echo "java ..."
mkdir -p export/java/res/
mkdir -p export/java/src/org/chromium/chrome/
scp -r src/chrome/android/java/res/* export/java/res
scp -r src/chrome/android/java/src/* export/java/src
scp src/out/$1/lib.java/guava_javalib.jar export/java/libs
scp -r src/out/$1/gen/chrome_java/res_grit/* export/java/res
scp -r src/out/$1/gen/chrome/java/res/* export/java/res
scp -r src/out/$1/gen/templates/org/chromium/chrome/* export/java/src/org/chromium/chrome

#sync
echo "sync ..."
mkdir -p export/sync/src/
mkdir -p export/sync/libs/
scp -r src/sync/android/java/src/* export/sync/src
scp -r src/out/$1/lib.java/guava_javalib.jar export/sync/libs
scp -r src/out/$1/lib.java/cacheinvalidation_javalib.jar export/sync/libs
scp -r src/out/$1/lib.java/jsr_305_javalib.jar export/sync/libs
scp -r src/out/$1/lib.java/cacheinvalidation_proto_java.jar export/sync/libs
scp -r src/out/$1/lib.java/cacheinvalidation_example_proto_java.jar export/sync/libs
scp -r src/out/$1/lib.java/protobuf_lite_javalib.jar export/sync/libs
scp -r src/third_party/android_tools/sdk/extras/google/gcm/gcm-client/dist/gcm.jar export/sync/libs

#printing
echo "printing ..."
mkdir -p export/printing/src/
scp -r src/printing/android/java/src/* export/printing/src

#dom_distiller
echo "dom_distiller ..."
mkdir -p export/dom_distiller/src/
scp -r src/components/dom_distiller/android/java/src/* export/dom_distiller/src

#web_contents_delegate_android_java
echo "web_contents_delegate_android_java ..."
mkdir -p export/web_contents_delegate_android_java/src/
scp -r src/components/web_contents_delegate_android/android/java/src/* export/web_contents_delegate_android_java/src

#autofill
echo "autofill_java ..."
mkdir -p export/autofill_java/src/
scp -r src/components/autofill/core/browser/android/java/src/* export/autofill_java/src

#navigation_interception_java
echo "navigation_interception_java ..."
mkdir -p export/navigation_interception_java/src/
scp -r src/components/navigation_interception/android/java/src/* export/navigation_interception_java/src

#libs
mkdir -p export/chrome_shell_apk/libs/armeabi-v7a/
scp -r src/out/$1/chrome_shell_apk/libs/armeabi-v7a/* export/chrome_shell_apk/libs/armeabi-v7a

#paks
scp -r src/out/$1/resources.pak export/chrome_shell_apk/assets
scp -r src/out/$1/locales/* export/chrome_shell_apk/assets
scp -r src/out/$1/chrome_100_percent.pak export/chrome_shell_apk/assets
scp -r src/out/$1/icudtl.dat export/chrome_shell_apk/assets 

#zip it
echo "zipping..."
zip -r crexport.zip export
 
if [ -f crexport.zip ]; then
 echo "crexport.zip created."
fi
echo "done."
