
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
            ;hwnd := DllCall("user32\FindWindow", "Str","Qt5QWindowIcon", "Str", settings.window.emulator, "Ptr")
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

    guiHwnd := GetGuiHwnd()
    editLogHwnd := GetControlHwnd("EditLog")
    itemWorldBattleCountHwnd := GetControlHwnd("ItemWorldBattleCount")
    battleCountHwnd := GetControlHwnd("BattleCount")
    eventStoryFarmCountHwnd := GetControlHwnd("EventStoryFarmCount")
    darkGateCountHwnd := GetControlHwnd("DarkGateCount")
    darkGateSkipCountHwnd := GetControlHwnd("DarkGateSkipCount")
    darkGateUseGateKeysOnFirstSkipHwnd := GetControlHwnd("DarkGateUseGateKeysOnFirstSkip")
    
    patterns := InitPatterns()
    InitPatternsTree()
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
    global patterns, settings, mode, darkGateSkipCountHwnd, darkGateUseGateKeysOnFirstSkipHwnd

    startTick := A_TickCount

    targetCompanions := []
    for k, v in battleOptions.companions
        targetCompanions.push(patterns["companions"]["targets"][v])

    targetAllies := []
    for k, v in battleOptions.allyTarget
        targetAllies.push(patterns["battle"]["target"]["ally"][v])

    standbySelected := false
    allyTargeted := false

    donePatterns := []
    ;donePatterns.push(patterns.battle.done)

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
            if (!FindPattern(patterns.companions.refresh).IsSuccess && battleOptions.skipTicketCount) {
                AddLog(A_ThisFunc . " Using SkipTickets")
                UseSkipTickets()
                battleOptions.skipTicketCount--
                ControlSetText,, % battleOptions.skipTicketCount, % "ahk_id " . darkGateSkipCountHwnd
                if (mode = "AutoDailies" || InStr(mode, "AutoDailyDarkGate")) {
                    if (mode = "AutoDailies") {
                        currentDaily := settings.dailies.current
                    } else {
                        currentDaily := mode
                    }
                    
                    IncrementDailyStat([currentDaily, "skip"])
                }
                sleep 1000
            }
            else if (result.IsSuccess) {
                ClickResult(result)
                sleep 1000
            }
        }

        if (battleOptions.autoRefillAP) {
            HandleInsufficientAP()
            sleep 1000
        }

        if (FindPattern(patterns.battle.done.2, { bounds : { x1 : 106, y1 : 38, x2 : 174, y2 : 108 } }).IsSuccess) {
            SetStatus(A_ThisFunc . ": Done", 2)
            Break
        }

        result := FindPattern([patterns.battle.auto, donePatterns])
    } until (result.IsSuccess)

    if (FindPattern([donePatterns, patterns.battle.done]).IsSuccess) {
        Return
    }

    if (battleOptions.targetEnemyMiddle) {
        Loop {
            ClickResult({ X : 342, Y : 388 })

            Loop, 5 {
                result := FindPattern(patterns.enemy.target, { variancePct : 20 })
            } until (result.IsSuccess)
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

        result := FindPattern([patterns.battle.wave.1over3, patterns.battle.wave.2over3, patterns.battle.wave.3over3], { bounds : { x1 : 269, y1 : 71, x2 : 377, y2 : 149 }})
        if (result.IsSuccess) {
            RegExMatch(result.comment, "(?P<wave>\d)over(?P<numWaves>\d)", matches)
            SetStatus(A_ThisFunc . ": " . matchesWave . "/" .  matchesNumWaves . "(" . count . ")", 2)
        }

        battleOptions.preBattle()

        if (battleOptions.auto) {
            FindPattern(patterns.battle.auto.disabled, { doClick : true, bounds : { x1 : 430, y1 : 23, x2 : 584, y2 : 99 } })
            if (battleOptions.onBattleAction)
            {
                battleOptions.onBattleAction.Call("")
            }
        }
        else {
            FindPattern(patterns.battle.auto.enabled, { doClick : true, bounds : { x1 : 430, y1 : 23, x2 : 584, y2 : 99 } })
            result := FindPattern(patterns.battle.skills.label, { bounds : { x1 : 122, y1 : 487, x2 : 583, y2 : 804 } })
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
                        Loop, 7 {
                            result := FindPattern(patterns.battle.target.on, { variancePct : 20 })
                        } until (result.IsSuccess)
                    } until (result.IsSuccess)
                    allyTargeted := true
                }

                result := FindPattern(actions, { bounds : { x1 : 122, y1 : 487, x2 : 583, y2 : 804 } })
                if (result.IsSuccess && battleOptions.onBattleAction)
                {
                    battleOptions.onBattleAction.Call(result)
                }
                else if (result.IsSuccess) {
                    ClickResult(result)
                }
            }
        }

        if (FindPattern(patterns.battle.done.2, { bounds : { x1 : 106, y1 : 38, x2 : 174, y2 : 108 } }).IsSuccess) {
            SetStatus(A_ThisFunc . ": Done", 2)
            Break
        }

        if (donePatterns.Length() > 0 && FindPattern(donePatterns).IsSuccess) {
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

    AddLog(A_ThisFunc . " " . DisplayTimeStampDiff(startTick, A_TickCount))
}

