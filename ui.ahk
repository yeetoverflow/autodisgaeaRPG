OnExit("Cleanup")

ResetUI() {
    global

    Gui, Destroy
    Gui, Color, 404040
    ;Gui, Font, cFFFFFF

    ;Gui, +HwndHwndMainGui
    statusBarText := "||"
    Gui Add, StatusBar,, % statusBarText
    Gui Add, Tab3, cWhite section vTopTabs, Main|Settings|Handlers|Patterns
    GuiControl, choose, TopTabs, 1

    Gui Tab, Main
    Gui, Font, Bold
    Gui Add, Text, cWhite x+10 xs+10 ys+25, Battle
    Gui Add, Text, x+250 vAttached cRed, DETACHED
    Gui, Font, Normal
    Gui Add, Text, cWhite xs+10 y+5, BattleContext
    Gui Add, Button, x+10 gResetCurrentBattleContext, Reset Selected Context
    Gui Add, Radio, cWhite gBattleContextChanged vBattleContext xs+10 y+5 checked, Default
    Gui Add, Radio, cWhite gBattleContextChanged x+10, Event
    Gui Add, Radio, cWhite gBattleContextChanged x+10, ItemWorld
    Gui Add, Radio, cWhite gBattleContextChanged x+10, Sweep
    Gui Add, Radio, cWhite gBattleContextChanged x+10, Raid
    Gui Add, Radio, cWhite gBattleContextChanged xs+10 y+5, DarkGateMats
    Gui Add, Radio, cWhite gBattleContextChanged x+10, DarkGateHL

    CreateBattleOptionsUI(settings.battleOptions.default)
    Gui Add, Button, xs+10 y+5 gBattle, Battle
    Gui Add, Text, cWhite x+10, Count: 
    Gui Add, Edit, cBlack w50 x+10 Number vBattleCount, 1

    Gui Add, Text, 0x10 xs w400 h10
    Gui, Font, Bold
    Gui Add, Text, cWhite xs+10, General
    Gui, Font, Normal
    ;Gui Add, Button, xs+10 gAutoClear, AutoClear
    Gui, Add, Progress, xs+10 vProgressBar_AutoClear -Smooth w120 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_AutoClear BackgroundTrans, Start AutoClear
    Gui Add, Button, x+10 gAutoShop, AutoShop
    ;Gui Add, Button, x+10 gAutoFriends, AutoFriends
    Gui Add, Button, x+10 gAutoDarkAssembly, DarkAssembly

    Gui Add, Text, 0x10 xs w400 h10
    Gui, Font, Bold
    Gui Add, Text, cWhite xs+10, Event
    Gui, Font, Normal
    Gui Add, Button, x+10 gSelectStoryBanner, Select Story Banner
    Gui Add, Button, x+10 gSelectRaidBanner, Select Raid Banner

    Gui, Add, Progress, xs+10 vProgressBar_EventStoryFarm -Smooth w120 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_EventStoryFarm BackgroundTrans, Start EventStoryFarm
    Gui Add, Text, cWhite x+10, Count
    Gui Add, Edit, cBlack w50 x+10 Number, 1
    Gui Add, Text, cWhite x+10, Stage: 
    Gui Add, Radio, cWhite gRadioOptionChanged vEventOptions_storyTarget_oneStar x+5, OneStar
    Gui Add, Radio, cWhite gRadioOptionChanged vEventOptions_storyTarget_exp x+5, Exp
    Gui Add, Radio, cWhite gRadioOptionChanged vEventOptions_storyTarget_hl x+5, HL
    GuiControl,, % "eventOptions_storyTarget_" . settings.eventOptions.storyTarget, 1

    Gui, Add, Progress, xs+10 vProgressBar_EventStory500Pct -Smooth w120 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_EventStory500Pct BackgroundTrans, Start EventStory500Pct

    Gui, Add, Progress, x+10 vProgressBar_EventAutoClear -Smooth w100 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_EventAutoClear BackgroundTrans, Start EventAutoClear

    Gui, Font, Bold
    Gui Add, Text, cWhite xs+10, Raid
    Gui, Font, Normal

    Gui, Add, Progress, x+10 w250 h18 c0x66FF66 vsettings_eventOptions_raid
    Gui Add, Text, xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left vsettingsText_eventOptions_raid, % GetSettingDisplay("settings_eventOptions_raid")

    Gui, Add, Progress, xs+10 vProgressBar_EventRaidLoop -Smooth w100 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_EventRaidLoop BackgroundTrans, Start EventRaidLoop

    Gui, Add, Progress, x+10 vProgressBar_EventRaidAutoClaim -Smooth w130 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_EventRaidAutoClaim BackgroundTrans, Start EventRaidAutoClaim

    Gui, Add, Progress, x+10 vProgressBar_EventRaidAutoVault -Smooth w130 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_EventRaidAutoVault BackgroundTrans, Start EventRaidAutoVault

    Gui Add, Text, 0x10 xs w400 h10
    Gui Font, Bold
    Gui Add, Text, cWhite xs+10, ItemWorld
    Gui Font, Normal

    ; Gui, Add, Progress, vProgressBar_FarmItemWorldAnyLoop -Smooth w170 h18 c0x66FF66 border
    ; Gui Add, Text, cBlack xp wp hp center vProgressText_FarmItemWorldAnyLoop BackgroundTrans, Start FarmItemWorldAnyLoop
    ; Gui Add, Radio, cWhite gRadioOptionChanged vItemWorldOptions_loop_itemType_armor x+5, Armor
    ; Gui Add, Radio, cWhite gRadioOptionChanged vItemWorldOptions_loop_itemType_weapon x+5, Weapon
    ; GuiControl,, % "itemWorldOptions_loop_itemType_" . settings.itemWorldOptions.loop.itemType, 1
    
    Gui, Add, Progress, xs+10 vProgressBar_GrindItemWorldLoop1 -Smooth w150 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_GrindItemWorldLoop1 BackgroundTrans, Start GrindItemWorldLoop1

    Gui, Add, Progress, x+10 vProgressBar_GrindItemWorldSingle1 -Smooth w150 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_GrindItemWorldSingle1 BackgroundTrans, Start GrindItemWorldSingle1

    Gui, Add, Progress, x+10 w50 h18 c0x66FF66 vsettings_itemWorldOptions_1
    Gui Add, Text, xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left, Settings

    Gui, Add, Progress, xs+10 vProgressBar_GrindItemWorldLoop2 -Smooth w150 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_GrindItemWorldLoop2 BackgroundTrans, Start GrindItemWorldLoop2

    Gui, Add, Progress, x+10 vProgressBar_GrindItemWorldSingle2 -Smooth w150 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_GrindItemWorldSingle2 BackgroundTrans, Start GrindItemWorldSingle2

    Gui, Add, Progress, x+10 w50 h18 c0x66FF66 vsettings_itemWorldOptions_2
    Gui Add, Text, xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left, Settings
    
    ; Gui, Add, Progress, xs+10 vProgressBar_FarmItemWorldLegendaryLoop -Smooth w170 h18 c0x66FF66 border
    ; Gui Add, Text, cBlack xp wp hp center vProgressText_FarmItemWorldLegendaryLoop BackgroundTrans, Start FarmItemWorldLegendaryLoop
    ; Gui Add, Radio, cWhite gRadioOptionChanged vItemWorldOptions_farmLoop_itemType_armor x+5, Armor
    ; Gui Add, Radio, cWhite gRadioOptionChanged vItemWorldOptions_farmLoop_itemType_weapon x+5, Weapon
    ; GuiControl,, % "itemWorldOptions_farmLoop_itemType_" . settings.itemWorldOptions.farmLoop.itemType, 1

    ; Gui, Add, Progress, xs+10 vProgressBar_FarmItemWorldSingle -Smooth w140 h18 c0x66FF66 border
    ; Gui Add, Text, cBlack xp wp hp center vProgressText_FarmItemWorldSingle BackgroundTrans, Start FarmItemWorldSingle
    ; ;Gui Add, Button, xs+10 gFarmItemWorldSingle, FarmSingle
    ; Gui Add, Text, cWhite x+10, Item Rarity: 
    ; Gui Add, Radio, cWhite gRadioOptionChanged vItemWorldOptions_targetItem_legendary x+5, Legendary
    ; Gui Add, Radio, cWhite gRadioOptionChanged vItemWorldOptions_targetItem_rareOrLegendary x+5, Rare/Legendary
    ; Gui Add, Radio, cWhite gRadioOptionChanged vItemWorldOptions_targetItem_any x+5, Any
    ; GuiControl,, % "itemWorldOptions_targetItem_" . settings.itemWorldOptions.targetItem, 1
    ; Gui Add, Button, xs+10 y+10 gDoItem, ClearSingle
    ; Gui Add, Text, cWhite x+10, Bribe: 
    ; Gui Add, Radio, cWhite gRadioOptionChanged vItemWorldOptions_bribe_none x+5, None
    ; Gui Add, Radio, cWhite gRadioOptionChanged vItemWorldOptions_bribe_goldenCandy x+5, GoldenCandy
    ; Gui Add, Radio, cWhite gRadioOptionChanged vItemWorldOptions_bribe_goldBar x+5, GoldBar
    ; Gui Add, Radio, cWhite gRadioOptionChanged vItemWorldOptions_bribe_crabMiso x+5, CrabMiso
    ; GuiControl,, % "itemWorldOptions_bribe_" . settings.itemWorldOptions.bribe, 1

    Gui Add, Text, 0x10 xs w400 h10
    Gui, Font, Bold
    Gui Add, Text, cWhite xs+10, DarkGate
    Gui, Font, Normal

    Gui Add, Text, cWhite x+10, Count:
    Gui Add, Edit, cBlack w50 x+10 Number vDarkGateCount, 1
    Gui Add, Text, cWhite x+10, Skip:
    Gui Add, Edit, cBlack w50 x+10 Number vDarkGateSkipCount, 0

    Gui, Add, Progress, xs+10 vProgressBar_DoDarkGateHL -Smooth w100 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_DoDarkGateHL BackgroundTrans, Start DoDarkGateHL

    Gui, Add, Progress, x+5 vProgressBar_DoDarkGateMatsHuman -Smooth w150 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_DoDarkGateMatsHuman BackgroundTrans, Start DoDarkGateMatsHuman

    Gui, Add, Progress, x+5 vProgressBar_DoDarkGateMatsMonster -Smooth w150 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_DoDarkGateMatsMonster BackgroundTrans, Start DoDarkGateMatsMonster

    ;Gui Add, Button, xs+10 y+5 gDoDarkGate, HL/Mats
    Gui Tab, Settings

    ;Gui Add, Text, 0x10  w400 h10
    Gui Add, Text, cWhite xs+10 ys+25, Target Window:
    Gui Add, Edit, cBlack x+10 vTargetWindow w150, % settings.blueStacks.identifier
    Gui Add, Button, x+10 gApplyTargetWindow, Apply
    Gui, Font, Bold
    Gui Add, Text, cRed x+10 vAttached2, DETACHED
    Gui, Font, Normal
    Gui Add, Text, cWhite xs+10 y+15, Bluestacks Installation path:
    Gui Add, Edit, x+5 cBlack vInstallationPath w200, % settings.blueStacks.installationPath
    Gui Add, Button, x+10 gApplyInstallationPath, Apply
    Gui Add, Text, cWhite xs+10 y+5, Override ADB port:
    Gui Add, Edit, x+5 cBlack vPortOverride w100, % settings.blueStacks.portOverride
    Gui Add, Button, x+10 gApplyPortOverride, Apply

    Gui Add, Button, xs+10 y+15 gResize, Resize
    Gui Add, Button, x+10 gScreenCap, ScreenCap
    Gui Add, Button, x+10 gVerify, Verify
    Gui Add, Button, x+10 gTestDrop, TestDrop
    Gui Add, Button, x+10 gTest, Test
    Gui Add, Text, cWhite xs+10 y+15, Scan Mode:
    Gui Add, Radio, cWhite gScanModeChanged vScanMode_1 , 1
    Gui Add, Radio, cWhite gScanModeChanged vScanMode_2 x+10, 2
    Gui Add, Radio, cWhite gScanModeChanged vScanMode_3 x+10, 3
    Gui Add, Radio, cWhite gScanModeChanged vScanMode_4 x+10, 4
    GuiControl,, % "ScanMode_" . (settings.scanMode ? settings.scanMode : 4) , 1

    Gui Add, Link, x+150,<a href="https://github.com/yeetoverflow/autodisgaeaRPG">documentation</a>

    Gui Tab, Handlers
    
    Gui Add, TreeView, h300 cBlack vHandlersTree
    Gui Add, Button, gTestHandler, Test
    TreeAdd(handlers, 0, { doChildrenPredicate : Func("PatternChildrenPredicate") })

    Gui, Tab, Patterns
    Gui, Add, Text, cWhite, Filter:
    Gui, Add, Edit, cBlack x+5 gFilterPatterns vPatternFilter w100
    Gui Add, TreeView, xs+10 y+5 h300 cBlack gPatternsSelect vPatternsTree
    Gui, Font, cBlack
    Gui, Font, s3
    Gui Add, Edit, cBlack w400 r20 vPatternsPreview
    Gui, Font
    Gui, Add, Button, gPickPatternColor, Pick Color
    Gui, Add, Edit, cBlack x+5 w100 vPatternColorPick,
    Gui, Add, Text, cWhite x+5, Variance: 
    Gui Add, Edit, cBlack x+5 w30 cBlack vPatternColorVariance, 10
    Gui, Add, Button, x+5 gApplyColorPattern, Apply
    Gui, Add, Text, cWhite xs+10 y+5, Gray Diff: 
    Gui Add, Edit, cBlack x+5 w30 cBlack vPatternGrayDiff, 50
    Gui, Add, Button, x+5 gApplyGrayPattern, Apply

    Gui Add, Button, xs+10 y+5 gTestPattern, Test
    Gui Add, Checkbox, cWhite x+10 vTestPatternMulti, Multi
    Gui Add, Button, x+10 gCopyPatternToClipboard, Copy To Clipboard
    Gui Add, Button, x+150 gSavePatterns, Save Changes
    Gui Add, Text, cWhite xs+10 y+10, FG Variance:
    Gui Add, Slider, w200 tickinterval5 tooltip vTestPatternFG
    Gui Add, Text, cWhite xs+10 y+10, BG Variance: 
    Gui Add, Slider, w200 tickinterval5 tooltip vTestPatternBG
    TreeAdd(patterns.Object(), 0, { leafCallback : Func("InitPatternsCallback")})

    Gui Show, w450

    guiHwnd := GetGuiHwnd()
    InitBlueStacks()
}

