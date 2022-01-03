# autodisgaeaRPG
AutoHotkey project that automates the grindy parts of DisgaeaRPG. The program does not modify DisgaeaRPG app. It simply scans BlueStacks instance for patterns and clicks or swipes accordingly.

## Setup [(video)](https://youtu.be/P-tkhNZyf8o)

### Desktop display
* Set desktop resolution settings
    * Right click desktop
    * Select display settings
    * In scale and layout, set the value to 100%

### BlueStacks
* Download and Install [BlueStacks 5.0](https://www.bluestacks.com/download.html). Note: Default 32 bit version crashes frequently. 64 bit version does not crash as much but will slow down.
* Open BlueStacks 5 Multi-Instance Manager. Name master instance into DisgaeaRPG or create an instance and name it DisgaeaRPG because program targets by window name (this is optional because we can change the window target in the settings in autoDisgaeaRPG program).
* Go to Settings in BlueStacks instance
  * Performance
      * (Recommended) CPU allocation => (4 Cores)
      * (Recommended) Memory allocation => (4 GB)
      * (Recommended) Frame rate: 60
  * Display
      * (Required) Display resolution => (Portrait) 1080x1920
      * (Required) Pixel density => 240 DPI (Medium)
  * Device
      * (Required) Device profile => Choose predefined profile => Samsung Galaxy S20 Ultra
* Make sure right sidebar is expanded (resolution depends on this)
* Install DisgaeaRPG

### Nox (Recommended for less crashes and less slowdown)
* Download and Install [Nox 7](https://www.bignox.com/).
* Open Nox Multi-Drive. Name master instance into DisgaeaRPG or create an instance and name it DisgaeaRPG because program targets by window name (this is optional because we can change the window target in the settings in autoDisgaeaRPG program).
* Go to Settings in Nox instance
  * Performance
      * (Recommended) Performance settings => High ( 4 Core CPU, 4096 MB Memory ). Give it more Cores/RAM if you have some to spare.
      * (Required) Resolution Setting => Mobile phone 1080x1920
  * Device
      * (Required) Device profile => Choose predefined profile => Samsung Galaxy S20 Ultra
* Install DisgaeaRPG

### Macro app
* Download [autoDisgaeaRPG](https://raw.githubusercontent.com/yeetoverflow/autodisgaeaRPG/main/exe/autoDisgaeaRpg.exe) (Recommended) Place this in a folder.
* Set up
    * Go to Settings tab
    * Make sure settings.window.emulator is set to the emulator you are using
    * Set setting.window.name to your emulator instance window name (for Nox do not include version number).
* Verify test
    * Open DisgaeaRPG emulator instance and autoDisgaeaRPG.exe. Go to Settings tab in autoDisgaeaRPG program
    * If (Window) DETACHED => BAD
       * Either the program was opened after emulator instance or the program does not know the window name of target emulator instance (default target is DisgaeaRPG). Make setting.window.name text the same as the emulator instance window name. Click Apply. You should be good when you see a green ATTACHED text.
    * If (Window Size) ??x?? => BAD (Target 600x1400)
       * Click resize 
       * If clicking resize does not work, your resolution is not the target resolution. Follow the instruction above (Set desktop resolution settings). Additionally, you can attempt to set a higher resolution for your desktop if available.
    * If verify says good on both metrics, you passed
    * Note: If you are using multiple monitors, only the main monitor resolution counts so depending on your setup you might need to change your main monitor
    * Noet: If you are using a 4k monitor and nox emulator, the top and side bars are larger. You will need to open nox instance while you are at a lower resolution. After starting you can change your resolution back.
* Patterns test
    * Go to stronghold in emulator instance 
    * Go to Patterns tab in autoDisgaeaRPG
    * In the filter search tabs
    * Select dimensionGate
    * Select test
       * If you see Found as a tooltip and see a box on the dimension gate button you pass
       * If not, go cry then complain in the [autoDisgaeaRPG reddit thread](https://www.reddit.com/r/DisgaeaRPGMobile/comments/qo36ua/autodisgaearpg)

## Battle [(video)](https://youtu.be/lxVgjwpZ8co)

* This section dictates the behavior during a battle for a given context.
    * Auto Checkbox => Specifies if built in Auto should be used or not.
    * TargetMiddleEnemy Checkbox => Target the middle enemy at the beginning of the battle. Good for boss battles.
    * Select Standby => Select standby companion at the beginning of the battle. Use this if you are relying on your companion.
    * Companions => Specify 1 or more possible companions to target (program will select the first one it finds if multiple selected).
    * AutoRefillAP => Will automatically refill AP with AP pot when you run out.
    * AllyTarget => Specify 1 or more ally (only the first one found will be selected) that gets targeted upon the start of the battle.
    * Skills => If Auto Checkbox is not checked, the selected skills will be used. If multiple skills are present, it will select the first skill it finds in order the skills are presented.
    * Note: When creating patterns for companions/allies/skills, make sure to avoid animations. For example, skill have a pulsing animation so make a box to catch a portion of the text to avoid the animating edges.

## General [(video)](https://youtu.be/rIw1qLvlyK8)
* AutoShop
    * Main starting point is stronghold
    * Simply buys daily items
* AutoFriends
    * Main starting point is stronghold
    * Press Claim All button
    * Press Give All button
* AutoDarkAssembly
    * Starting point is a dark assembly
    * Will keep using bribes until viability is almost certain
        *  Crab miso is only used if affinity is negative
        *  Gold bar is only used if NOT feelingTheLove, prettyFavorable or favorable
        *  Golden candy is only used if NOT feelingTheLove, prettyFavorable or favorable
    * Specify max bribe per bribe item in settings
 * AutoDarkAssembly
    * Main starting point is stronghold
    * Will automatically claim fishing rewards, bribe then deploy
    * Specify max bribe per bribe item in settings

## Story
* AutoClear
    * Uses default battle context (for the time being)
    * Starting point is wherever there is a NEW icon
    * Automatically clear story or event based on NEW icon
    
## Event [(video)](https://youtu.be/qsnN6vmTNRw)

* Select Banners
    * Specifies target banner for
        * characterGate1
        * eventReview1
        * raid
        * story
* Start EventStoryFarm
    * Main starting point is stronghold 
    * Can specify farmTarget: oneStar, exp or hl
    * Farms specified hard stage as many times as the count
    * Uses Event battle context
* Start EventStory500Pct
    * Main starting point is stronghold 
    * Clears daily 500Pct stages
    * Uses Event battle context
* Start CharacterGate1
    * Main starting point is stronghold 
    * Clears three starred character gate specified as characterGate1 banner
    * Uses Event battle context
* Start EventReview1
    * Main starting point is stronghold 
    * Clears easy event review stage specified as eventReview1 banner 4 times
    * Uses Event battle context
* Start EventRaidLoop
    * Main starting point is stronghold 
    * Keeps clearing raids when available
    * Uses Raid battle context

## ItemWorld [(video)](https://youtu.be/P6Qh4f33LTk)

* Start GrindItemWorldLoop
    * Main starting point is stronghold 
    * Will keep clearing item world as long as it can until defeated or manually stopped 
    * Settings
        * targetItemType : specify if macro will level armor or weapon item  
        * targetItemSort : specify if items to level will be sorted by gained or rarity
        * targetItemRarity : specify rarity of item to level
        * lootTarget : specify item loot rarity to reset for
        * bribe: specify bribe if items to use one time (none, goldenCandy, goldBar, crabMiso)
        * farmLevels: specify which levels to loot reset for
    
## DarkGate [(video)](https://youtu.be/ARX7VNLxIj4)

* Start DoDarkGateHL
    * Main starting point is stronghold 
    * Clears dark gate stages as many times as count
    * Uses DarkGateHL battle context
* Start DoDarkGateMatsHuman
    * Main starting point is stronghold 
    * Clears dark gate stages as many times as count
    * Uses DarkGateMats battle context
* Start DoDarkGateMatsMonster
    * Main starting point is stronghold 
    * Clears dark gate stages as many times as count
    * Uses DarkGateMats battle context

---

If you'd like to support me:

[![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate?business=Z2GDPP65YMA7G&no_recurring=0&currency_code=USD)
