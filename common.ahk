
#Include <FindText>
#Include <Utils>
#Include <Json>

SetControlDelay, 0
DetectHiddenWindows, On
SetTitleMatchMode, 3

InitWindow()
{
    global
    ;WinGet, hwnd, ID, % settings.blueStacks.identifier . " ahk_exe HD-Player.exe"
    ;WinGet, hwnd, ID, % "ahk_class Qt5QWindowIcon"

    switch (settings.window.emulator) {
        case "nox":
            ;hwnd := DllCall("user32\FindWindow", "Str","Qt5QWindowIcon", "Str", settings.window.name, "Ptr")
            WinGet, hwnd, ID, % settings.window.name . " ahk_exe Nox.exe"
        case "testPaintBs":
            SetTitleMatchMode, 2
            WinGet, hwnd, ID, Paint
            SetTitleMatchMode, 3
        case "testPaintNox":
            SetTitleMatchMode, 2
            WinGet, hwnd, ID, Paint
            SetTitleMatchMode, 3
        default:
            WinGet, hwnd, ID, % settings.window.name . " ahk_exe HD-Player.exe"
    }

    patterns := InitPatterns()
    InitPatternsTree()
    
    ;SetTitleMatchMode, 2
    ;WinGet, hwnd, ID,Photos

    WinActivate, % ahk_id hwnd
    FindText().BindWindow(hwnd, (settings.window.scanMode ? settings.window.scanMode : 4))>
    
    Resize()

    ; cmdLine := GetCommandLine(hwnd)
    ; RegExMatch(cmdLine, "--instance (?P<instance>.*?) ", matches)
    ; RegExMatch(matchesInstance, "_(?P<instanceNum>.*)", matches)

    ; if (!matchesInstanceNum) {
    ;     matchesInstanceNum := 0
    ; }

    ; ;https://developer.android.com/studio/command-line/adb
    ; blueStacksInstanceNumber := 5555 + matchesInstanceNum * 10

    ; if (settings.blueStacks.portOverride) {
    ;     port := settings.blueStacks.portOverride
    ;     run, hd-adb.exe connect 127.0.0.1:%port% , % settings.blueStacks.installationPath, Hide
    ; }
    ; else {
    ;     run, hd-adb.exe connect 127.0.0.1:%blueStacksInstanceNumber% , % settings.blueStacks.installationPath, Hide
    ; }

    if (hwnd) {
        GuiControl, +cGreen, attached
        GuiControl, +cGreen, attached2
        GuiControl,, attached, ATTACHED
        GuiControl,, attached2, ATTACHED
    }
    else {
        GuiControl, +cRed, attached
        GuiControl, +cRed, attached2
        GuiControl,, attached, DETACHED
        GuiControl,, attached2, DETACHED
    }

    WinSetTitle, % "ahk_id " . guiHwnd,, % settings.window.name
    Menu, Tray, Tip, % settings.window.name
}

InitPatternsCallback(key, value, parent, path) {
    global metadata
    newPattern := RegExReplace(value, "<.*?>", "<" . path . ">")
    parent[key] := newPattern

    segments := StrSplit(path, ".")
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
        if (IsArray(parent)) {
            target.isArrayItem := true
        }
    }
}

