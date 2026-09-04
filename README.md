# Story Time

Story Time is a player for audio books.

## Features

- pretty ui (according to me)
- it just plays files --- no library management that imposes an order on your existing library 
  - but still remembers your playback position in your books
- supports embedded chapter metadata 

# build

Requires ffmpeg_kit_next_flutter, which has to be build locally for license/patent reasons. See https://github.com/arthenica/ffmpeg-kit-next

Build appimage and deb files with fastforge. The ``LD_LIBARARY_PATH`` variable needs to be updated so fastforge finds the libraries provided by ``ffmpeg_kit_next``

``LD_LIBRARY_PATH="$LD_LIBRARY_PATH:./build/linux/x64/release/bundle/lib/" fastforge package --platform=linux --targets=appimage,deb``

# todo list

### bugs
- [x] make DBus/MPRIS work 
  - [x] get player info into dbus, maybe that fixes KDE 
  - [x] and hook up state change signals to ``PlayerService`` 
  - [x] works in DMS!
  - [ ] fix thhe bugsss 
- [ ] if menu is closed before a book is selected the widget is unmounted and navigation is blocked 

### ui 
- [x] animations 
  - [x] fade out the unskip button
  - [x] animate the time left to unskip 
  - [x] animate popover menus/dialogs, at least fade them in a little 
- [ ] give popover dialogs the little speech bubble tail they have in adwaita? 
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
- [ ] drag and drop in hero dialog 
  - [ ] requires ripping out ``system_tray`` in favor of [tray_manager](https://pub.dev/packages/tray_manager)? hopefully [super_drag_and_drop](https://pub.dev/packages/super_drag_and_drop) works then
- [ ] do something fun when an audiobook ends
  - [ ] and mark finished books in the card view

### enhancements 
- [x] error handling 
  - [x] check if files are available and warn if they arent 
    - [x] give a hint to mount drives and 
    - [x] give an option to relocate the file without losing listening progress 
      - [ ] polish this a little more, it works tho
- [x] use a real logging framework instead of ``print()`` 

### shipping 
- [x] translations
  - [x] before that, update the copy 
- [ ] new app icon 
- [ ] new default cover icon
- [ ] figure out how to set up starUpWMClass for appimage/deb 
- [ ] automate packaging/ci at least for x86 
  - [ ] apparently in two versions (for debian 13, which comes with an old-ass glibc, and for everyone who doesn't use a distro with a prehistoric kernel) 
- [ ] set repository to public
- [ ] make a github page 

 