ScanModeChanged() {
    global hwnd, settings, scanMode_1, scanMode_2, scanMode_3, scanMode_4
    Gui Submit, NoHide

    if (scanMode_1) {
        settings.scanMode := 1
    } else if (scanMode_2) {
        settings.scanMode := 2
    } else if (scanMode_3) {
        settings.scanMode := 3
    } else if (scanMode_4) {
        settings.scanMode := 4
    }

    settings.Save(true)

    FindText().BindWindow(hwnd, (settings.scanMode ? settings.scanMode : 4))>
}

CopyPatternToClipboard() {
    global patterns, patternsTree
    Gui Submit, NoHide
    Gui TreeView, patternsTree
    nodePath := GetNodePath()
    segments := StrSplit(nodePath, ".")
    target := patterns
    
    for k, v in segments {
        lastParent := target
        lastKey := v
        target := target[v]
    }

    Clipboard := target
}

SavePatterns() {
    global patterns
    patterns.Save(true)
}

ApplyGrayPattern() {
    Gui Submit, NoHide
    global patterns, patternsTree, patternGrayDiff
    pattern := GetPatternGrayDiff(patternGrayDiff)
    ;MsgBox, % pattern

    ascii := FindText().ASCII(pattern)
    GuiControl,, patternsPreview, % Trim(ascii,"`n")

    Gui Submit, NoHide
    Gui TreeView, patternsTree
    nodePath := GetNodePath()
    segments := StrSplit(nodePath, ".")
    target := patterns
    
    for k, v in segments {
        lastParent := target
        lastKey := v
        target := target[v]
    }

    lastParent[lastKey] := pattern
}

