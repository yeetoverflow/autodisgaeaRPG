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
handlers.DoDarkGateHL := { Func : Func("DoDarkGateHL") }
handlers.DoDarkGateMatsHuman := { Func : Func("DoDarkGateMatsHuman") }
handlers.DoDarkGateMatsMonster := { Func : Func("DoDarkGateMatsMonster") }
handlers.SwipeUp := { Func : Func("SwipeUp") }
handlers.SwipeDown := { Func : Func("SwipeDown") }
handlers.DoItemWorldLoop := { Func : Func("DoItemWorldLoop") }
handlers.DoItemWorldFarmLoop := { Func : Func("DoItemWorldFarmLoop") }
handlers.MiddleClickCallback := { Func : Func("MiddleClickCallback") }

;A_Args.1 is the executable
;A_Args.2 is the mode (function to be called)

TreeAdd(patterns, 0, { leafCallback : Func("InitPatterns")})

mode := StrReplace(A_Args.2, "mode=")
; mode := StrReplace(mode, "`n")
; mode := StrReplace(mode, "`r")

msgToMode := { 0x1001 : "EventStoryFarm"
             , 0x1002 : "EventStory500Pct"
             , 0x1003 : "EventRaidLoop"
             , 0x1004 : "DoItemWorldLoop"
             , 0x1005 : "DoItemWorldFarmLoop"
             , 0x1006 : "DoDarkGateHL"
             , 0x1007 : "DoDarkGateMatsHuman"
             , 0x1008 : "DoDarkGateMatsMonster"}
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
        targetCompanion.push(patterns.companions[v])

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
            FindAndClickListTarget(targetCompanion, { predicatePattern : patterns.battle.auto })
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
    Resize()
    sleep 500
    FindText().ScreenShot()
    FindText().SavePic("cap_" . A_Now . ".png")
}

AutoClear() {
    global patterns, settings
    SetStatus(A_ThisFunc)

    battleOptions := settings["battleOptions"][settings.battleContext]
    battleOptions.Callback := func("BattleMiddleClickCallback")
    battleOptions.donePatterns := [patterns.raid.appear.advanceInStory]

    targetCompanion := []
    for k, v in battleOptions.companions
        targetCompanion.push(patterns.companions[v])


    loopTargets := [patterns.new, patterns.companions.title, patterns.skip, patterns.areaClear]
    Loop {
        result := PollPattern(loopTargets)

        if InStr(result.comment, "new") || InStr(result.comment, "skip") || InStr(result.comment, "areaClear") {
            ClickResult(result)
            sleep, 50
            ClickResult(result)

            if InStr(result.comment, "skip") {
                PollPattern(loopTargets, { callback : Func("MiddleClickCallback") })
            }
        }
        else if InStr(result.comment, "companions.title") {
            FindAndClickListTarget(targetCompanion, { predicatePattern : patterns.battle.start })
            sleep 500
            PollPattern([patterns.battle.start], { doClick : true, variancePct: 5, callback : Func("BattleMiddleClickCallback") })
            DoBattle(battleOptions)
            PollPattern(loopTargets, { callback : Func("MiddleClickCallback") })
        }
    }
}

AutoShop() {
    global patterns
    
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

    MsgBox, Done
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
    global patterns, settings
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

    MsgBox, Done
    
}

Test() {
    global patterns, settings, hwndMainGui, guiHwnd
    SetStatus(A_ThisFunc)

    Resize(true)
    ;https://docs.microsoft.com/en-us/windows/win32/wmisdk/like-operator
    ; query := "Select * from Win32_Process where CommandLine like '%" . StrReplace(A_ScriptFullPath, "\", "\\") . "%'" . " and not CommandLine like '%code%'"
    ; queryEnum := ComObjGet("winmgmts:").ExecQuery(query)._NewEnum()
    ; queryEnum[proc]

    ; ;https://www.autohotkey.com/board/topic/20850-retrieve-win-ids-of-all-associated-windows-and-child-windows/
    ; WinGet, windowList, List, % "ahk_pid" . proc.ProcessId
    ; ;WinGet, hwndWindow, ID, % "ahk_pid" . proc.ProcessId

    ; Loop, % windowList
    ; {
    ;     WinGetClass, windowClass, % "ahk_id " windowList%A_Index%
    ;     if (windowClass = "AutoHotkeyGUI") {
    ;         ControlSetText, msctls_statusbar321, "whoa",  % "ahk_id " windowList%A_Index%
    ;         Break
    ;     }
    ; }


    ; for process in ComObjGet("winmgmts:").ExecQuery(query) {
    ;     regex := "^.*""(?P<targetWindow>.*?)\"" (?P<mode>.*?)$"
    ;     RegExMatch(process.CommandLine, regex, matches)
    ;     MsgBox, % process.CommandLine . " | " . process.ProcessId
    ; }

    ;Just opens raid vault in a loop
    ; Loop {
    ;     FindPattern(patterns.events.vault.acquired, { variancePct : 15, doClick : true, predicatePattern : patterns.prompt.close })
    ;     FindPattern(patterns.prompt.close, { variancePct : 15, doClick : true, predicatePattern : patterns.events.vault.acquired })
    ; }
    
    ;result := FindDrop()
}

Recover(mode) {
    global patterns

    Resize()
    result := FindPattern([patterns.homeScreen.disgaea, patterns.homeScreen.disgaea7ds])
    
    doRecover := false
    doClickDisgaeaIcon := false

    if (result.IsSuccess) {
        doRecover := true
        doClickDisgaeaIcon := true
    }

    result := FindPattern(patterns.prompt.dateHasChanged)
    if (result.IsSuccess) {
        FindPattern(patterns.prompt.ok, { doClick : true})
        doRecover := true
    }

    result := FindPattern(patterns.prompt.communicationError)
    if (result.IsSuccess) {
        FindPattern(patterns.prompt.ok, { doClick : true})
    }

    if (doRecover) {
        AddLog("Recover")
        HandleAction("Stop", mode)
        if (doClickDisgaeaIcon) {
            PollPattern([patterns.homeScreen.disgaea, patterns.homeScreen.disgaea7ds], { doClick : true, predicatePattern : patterns.criware, pollInterval : 1000 })
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
