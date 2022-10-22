#!/bin/bash
NDK=/home/muxi/code/android-ndk-r21e
SYSROOT=$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
APK_PATH=/home/muxi/code/ffmpegdemo/app/jni/ffmpeg
API=22

function build_android
{
    ./configure \
    --prefix=$PREFIX \
    --enable-encoders \
    --enable-decoders \
    --enable-avdevice \
    --disable-static \
    --enable-ffplay \
    --enable-network \
    --disable-doc \
    --disable-symver \
    --enable-neon \
    --enable-shared \
    --enable-gpl \
    --enable-pic \
    --enable-jni \
    --enable-debug=3 \
    --enable-pthreads \
    --enable-mediacodec \
    --enable-encoder=aac \
    --enable-encoder=gif \
    --enable-encoder=mpeg4 \
    --enable-encoder=pcm_s16le \
    --enable-encoder=png \
    --enable-encoder=srt \
    --enable-encoder=subrip \
    --enable-encoder=yuv4 \
    --enable-encoder=text \
    --enable-decoder=aac \
    --enable-decoder=aac_latm \
    --enable-decoder=mp3 \
    --enable-decoder=mpeg4_mediacodec \
    --enable-decoder=pcm_s16le \
    --enable-decoder=flac \
    --enable-decoder=flv \
    --enable-decoder=gif \
    --enable-decoder=png \
    --enable-decoder=srt \
    --enable-decoder=xsub \
    --enable-decoder=yuv4 \
    --enable-decoder=vp8_mediacodec \
    --enable-decoder=vp9_mediacodec \
    --enable-decoder=hevc_mediacodec \
    --enable-decoder=h264_mediacodec \
    --enable-decoder=mpeg4_mediacodec \
    --enable-ffmpeg \
    --enable-bsf=aac_adtstoasc \
    --enable-bsf=h264_mp4toannexb \
    --enable-bsf=hevc_mp4toannexb \
    --enable-bsf=mpeg4_unpack_bframes \
    --disable-filter=lut3d \
    --disable-iconv \
    --disable-asm \
    --cross-prefix=$CROSS_PREFIX \
    --target-os=android \
    --arch=$ARCH \
    --cpu=$CPU \
    --enable-cross-compile \
    --cc=$CC \
    --cxx=$CXX \
    --sysroot=$SYSROOT \
    --enable-small \
    --extra-cflags="-Os -fpic $ADDI_CFLAGS -llog" \
    --extra-ldflags="$ADDI_LDFLAGS -llog" \
    $ADDITIONAL_CONFIGURE_FLAG

    make clean
    make -j8
    make install
}

function choose_build(){
    CPU=$1
    echo "CPU $CPU"
    if [[ $CPU = 'armv7-a' ]];
    then
        ABI='armeabi-v7a'
        ARCH='arm'
        CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang
        CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++
        CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
    elif [[ $CPU = 'armv8-a' ]];
    then
        ABI='arm64-v8a'
        ARCH='arm64'
        CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
        CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
        CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
    else
        echo "Input Is Error."
    fi

    PREFIX=$(pwd)/android/$ABI
}

#function copy_lib(){
#    mkdir -p android/release_android/$LIBPATH/lib
#	mkdir -p android/release_android/$LIBPATH/include
#    cp -rf $PREFIX/lib/*.so $APK_PATH/$LIBPATH/lib/
#	cp -rf $PREFIX/include/* $APK_PATH/$LIBPATH/include/
#}
choose_build $1
build_android
#copy_lib

