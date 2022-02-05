#include settings.ahk

OnExit("Cleanup")

ResetUI() {
    global

    Gui, Destroy
    Gui, Color, 404040
    ;Gui, Font, cFFFFFF

    ;Gui, +HwndHwndMainGui
    statusBarText := "||"
    Gui Add, StatusBar,, % statusBarText
    Gui Add, Tab3, cWhite section vTopTabs, Main|Settings|Handlers|Patterns|Logs
    GuiControl, choose, TopTabs, 1

    Gui Tab, Main

    InitBattleOptionsUI()

    Gui, Add, Progress, xs+120 y+10 vProgressBar_Battle -Smooth w80 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_Battle BackgroundTrans, Start Battle
    Gui Add, Text, cWhite x+10, Count: 
    Gui Add, Edit, cBlack w50 x+10 Number vBattleCount, 1

    Gui Add, Text, 0x10 xs w400 h10
    Gui, Font, Bold
    Gui Add, Text, cWhite xs+10, General
    Gui, Font, Normal
    Gui Add, Link, x+5,<a href="https://github.com/yeetoverflow/autodisgaeaRPG/blob/main/README.md#general-video">?</a>
    Gui, Add, Progress, xs+10 vProgressBar_AutoDailies -Smooth w80 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_AutoDailies BackgroundTrans, Start AutoDailies
    Gui, Add, Progress, x+10 w50 h18 c0x66FF66 vsettingsmodal_dailies
    Gui Add, Text, xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left, Settings
    Gui Add, Text, x+10 cWhite, Start: 
    AddSetting("settings_dailies_current", "1", { hideLabel : true, optsOverride : "w200 x+10" } )
    ; Gui Add, Text, x+10 cWhite, Current:
    ; Gui Add, DropDownList, x+10 w100 uppercase, Red|Blue|Green|Yellow|Black
    
    Gui, Add, Progress, xs+10 vProgressBar_AutoShop -Smooth w80 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_AutoShop BackgroundTrans, Start AutoShop
    AddSetting("settings_shop_shopType", "1", { hideLabel : true, optsOverride : "x+10" } )
    AddSetting("settings_shop_skipRefresh", "1", { hideLabel : true, optsOverride : "x+10" } )
    
    Gui, Add, Progress, xs+10 vProgressBar_AutoFriends -Smooth w100 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_AutoFriends BackgroundTrans, Start AutoFriends
    Gui, Add, Progress, x+10 vProgressBar_AutoDailySummon -Smooth w120 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_AutoDailySummon BackgroundTrans, Start AutoDailySummon
    Gui, Add, Progress, x+10 vProgressBar_AutoDope -Smooth w80 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_AutoDope BackgroundTrans, Start AutoDope

    Gui, Add, Progress, xs+10 vProgressBar_AutoFish -Smooth w120 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_AutoFish BackgroundTrans, Start AutoFish
    Gui, Add, Progress, x+10 w50 h18 c0x66FF66 vsettingsmodal_fishingFleet_bribe
    Gui Add, Text, xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left, Settings

    Gui, Add, Progress, xs+10 vProgressBar_AutoDarkAssembly -Smooth w120 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_AutoDarkAssembly BackgroundTrans, Start AutoDarkAssembly
    Gui, Add, Progress, x+10 w50 h18 c0x66FF66 vsettingsmodal_general_darkAssembly
    Gui Add, Text, xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left, Settings
    AddSetting("settings_general_darkAssembly_targetBill", "1", { hideLabel : true, optsOverride : "x+10" } )

    Gui, Add, Progress, xs+10 vProgressBar_AutoDailyCharacterGate1 -Smooth w200 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_AutoDailyCharacterGate1 BackgroundTrans, Start AutoDailyCharacterGate1

    Gui, Add, Progress, xs+10 vProgressBar_AutoDailyEventReview1 -Smooth w200 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_AutoDailyEventReview1 BackgroundTrans, Start AutoDailyEventReview1

    Gui, Add, Progress, xs+10 vProgressBar_AutoDailyDarkGateHL -Smooth w200 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_AutoDailyDarkGateHL BackgroundTrans, Start AutoDailyDarkGateHL
    Gui, Add, Progress, x+10 w50 h18 c0x66FF66 vsettingsmodal_darkGateOptions_hl
    Gui Add, Text, xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left, Settings
    
    Gui, Add, Progress, xs+10 vProgressBar_AutoDailyDarkGateMatsHuman -Smooth w200 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_AutoDailyDarkGateMatsHuman BackgroundTrans, Start AutoDailyDarkGateMatsHuman
    Gui, Add, Progress, x+10 w50 h18 c0x66FF66 vsettingsmodal_darkGateOptions_matsHuman
    Gui Add, Text, xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left, Settings

    Gui, Add, Progress, xs+10 vProgressBar_AutoDailyDarkGateMatsMonster -Smooth w200 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_AutoDailyDarkGateMatsMonster BackgroundTrans, Start AutoDailyDarkGateMatsMonster
    Gui, Add, Progress, x+10 w50 h18 c0x66FF66 vsettingsmodal_darkGateOptions_matsMonster
    Gui Add, Text, xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left, Settings

    Gui, Add, Progress, xs+10 vProgressBar_AutoDailyEventStoryFarm -Smooth w200 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_AutoDailyEventStoryFarm BackgroundTrans, Start AutoDailyEventStoryFarm
    Gui, Add, Progress, x+10 w50 h18 c0x66FF66 vsettingsmodal_dailies_event_story
    Gui Add, Text, xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left, Settings

    Gui Add, Text, 0x10 xs w400 h10
    Gui, Font, Bold
    Gui Add, Text, cWhite xs+10, Story
    Gui Add, Link, x+5,<a href="https://github.com/yeetoverflow/autodisgaeaRPG/blob/main/README.md#story">?</a>
    Gui, Font, Normal
    Gui, Add, Progress, xs+10 vProgressBar_AutoClear -Smooth w120 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_AutoClear BackgroundTrans, Start AutoClear

    Gui Add, Text, 0x10 xs w400 h10
    Gui, Font, Bold
    Gui Add, Text, cWhite xs+10, Event
    Gui, Font, Normal
    Gui Add, Link, x+5,<a href="https://github.com/yeetoverflow/autodisgaeaRPG/blob/main/README.md#event-video">?</a>
    Gui Add, Button, x+10 gSelectBanners, Select Banners

    Gui, Add, Progress, xs+10 vProgressBar_EventStoryFarm -Smooth w120 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_EventStoryFarm BackgroundTrans, Start EventStoryFarm
    Gui Add, Text, cWhite x+10, Count
    Gui Add, Edit, cBlack w50 x+10 Number, 1
    AddSetting("settings_eventOptions_story_farmTarget", "1", { hideLabel : true, optsOverride : "x+10" } )

    Gui, Add, Progress, xs+10 vProgressBar_EventStory500Pct -Smooth w120 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_EventStory500Pct BackgroundTrans, Start EventStory500Pct

    Gui, Add, Progress, x+10 vProgressBar_EventAutoClear -Smooth w100 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_EventAutoClear BackgroundTrans, Start EventAutoClear

    Gui, Font, Bold
    Gui Add, Text, cWhite xs+10, Raid
    Gui, Font, Normal

    Gui, Add, Progress, x+10 w250 h18 c0x66FF66 vsettingsmodal_eventOptions_raid
    Gui Add, Text, xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left vsettingsText_eventOptions_raid, % GetSettingDisplay("settings_eventOptions_raid")

    Gui, Add, Progress, xs+10 vProgressBar_EventRaidLoop -Smooth w100 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_EventRaidLoop BackgroundTrans, Start EventRaidLoop

    Gui, Add, Progress, xs+10 vProgressBar_EventRaidAutoClaim -Smooth w130 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_EventRaidAutoClaim BackgroundTrans, Start EventRaidAutoClaim

    AddSetting("settings_eventOptions_raid_claimType", "1", { hideLabel : true, optsOverride : "x+10" } )

    ; Gui, Add, Progress, x+10 vProgressBar_EventRaidAutoVault -Smooth w130 h18 c0x66FF66 border
    ; Gui Add, Text, cBlack xp wp hp center vProgressText_EventRaidAutoVault BackgroundTrans, Start EventRaidAutoVault

    Gui Add, Text, 0x10 xs w400 h10
    Gui Font, Bold
    Gui Add, Text, cWhite xs+10, ItemWorld
    Gui Font, Normal
    Gui Add, Link, x+5,<a href="https://github.com/yeetoverflow/autodisgaeaRPG/blob/main/README.md#itemworld-video">?</a>
    Gui, Add, Progress, x+10 w50 h18 c0x66FF66 vsettingsmodal_itemWorldOptions
    Gui Add, Text, xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left, Settings
    
    Gui Add, Text, x+5 cWhite, Battle Count : 
    Gui Add, Text, x+5 hidden, ItemWorldBattleCount
    Gui Add, Text, xp yp cWhite w100, 0
    
    Gui, Add, Progress, xs+10 vProgressBar_GrindItemWorldLoop1 -Smooth w150 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_GrindItemWorldLoop1 BackgroundTrans, Start GrindItemWorldLoop1

    Gui, Add, Progress, x+10 vProgressBar_GrindItemWorldSingle1 -Smooth w150 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_GrindItemWorldSingle1 BackgroundTrans, Start GrindItemWorldSingle1

    Gui, Add, Progress, x+10 w50 h18 c0x66FF66 vsettingsmodal_itemWorldOptions_1
    Gui Add, Text, xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left, Settings

    Gui, Add, Progress, xs+10 vProgressBar_GrindItemWorldLoop2 -Smooth w150 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_GrindItemWorldLoop2 BackgroundTrans, Start GrindItemWorldLoop2

    Gui, Add, Progress, x+10 vProgressBar_GrindItemWorldSingle2 -Smooth w150 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_GrindItemWorldSingle2 BackgroundTrans, Start GrindItemWorldSingle2

    Gui, Add, Progress, x+10 w50 h18 c0x66FF66 vsettingsmodal_itemWorldOptions_2
    Gui Add, Text, xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left, Settings

    Gui Add, Text, 0x10 xs w400 h10
    Gui, Font, Bold
    Gui Add, Text, cWhite xs+10, DarkGate
    Gui, Font, Normal
    Gui Add, Link, x+5,<a href="https://github.com/yeetoverflow/autodisgaeaRPG/blob/main/README.md#darkgate-video">?</a>

    Gui Add, Text, cWhite x+5, Count:
    Gui Add, Edit, cBlack w30 x+5 Number vDarkGateCount, 1
    Gui Add, Text, cWhite x+5, Skip:
    Gui Add, Edit, cBlack w30 x+5 Number vDarkGateSkipCount, 0

    Gui, Add, Progress, xs+10 vProgressBar_AutoDarkGate -Smooth w100 h18 c0x66FF66 border
    Gui Add, Text, cBlack xp wp hp center vProgressText_AutoDarkGate BackgroundTrans, Start AutoDarkGate
    AddSetting("settings_darkGateOptions_selectedGate", "1", { hideLabel : true, optsOverride : "x+10" } )

    Gui Tab, Settings

    Gui, Font, Bold
    Gui Add, Text, cWhite xs+10 y+20, Settings
    Gui, Font, Normal
    Gui Add, Link, x+5,<a href="https://github.com/yeetoverflow/autodisgaeaRPG/blob/main/README.md#setup-video">?</a>
    Gui Add, Text, 0x10 xs+10 y+5 w400 h10

    AddSetting("settings_window_emulator", "1")
    AddSetting("settings_window_name", "1")
    AddSetting("settings_window_scanMode", "1")
    
    Gui, Font, Bold
    Gui Add, Text, cWhite xs+10 y+20, Debug 
    Gui, Font, Normal
    
    AddSetting("settings_debug_drop", "1")

    Gui, Font, Bold
    Gui Add, Text, cRed x+100 y+10 vAttached2, DETACHED
    Gui, Font, Normal
    Gui Add, Button, xs+10 y+15 gResize, Resize
    Gui Add, Button, x+10 gScreenCap, ScreenCap
    Gui Add, Button, x+10 gVerify, Verify
    Gui Add, Button, x+10 gTestDrop, TestDrop
    Gui Add, Button, x+10 gTest, Test

    Gui Add, Link, x+50,<a href="https://github.com/yeetoverflow/autodisgaeaRPG">documentation</a>

    Gui Tab, Handlers
    
    Gui Add, TreeView, h300 cBlack vHandlersTree
    Gui Add, Button, gTestHandler, Test

    Gui, Tab, Patterns
    Gui, Add, Text, cWhite, Filter:
    Gui, Add, Edit, cBlack x+5 gFilterPatterns vPatternFilter w100
    Gui Add, TreeView, xs+10 y+5 h300 cBlack gPatternsSelect vPatternsTree
    Gui, Font, cBlack
    Gui, Font, s3
    Gui Add, Edit, cBlack w400 r20 vPatternsPreview
    Gui, Font

    Gui Add, Button, xs+10 y+5 gTestPattern, Test
    Gui Add, Checkbox, cWhite x+10 vTestPatternMulti, Multi
    Gui Add, Button, x+10 gCopyPatternToClipboard, Copy To Clipboard
    Gui Add, Button, x+10 gOpenUserPattern, UserPattern
    Gui Add, Text, cWhite xs+10 y+10, Variance:
    Gui Add, Slider, w200 tickinterval5 tooltip vTestPatternVariance, 15
    Gui Add, Text, cWhite xs+10 y+5, Bounds: 
    Gui Add, Edit, x+10 vTestBounds w100,
    Gui Add, Button, x+10 gGenerateBounds, Generate

    Gui, Tab, Logs
    AddSetting("settings_debug_doLog", "1")
    Gui Add, Text, hidden, EditLog
    Gui Add, Edit, xp yp r60 w400 vEditLog

    Gui Show, w450

    LV_Modify(1, "Select")
    InitHandlersTree()
    InitWindow()
}

