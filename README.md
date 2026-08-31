# fl_audiobook

# setup 

requires ffmpeg_kit_next_flutter, which has to be build locally. See https://github.com/arthenica/ffmpeg-kit-next

# build

fastforge package --platform=linux --targets=deb --skip-clean

vovin@the-red-scare:~/git/fl-audiobook/fl_audiobook$ LD_LIBRARY_PATH="$LD_LIBRARY_PATH://home/vovin/git/fl-audiobook/fl_audiobook/build/linux/x64/release/bundle/lib/" fastforge package --platform=linux --targets=appimage --skip-clean

# todo list

### bugs
- [ ] make DBus/MPRIS work 
  - [ ] and hook up state change signals to ``PlayerService`` 
- [ ] if menu is closed before a book is selected the widget is unmounted and navigation is blocked 

### ui 
- [x] animations 
  - [x] fade out the unskip button
  - [x] animate the time left to unskip 
  - [x] animate popover menus/dialogs, at least fade them in a little 
- [ ] give popover dialogs the little speech bubble tail they hace in adwaita? 
- [x] better chapters list drawer in player
  - [x] highlight the currently playing chapter
  - [x] maybe display the progress
  - [x] larger fonts, at least for the start time label 
    - [x] consider swapping start time label for time remaining for currently playing? 
- [x] bring back light theme
  - [ ] abstract theme colors into a service? 
- [ ] change the hint when play history isn't empty 
- [ ] pull primary accent from currently playing cover  
- [x] rework last played cards
- [ ] add a theme switcher
 
### enhancements 
- [x] error handling 
  - [x] check if files are available and warn if they arent 
    - [x] give a hint to mount drives and 
    - [x] give an option to relocate the file without losing listening progress 
      - [ ] polish this a little more, it works tho
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

 