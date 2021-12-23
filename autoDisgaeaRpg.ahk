#SingleInstance, off
#Include common.ahk
#Include itemWorld.ahk
#Include events.ahk
#Include darkGate.ahk
#include ui.ahk

handlers := {}
handlers.EventStoryFarm := { Func : Func("EventStoryFarm") }
handlers.EventRaidLoop := { Func : Func("EventRaidLoop") }
handlers.EventStory500Pct := { Func : Func("EventStory500Pct") }
handlers.EventAutoClear := { Func : Func("EventAutoClear") }
handlers.DoDarkGateHL := { Func : Func("DoDarkGateHL") }
handlers.DoDarkGateMatsHuman := { Func : Func("DoDarkGateMatsHuman") }
handlers.DoDarkGateMatsMonster := { Func : Func("DoDarkGateMatsMonster") }
handlers.SwipeUp := { Func : Func("SwipeUp") }
handlers.SwipeDown := { Func : Func("SwipeDown") }
handlers.ScrollUp := { Func : Func("ScrollUp") }
handlers.ScrollDown := { Func : Func("ScrollDown") }
handlers.MiddleClickCallback := { Func : Func("MiddleClickCallback") }
handlers.GrindItemWorldLoop1 := { Func : Func("GrindItemWorldLoop1") }
handlers.GrindItemWorldSingle1 := { Func : Func("GrindItemWorldSingle1") }
handlers.GrindItemWorldLoop2 := { Func : Func("GrindItemWorldLoop2") }
handlers.GrindItemWorldSingle2 := { Func : Func("GrindItemWorldSingle2") }
handlers.AutoClear := { Func : Func("AutoClear") }
handlers.AutoShop := { Func : Func("AutoShop") }
handlers.AutoDarkAssembly := { Func : Func("AutoDarkAssembly") }

;A_Args.1 is the executable
;A_Args.2 is the mode (function to be called)

;This needs to be here for non UI mode
;TreeAdd(patterns, 0, { leafCallback : Func("InitPatternsCallback")})

InitPatternsTree()

;Traverse(patterns, {}, {})

mode := StrReplace(A_Args.2, "mode=")
msgToMode := { 0x1001 : "EventStoryFarm"static
             , 0x1002 : "EventStory500Pct"
             , 0x1003 : "EventRaidLoop"
             , 0x1004 : "AutoShop"
             , 0x1005 : "AutoDarkAssembly"
             , 0x1006 : "DoDarkGateHL"
             , 0x1007 : "DoDarkGateMatsHuman"
             , 0x1008 : "DoDarkGateMatsMonster"
             , 0x1009 : "AutoClear"
             , 0x1010 : "FarmItemWorldSingle"
             , 0x1011 : "EventAutoClear"
             , 0x1012 : "EventRaidAutoClaim"
             , 0x1013 : "EventRaidAutoVault"
             , 0x1014 : "GrindItemWorldLoop1"
             , 0x1015 : "GrindItemWorldSingle1"
             , 0x1016 : "GrindItemWorldLoop2"
             , 0x1017 : "GrindItemWorldSingle2" }
modeToMsg := {}

for k, v in msgToMode {
    modeToMsg[v] := k
    OnMessage(k, "OnCustomMessage")
}

if (mode) {
    windowTarget := StrReplace(A_Args.1, "id=")
    guiHwnd := GetGuiHwnd()
    InitBlueStacks()
    
    msg := modeToMsg[mode]
    if (!msg) {
        MsgBox, % "Unmapped message: " . msg
        ExitApp
    }
    ;Send a start message
    PostMessage, % msg, 1, 0, , % "ahk_id " . guiHwnd
    
    ;https://www.autohotkey.com/board/topic/21727-change-tooltip-on-trayicon-hover/
    Menu, Tray, Tip, % windowTarget . " - " . mode
    %mode%()
}
else {
    OnMessage(0x201,"WM_LBUTTONDOWN")

    ResetUI()

    WinSetTitle, % "ahk_id " . guiHwnd,, % settings.blueStacks.identifier
    ;WinSetTitle, % "ahk_id " . guiHwnd,, % guiHwnd
    Menu, Tray, Tip, % settings.blueStacks.identifier
}

Return

Battle() {
    SetStatus(A_ThisFunc)
    global settings, patterns, battleCount
    Gui Submit, NoHide
    
    battleOptions := settings["battleOptions"][settings.battleContext]
    battleOptions.Callback := func("BattleMiddleClickCallback")
    battleOptions.donePatterns := [patterns.raid.appear.advanceInStory]

    targetCompanion := []
    for k, v in battleOptions.companions
        targetCompanion.push(patterns["companions"][v])

    result := FindPattern([patterns.battle.auto.enabled, patterns.battle.auto.disabled]) 
    if (InStr(result.comment, "battle.auto")) {
        DoBattle(battleOptions)
        battleCount--
        GuiControl,,battleCount, % battleCount
    }

    SetStatus(battleCount, 2)

    while battleCount > 0 {
        PollPattern([patterns.battle.start, patterns.battle.prompt.battle], { variancePct: 5, callback : Func("BattleMiddleClickCallback") })
        result := PollPattern([patterns.battle.start, patterns.battle.prompt.battle], { variancePct: 5, doClick : true
            , predicatePattern : [patterns.battle.auto, patterns.companions.refresh, patterns.prompt.insufficientAP] })
        sleep 500
        
        if (HandleInsufficientAP()) {
            PollPattern([patterns.battle.start, patterns.battle.prompt.battle], { variancePct: 5, doClick : true }) 
        }

        if InStr(result.comment, "prompt.battle") {
            ;FindAndClickListTarget(targetCompanion, { predicatePattern : patterns.battle.auto })
            ScrollUntilDetect(targetCompanion, { predicatePattern : patterns.battle.auto })
            sleep 500
        }

        DoBattle(battleOptions)
        sleep 1000
        battleCount--
        GuiControl,,battleCount, % battleCount
    }

    MsgBox, Done
}