UseSkipTickets() {
    global patterns, darkGateUseGateKeysOnFirstSkipHwnd
    ControlGet, useGateKeysOnFirstSkip, Checked,,, % "ahk_id " . darkGateUseGateKeysOnFirstSkipHwnd

    PollPattern(patterns.darkGates.skip.ticket, { doClick : true, predicatePattern : patterns.darkGates.skip.add })
    sleep 500

    if (useGateKeysOnFirstSkip) {
        Loop 10 {
            FindPattern(patterns.darkGates.skip.add, { doClick : true })
            sleep 750
        }

        sleep 1000
        if (!FindPattern(patterns.darkGates.skip.unlockingZero).IsSuccess) {
            Loop 2 {
                PollPattern(patterns.prompt.close, { doClick : true, predicatePattern : patterns.battle.start })
                PollPattern(patterns.apAdd, { doClick : true, predicatePatern : patterns.prompt.use, bounds : { x1 : 223, y1 : 63, x2 : 313, y2 : 130 } })
                PollPattern(patterns.prompt.use, { doClick : true, predicatePatern : patterns.prompt.close })
                PollPattern(patterns.prompt.use, { doClick : true, predicatePatern : patterns.prompt.close, bounds : { x1 : 182, y1 : 655, x2 : 390, y2 : 742 } })
                PollPattern(patterns.prompt.close, { doClick : true, predicatePatern : patterns.battle.start })
                sleep 500
            }
            PollPattern(patterns.darkGates.skip.ticket, { doClick : true, predicatePattern : patterns.darkGates.skip.add })
            sleep 500
            Loop 10 {
                FindPattern(patterns.darkGates.skip.add, { doClick : true })
                sleep 750
            }
        }
        Control, UnCheck,,, % "ahk_id " . darkGateUseGateKeysOnFirstSkipHwnd    
    }
    else {
        Loop 2 {
            FindPattern(patterns.darkGates.skip.add, { doClick : true })
            sleep 750
        }

        sleep 1000
        if (!FindPattern(patterns.darkGates.skip.remainingZero).IsSuccess) {
            PollPattern(patterns.prompt.close, { doClick : true, predicatePattern : patterns.battle.start })
            PollPattern(patterns.apAdd, { doClick : true, predicatePatern : patterns.prompt.use, bounds : { x1 : 223, y1 : 63, x2 : 313, y2 : 130 } })
            PollPattern(patterns.prompt.use, { doClick : true, predicatePatern : patterns.prompt.close })
            PollPattern(patterns.prompt.use, { doClick : true, predicatePatern : patterns.prompt.close, bounds : { x1 : 182, y1 : 655, x2 : 390, y2 : 742 } })
            PollPattern(patterns.prompt.close, { doClick : true, predicatePatern : patterns.battle.start })
            sleep 500
            PollPattern(patterns.darkGates.skip.ticket, { doClick : true, predicatePattern : patterns.darkGates.skip.add })
            sleep 500
            Loop 2 {
                FindPattern(patterns.darkGates.skip.add, { doClick : true })
                sleep 750
            }
        }
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
        PollPattern(patterns.prompt.insufficientAP, { doClick : true, predicatePattern : patterns.prompt.use })
        PollPattern(patterns.prompt.use, { doClick : true, predicatePatern : patterns.prompt.close })
        PollPattern(patterns.prompt.use, { doClick : true, predicatePatern : patterns.prompt.close, bounds : { x1 : 182, y1 : 655, x2 : 390, y2 : 742 } })
        PollPattern(patterns.prompt.close, { doClick : true, predicatePattern : [patterns.apAdd, patterns.battle.prompt.battle, patterns.battle.start] })
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

;Hidden text control indicates that the name of the next control
GetControlHwnd(hiddenText) {
    global guiHwnd

    ;https://www.autohotkey.com/docs/commands/WinGet.htm
    WinGet, controlHwnds, ControlListHwnd, % "ahk_id " . guiHwnd
    Loop, Parse, controlHwnds, `n
    {
        if (found = true) {
            Return A_LoopField
        }

        ControlGetText, controlText,, ahk_id %A_LoopField%
        if (hiddenText = controlText) {
            found := true
        }
    }
}

PollPattern(pattern, opts := "") {
	opts := InitOps(opts, { doClick : false, clickDelay : 0, bounds : "", pollInterval : 500, doubleCheck: false, doubleCheckDelay: 500, predicatePattern : "", maxCount : "", clickPattern : ""})

    opts.callback()
    count := 0
	originalDoClick := opts.doClick
    originalDoubleCheck := opts.doubleCheck
    opts.doClick := false
    opts.doubleCheck := false

    ;keep polling until predicatePattern is found
    if (opts.predicatePattern) {
        result := FindPattern(pattern, opts)
        targetResult := FindPattern(opts.predicatePattern, opts)

        if (targetResult.IsSuccess)
        {
            if (originalDoClick) {
                sleep, opts.clickDelay
                ClickResult(result)
            }
        }
        else {
            while (!targetResult.IsSuccess) {
                SetStatus("Try " . count, 2)
                
                opts.callback()
                sleep, opts.pollInterval
                result := FindPattern(pattern, opts)

                if (originalDoubleCheck) {
                    sleep, opts.doubleCheckDelay
                    result := FindPattern(pattern, opts)
                }

                if (result.IsSuccess && originalDoClick) {
                    successResult := result
                    sleep, opts.clickDelay
                    ClickResult(result)
                    sleep, opts.pollInterval
                }

                if (opts.clickPattern) {
                    FindPattern(opts.clickPattern, { doClick : true })
                }

                targetResult := FindPattern(opts.predicatePattern, opts)
            }
        }
        
        if (!result.comment) {
            result := initialResult
        }

        if (opts.maxCount && opt.maxCount >= count) {
            result.IsSuccess := false
        }

        if (!successResult) {
            successResult := result
        }

        Return successResult
    }

    result := FindPattern(pattern, opts)
    while (!result.IsSuccess && (!opts.maxCount || count < opts.maxCount)) {
        SetStatus("Try " . count, 2)
        sleep, opts.pollInterval
        opts.callback()

        if (opts.clickPattern) {
            FindPattern(opts.clickPattern, { doClick : true })
        }

        result := FindPattern(pattern, opts)
        count++
    }

    if (originalDoubleCheck) {
        sleep, opts.doubleCheckDelay
        result := FindPattern(pattern, opts)
    }
    
    if (originalDoClick) {
        sleep, opts.clickDelay
        ClickResult(result)
    }

	return result
}

FindPattern(pattern, opts := "") {
	global hwnd, settings

	opts := InitOps(opts, { multi : false, variancePct : 15, fgVariancePct : 0, bgVariancePct : 0, bounds : "", doClick : false, clickDelay : 0, offsetX : 0, offsetY : 0, doubleCheck: false, doubleCheckDelay: 500})
    arrPattern := ToFlatArray(pattern)
    updateCallback := opts.updateCallback

    fgVariancePct := (opts.fgVariancePct ? opts.fgVariancePct : opts.variancePct) / 100
    bgVariancePct := (opts.bgVariancePct ? opts.bgVariancePct : opts.variancePct) / 100
    if (settings.window.extraVariance) {
        fgVariancePct += settings.window.extraVariance / 100
        bgVariancePct += settings.window.extraVariance / 100
    }

    result := FindPatternLoop(arrPattern, { multi: opts.multi, err1 : fgVariancePct, err0 : bgVariancePct, bounds : opts.bounds })

    if (opts.doubleCheck) {
        sleep, opts.doubleCheckDelay
        result := FindPatternLoop(arrPattern, { multi: false, err1 : fgVariancePct, err0 : bgVariancePct, bounds : bounds })
    }

    if (result.IsSuccess && opts.offsetX) {
        result.X += opts.offsetX
    }

    if (result.IsSuccess && opts.offsetY) {
        result.Y += opts.offsetY
    }

	if (result.IsSuccess && opts.doClick) {
		sleep, opts.clickDelay
		ClickResult(result)
	}

	Return result
}

FindPatternLoop(arrPattern, opts := "") {
    global hwnd, settings
    result := { IsSuccess: false }
    opts := InitOps(opts, { multi : false, err1 : 0, err0 : 0, bounds : "" })

    if (opts.bounds) {
        FindText().ClientToScreen(x1, y1, opts.bounds.x1, opts.bounds.y1, hwnd)
        FindText().ClientToScreen(x2, y2, opts.bounds.x2, opts.bounds.y2, hwnd)
        bounds := { x1 : x1, y1 : y1, x2 : x2, y2 : y2 }
    }
    else {
        bounds := { x1 : 0, y1 : 0, x2 : 0, y2 : 0 }
    }

    for index, pattern in arrPattern {
        RegExMatch(pattern, "<(?P<comment>.*)>", matches)   ;https://www.autohotkey.com/docs/commands/RegExMatch.htm#NamedSubPat
        SetStatus("Finding: " . matchesComment, 3)

        ; if (opts.boundsMap[matchesComment]) {
        ;     bounds := opts.boundsMap[matchesComment]
        ; }

        if (settings.debug.patterns && bounds) {
            ShowRectangle(bounds.x1, bounds.y1, bounds.x2, bounds.y2, "Blue")
        }
        ok := FindText(X, Y, bounds.x1, bounds.y1, bounds.x2, bounds.y2, opts.err1, opts.err0, pattern, 1, opts.multi)
        if (ok)
        {
            if (settings.debug.patterns) {
                ShowRectangle(ok.1.1, ok.1.2, ok.1.1 + ok.1.3, ok.1.2 + ok.1.4)
            }
            result.IsSuccess := true
            FindText().ScreenToWindow(x, y, ok.1.x, ok.1.y, hwnd)
            result.X := x
            result.Y := y
            if (matchesComment)
                result.comment := matchesComment

            if (opts.multi) {
                result.multi := []
                for k, v in ok {
                    FindText().ScreenToWindow(x, y, v.x, v.y, hwnd)
                    result.multi.push({ X : x, Y : y })
                }
            }
            Break
        }
    }

    return result
}
