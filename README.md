# fl_audiobook

# setup 

requires ffmpeg_kit_next_flutter, which has to be build locally. See https://github.com/arthenica/ffmpeg-kit-next

# build

fastforge package --platform=linux --targets=deb --skip-clean

vovin@the-red-scare:~/git/fl-audiobook/fl_audiobook$ LD_LIBRARY_PATH="$LD_LIBRARY_PATH://home/vovin/git/fl-audiobook/fl_audiobook/build/linux/x64/release/bundle/lib/" fastforge package --platform=linux --targets=appimage --skip-clean

# todo list

### bugs
- [ ] make DBus/MPRIS work 
  - [ ] and hook it up to the "new" ``PlayerService`` 
- [ ] write test? lol. no i'm not at work here 
- [ ] if menu is closed before a book is selected the widget is unmounted and navigation is blocked 
### ui 
- [ ] animations 
  - [ ] fade out the unskip button
  - [ ] animate the time left to unskip 
  - [ ] animate popover menus/dialogs, at least fade them in a little 
- [ ] better chapters list drawer in player
  - [ ] highlight the currently playing chapter
  - [ ] maybe display the progress
  - [ ] larger fonts, at least for the start time label 
    - [ ] consider swapping start time label for time remaining for currently playing? 
- [ ] bring back light theme
  - [ ] abstract theme colors into a service? 

### enhancements 
- [ ] error handling 
  - [ ] check if files are available and warn if they arent 
    - [ ] give a hint to mount drives and 
    - [ ] give an option to relocate the file without losing listening progress 
- [ ] use a real logging framework instead of ``print()`` 

### shipping 
- [ ] translations
  - [ ] before that, update the copy 
- [ ] new app icon 
- [ ] new default cover icon
- [ ] figure out how to set up starUpWMClass for appimage/deb 
- [ ] automate packaging/ci at least for x86 
- [ ] set repository to public
- [ ] make a github page 

 