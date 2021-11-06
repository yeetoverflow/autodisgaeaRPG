# autodisgaeaRPG
AutoHotkey project that automates the grindy parts of DisgaeaRPG. I am open to publicizing the AutoHotkey code but don't see the need at the moment.

## Setup [(video)](youtube.com)

* Download and Install [BlueStacks 5.0](https://www.bluestacks.com/bluestacks-5.html). Make sure that this installs in C:\Program Files\BlueStacks_nxt else sending swipe gesture will not work.
* Open BlueStacks 5 Multi-Instance Manager. Name master instance into DisgaeaRPG or create an instance and name it DisgaeaRPG because program targets by window name (this is optional because we can change the window target.
* Go to Setting
  * Performance
    * (Recommended) CPU allocation => (4 Cores)
    * (Recommended) Memory allocation => (4 GB)
    * (Recommended) Frame rate: 60
  * Display
    * (Recommended) Frame rate: 60
    * (Required) Display resolution => (Landscape) 1920x1080 - (*in hindsight I should have developed this in Portrait mode)
    * (Requred) Pixel density ==> 240 DPI (Medium)
  * Advanced
    * (Required) Android debug bridge => Enabled (this is required to be able be able to send swipe gestures)
* Install DisgaeaRPG in BlueStacks instance and make sure you are up to date.
* Download [autoDisgaeaRPG](https://raw.githubusercontent.com/yeetoverflow/autodisgaeaRPG/main/exe/autoDisgaeaRpg.exe) executable. (Recommended) Place this in a folder.
* Open BlueStacks DisgaeaRPG instance and autoDisgaeaRPG.exe. You should see ATTACHED at the bottom right of the program. If you see DETACHED, either enter a similar target window name to program or rename DisgaeaRPG instance appropriately then click Apply for target window.
* Click Resize at the bottom left of the program. If you see the BlueStack instance window get change size, then you should be good to go.