ApplyColorPattern() {
    Gui Submit, NoHide
    global patterns, patternsTree, patternColorPick, patternColorVariance
    pattern := GetPatternColor2Two(patternColorPick, 100-patternColorVariance)
    ;MsgBox, % pattern

    ascii := FindText().ASCII(pattern)
    GuiControl,, patternsPreview, % Trim(ascii,"`n")

    Gui Submit, NoHide
    Gui TreeView, patternsTree
    nodePath := GetNodePath()
    segments := StrSplit(nodePath, ".")
    target := patterns
    
    for k, v in segments {
        lastParent := target
        lastKey := v
        target := target[v]
    }

    lastParent[lastKey] := pattern
}

PickPatternColor() {
    color := GetPixelColor()
    GuiControl,, patternColorPick, % color
}

FilterPatterns() {
    global hwnd, patterns, patternsTree, patternFilter

    Gui Submit, NoHide
    Gui TreeView, patternsTree

    ;root := TV_Add(patterns, 0, "expand")

    tempRoot := {}
    
    TV_Delete()
    for k, v in patterns.Object() {
        if InStr(k, patternFilter) {
            tempRoot[k] := v
        }
    }

    TreeAdd(tempRoot)
}

ApplyTargetWindow() {
    global
    Gui, Submit, NoHide

    settings.blueStacks.identifier := targetWindow
    WinSetTitle, % "ahk_id " . guiHwnd,, % settings.blueStacks.identifier
    Menu, Tray, Tip, % settings.blueStacks.identifier
    settings.save(true)
    InitBlueStacks()
}