DoBattle(battleOptions) {
    SetStatus(A_ThisFunc, 2)
    global patterns, settings

    targetCompanions := []
    for k, v in battleOptions.companions
        targetCompanions.push(patterns["companions"]["targets"][v])

    targetAllies := []
    for k, v in battleOptions.allyTarget
        targetAllies.push(patterns["battle"]["target"]["ally"][v])

    standbySelected := false
    allyTargeted := false

    donePatterns := []
    donePatterns.push(patterns.battle.done)

    if (battleOptions.donePatterns) {
        donePatterns.push(battleOptions.donePatterns)
    }

    Loop {
        if (targetCompanions.Length() > 0 && FindPattern(patterns.companions.refresh).IsSuccess) {
            ScrollUntilDetect(targetCompanions)
            sleep 1000
        }

        if (battleOptions.startPatterns) {
            result := FindPattern(battleOptions.startPatterns)
            if (battleOptions.skipTicketCount) {
                UseSkipTickets()
                battleOptions.skipTicketCount--
            }
            else {
                ClickResult(result)
            }

            sleep 1000
        }

        if (battleOptions.autoRefillAP) {
            HandleInsufficientAP()
            sleep 1000
        }

        result := FindPattern([patterns.battle.auto, donePatterns])
    } until (result.IsSuccess)

    if (battleOptions.targetEnemyMiddle) {
        Loop {
            ClickResult({ X : 342, Y : 388 })
            sleep 500
            result := FindPattern(patterns.enemy.target, { variancePct : 20 })
        } until (result.IsSuccess)
    }

    userPatternSkills := settings.userPatterns.battle.skills
    actions := []
    highPrioritySkills := []
    mediumPrioritySkills := []
    lowPrioritySkills := []

    ;loop through skill list
    for k, v in battleOptions.skills
    {
        switch (userPatternSkills[v].priority) {
            case "High":
                highPrioritySkills.Push(patterns.battle.skills[v])
            case "Low":
                lowPrioritySkills.Push(patterns.battle.skills[v])
            default:
                mediumPrioritySkills.Push(patterns.battle.skills[v])
        }
    }
    
    actions.Push(highPrioritySkills)
    actions.Push(mediumPrioritySkills)
    actions.Push(lowPrioritySkills)
    actions.Push(patterns.battle.attack)

    Loop {
        count := 0

        result := FindPattern([patterns.battle.wave.1over3, patterns.battle.wave.2over3, patterns.battle.wave.3over3])
        if (result.IsSuccess) {
            RegExMatch(result.comment, "(?P<wave>\d)over(?P<numWaves>\d)", matches)
            SetStatus(A_ThisFunc . ": " . matchesWave . "/" .  matchesNumWaves . "(" . count . ")", 2)
        }

        if (battleOptions.auto) {
            FindPattern(patterns.battle.auto.disabled, { doClick : true })
            if (battleOptions.onBattleAction)
            {
                battleOptions.onBattleAction.Call("")
            }
        }
        else {
            battleOptions.preBattle()

            FindPattern(patterns.battle.auto.enabled, { doClick : true })
            result := FindPattern(patterns.battle.skills.label)
            if (result.IsSuccess) {
                if (battleOptions.selectStandby && !standbySelected) {
                    result := FindPattern(patterns.battle.standby, { doClick : true, clickDelay : 500 })
                    if (result.IsSuccess) {
                        standbySelected := true
                        sleep 500
                    }
                }

                if (battleOptions.allyTarget && targetAllies.Length() > 0 && !allyTargeted) {
                    Loop {
                        FindPattern(targetAllies, { doClick : true })
                        sleep 250
                        result := FindPattern(patterns.battle.target.on, { variancePct : 20 })
                    } until (result.IsSuccess)
                    allyTargeted := true
                }

                result := FindPattern(actions)
                if (result.IsSuccess && battleOptions.onBattleAction)
                {
                    battleOptions.onBattleAction.Call(result)
                }
                else if (result.IsSuccess) {
                    ClickResult(result)
                }
            }
        }

        if (FindPattern(donePatterns).IsSuccess) {
            SetStatus(A_ThisFunc . ": Done", 2)
            Break
        }

        sleep, 250
        count++
        SetStatus(A_ThisFunc . ": " . matchesWave . "/" .  matchesNumWaves . "(" . count . ")", 2)

        if (mod(count, 250) = 0) {
            Resize(true)
        }
    }
}