BattleMiddleClickCallback() {
    global patterns

    Click("x300 y150")

    result := FindPattern(patterns.raid.appear.advanceInStory)
    if (result.IsSuccess) {
        ClickResult(result)
    }

    Resize()
}

ScreenCap() {
    global hwnd
    Resize()
    sleep 500

    ; FindText().ScreenShot()
    ; FindText().SavePic("cap_" . A_Now . ".png")

    FindText().BindWindow(hwnd)>
    FindText().ScreenShot()
    FindText().SavePic("cap_mode_0.png")

    sleep 250

    FindText().BindWindow(hwnd,1)>
    FindText().ScreenShot()
    FindText().SavePic("cap_mode_1.png")

    sleep 250

    FindText().BindWindow(hwnd,2)>
    FindText().ScreenShot()
    FindText().SavePic("cap_mode_2.png")

    sleep 250

    FindText().BindWindow(hwnd,3)>
    FindText().ScreenShot()
    FindText().SavePic("cap_mode_3.png")

    sleep 250

    FindText().BindWindow(hwnd,4)>
    FindText().ScreenShot()
    FindText().SavePic("cap_mode_4.png")

    ; FindText().BindWindow(0)>
    ; FindText().ScreenShot()
    ; FindText().SavePic("cap_mode_none.png")

    ; sleep 250
}

AutoClear() {
    global patterns, settings
    SetStatus(A_ThisFunc)

    battleOptions := settings["battleOptions"][settings.battleContext]
    autoRefillAP.autoRefillAP := false
    battleOptions.donePatterns := [patterns.raid.appear.advanceInStory]
    battleOptions.startPatterns := [patterns.battle.start]

    targetCompanion := []
    for k, v in battleOptions.companions
        targetCompanion.push(patterns["companions"][v])

    loopTargets := [patterns.general.autoClear.new, patterns.companions.title, patterns.general.autoClear.skip, patterns.general.autoClear.areaClear, patterns.raid.appear.advanceInStory]
    Loop {
        result := PollPattern(loopTargets)

        if InStr(result.comment, "general.autoClear.new") || InStr(result.comment, "general.autoClear.skip") || InStr(result.comment, "general.autoClear.areaClear") {
            ClickResult(result)
            sleep, 50
            ClickResult(result)

            if InStr(result.comment, "general.autoClear.skip") {
                PollPattern(loopTargets)
            }
        }
        else if InStr(result.comment, "companions.title") {
            DoBattle(battleOptions)
            PollPattern(loopTargets, { clickPattern : patterns.battle.done, pollInterval : 250 })
        }
        else if InStr(result.comment, "raid.appear.advanceInStory") {
            ClickResult(result)
            sleep, 1000
        }
    }
}

AutoShop() {
    global patterns, mode
    
    done := false
    Loop {
        result := FindPattern([patterns.stronghold.gemsIcon, patterns.tabs.shop.items.tab, patterns.tabs.shop.items.hl.disabled, patterns.tabs.shop.items.hl.enabled])
        
        if InStr(result.comment, "stronghold.gemsIcon") {
            PollPattern(patterns.tabs.shop.tab, { doClick : true })
        } else if InStr(result.comment, "tabs.shop.items.tab") || InStr(result.comment, "tabs.shop.items.hl.disabled") {
            ClickResult(result)
        } else if InStr(result.comment, "tabs.shop.items.hl.enabled") {
            Loop {
                result := FindPattern(patterns.tabs.shop.items.blocks)

                if (result.IsSuccess) {
                    ClickResult(result)
                    PollPattern(patterns.slider.max, { doClick : true, variancePct : 1 })
                    PollPattern(patterns.prompt.yes, { doClick : true })
                    PollPattern(patterns.prompt.close, { doClick : true })
                    sleep, 1500
                }
            } until (!result.IsSuccess)

            done := true
        }

        sleep, 250
    } until (done)

    if (mode) {
        ExitApp
    }
}

AutoFriends() {
    global patterns
    
    done := false
    Loop {
        result := FindPattern([patterns.stronghold.gemsIcon, patterns.stronghold.friends.title])
        
        if InStr(result.comment, "stronghold.gemsIcon") {
            PollPattern(patterns.stronghold.friends.icon, { doClick : true })
        } else if InStr(result.comment, "stronghold.friends.title") {
            FindPattern(patterns.stronghold.friends.give, { doClick : true })
            sleep 500
            FindPattern(patterns.prompt.ok, { doClick : true })
            sleep 500
            FindPattern(patterns.stronghold.friends.claim, { doClick : true })
            sleep 500
            FindPattern(patterns.prompt.ok, { doClick : true })
            done := true
        }

        sleep, 250
    } until (done)

    MsgBox, Done
}