ApplyInstallationPath() {
    global settings, installationPath
    Gui, Submit, NoHide

    settings.blueStacks.installationPath := installationPath
    settings.save(true)
}

ApplyPortOverride() {
    global settings, portOverride
    Gui, Submit, NoHide

    settings.blueStacks.portOverride := portOverride
    run, hd-adb.exe connect 127.0.0.1:%portOverride% , % settings.blueStacks.installationPath, Hide

    settings.save(true)
}

AddAllyTarget() {
    global settings, patterns
    pattern := GetPatternGrayDiff50()

    if (pattern) {
        sleep 100
        FindText(X, Y, 0, 0, 0, 0, 0, 0, pattern, 1, 0)
        FindText().MouseTip(x, y)
        
        InputBox, allyTarget, Add Ally Target, Enter Ally Target Name (no spaces)

        If allyTarget && !ErrorLevel {
            doResetUI := false
            if (!settings.battleOptions.allyTargets[allyTarget]) {
                settings.battleOptions.allyTargets[allyTarget] := []
                patterns.battle.target[allyTarget] := []
                doResetUI := true
            }

            patterns.battle.target[allyTarget].Push(pattern)
            settings.battleOptions.allyTargets[allyTarget].Push(pattern)
            settings.save(true)

            if (doResetUI) {
                ResetUI()
            }
        }
    }
}