UseSkipTickets() {
    global patterns

    PollPattern(patterns.darkGates.skip.ticket, { doClick : true, predicatePattern : patterns.darkGates.skip.add })
    sleep 500
    FindPattern(patterns.darkGates.skip.add, { doClick : true })
    sleep 1000
    FindPattern(patterns.darkGates.skip.add, { doClick : true })
    sleep 500
    if (!FindPattern(patterns.darkGates.skip.remainingZero).IsSuccess) {
        PollPattern(patterns.prompt.close, { doClick : true, predicatePattern : patterns.battle.start })
        PollPattern(patterns.apAdd, { doClick : true, predicatePatern : patterns.prompt.use })
        PollPattern(patterns.prompt.use, { doClick : true, predicatePatern : patterns.prompt.yes })
        PollPattern(patterns.prompt.yes, { doClick : true, predicatePatern : patterns.battle.close })
        PollPattern(patterns.prompt.close, { doClick : true, predicatePatern : patterns.battle.start })

        PollPattern(patterns.darkGates.skip.ticket, { doClick : true, predicatePattern : patterns.darkGates.skip.add })
        sleep 500
        FindPattern(patterns.darkGates.skip.add, { doClick : true })
        sleep 1000
        FindPattern(patterns.darkGates.skip.add, { doClick : true })
        sleep 500
    }

    PollPattern(patterns.prompt.use, { doClick : true, predicatePattern : patterns.battle.done })
}

Resize(reset := "") {
    global settings, hwnd, metadata

    size := metadata.window.emulator[settings.window.emulator]

    if (reset) {
        ResizeWin("ahk_id " hwnd, size.targetWidth + 50, size.targetHeight + 70)
        sleep 400
    }

    ResizeWin("ahk_id " hwnd, size.targetWidth, size.targetHeight)
}

MiddleClickCallback() {
    global hwnd

    WinGetPos,X,Y,W,H, % "ahk_id " . hwnd

    if (W = 600 && H = 1040 && !FindPattern(patterns.homeScreen.playStore).IsSuccess) {
        Click("x550 y220")
    }
    
    ;Resize()
}

SetStatus(value, part := 1) {
    global settings, guiHwnd

    ControlGetText, status, msctls_statusbar321, % "ahk_id " . guiHwnd

    regex := "^(?P<first>.*?)\|(?P<second>.*?)\|(?P<third>.*?)$"

    ;RegExMatch(result.comment, regex, matches)

    replace := "${first}|${second}|${third}"
    if (part = 1) {
        replace := StrReplace(replace, "${first}", value . " ")
    } else if (part = 2) {
        replace := StrReplace(replace, "${second}", " " . value . " ")
    } else if (part = 3) {
        replace := StrReplace(replace, "${third}", " " . value . " ")
    }

    newStatus := RegExReplace(status, regex , replace)
    ControlSetText, msctls_statusbar321, % newStatus,  % "ahk_id " . guiHwnd
}

HandleInsufficientAP() {
    global patterns
    result := FindPattern(patterns.prompt.insufficientAP)
    
    if (result.IsSuccess) {
        ClickResult(result)
        PollPattern(patterns.prompt.use, { doClick : true, predicatePattern : patterns.prompt.yes })
        PollPattern(patterns.prompt.yes, { doClick : true, predicatePattern : patterns.prompt.close })
        PollPattern(patterns.prompt.close, { doClick : true })
        return true
    }

    return false
}

SwipeRight()
{
    Swipe(750, 320, 600, 320)
}

SwipeDown()
{
    Swipe(250, 750, 250, 450)
}

SwipeUp()
{
    Swipe(250, 750, 250, 1050)
}

Swipe(startX, startY, endX, endY)
{
    global blueStacksInstanceNumber, settings


    if (settings.blueStacks.portOverride) {
        port := settings.blueStacks.portOverride
        run, hd-adb.exe -s 127.0.0.1:%port% shell input swipe %startX% %startY% %endX% %endY%, % settings.blueStacks.installationPath, Hide
    }
    else {
        path := settings.blueStacks.intallationPath
        ;https://developer.android.com/studio/command-line/adb
        run, hd-adb.exe -s 127.0.0.1:%blueStacksInstanceNumber% shell input swipe %startX% %startY% %endX% %endY%, % settings.blueStacks.installationPath, Hide
    }
    ;run, % "hd-adb.exe -s localhost:"  . blueStacksInstanceNumber . " shell input swipe "  . startX . " " . startY . " " . endX . " " . endY, C:\Program Files\BlueStacks_nxt, Hide
}

