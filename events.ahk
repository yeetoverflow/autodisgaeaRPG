#Include common.ahk

EventStoryFarm() {
    global patterns, settings, guiHwnd, mode
    SetStatus(A_ThisFunc)
    ControlGetText, battleCount, edit2, % "ahk_id " . guiHwnd
    SetStatus(battleCount, 2)

    battleOptions := settings.battleOptions.event
    battleOptions.startPatterns := [patterns.battle.start, patterns.battle.prompt.battle]
    battleOptions.donePatterns := [patterns.raid.appear.advanceInStory, patterns.battle.prompt.quitBattle]
   
    loopTargets := [patterns.stronghold.gemsIcon, patterns.dimensionGate.background, patterns.dimensionGate.events.select
        , patterns.battle.start, patterns.events.title, patterns.events.stage.title, patterns.battle.prompt.battle
        , patterns.raid.message, patterns.companions.title]
    Loop {
        result := PollPattern(loopTargets)

        if InStr(result.comment, "stronghold.gemsIcon") {
            FindPattern(patterns.tabs.dimensionGate, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "dimensionGate.background") {
            FindPattern(patterns.dimensionGate.events.block, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "dimensionGate.events.select") {
            ; FindAndClickListTarget(patterns.dimensionGate.events.story)
            ScrollUntilDetect(patterns.dimensionGate.events.story)
            sleep 3000
        }
        else if InStr(result.comment, "battle.start") {
            ClickResult(result)
            sleep 1000
        }
        else if InStr(result.comment, "battle.prompt.battle") || InStr(result.comment, "companions.title") {
            DoBattle(battleOptions)
            battleCount--
            ControlSetText, edit2, % battleCount,  % "ahk_id " . guiHwnd
            SetStatus(battleCount, 2)
            PollPattern(loopTargets, { callback : Func("MiddleClickCallback") })
            sleep 2000
            if (battleCount <= 0) {
                Break
            }
        }
        else if InStr(result.comment, "events.title") {
            sleep 1000
            PollPattern(patterns.events.hard, { doClick : true, predicatePattern : patterns.events.hard.enabled })
            Click("x470 y443")
            sleep 50
            Click("x470 y443")
        }
        else if InStr(result.comment, "events.stage.title") {
            PollPattern(patterns.events.stage[settings.eventOptions.storyTarget], { doClick : true })
        }
        else if InStr(result.comment, "raid.message") {
            HandleRaid()
        }
    }

    if (mode) {
        ExitApp
    }
}

HandleRaid() {
    global patterns

    PollPattern(patterns.raid.appear.fightRaidBoss, { doClick : true })
    PollPattern(patterns.raid.helpRequests, { doClick : true })
    PollPattern(patterns.prompt.ok, { doClick : true })
    PollPattern(patterns.stage.back, { doClick : true })
    sleep 1000
    PollPattern(patterns.tabs.stronghold, { doClick : true })
    sleep 1000
}

EventStory500Pct() {
    global mode, patterns, settings
    SetStatus(A_ThisFunc)

    done := false
    battleOptions := settings.battleOptions.event
    battleOptions.startPatterns := [patterns.battle.start, patterns.battle.prompt.battle]
    battleOptions.donePatterns := [patterns.raid.appear.advanceInStory, patterns.battle.prompt.quitBattle]

    loopTargets := [patterns.stronghold.gemsIcon, patterns.dimensionGate.background, patterns.dimensionGate.events.select
        , patterns.battle.start, patterns.events.title, patterns.events.stage.title, patterns.battle.prompt.quitBattle, patterns.raid.message]
    Loop {
        result := PollPattern(loopTargets)

        if InStr(result.comment, "stronghold.gemsIcon") {
            FindPattern(patterns.tabs.dimensionGate, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "dimensionGate.background") {
            FindPattern(patterns.dimensionGate.events.block, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "dimensionGate.events.select") {
            ; FindAndClickListTarget(patterns.dimensionGate.events.story)
            ScrollUntilDetect(patterns.dimensionGate.events.story)
            sleep 3000
        }
        else if InStr(result.comment, "battle.start") || InStr(result.comment, "battle.prompt.quitBattle") {
            ClickResult(result)
            sleep 1000
        }
        else if InStr(result.comment, "events.overview.500Pct") {
            PollPattern(patterns.events.overview.500Pct, { fgVariancePct : 20, bgVariancePct : 15, offsetY : 30 })
            sleep 1000
        }
        else if InStr(result.comment, "events.title") {
            sleep 1000
            result := FindPattern([patterns.events.overview.500Pct], { fgVariancePct : 20, bgVariancePct : 15 })
            if InStr(result.comment, "overview.500Pct") {
                result.Y := result.Y + 30
                ClickResult(result)
                sleep 50
                ClickResult(result)
            }
            else {
                result := FindPattern([patterns.events.hard.enabled, patterns.events.normal.enabled])
                if InStr(result.comment, "hard.enabled") {
                    FindPattern(patterns.events.normal, { doClick : true })
                    sleep 1000
                }
                else if InStr(result.comment, "normal.enabled") {
                    FindPattern(patterns.events.easy, { doClick : true })
                    sleep 1000
                }
                else {
                    done := true
                }
            }
        }
        else if InStr(result.comment, "events.stage.title") {
            result := FindPattern(patterns.events.stage.500Pct)
            if (result.IsSuccess) {
                PollPattern(patterns.events.stage.500Pct, { doClick : true, fgVariancePct : 20, bgVariancePct : 15, predicatePattern : patterns.companions.50Pct })
                DoBattle(battleOptions)
                PollPattern(loopTargets, { callback : Func("MiddleClickCallback") })
                sleep 2000
            }
            else {
                FindPattern(patterns.stage.back, { doClick : true })
            }
        }
        else if InStr(result.comment, "raid.message") {
            HandleRaid()
        }
    } until (done)

    if (mode) {
        ExitApp
    }
}

EventRaidLoop() {
    global patterns, settings
    SetStatus(A_ThisFunc)

    loopTargets := [patterns.stronghold.gemsIcon, patterns.dimensionGate.background, patterns.dimensionGate.events.select, patterns.raid.activeBoss]
    Loop {
        result := PollPattern(loopTargets)

        if InStr(result.comment, "stronghold.gemsIcon") {
            FindPattern(patterns.tabs.dimensionGate, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "dimensionGate.background") {
            FindPattern(patterns.dimensionGate.events.block, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "dimensionGate.events.select") {
            ; FindAndClickListTarget(patterns.dimensionGate.events.raid)
            ScrollUntilDetect(patterns.dimensionGate.events.raid)
            sleep 3000
        }
        else if InStr(result.comment, "raid.activeBoss") {
            Loop {
                result := PollPattern(patterns.raid.helper, { maxCount : 100 })
                if (result.IsSuccess) {
                    PollPattern(patterns.raid.helper, { doClick : true, predicatePattern : patterns.battle.start })
                } else {
                    PollPattern(patterns.raid.reload, { doClick : true })
                    Continue
                }
                
                PollPattern(patterns.battle.start, { doClick : true })

                result := PollPattern([patterns.prompt.ok, patterns.battle.auto])
                if InStr(result.comment, "prompt.ok") {
                    ClickResult(result)
                    continue
                }

                DoBattle(settings.battleOptions.raid)
                PollPattern(patterns.raid.activeBoss, { callback : Func("RaidClickCallback") })
            }
        }

        sleep 250
    }
}

RaidClickCallback() {
    global patterns, hwnd

    WinGetPos,X,Y,W,H, % "ahk_id " . hwnd

    if (W = 600 && H = 1040) {
        Click("x300 y150")

        FindPattern(patterns.prompt.close, { doClick : true })
    }
    
    ;Resize()
}