AddBattleCompanion() {
    global settings, patterns
    pattern := GetPatternGrayDiff50()

    if (pattern) {
        sleep 100
        FindText(X, Y, 0, 0, 0, 0, 0, 0, pattern, 1, 0)
        FindText().MouseTip(x, y)
        
        InputBox, companionName, Add Companion, Enter companion name (no spaces)

        If companionName && !ErrorLevel {
            doResetUI := true
            if (!settings.battleOptions.companions[companionName]) {
                settings.battleOptions.companions[companionName] := []
                patterns.companions[companionName] := []
                doResetUI := false
            }

            patterns.companions[companionName].Push(pattern)
            settings.battleOptions.companions[companionName].Push(pattern)
            settings.save(true)
            
            if (doResetUI) {
                ResetUI()
            }
        }
    }
}

AddBattleSkill() {
    global settings, patterns
    pattern := GetPatternGrayDiff50()

    if (pattern) {
        sleep 100
        FindText(X, Y, 0, 0, 0, 0, 0, 0, pattern, 1, 0)
        FindText().MouseTip(x, y)
        
        InputBox, skillName, Add Skill, Enter skill name (no spaces)

        If skillName && !ErrorLevel {
            if (!patterns.battle.skills[skillName]) {
                settings.battleOptions.skillOrder.push(skillName)
            }
            patterns.battle.skills[skillName] := pattern
            settings.battleOptions.skills[skillName] := pattern
            settings.save(true)
            ResetUI()
        }
    }
}

AddBattleSingleTargetSkill() {
    global settings
    
    Gui DropDownInput:New,,
    Gui DropDownInput:Add, Text,, Select Skill

    skills := ""
    for k, v in settings.battleOptions.skills {
        skip := false
        for k2, v2 in settings.battleOptions.singleTargetSkills {
            if (k = v2) {
                skip := true
                Break
            }
        }

        if (!skip) {
            skills .= k . "|" 
        }
    }

    Gui DropDownInput:Add, DropDownList, vAddBattleSingleTargetSkill w200, % skills
    Gui DropDownInput:Add, Button, gAddBattleSingleTargetSkillOk w100, Ok
    Gui DropDownInput:Add, Button, x+5 w100 gAddBattleSingleTargetSkillCancel, Cancel
    
    Gui DropDownInput:Show, w250 h100
}

AddBattleSingleTargetSkillOk() {
    global settings, addBattleSingleTargetSkill
    Gui DropDownInput:Submit

    if (addBattleSingleTargetSkill) {
        settings.battleOptions.singleTargetSkills.Push(addBattleSingleTargetSkill)
        settings.save(true)
        ResetUI()
    }
}

AddBattleSingleTargetSkillCancel() {
    Gui DropDownInput:Submit
}

SelectStoryBanner() {
    global settings, patterns
    pattern := GetPatternGrayDiff50()

    if (pattern) {
        sleep 100
        FindText(X, Y, 0, 0, 0, 0, 0, 0, pattern, 1, 0)
        FindText().MouseTip(x, y)
        settings.eventOptions.banners.story := pattern
        settings.save(true)
        InitSettings()
        ResetUI()
    }
}

SelectRaidBanner() {
    global settings, patterns
    pattern := GetPatternGrayDiff50()

    if (pattern) {
        sleep 100
        FindText(X, Y, 0, 0, 0, 0, 0, 0, pattern, 1, 0)
        FindText().MouseTip(x, y)
        settings.eventOptions.banners.raid := pattern
        settings.save(true)
        InitSettings()
        ResetUI()
    }
}

ResetCurrentBattleContext() {
    global settings, defaults

    settings["battleOptions"][settings.battleContext] := defaults["battleOptions"][settings.battleContext]
    InitBattleOptionsUI(settings["battleOptions"][settings.battleContext])

    settings.save(true)
}