AutoDarkAssembly() {
    global patterns, settings, mode
    SetStatus(A_ThisFunc)

    crabMisoLimit := 2

    senators := ["x315 y210", "x215 y265", "x115 y296", "x428 y293", "x227 y387", "x74 y451", "x427 y405", "x176 y521"]

    ;crabMiso loop
    for k, v in senators {
        result := FindPattern(patterns.darkAssembly.viability)
        viability := StrReplace(result.comment, "darkAssembly.viability.")
        
        if (viability = "almostCertain") {
            Break
        }
        
        Click(v)
        sleep, 250
        Click(v)
        sleep, 250

        result := FindPattern(patterns.darkAssembly.affinity)
        affinity := StrReplace(result.comment, "darkAssembly.affinity.")

        ;MsgBox, % viability . "`n" . affinity
        if (affinity = "negative" && crabMisoLimit > 0) {
            FindPattern(patterns.darkAssembly.bribe.crabMiso, { doClick : true })
            crabMisoLimit--
        } 

        if (crabMisoLimit == 0) {
            Break
        }
        
        sleep, 250
    }

    ;goldenCandy loop
    for k, v in senators {
        result := FindPattern(patterns.darkAssembly.viability)
        viability := StrReplace(result.comment, "darkAssembly.viability.")
        
        if (viability = "almostCertain") {
            Break
        }
        
        Click(v)
        sleep, 250
        Click(v)
        sleep, 250

        result := FindPattern(patterns.darkAssembly.affinity)
        affinity := StrReplace(result.comment, "darkAssembly.affinity.")

        ;MsgBox, % viability . "`n" . affinity
        if (affinity != "feelingTheLove" && affinity != "prettyFavorable" && affinity != "favorable") {
            FindPattern(patterns.darkAssembly.bribe.goldenCandy, { doClick : true })
        } 

        sleep, 250
    }

    if (mode) {
        ExitApp
    }
}

Verify() {
    global hwnd

    WinGetPos,X,Y,W,H, % "ahk_id " . hwnd

    MsgBox, % "(Window) " . (hwnd ? "ATTACHED" : "DETACHED") . " => "  . (hwnd ? "GOOD" : "BAD") . "`n"
            . "(Window Size) " . W . "x" . H . " => " . (W = 600 && H = 1040 ? "GOOD" : "BAD (Target 600x1400)")
}

TestDrop() {
    MsgBox, % FindDrop().Type
}

Test() {
    ;global patterns, settings, hwnd, guiHwnd
    global
    SetStatus(A_ThisFunc)

    ; battleOptions := settings.battleOptions.default

    ; targetCompanions := []
    ; for k, v in battleOptions.companions
    ;     targetCompanions.push(patterns["companions"]["targets"][v])

    ; ScrollUntilDetect(targetCompanions)

    ; targetBattleContext := "default"
    ; display := GetSettingDisplay("settings_battleOptions_" . targetBattleContext . "_companions")
    ; GuiControl, %guiHwnd%:Text, battleOptionsText_default_companions, % display

    battleOption := "Default"
    MsgBox, % GetSettingDisplay("settings_battleOptions_" . battleOption . "_allyTarget")
}

CapitalizeFirstLetter(str) {
    Return RegExReplace(str, "^(.)", "$u1")
}

SettingsModal(targetSettings, opts := "")
{
    global

    opts := InitOps(opts, { })
    local settingMetaData := GetSettingMetaData(targetSettings)

    Gui, SettingsModal:Destroy
    Gui, SettingsModal:New,, % StrReplace(targetSettings, "_", ".")
    Gui, SettingsModal:Color, 404040
    Gui, SettingsModal:Font, s3
    Gui, SettingsModal:Add, Text, section
    Gui, SettingsModal:Font
    Gui, +AlwaysOnTop
    Gui, -SysMenu

    if (settingMetaData.displayOrder) {
        for i, v in settingMetaData.displayOrder
        {
            settingUnderscore := targetSettings . "_" . v
            local settingInfo := GetSettingInfo(settingUnderscore)
            AddSetting(settingInfo, "SettingsModal")
        }
    }
    else if (settingMetaData.type) {
        local settingInfo := GetSettingInfo(targetSettings)
        AddSetting(settingInfo, "SettingsModal", opts)
    } 
    else {
        for k, v in settingMetaData
        {
            settingUnderscore := targetSettings . "_" . k
            local settingInfo := GetSettingInfo(settingUnderscore)
            AddSetting(settingInfo, "SettingsModal")
        }
    }
    
    Gui, SettingsModal:Add, Button, gSettingsModalGuiClose, Done
    Gui, SettingsModal:Show
}

SettingPresetChanged() 
{
    global

    local settingUnderscore := RegExReplace(A_GuiControl, "_[^_]+?$", "")
    local targetValue := ""
    RegExMatch(A_GuiControl, "[^_]+?$", targetValue)

    local settingInfo := GetSettingInfo(settingUnderscore)

    for i, v in settingInfo.metaData.options {
        GuiControl,, % settingUnderscore . "_" . v, 0
    }

    for i, v in settingInfo.metaData.presets[targetValue] {
        GuiControl,, % settingUnderscore . "_" . v, 1
    }

    local value := []
    for i, opt in settingInfo.metaData.options {
        GuiControlGet, optChecked,, % settingUnderscore . "_" . opt
        if (optChecked)
        {
            value.Push(opt)
        }
    }
    settingInfo.setting[settingInfo.key] := value
    settings.Save(true)

    local parentSettingInfo := GetSettingInfo(settingInfo.parentPathUnderscore)
    GuiControl, %guiHwnd%:Text, % StrReplace(parentSettingInfo.pathUnderscore, "Settings", "SettingsText"), % GetSettingDisplay(parentSettingInfo)
}

SettingsModalGuiClose()
{
    Gui, SettingsModal:Destroy
}