GenerateBounds() {
    global hwnd
    result := LetUserSelectRect()
    FindText().ScreenToWindow(x1, y1, result.x1, result.y1, hwnd)
    FindText().ScreenToWindow(x2, y2, result.x2, result.y2, hwnd)
    GuiControl,, TestBounds, % "{ x1 : " . x1 . ", y1 : " . y1 . ", x2 : " . x2 . ", y2 : " . y2 . " }"
}

SelectBattleOption() {
    if (A_GuiEvent = "I") {
        currentRow := LV_GetNext(0)
        LV_GetText(currentBattleOption, currentRow)
        ResetBattleOption(currentBattleOption)
    }
}

ResetBattleOption(currentBattleOption) {
    global guiHwnd, settings
    battleOptions := ["Default", "Event", "ItemWorld", "Sweep", "Raid", "DarkGateMats", "DarkGateHL"]

    defaultSettings := "settings_battleOptions_default"
    settingMetaData := GetSettingMetaData(defaultSettings)

    ;hide all the controls
    for k, v in settingMetaData.displayOrder
    {
        for i, battleOption in battleOptions {
            GuiControl, %guiHwnd%:Hide, % "settings_battleOptions_" . battleOption . "_" . v 
        }
    }

    for i, battleOption in battleOptions {
        GuiControl, %guiHwnd%:Hide, % "battleOptions_" . battleOption . "_companions"
        GuiControl, %guiHwnd%:Hide, % "battleOptionsText_" . battleOption . "_companions" 
        GuiControl, %guiHwnd%:Hide, % "battleOptions_" . battleOption . "_allyTarget"
        GuiControl, %guiHwnd%:Hide, % "battleOptionsText_" . battleOption . "_allyTarget" 
        GuiControl, %guiHwnd%:Hide, % "battleOptions_" . battleOption . "_skills"
        GuiControl, %guiHwnd%:Hide, % "battleOptionsText_" . battleOption . "_skills" 
    }

    for k, v in settingMetaData.displayOrder
    {
        GuiControl, %guiHwnd%:Show, % "settings_battleOptions_" . currentBattleOption . "_" . v 
    }

    GuiControl, %guiHwnd%:Show, % "battleOptions_" . currentBattleOption . "_companions" 
    GuiControl, %guiHwnd%:Show, % "battleOptionsText_" . currentBattleOption . "_companions" 
    GuiControl, %guiHwnd%:Show, % "battleOptions_" . currentBattleOption . "_allyTarget" 
    GuiControl, %guiHwnd%:Show, % "battleOptionsText_" . currentBattleOption . "_allyTarget" 
    GuiControl, %guiHwnd%:Show, % "battleOptions_" . currentBattleOption . "_skills" 
    GuiControl, %guiHwnd%:Show, % "battleOptionsText_" . currentBattleOption . "_skills" 

    settings.battleContext := currentBattleOption
    settings.save(true)
}