RadioOptionChanged() {
    global settings
    Gui Submit, NoHide

    segments := StrSplit(A_GuiControl, "_")
    target := settings
    length := segments.MaxIndex()
    
    for k, v in segments {
        ;last segment is the target value
        if (k > length - 1) {
            targetValue := v
            target := lastParent
            Break
        }

        lastParent := target
        lastKey := v
        target := target[v]
    }

    target[lastKey] := targetValue
    settings.save(true)
}

BattleContextChanged() {
    global settings, battleContext
    Gui Submit, NoHide

    switch battleContext
    {
        case 1: settings.battleContext := "default"
        case 2: settings.battleContext := "event"
        case 3: settings.battleContext := "itemWorld"
        case 4: settings.battleContext := "sweep"
        case 5: settings.battleContext := "raid"
        case 6: settings.battleContext := "darkGateMats"
        case 7: settings.battleContext := "darkGateHL"
    }

    settings.Save(true)
    InitBattleOptionsUI(settings["battleOptions"][settings.battleContext])
}

GuiClose() {
    ExitApp
}

GetNodePath() {
    nodePath := ""
    nodeId := TV_GetSelection()
    Loop {
        TV_GetText(itemName, nodeId)
        nodePath := itemName . "." . nodePath
        nodeId := TV_GetParent(nodeId)
    } Until (nodeId = 0)

    nodePath := RTrim(nodePath, ".")
    Return nodePath
}

IsWithIn(pos, x1, x2, y1, y2) {
    if (pos.X >= x1 && pos.Y >= y1 && pos.X <= x2 && pos.Y <= y2) {
        Return True
    }
    Return False
}

CreateBattleOptionsUI(battleOptions) {
    global

    Gui Add, Checkbox, % "cWhite xs+10 y+10 gBattleOptionsCheckedChanged vBattleOptions_"
        . "auto", Auto
    Gui Add, Checkbox, % "cWhite x+5 gBattleOptionsCheckedChanged vBattleOptions_"
        . "targetEnemyMiddle", TargetEnemyMiddle
    Gui Add, Checkbox, % "cWhite x+5 gBattleOptionsCheckedChanged vBattleOptions_"
        . "selectStandby", SelectStandby
    Gui Add, Checkbox, % "cWhite x+5 gBattleOptionsCheckedChanged vBattleOptions_"
        . "autoRefillAP", AutoRefillAP

    ; local targetSettings := "settings_battleOptions_" . settings.battleContext
    ; local settingMetaData := GetSettingMetaData(targetSettings)
    ; for k, v in settingMetaData.displayOrder
    ; {
    ;     local settingUnderscore := targetSettings . "_" . v
    ;     local settingInfo := GetSettingInfo(settingUnderscore)
    ;     AddSetting(settingInfo, "1")
    ; }

    Gui Add, Text, cWhite xs+10 y+5, Companions:

    count := 1
    for k, v in settings.battleOptions.companions {
        if (count = 1) {
            Gui Add, Checkbox, % "cWhite gBattleOptionsMultiCheckedChanged vBattleOptions_"
                . "companions_" . k, % k
        } else if (mod(count, 4) = 0) {
            Gui Add, Checkbox, % "cWhite xs+10 y+5 gBattleOptionsMultiCheckedChanged vBattleOptions_"
                . "companions_" . k, % k
        } else {
            Gui Add, Checkbox, % "cWhite x+5 gBattleOptionsMultiCheckedChanged vBattleOptions_"
                . "companions_" . k, % k
        }
        count++
    }

    Gui Add, Button, x+5 gAddBattleCompanion, Add

    count := 2
    Gui Add, Text, cWhite xs+10 y+5, AllyTarget:
    Gui Add, Radio, % "cWhite gBattleOptionsRadioCheckedChanged vBattleOptions_allyTarget_None", None
    for k, v in settings.battleOptions.allyTargets  {
        if (k = "None") {
            continue
        }

        if (mod(count, 4) = 0) {
            Gui Add, Radio, % "cWhite xs+10 y+5 gBattleOptionsRadioCheckedChanged vBattleOptions_"
                . "allyTarget_" . k, % k
        } else {
            Gui Add, Radio, % "cWhite x+5 gBattleOptionsRadioCheckedChanged vBattleOptions_"
                . "allyTarget_" . k, % k
        }
        count++
    }
    
    Gui Add, Button, x+5 gAddAllyTarget, Add

    Gui Add, Text, cWhite xs+10 y+5, Skills:
    for k, v in settings.battleOptions.skillOrder {
        if (k = 1) {
            Gui Add, Checkbox, % "cWhite gBattleOptionsMultiCheckedChanged vBattleOptions_"
                . "skills_" . v, % v
        } else if mod(k, 4) = 0 {
            Gui Add, Checkbox, % "cWhite xs+10 y+5 gBattleOptionsMultiCheckedChanged vBattleOptions_"
                . "skills_" . v, % v
        } else {
            Gui Add, Checkbox, % "cWhite x+5 gBattleOptionsMultiCheckedChanged vBattleOptions_"
                . "skills_" . v, % v
        }
    }

    Gui Add, Button, x+5 gAddBattleSkill, Add

    Gui Add, Text, cWhite xs+10 y+5, SingleTargetSkills (Used in ItemWorld):
    for k, v in settings.battleOptions.singleTargetSkills {
        if (k = 1) {
            Gui Add, Checkbox, % "cWhite gBattleOptionsMultiCheckedChanged vBattleOptions_"
                . "singleTargetSkills_" . v, % v
        } else if mod(k, 4) = 0 {
            Gui Add, Checkbox, % "cWhite xs+10 y+5 gBattleOptionsMultiCheckedChanged vBattleOptions_"
                . "singleTargetSkills_" . v, % v
        } else {
            Gui Add, Checkbox, % "cWhite x+5 gBattleOptionsMultiCheckedChanged vBattleOptions_"
                . "singleTargetSkills_" . v, % v
        }
    }

    Gui Add, Button, x+5 gAddBattleSingleTargetSkill, Add

    InitBattleOptionsUI(battleOptions)
}