GetSettingDisplay(settingInfo)
{
    if !IsObject(settingInfo) {
        settingInfo := GetSettingInfo(settingInfo)
    }

    display := ""

    for i, v in settingInfo.metaData.displayOrder
    {
        settingUnderscore := settingInfo.pathUnderscore . "_" . v
        
        childSettingInfo := GetSettingInfo(settingUnderscore)
        strValue := ""

        settingValue := childSettingInfo.setting[childSettingInfo.key]

        if IsArray(settingValue)
        {
            for i, opt in settingValue {
                strValue := strValue . "," . opt
            }
            strValue := childSettingInfo.key . ": " . SubStr(strValue, 2)
        }
        else {
            strValue := childSettingInfo.key . ": " . settingValue
        }
        
        display .= strValue . "; "
    }

    if (!display) {
        settingValue := settingInfo.setting[settingInfo.key]
        display .= settingInfo.key . " : "
        for k, v in settingValue {
            display .= v . "; "
        }
    }

    Return display
}

AddSetting(settingInfo, targetGui, opts := "") {
    global

    opts := InitOps(opts, { offsetX : 10 })
    local settingUnderscore := settingInfo.pathUnderScore

    switch (settingInfo.metaData.type)
    {
        case "Checkbox":
        {
            local targetKey := ""
            RegExMatch(settingUnderscore, "[^_]+?$", targetKey)
            local newRow := settingInfo.metaData.newLine
            local controlOpts := "cWhite gSettingChanged v" . settingUnderscore 
                . (newRow ? " xs+" . opts.offsetX . " y+5" : " x+10")
            if (settingInfo.metaData.optsOverride) {
                controlOpts := "cWhite gSettingChanged v" . settingUnderscore . " " . settingInfo.metaData.optsOverride
            }
            if (opts.optsOverride) {
                controlOpts := "cWhite gSettingChanged v" . settingUnderscore . " " . opts.optsOverride
            }
            Gui %targetGui%:Add, Checkbox, % controlOpts, % CapitalizeFirstLetter(targetKey)
            GuiControl,, % settingUnderscore, % settingInfo.setting[settingInfo.key] ? 1 : 0
        }
        case "Radio":
        {
            Gui,  %targetGui%:Add, Text, xs y+5 cWhite, % settingInfo.path

            for i, opt in settingInfo.metaData.options {
                local newRow := false
                if (i = 1 || Mod(i - 1, settingInfo.metaData.itemsPerRow) = 0) {
                    newRow := true
                }
                
                Gui %targetGui%:Add, Radio, % "cWhite gSettingChanged v" . settingUnderscore . "_" . opt
                    . (newRow ? " xs+10 y+5" : " x+10"), % opt
            }

            GuiControl,, % settingUnderscore . "_" . settingInfo.setting[settingInfo.key], 1

            Gui, %targetGui%:Add, Text, xs y+5 0x10 w400 cWhite
        }
        case "Array":
        {
            Gui, %targetGui%:Add, Text, xs y+5 cWhite, % settingInfo.path

            local index := 1
            for key, preset in settingInfo.metaData.presets {
                local newRow := false
                if (index = 1) {
                    newRow := true
                }
                Gui %targetGui%:Add, Radio, % "cWhite gSettingPresetChanged v" . settingUnderscore . "_" . key
                    . (newRow ? " xs y+5" : " x+10"), % key
                index++
            }

            for i, opt in settingInfo.metaData.options {
                local newRow := false
                if (i = 1 || Mod(i - 1, settingInfo.metaData.itemsPerRow) = 0) {
                    newRow := true
                }
                
                Gui %targetGui%:Add, Checkbox, % "cWhite gSettingChanged v" . settingUnderscore . "_" . opt
                    . (newRow ? " xs y+5" : " x+10"), % opt
            }

            for i, v in settingInfo.setting[settingInfo.key] {
                GuiControl,, % settingUnderscore . "_" . v, 1
            }

            Gui, %targetGui%:Add, Text, xs y+5 0x10 w400 cWhite
        }
        case "Pattern":
        {
            for k, v in settingInfo.metaData {
                if (k = "type" || k = "isArrayItem") {
                    Continue
                }

                if (!settingInfo.setting[settingInfo.key]) {
                    settingInfo.setting[settingInfo.key] := {}
                }

                if (k != "default" && k != "userPattern" && !settingInfo.setting[settingInfo.key][k]) {
                    settingInfo.setting[settingInfo.key][k] := {}
                }
            }

            Gui, %targetGui%:Add, Text, xs y+5 cWhite, % settingInfo.path
            Gui, %targetGui%:Add, TreeView, % (settingInfo.metaData.checked ? "checked " : "" ) . "xs+10 y+5 h300 cBlack AltSubmit gSelectPatternSetting vPatternSettingSelect_" 
                . settingUnderscore . (opts.battleContext ? "_battleContext_" . opts.battleContext . "_" . opts.setting : "")

            if (!settingInfo.metaData.disableAdd) {
                Gui, %targetGui%:Add, Text, x+10 ys+30 cWhite, Key: 
                Gui, %targetGui%:Add, Edit, % "x+10 w100 vPatternSettingKey_" . settingUnderscore, Key
                Gui, %targetGui%:Add, Button, % "gAddPatternSetting vPatternSettingAdd_" . settingUnderscore, Add
                Gui, %targetGui%:Add, Button, % "gDeletePatternSetting vPatternSettingDelete_" . settingUnderscore, Delete
            }

            if (settingInfo.metaData.props) {
                for k, v in settingInfo.metaData.props {
                    if (v.type = "Checkbox") {
                        Gui, %targetGui%:Add, Checkbox, % "cWhite gCheckedChangedPatternSettingProp vPatternSettingCheckBoxProp_"
                            . settingUnderscore . "_" . k, % k
                    }
                    else if (v.type = "Dropdown") {
                        Gui, %targetGui%:Add, Text, cWhite, % k . ": "
                        Gui, %targetGui%:Add, DropDownList, % "cWhite gDropDownChangedPatternSettingProp vPatternSettingDropDownProp_"
                            . settingUnderscore . "_" . k, % v.options
                    }
                }
            }
           
            Gui, %targetGui%:Add, Edit, % "xs+10 ys+330 cBlack w400 vPatternSettingValue_" . settingUnderscore

            Gui, %targetGui%:Font, cBlack
            Gui, %targetGui%:Font, s3
            Gui, %targetGui%:Add, Edit, % "xs+10 y+5 cBlack w400 r20 vPatternSettingPreview_" . settingUnderscore
            Gui, %targetGui%:Font
            Gui, %targetGui%:Add, Button, % "gPickPatternSettingColor vPatternSettingColorPick_" . settingUnderscore, Pick Color
            Gui, %targetGui%:Add, Edit, % "cBlack x+5 w100 vPatternSettingColor_" . settingUnderscore,
            Gui, %targetGui%:Add, Text, cWhite x+5, Variance: 
            Gui, %targetGui%:Add, Edit, % "cBlack x+5 w30 cBlack vPatternSettingColorVariance_" . settingUnderscore, 10
            Gui, %targetGui%:Add, Button, % "x+5 gApplyPatternSettingColor vPatternSettingColorApply_" . settingUnderscore, DoColorPattern
            Gui, %targetGui%:Add, Text, cWhite xs+10 y+5, Gray Diff: 
            Gui, %targetGui%:Add, Edit, % "cBlack x+5 w100 cBlack vPatternSettingGrayDiff_" . settingUnderscore, 50
            Gui, %targetGui%:Add, Button, % "x+5 gApplyPatternSettingGrayDiff vPatternSettingGrayDiffApply_" . settingUnderscore, DoGrayPattern
            Gui Add, Text, cWhite xs+10 y+10, FG Variance:
            Gui Add, Slider, % "w200 tickinterval5 tooltip vPatternSettingTestVariance_" . settingUnderscore
            Gui Add, Checkbox, % "cWhite xs+10 y+5 vPatternSettingTestMulti_" . settingUnderscore, Multi
            Gui Add, Button, % "xs+10 y+5 gTestPatternSetting vPatternSettingTest_" . settingUnderscore, Test

            InitPatternSettingTreeView(settingUnderscore, opts)
            ; if (!settingInfo.metaData.isArrayItem || settingInfo.setting[settingInfo.key].isLeaf) {
            ;     InitPatternSettingTreeView(settingUnderscore)
            ; }
        }
    }
}

