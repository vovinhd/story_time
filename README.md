# fl_audiobook

# setup 

requires ffmpeg_kit_next_flutter, which has to be build locally. See https://github.com/arthenica/ffmpeg-kit-next

# build 

fastforge package --platform=linux --targets=deb --skip-clean

vovin@the-red-scare:~/git/fl-audiobook/fl_audiobook$ LD_LIBRARY_PATH="$LD_LIBRARY_PATH://home/vovin/git/fl-audiobook/fl_audiobook/build/linux/x64/release/bundle/lib/" fastforge package --platform=linux --targets=appimage --skip-clean