InitBattleOptionsUI() {
    global

    Gui, Font, Bold
    Gui Add, Text, xs+250 ys+25 vAttached cRed, DETACHED
    Gui Add, Text, cWhite xs+10 ys+25, BattleContext
    Gui, Font, Normal
    Gui Add, Link, x+5,<a href="https://github.com/yeetoverflow/autodisgaeaRPG/blob/main/README.md#battle-video">?</a>
    Gui Add, ListView, xs+10 y+5 w100 h170 gSelectBattleOption vBattleOptionsTree NoSort AltSubmit, Name
    Gui Add, Text, x+10,

    battleOptions := ["Default", "Event", "ItemWorld", "Sweep", "Raid", "DarkGateMats", "DarkGateHL"]

    local defaultSettings := "settings_battleOptions_default"
    local settingMetaData := GetSettingMetaData(defaultSettings)

    for i, battleOption in battleOptions {
        LV_Add("", battleOption)
    }

    for k, v in settingMetaData.displayOrder
    {
        for i, battleOption in battleOptions {
            local targetSettings := "settings_battleOptions_" . battleOption
            local settingUnderscore := targetSettings . "_" . v
            local settingInfo := GetSettingInfo(settingUnderscore)
            local opts := { offsetX : 120 }

            if (i != 1) {
                opts.optsOverride := "xp yp"
            }

            AddSetting(settingInfo, "1", opts)
        }
    }

    for i, battleOption in battleOptions {
        local targetSettings := "settings_battleOptions_" . battleOption
        local targetSetting := "companions"
        local settingUnderscore := targetSettings . "_" . targetSetting
        local settingInfo := GetSettingInfo(settingUnderscore)
        local opts := { offsetX : 120 }

        if (i == 1) {
            Gui, Add, Progress, % "xs+120 y+10 w300 h18 c0x66FF66 vbattleOptions_" . battleOption . "_" . targetSetting
            Gui Add, Text, % "xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left vbattleOptionsText_" . battleOption . "_" . targetSetting, % GetSettingDisplay("settings_battleOptions_" . battleOption . "_" . targetSetting)
        }
        else {
            Gui, Add, Progress, % "xp-5 yp w300 h18 c0x66FF66 vbattleOptions_" . battleOption . "_" . targetSetting
            Gui Add, Text, % "xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left vbattleOptionsText_" . battleOption . "_" . targetSetting, % GetSettingDisplay("settings_battleOptions_" . battleOption . "_" . targetSetting)
        }
    }

    for i, battleOption in battleOptions {
        local targetSettings := "settings_battleOptions_" . battleOption
        local targetSetting := "allyTarget"
        local settingUnderscore := targetSettings . "_" . targetSetting
        local settingInfo := GetSettingInfo(settingUnderscore)
        local opts := { offsetX : 120 }

        if (i == 1) {
            Gui, Add, Progress, % "xs+120 y+10 w300 h18 c0x66FF66 vbattleOptions_" . battleOption . "_" . targetSetting
            Gui Add, Text, % "xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left vbattleOptionsText_" . battleOption . "_" . targetSetting, % GetSettingDisplay("settings_battleOptions_" . battleOption . "_" . targetSetting)
        }
        else {
            Gui, Add, Progress, % "xp-5 yp w300 h18 c0x66FF66 vbattleOptions_" . battleOption . "_" . targetSetting
            Gui Add, Text, % "xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left vbattleOptionsText_" . battleOption . "_" . targetSetting, % GetSettingDisplay("settings_battleOptions_" . battleOption . "_" . targetSetting)
        }
    }

    for i, battleOption in battleOptions {
        local targetSettings := "settings_battleOptions_" . battleOption
        local targetSetting := "skills"
        local settingUnderscore := targetSettings . "_" . targetSetting
        local settingInfo := GetSettingInfo(settingUnderscore)
        local opts := { offsetX : 120 }

        if (i == 1) {
            Gui, Add, Progress, % "xs+120 y+10 w300 h18 c0x66FF66 vbattleOptions_" . battleOption . "_" . targetSetting
            Gui Add, Text, % "xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left vbattleOptionsText_" . battleOption . "_" . targetSetting, % GetSettingDisplay("settings_battleOptions_" . battleOption . "_" . targetSetting)
        }
        else {
            Gui, Add, Progress, % "xp-5 yp w300 h18 c0x66FF66 vbattleOptions_" . battleOption . "_" . targetSetting
            Gui Add, Text, % "xp+5 wp hp r1 +0x4000 cBlack BackgroundTrans left vbattleOptionsText_" . battleOption . "_" . targetSetting, % GetSettingDisplay("settings_battleOptions_" . battleOption . "_" . targetSetting)
        }
    }
}