DropDownChangedPatternSettingProp() {
    global settings

    GuiControlGet, state,, % A_GuiControl
    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingDropDownProp_", "")
    settingUnderscore := RegExReplace(settingUnderscore, "_[^_]+?$", "")
    targetProp := ""
    RegExMatch(A_GuiControl, "[^_]+?$", targetProp)

    settingInfo := GetSettingInfo(settingUnderscore)
    patternObject := settingInfo.setting[settingInfo.key]

    selectedItem := TV_GetSelection()
    parentId := TV_GetParent(selectedItem)
    
    if (parentId = "0") {
        TV_GetText(targetKey, selectedItem)

        if (!IsObject(patternObject[targetKey]))
        {
            patternObject[targetKey] := { 1 : patternObject[targetKey] }
            reset := true
        }

        patternObject[targetKey][targetProp] := state
        settings.save(true)

        if (reset) {
            InitPatternSettingTreeView(settingUnderscore)
        }
    }
    else {
        MsgBox, 262144, Warning, Setting only valid for top level items
    }
}

CheckedChangedPatternSettingProp() {
    global settings

    GuiControlGet, state,, % A_GuiControl
    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingCheckBoxProp_", "")
    settingUnderscore := RegExReplace(settingUnderscore, "_[^_]+?$", "")
    targetProp := ""
    RegExMatch(A_GuiControl, "[^_]+?$", targetProp)

    settingInfo := GetSettingInfo(settingUnderscore)
    patternObject := settingInfo.setting[settingInfo.key]

    selectedItem := TV_GetSelection()
    parentId := TV_GetParent(selectedItem)
    
    if (parentId = "0") {
        TV_GetText(targetKey, selectedItem)

        if (!IsObject(patternObject[targetKey]))
        {
            patternObject[targetKey] := { 1 : patternObject[targetKey] }
            reset := true
        }

        patternObject[targetKey][targetProp] := state
        settings.save(true)

        if (reset) {
            InitPatternSettingTreeView(settingUnderscore)
        }
    }
    else {
        MsgBox, 262144, Warning, Setting only valid for top level items
    }
}

TestPatternSetting() {
    global hwnd, settings

    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingTest_", "")
    settingInfo := GetSettingInfo(settingUnderscore)
    GuiControlGet, pattern,, % "PatternSettingValue_" . settingUnderscore
    GuiControlGet, patternVariance,, % "PatternSettingTestVariance_" . settingUnderscore
    GuiControlGet, patternTestMulti,, % "PatternSettingTestMulti_" . settingUnderscore

    opts := { multi : patternTestMulti, fgVariancePct : patternVariance, bgVariancePct : patternVariance }
    result := FindPattern(pattern, opts)

    if (result.IsSuccess) {
        ToolTipExpire("Pattern " . settingUnderscore . " FOUND " . result.multi.Length())
        if (testPatternMulti) {
            for k, v in result.multi {
                FindText().ClientToScreen(x, y, v.X, v.Y, hwnd)
                FindText().MouseTip(x, y)
            }
        }
        Else {
            ToolTipExpire("Pattern " . settingUnderscore . " FOUND")
            FindText().ClientToScreen(x, y, result.X, result.Y, hwnd)
            FindText().MouseTip(x, y)
        }
    }
    Else {
        ToolTipExpire("Pattern " . settingUnderscore . " NOT FOUND")
    }
}

