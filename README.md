# autodisgaeaRPG
AutoHotkey project that automates the grindy parts of DisgaeaRPG. The program does not modify DisgaeaRPG app. It simply scans BlueStacks instances for patterns and clicks or swipes accordingly. I am open to publicizing the AutoHotkey code but don't see the need at the moment.

## Setup [(video)](https://youtube.com)

* Download and Install [BlueStacks 5.0](https://www.bluestacks.com/bluestacks-5.html). Make sure that this installs in C:\Program Files\BlueStacks_nxt else sending swipe gesture will not work.
* Open BlueStacks 5 Multi-Instance Manager. Name master instance into DisgaeaRPG or create an instance and name it DisgaeaRPG because program targets by window name (this is optional because we can change the window target.
* Go to Setting
  * Performance
    * (Recommended) CPU allocation => (4 Cores)
    * (Recommended) Memory allocation => (4 GB)
    * (Recommended) Frame rate: 60
  * Display
    * (Required) Display resolution => (Landscape) 1920x1080 - (*in hindsight I should have developed this in Portrait mode)
    * (Requred) Pixel density ==> 240 DPI (Medium)
  * Advanced
    * (Required) Android debug bridge => Enabled (this is required to be able be able to send swipe gestures)
* Install DisgaeaRPG in BlueStacks instance and make sure you are up to date.
* Download [autoDisgaeaRPG](https://raw.githubusercontent.com/yeetoverflow/autodisgaeaRPG/main/exe/autoDisgaeaRpg.exe) executable. (Recommended) Place this in a folder.
* Open BlueStacks DisgaeaRPG instance and autoDisgaeaRPG.exe. You should see ATTACHED at the bottom right of the program. If you see DETACHED, either enter a similar target window name to program or rename DisgaeaRPG instance appropriately then click Apply for target window.
* Click Resize at the bottom left of the program. If you see the BlueStack instance window get change size, then you should be good to go.

## Battle [(video)](https://youtube.com)

* This section dictates the behavior during a battle for a given context.
    * Reset Selected Context => Change the current context back to default values.
    * Auto Checkbox => Specifies if built in Auto should be used or not.
    * TargetMiddleEnemy Checkbox => Target the middle enemy at the beginning of the battle. Good for boss battles.
    * Select Standby => Select standby companion at the beginning of the battle. Use this if you are relying on your companion.
    * Companions => Specify 1 or more possible companions to target (program will select the first one it finds if multiple selected).
    * AllyTarget => Specify ally that gets target upon the start of the battle.
    * Skills => If Auto Checkbox is not checked, the selected skills will be used. If multiple skills are present, it will select the first skill it finds in order the skills are presented. Modify settings.json battleOptions.skillOrder section if you would like to change the order the skills are scanned. Restart the program after modification.

## General [(video)](https://youtube.com)

* AutoClear
    * Starting point is wherever there is a NEW icon
    * Automatically clear story or event based on NEW icon
    * Uses current selected battle context
    * Does not auto-refill AP
* AutoShop
    * Main starting point is stronghold
    * Simply buys daily items
* DarkAssembly
    * Starting point is a dark assembly
    * Will keep using bribes until viability is almost certain

## Event [(video)](https://youtube.com)

* Select Story Banner
    * Specifies target story banner for story based loops
* Select Raid Banner
    * Specifies target raid banner for raid loop
* Start EventStoryFarm
    * Farms specified stage as many times as the count
    * Uses event battle context
    * Will auto-fill AP
* Start EventStory500Pct
    * Clears daily 500Pct stages
    * Uses event battle context
    * Will auto-fill AP
* Start EventRaidLoop
    * Keeps clearing raids when available
    * Uses raid battle context