InitHandlersTree() {
    global guiHwnd, handlers, handlersTree
    
    if (guiHwnd) {
        Gui TreeView, handlersTree
        Traverse(handlers, { parentId : 0 }, { dataCallBack : Func("TreeAddDataCallback"), skipFields : ["Func"] } )
    }
}

InitPatternsTree(root := "", opts := "") {
    global guiHwnd, patterns, mode, patternsTree

    if (guiHwnd) {
        Gui TreeView, patternsTree
        root := (root ? root : patterns)
        opts := InitOps(opts, { startPath : "" })
        
        Traverse(root, { parentId : 0, path : opts.startPath }, { doDebug : opts.doDebug, dataCallBack : Func("TreeAddDataCallback")
            , callback : Func("TreeAddPatternsCallback"), skipFields : opts.skipFields } )
    }
}

TreeAddPatternsCallback(node, data, opts) {
    global metadata

    if (data.value && !IsObject(data.value)) {
        newPattern := RegExReplace(data.value, "<.*?>", "<" . data.path . ">")
        data.parent[data.key] := newPattern
    }

    ;initialize metadata
    segments := StrSplit(data.path, ".")
    target := metadata.userPatterns

    for k, v in segments {
        if (!v) {
            Continue
        }

        if (!target[v]) {
            target[v] := {}
            target[v].type := "Pattern"
        }
        target := target[v]
        if (IsArray(data.parent)) {
            target.isArrayItem := true
        }
    }
}