InitBattleOptionsUI(battleOptions) {
    global

    GuiControl,, % "battleOptions_auto", % battleOptions.auto ? 1 : 0
    GuiControl,, % "battleOptions_targetEnemyMiddle", % battleOptions.targetEnemyMiddle ? 1 : 0
    GuiControl,, % "battleOptions_selectStandby", % battleOptions.selectStandby ? 1 : 0
    GuiControl,, % "battleOptions_autoRefillAP", % battleOptions.autoRefillAP ? 1 : 0

    for k, v in settings.battleOptions.companions {
        GuiControl,, % "battleOptions_companions_" . k, 0
    }
    for k, v in battleOptions.companions {
        GuiControl,, % "battleOptions_companions_" . v, 1
    }
    
    GuiControl,, % "battleOptions_allyTarget_" . battleOptions.allyTarget, 1
    
    for k, v in settings.battleOptions.skillOrder {
        GuiControl,, % "battleOptions_skills_" . v, 0
    }
    for k, v in battleOptions.skills {
        GuiControl,, % "battleOptions_skills_" . v, 1
    }

    for k, v in settings.battleOptions.singleTargetSkills {
        GuiControl,, % "battleOptions_singleTargetSkills_" . v, 0
    }
    for k, v in battleOptions.singleTargetSkills {
        GuiControl,, % "battleOptions_singleTargetSkills_" . v, 1
    }
}

BattleOptionsCheckedChanged() {
    global
    Gui Submit, NoHide

    segments := StrSplit(A_GuiControl, "_")
    property := segments[2]
    battleOptions := settings["battleOptions"][settings.battleContext]

    GuiControlGet, currentVal, , % A_GuiControl
    battleOptions[property] := currentVal

    settings.save(true)
}

BattleOptionsMultiCheckedChanged() {
    global
    Gui Submit, NoHide

    segments := StrSplit(A_GuiControl, "_")
    property := segments[2]
    battleOptions := settings["battleOptions"][settings.battleContext]
    
    values := []
    for k, v in settings["battleOptions"][property] {
        GuiControlGet, valueChecked, , % "battleOptions_" . property . "_" . k
        if (valueChecked) {
            values.Push(k)
        }

        GuiControlGet, valueChecked, , % "battleOptions_" . property . "_" . v
        if (valueChecked) {
            values.Push(v)
        }
    }

    battleOptions[property] := values
    settings.save(true)
}

BattleOptionsRadioCheckedChanged() {
    global
    Gui Submit, NoHide

    segments := StrSplit(A_GuiControl, "_")
    optionType := segments[1]
    property := segments[2]
    battleOptions := settings[optionType][settings.battleContext]
    
    for k, v in settings[optionType][property . "s"] {
        GuiControlGet, valueChecked, , % optionType . "_" . property . "_" . k
        if (valueChecked) {
            battleOptions[property] := k
            settings.save(true)
            Return
        }
    }
}