ApplyPatternSettingColor() {
    global settings

    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingColorApply_", "")
    settingInfo := GetSettingInfo(settingUnderscore)
    GuiControlGet, patternColorPick,, % "PatternSettingColor_" . settingUnderscore
    GuiControlGet, patternColorVariance,, % "PatternSettingColorVariance_" . settingUnderscore

    nodePath := GetNodePath()
    pattern := RegExReplace(pattern, "<.*?>", "<" . StrReplace(settingUnderscore, "_", ".") . "." . nodePath . ">")

    if (!pattern) {
        Return
    }

    ascii := FindText().ASCII(pattern)

    segments := StrSplit(nodePath, ".")
    target := settingInfo.setting[settingInfo.key]
    for k, v in segments {
        lastParent := target
        lastKey := v
        target := target[v]
    }

    lastParent[lastKey] := pattern
    settings.save(true)

    GuiControl,, % "PatternSettingValue_" . settingUnderscore, % pattern
    If InStr(pattern, "|<") {
        ascii := FindText().ASCII(pattern)
        GuiControl,, % "PatternSettingPreview_" . settingUnderscore, % Trim(ascii,"`n")
    }

    InitUserPatterns(settings.userPatterns)

    Gui 1:Default
    TV_Delete()
    InitPatternsTree()
}

PickPatternSettingColor() {
    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingColorPick_", "")
    color := GetPixelColor()
    GuiControl,, % "PatternSettingColor_" . settingUnderscore, % color
}

ApplyPatternSettingGrayDiff() {
    global settings, patterns, patternsTree
    
    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingGrayDiffApply_", "")
    settingInfo := GetSettingInfo(settingUnderscore)
    GuiControlGet, grayDiff,, % "PatternSettingGrayDiff_" . settingUnderscore
    pattern := GetPatternGrayDiff(grayDiff)

    if (!pattern) {
        Return
    }

    nodePath := GetNodePath()
    pattern := RegExReplace(pattern, "<.*?>", "<" . StrReplace(settingUnderscore, "_", ".") . "." . nodePath . ">")

    ascii := FindText().ASCII(pattern)

    segments := StrSplit(nodePath, ".")
    target := settingInfo.setting[settingInfo.key]
    for k, v in segments {
        lastParent := target
        lastKey := v
        target := target[v]
    }
    
    lastParent[lastKey] := pattern

    ;userPattern and default happens in InitUserPatterns; Can't figure out how to prevent it. Don't know how to deep clone
    lastParent.Delete("userPattern")
    lastParent.Delete("default")
    settings.save(true)

    GuiControl,, % "PatternSettingValue_" . settingUnderscore, % pattern
    If InStr(pattern, "|<") {
        ascii := FindText().ASCII(pattern)
        GuiControl,, % "PatternSettingPreview_" . settingUnderscore, % Trim(ascii,"`n")
    }

    InitUserPatterns(settings.userPatterns)

    Gui 1:Default
    TV_Delete()
    InitPatternsTree()
}

InitPatternSettingTreeView(settingUnderScore, opts := "") {
    global settings
    opts := InitOps(opts, { })

    TV_Delete()
    settingInfo := GetSettingInfo(settingUnderscore)
    if (!settingInfo.setting[settingInfo.key]) {
        settingInfo.setting[settingInfo.key] := {}
    }
    InitPatternsTree(settingInfo.setting[settingInfo.key], { startPath : StrReplace(settingUnderScore, "_", "."), skipFields : ["disableAdd", "isLeaf", "checked", "props", "singleTarget", "priority"]})

    if (opts.battleContext) {
        battleContext := opts.battleContext
        setting := opts.setting

        value := settings["battleOptions"][battleContext][setting]
        strValue := ","
        for k, v in value {
            strValue .= v . ","
        }

        item := TV_GetNext(0, "Full")

        while (item) {
            TV_GetText(name, item)
            parentId := TV_GetParent(item)

            if (parentId = "0" && InStr(strValue, "," . name . ",")) {
                TV_Modify(item, "Check")
            }
            item := TV_GetNext(item, "Full")
        }
    }
}