ScrollUp()
{
    global patterns
    FindPattern(patterns.scroll.up.handle, { doClick : true, variancePct: 20, offSetY : -12 })
}

ScrollDown()
{
    global patterns
    FindPattern(patterns.scroll.down.handle, { doClick : true, variancePct: 20, offSetY : 12 })
}

ScrollUntilDetect(target, opts := "") {
    global patterns

    opts := InitOps(opts, { variancePct : 20, doClick : true })

    direction := "down"
    Loop {
        if (FindPattern(target, opts).IsSuccess) {
            Break
        }

        if (direction = "down") {
            ScrollDown()
        }
        else {
            ScrollUp()
        }

        sleep, 1000

        if (FindPattern(patterns.scroll.down.max).IsSuccess) {
            direction := "up"
            FindPattern(patterns.companions.refresh, { variancePct : 20, doClick : true })
            sleep 1000
        }

        if (FindPattern(patterns.scroll.up.max).IsSuccess) {
            direction := "down"
            FindPattern(patterns.companions.refresh, { variancePct : 20, doClick : true })
            sleep 1000
        }
    }
}

GetCommandLine(hwnd)
{
	;https://www.autohotkey.com/docs/commands/ComObjGet.htm
	WinGet pid, PID, % "ahk_id" hwnd
    ; Get WMI service object.
    wmi := ComObjGet("winmgmts:")
    ; Run query to retrieve matching process(es).
    queryEnum := wmi.ExecQuery(""
        . "Select * from Win32_Process where ProcessId=" . pid)
        ._NewEnum()
    ; Get first matching process.
    if queryEnum[proc]
        result := proc.CommandLine
    else
        result := "Process not found!"
    ; Free all global objects (not necessary when using local vars).
    wmi := queryEnum := proc := ""
	
	;https://www.autohotkey.com/boards/viewtopic.php?t=43418
	;Clipboard := RegExReplace(result, "^""|"" $")		;https://www.autohotkey.com/docs/misc/Clipboard.htm
	;return RegExReplace(result, "^""|"" $")
	Return RegExReplace(result, """")
}

GetGuiHwnd() {
    query := "Select * from Win32_Process where CommandLine like '%" . StrReplace(A_ScriptFullPath, "\", "\\") . "%'" . " and not CommandLine like '%mode%'"
    queryEnum := ComObjGet("winmgmts:").ExecQuery(query)._NewEnum()
    queryEnum[proc]

    ;MsgBox, % proc.CommandLine

    ;https://www.autohotkey.com/board/topic/20850-retrieve-win-ids-of-all-associated-windows-and-child-windows/
    WinGet, windowList, List, % "ahk_pid" . proc.ProcessId
    ;WinGet, hwndWindow, ID, % "ahk_pid" . proc.ProcessId

    Loop, % windowList
    {
        WinGetClass, windowClass, % "ahk_id " windowList%A_Index%
        if (windowClass = "AutoHotkeyGUI") {
            Return windowList%A_Index%
        }
    }
}

GetHwnd(targetWindow, mode) {
	DetectHiddenWindows, On
    query := "Select * from Win32_Process where "
		;. "CommandLine like '%" . StrReplace(A_ScriptFullPath, "\", "\\") . "%' and " 
        . "CommandLine like '%mode=" . mode . "%' and "
        . "CommandLine like '%id=""" . targetWindow . """%'"
    queryEnum := ComObjGet("winmgmts:").ExecQuery(query)._NewEnum()
    queryEnum[proc]
	;MsgBox, % proc.CommandLine
    WinGet, hwnd, ID, % "ahk_pid" . proc.ProcessId
	Return hwnd
}