GetProgressBarArgs(mode) {
    global guiHwnd

    ;https://www.autohotkey.com/docs/commands/WinGet.htm
    WinGet, controlHwnds, ControlListHwnd, % "ahk_id " . guiHwnd
    Loop, Parse, controlHwnds, `n
    {
        ;WinGetClass, this_class, ahk_id %A_LoopField%
        ControlGetText, controlText,, ahk_id %A_LoopField%

        if strreplace(controlText, "`n") = "Stop " . mode || strreplace(controlText, "`n") = "Start " . mode
        {
            ;https://www.autohotkey.com/docs/commands/WinSet.htm#Redraw
            ;SendMessage, 0x000C,0,"qqq",, % "ahk_id " . A_LoopField
            ; Control, Style, -0x8,,% "ahk_id " . prevHwnd
            ; ControlSetText,, "Start " . text,  % "ahk_id " . A_LoopField
            ; WinHide, % "ahk_id " . A_LoopField
            ; WinShow, % "ahk_id " . A_LoopField
            Return { progressBarHwnd : prevHwnd, progressTextHwnd : A_LoopField, text : mode }
        }
        
        prevHwnd := A_LoopField
    }

    Return false
}

CleanUp() {
    global timers, mode, pbArgs, modeToMsg, guiHwnd
    if (timers) {
        for mode, v in timers {
            HandleAction("Stop", mode)
            SetTimer, % v, delete
        }
    }

    if (mode) {
        msg := modeToMsg[mode]
        ;Send a stop message
        PostMessage, % msg, 0, 0, , % "ahk_id " . guiHwnd
    }
}

StartProgressBar(pbArgs) {
    ;https://docs.microsoft.com/en-us/windows/win32/controls/pbm-deltapos
    ;https://nsis-dev.github.io/NSIS-Forums/html/t-174689.html
    SendMessage, 0x0403, 1, 0, , % "ahk_id " . pbArgs.progressBarHwnd
    ControlSetText,, % "Stop " . pbArgs.text,  % "ahk_id " . pbArgs.progressTextHwnd
}

OnCustomMessage(wParam, lParam, msg, hwnd)
{
    global timers, pbArgsList, msgToMode

    if (!timers) {
        timers := {}
    }

    if (!pbArgsList) {
        pbArgsList := {}
    }

    mode := msgToMode[msg]
    if (!mode) {
        MsgBox, % "Unmapped mode: " . mode
    }

    if (mode && wParam = 1) {
        pbArgs := GetProgressBarArgs(mode)
        pbFunc := Func("StartProgressBar").bind(pbArgs)
        pbArgsList[mode] := pbArgs

        SetTimer, % pbFunc, 200
        timers[mode] := pbFunc

        recover := Func("Recover").Bind(mode)
        SetTimer, % recover, 60000
        timers[mode . "_Recover"] := recover

        Control, Style, +0x8,,% "ahk_id " . pbArgs.progressBarHwnd
    } else if (mode && wParam = 0) {
        pbFunc := timers[mode]
        SetTimer, % pbFunc, delete

        recover := timers[mode . "_Recover"]
        SetTimer, % recover, delete
        pbArgs := pbArgsList[mode]

        Control, Style, -0x8,,% "ahk_id " . pbArgs.progressBarHwnd
        sleep 200
        ControlSetText,, % "Start " . pbArgs.text,  % "ahk_id " . pbArgs.progressTextHwnd
    }
}

;https://www.autohotkey.com/boards/viewtopic.php?t=66561
WM_LBUTTONDOWN() {
    global guiHwnd, modeToMsg

    segments := StrSplit(A_GuiControl, "_")
    control := segments.1
    mode := segments.2

    If (A_Gui != "1")
        Return

    If (control = "ProgressBar") {
        progressText := StrReplace(A_GuiControl, "ProgressBar", "ProgressText")
        GuiControlGet, currentText,, % progressText

        if InStr(currentText, "Start") {
            HandleAction("Start", mode)
        } else {
            HandleAction("Stop", mode)
            msg := modeToMsg[mode]
            if (!msg) {
                MsgBox, % "Unmapped message: " . msg
            }
            PostMessage, % msg, 0, 0, , % "ahk_id " . guiHwnd
        }
    }
    Else If (control = "Settings") {
        SettingsModal(A_GuiControl)
    }
}

HandleAction(action, mode) {
    global settings
    
    SetStatus(action)
    SetStatus(mode , 2)
    SetStatus("" , 3)

    if (action = "Start") {
        if (A_IsCompiled) {
            Run, % "autoDisgaeaRpg.exe id=""" . settings.blueStacks.identifier . """ mode=" . mode
        }
        else {
            Run, % "autoDisgaeaRpg.ahk id=""" . settings.blueStacks.identifier . """ mode=" . mode
        }
    }
    else if (action = "Stop") {
        hwnd := GetHwnd(settings.blueStacks.identifier, mode)
        WinClose, % "ahk_id " . hwnd
        WinWaitClose, % "ahk_id " . hwnd,,5
    }
}

PatternChildrenPredicate(node) {
    if (node.Func && node.Count() = 1) {
        Return false
    }

    if (node.Func && node.Arg1 && node.Count() = 2) {
        Return false
    }

    Return true
}
