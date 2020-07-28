# flutter_ijkplayer_source

### About

IJKPlayer Source Code For Flutter


### HOW TO USE THIS REPO

### 0. Environment

    Android: https://blog.csdn.net/coder_pig/article/details/79134625
    IOS: https://www.jianshu.com/p/3108c8a047ee

### 1. Add Decoders or Protocols

```
cd config
rm module.sh
##modify module-rasp.sh
##link your module
ln -s module-rtsp.sh module.sh

```

### 2. Android:

```
cd android/contrib
./compile-ffmpeg.sh clean
./compile-ffmpeg.sh all
cd ..
./compile-ijk.sh all
```

then get so

refer https://blog.csdn.net/coder_pig/article/details/79134625

### 3. IOS:

```
cd ios
./compile-ffmpeg.sh clean
./compile-ffmpeg.sh all

open IJKMediaPlayer with Xcode
build release-iphoneos
build release-iphonesimulator
cd (Product Path)
lipo -create Release-iphoneos/IJKMediaFramework.framework/IJKMediaFramework Release-iphonesimulator/IJKMediaFramework.framework/IJKMediaFramework -output IJKMediaFramework
cp IJKMediaFramework Release-iphoneos/IJKMediaFramework.framework/
```

then get Release-iphoneos/IJKMediaFramework.framework


refer https://www.jianshu.com/p/3108c8a047ee