SelectPatternSetting() {
    global settings, guiHwnd

    RegExMatch(A_GuiControl, "(?P<control>.*?)_(?P<battleContext>battleContext.*?)$", battleContextMatch)   ;https://www.autohotkey.com/docs/commands/RegExMatch.htm#NamedSubPat
    guiControl := (battleContextMatch ? battleContextMatchControl : A_GuiControl)

    if (battleContextMatch) {
        parts := StrSplit(battleContextMatchBattleContext, "_")
        battleContext := parts.2
        setting := parts.3

        if (A_GuiEvent = "Normal") {
            items := []
            checkedItem := TV_GetNext(0, "Checked")
            while (checkedItem) {
                TV_GetText(name, checkedItem)
                parentId := TV_GetParent(checkedItem)

                if (parentId = "0") {
                    items.Push(name)
                }
                checkedItem := TV_GetNext(checkedItem, "Checked")
            }

            settings["battleOptions"][battleContext][setting] := items
            settings.save(true)

            GuiControl, %guiHwnd%:Text, % "battleOptionsText_" . battleContext . "_" . setting, % GetSettingDisplay("settings_battleOptions_" . battleContext . "_" . setting)
        }

        if (setting = "skills") {
            selectedItem := TV_GetSelection()
            TV_GetText(targetKey, selectedItem)
            parentId := TV_GetParent(selectedItem)

            if (!parentId) {
                GuiControl, Enable, PatternSettingCheckBoxProp_settings_userPatterns_battle_skills_singleTarget
                GuiControl, Enable, PatternSettingDropDownProp_settings_userPatterns_battle_skills_priority

                singleTarget := settings["userPatterns"]["battle"]["skills"][targetKey]["singleTarget"]
                GuiControl,, PatternSettingCheckBoxProp_settings_userPatterns_battle_skills_singleTarget, % (singleTarget ? 1 : 0)
                priority := settings["userPatterns"]["battle"]["skills"][targetKey]["priority"]
                if (!priority) {
                    priority := "Normal"
                }
                GuiControl, ChooseString, PatternSettingDropDownProp_settings_userPatterns_battle_skills_priority, % priority
            }
            else {
                GuiControl, Disable, PatternSettingCheckBoxProp_settings_userPatterns_battle_skills_singleTarget
                GuiControl, Disable, PatternSettingDropDownProp_settings_userPatterns_battle_skills_priority
            }
        }
    }

    settingUnderscore := StrReplace(guiControl, "PatternSettingSelect_", "")
    settingInfo := GetSettingInfo(settingUnderscore)

    nodePath := GetNodePath()
    segments := StrSplit(nodePath, ".")
    target := settingInfo.setting[settingInfo.key]

    for k, v in segments
        target := target[v]

    GuiControl,, % "PatternSettingValue_" . settingUnderscore, % target
    If InStr(target, "|<") {
        ascii := FindText().ASCII(target)
        GuiControl,, % "PatternSettingPreview_" . settingUnderscore, % Trim(ascii,"`n")
    }
}

AddPatternSetting() {
    global settings, patterns

    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingAdd_", "")
    GuiControlGet, key,, % "PatternSettingKey_" . settingUnderscore
    settingInfo := GetSettingInfo(settingUnderscore)
    patternObject := settingInfo.setting[settingInfo.key]
    
    if (!patternObject || IsArray(patternObject)) {
        settingInfo.setting[settingInfo.key] := {}
        patternObject := settingInfo.setting[settingInfo.key]
    }
    
    patternObject[key] := "Placeholder"
    patternObject.Delete("userPattern")
    patternObject.Delete("default")

    settings.save(true)
    InitPatternSettingTreeView(settingUnderScore)

    Gui 1:Default
    TV_Delete()
    InitPatternsTree()
}

DeletePatternSetting() {
    global settings, patterns

    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingDelete_", "")
    settingInfo := GetSettingInfo(settingUnderscore)
    patternObject := settingInfo.setting[settingInfo.key]
    
    if (!patternObject || IsArray(patternObject)) {
        settingInfo.setting[settingInfo.key] := {}
        patternObject := settingInfo.setting[settingInfo.key]
    }
    
    selectedId := TV_GetSelection()
    TV_GetText(key, selectedId)
    patternObject.Delete(key)

    settings.save(true)
    InitPatternSettingTreeView(settingUnderScore)

    Gui 1:Default
    TV_Delete()
    InitPatternsTree()
}

SettingChanged()
{
    global

    local settingUnderscore := RegExReplace(A_GuiControl, "_[^_]+?$", "")
    local targetValue := ""
    RegExMatch(A_GuiControl, "[^_]+?$", targetValue)

    local settingInfo := GetSettingInfo(settingUnderscore)
    
    if (!settingInfo.metaData.type) {
        local settingInfo := GetSettingInfo(A_GuiControl)
    }

    switch (settingInfo.metaData.type)
    {
        case "Checkbox":
        {
            GuiControlGet, boolVal, , % A_GuiControl
            settingInfo.setting[settingInfo.key] := boolVal
            settings.Save(true)
        }
        case "Radio":
        {
            settingInfo.setting[settingInfo.key] := targetValue
            settings.Save(true)
        }
        case "Array":
        {
            local value := []
            strValue := ""
            for i, opt in settingInfo.metaData.options {
                GuiControlGet, optChecked,, % settingUnderscore . "_" . opt
                if (optChecked)
                {
                    value.Push(opt)
                    strValue := strValue . "," . opt
                }
            }
            strValue := SubStr(strValue, 2)
            settingInfo.setting[settingInfo.key] := value
            settings.Save(true)
        }
    }

    local parentSettingInfo := GetSettingInfo(settingInfo.parentPathUnderscore)
    local targetControl := StrReplace(parentSettingInfo.pathUnderscore, "Settings", "SettingsText")
    GuiControl, %guiHwnd%:Text, % StrReplace(parentSettingInfo.pathUnderscore, "Settings", "SettingsText"), % GetSettingDisplay(parentSettingInfo)
}

GetSettingMetaData(settingUnderscore)
{
    global metadata

    path := StrReplace(settingUnderscore, "_", ".")
    segments := StrSplit(settingUnderscore, "_")
    numSegments := segments.Length()
    settingMetaData := metadata
    targetKey := segments[numSegments]

    Loop, % numSegments - 1
    {
        if (A_Index = 1) {  ;first segment is settings
            Continue
        }

        key := segments[A_Index]
        settingMetaData := settingMetaData[key]
    }

    settingMetaData := settingMetaData[targetKey]

    Return settingMetaData
}