TreeAddDataCallback(node, data, opts) {
    if (!data.rootSkipped) {
        data.rootSkipped := true
        return data
    }

    id := TV_Add(data.key, data.parentId, "expand")
    data.parentId := id
    return data
}

OpenUserPattern() {
    global patterns, settings

    nodePath := GetNodePath()
    patternPath := StrReplace(nodePath, ".", "_")
    userPatternExists := false

    segments := StrSplit(nodePath, ".")
    target := patterns

    for k, v in segments {
        lastParent := target
        lastKey := v
        target := target[v]
    }
    
    if (target.userPattern) {
        userPatternExists := true
    }

    if (IsArray(lastParent)) {  ;child of an array
        patternPath := RegExReplace(patternPath, "_[^_]+?$", "")
    }
    
    if InStr(patternPath, "userPattern") {
        patternPath := RegExReplace(patternPath, "_userPattern.*?$", "")
        userPatternExists := true
    }

    if InStr(patternPath, "default") {
        patternPath := RegExReplace(patternPath, "_default.*?$", "")
        userPatternExists := true
    }

    if (userPatternExists || !IsObject(target) || IsArray(target)) {
        SettingsModal("settings_userPatterns_" . patternPath)
    }
    else {
        MsgBox, User Patterns are only supported for terminal nodes
    }
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

FilterPatterns() {
    global hwnd, patterns, patternsTree, patternFilter

    Gui Submit, NoHide
    Gui TreeView, patternsTree

    tempRoot := {}
    
    TV_Delete()
    for k, v in patterns {
        if InStr(k, patternFilter) {
            tempRoot[k] := v
        }
    }

    InitPatternsTree(tempRoot)
}

SelectBanners() {
    global metadata
    metadata.userPatterns.dimensionGate.events.banners.disableAdd := true
    SettingsModal("settings_userPatterns_dimensionGate_events_banners")
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
    Else If (control = "SettingsModal") {
        SettingsModal(StrReplace(A_GuiControl, "SettingsModal", "Settings"))
    }
    Else If (control = "BattleOptions") {
        context := segments.2
        setting := segments.3
        
        switch setting
        {
            Case "companions":
                targetSettings := "settings_userPatterns_companions_targets"
            Case "allyTarget":
                targetSettings := "settings_userPatterns_battle_target_ally"
            Case "skills":
                targetSettings := "settings_userPatterns_battle_skills"
        }

        SettingsModal(targetSettings, { setting : setting, battleContext : context })
    }
}

HandleAction(action, mode) {
    global settings
    
    SetStatus(action)
    SetStatus(mode , 2)
    SetStatus("" , 3)

    if (action = "Start") {
        if (A_IsCompiled) {
            Run, % "autoDisgaeaRpg.exe id=""" . settings.window.name . """ mode=" . mode
        }
        else {
            Run, % "autoDisgaeaRpg.ahk id=""" . settings.window.name . """ mode=" . mode
        }
    }
    else if (action = "Stop") {
        hwnd := GetHwnd(settings.window.name, mode)
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