GetSettingInfo(settingUnderscore) {
    global settings, metadata

    path := StrReplace(settingUnderscore, "_", ".")
    parentPath := RegExReplace(path, "\.[^\.]+?$", "")
    parentPathUnderScore := StrReplace(parentPath, ".", "_")
    segments := StrSplit(settingUnderscore, "_")
    numSegments := segments.Length()
    targetSetting := settings
    settingMetaData := metadata
    targetKey := segments[numSegments]

    Loop, % numSegments - 1
    {
        if (A_Index = 1) {  ;first segment is settings
            Continue
        }

        key := segments[A_Index]
        if (!targetSetting[key])
        {
            targetSetting[key] := {}
        }

        targetSetting := targetSetting[key]
        settingMetaData := settingMetaData[key]
    }

    ;parentMetaData := settingMetaData
    ; if (IsObject(settingMetaData[targetKey])) {
    ;     settingMetaData := settingMetaData[targetKey]
    ; }

    settingMetaData := settingMetaData[targetKey]

    ; if (settingMetaData.type = "Pattern" && !targetSetting[key])
    ; {
    ;     targetSetting[key] := []
    ; }

    Return { setting : targetSetting, metaData : settingMetaData, key : targetKey, path : path, pathUnderScore : settingUnderscore, parentPath : parentPath, parentPathUnderScore : parentPathUnderScore }
}

Recover(mode) {
    global patterns

    Resize()
    result := FindPattern(patterns.homeScreen.playStore)
    
    doRecover := false
    doClickDisgaeaIcon := false

    if (result.IsSuccess && mode = "FarmItemWorldSingle") {
        AddLog("Recover")
        HandleAction("Stop", mode)
        PollPattern([patterns.homeScreen.disgaea], { doClick : true, predicatePattern : patterns.criware, pollInterval : 1000 })
        PollPattern([patterns.criware], { doClick : true, predicatePattern : patterns.prompt.unfinishedBattle, pollInterval : 1000 })
        PollPattern(patterns.prompt.unfinishedBattle, { doClick : true, predicatePattern : patterns.prompt.resume})
        PollPattern(patterns.prompt.resume, { doClick : true, predicatePattern : patterns.battle.auto})
        Resize()
        HandleAction("Start", mode)
        Return
    }

    if (result.IsSuccess) {
        if(FindPattern([patterns.homeScreen.disgaea]).IsSuccess)
        {
            doRecover := true
            doClickDisgaeaIcon := true
        }
    }

    result := FindPattern(patterns.prompt.corner)

    if (result.IsSuccess)
    {
        result := FindPattern(patterns.prompt.dateHasChanged)
        if (result.IsSuccess) {
            FindPattern(patterns.prompt.ok, { doClick : true, predicatePattern : patterns.criware })
            doRecover := true
        }

        result := FindPattern(patterns.prompt.communicationError)
        if (result.IsSuccess) {
            FindPattern(patterns.prompt.ok, { doClick : true})
        }
    }

    if (doRecover) {
        AddLog("Recover")
        HandleAction("Stop", mode)
        if (doClickDisgaeaIcon) {
            PollPattern([patterns.homeScreen.disgaea], { doClick : true, predicatePattern : patterns.criware, pollInterval : 1000 })
        }
        PollPattern([patterns.criware], { doClick : true, predicatePattern : patterns.stronghold.gemsIcon, pollInterval : 1000, callback : Func("RecoverCallback") })
        Resize()
        HandleAction("Start", mode)
    }
}

RecoverCallback() {
    global patterns

    Resize()
    result := FindPattern(patterns.prompt.unfinishedBattle)
    if (result.IsSuccess) {
        PollPattern(patterns.prompt.no, { doClick : true })
    }

    FindPattern(patterns.prompt.close, { doClick : true })

    Click("x500 y300")
}

TestHandler() {
    global handlers, HandlersTree
    ;Gui Submit, NoHide

    Gui TreeView, HandlersTree
    nodePath := GetNodePath()
    segments := StrSplit(nodePath, ".")
    target := handlers

    for k, v in segments {
        lastParent := target
        lastKey := v
        target := target[v]
    }

    node := lastParent[lastKey]
    handler := node.Func
    %handler%(node.Arg1, node.Arg2, node.Arg3)
}

TestPattern() { 
    global hwnd, patterns, PatternsTree, testPatternMulti, testPatternFG, testPatternBG

    Gui Submit, NoHide
    Gui TreeView, PatternsTree
    nodePath := GetNodePath()
    segments := StrSplit(nodePath, ".")
    target := patterns

    for k, v in segments
        target := target[v]

    opts := { multi : testPatternMulti, fgVariancePct : testPatternFG, bgVariancePct : testPatternBG }
    result := FindPattern(target, opts)

    if (result.IsSuccess) {
        ToolTipExpire("Pattern " . nodePath . " FOUND " . result.multi.Length())
        if (testPatternMulti) {
            for k, v in result.multi {
                FindText().ClientToScreen(x, y, v.X, v.Y, hwnd)
                FindText().MouseTip(x, y)
            }
        }
        Else {
            ToolTipExpire("Pattern " . nodePath . " FOUND")
            FindText().ClientToScreen(x, y, result.X, result.Y, hwnd)
            FindText().MouseTip(x, y)
        }
    }
    Else {
        ToolTipExpire("Pattern " . nodePath . " NOT FOUND")
    }
}

PatternsSelect() {
    ;https://www.autohotkey.com/docs/commands/TreeView.htm
    if (A_GuiEvent != "S")  ; i.e. an event other than "select new tree item".
        return  ; Do nothing.

    global hwnd, patterns, patternsTree

    Gui Submit, NoHide
    Gui TreeView, patternsTree
    nodePath := GetNodePath()
    segments := StrSplit(nodePath, ".")
    target := patterns

    for k, v in segments
        target := target[v]
    
    
    If InStr(target, "|<") {
        ascii := FindText().ASCII(target)
        GuiControl,, patternsPreview, % Trim(ascii,"`n")
    }
}