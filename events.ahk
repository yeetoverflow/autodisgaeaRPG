#Include common.ahk

EventAutoClear() {
    global patterns, settings
    SetStatus(A_ThisFunc)

    battleOptions := settings.battleOptions.event
    autoRefillAP.autoRefillAP := false
    battleOptions.Callback := func("BattleMiddleClickCallback")
    battleOptions.startPatterns := [patterns.battle.start]
    battleOptions.donePatterns := [patterns.raid.message]

    targetCompanion := []
    for k, v in battleOptions.companions
        targetCompanion.push(patterns["companions"][v])

    loopTargets := [patterns.stronghold.gemsIcon, patterns.dimensionGate.background, patterns.dimensionGate.events.select
                  , patterns.battle.start, patterns.general.autoClear.new, patterns.companions.title, patterns.general.autoClear.skip, patterns.general.autoClear.areaClear, patterns.raid.message]
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
        else if InStr(result.comment, "general.autoClear.new") || InStr(result.comment, "general.autoClear.skip") || InStr(result.comment, "general.autoClear.areaClear") {
            ClickResult(result)
            sleep, 50
            ClickResult(result)

            if InStr(result.comment, "general.autoClear.skip") {
                PollPattern(loopTargets, { callback : Func("MiddleClickCallback") })
            }
        }
        else if InStr(result.comment, "companions.title") {
            ; FindAndClickListTarget(targetCompanion, { predicatePattern : patterns.battle.start })
            ; ScrollUntilDetect(targetCompanion, { predicatePattern : patterns.battle.start })
            sleep 500
            ; PollPattern([patterns.battle.start], { doClick : true, variancePct: 5, callback : Func("BattleMiddleClickCallback") })
            DoBattle(battleOptions)
            PollPattern(loopTargets, { callback : Func("MiddleClickCallback"), pollInterval : 250 })
        }
        else if InStr(result.comment, "raid.message") {
            HandleRaid()
        }
    }
}

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
            PollPattern(loopTargets, { callback : Func("MiddleClickCallback"), pollInterval : 250 })
            sleep 2000
            if (battleCount <= 0) {
                Break
            }
        }
        else if InStr(result.comment, "events.title") {
            sleep 1000
            PollPattern(patterns.events.hard, { doClick : true, predicatePattern : patterns.events.hard.enabled })
            sleep 500
            Click("x470 y443")
            sleep 50
            Click("x470 y443")
        }
        else if InStr(result.comment, "events.stage.title") {
            FindPattern(patterns.events.stage[settings.eventOptions.storyTarget], { doClick : true })
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

    PollPattern(patterns.raid.appear.fightRaidBoss, { doClick : true, predicatePattern : patterns.raid.helpRequests })
    PollPattern(patterns.raid.helpRequests, { doClick : true, predicatePattern : patterns.prompt.ok })
    PollPattern(patterns.prompt.ok, { doClick : true, predicatePattern : patterns.stage.back })
    PollPattern(patterns.stage.back, { doClick : true, predicatePattern : patterns.tabs.stronghold })
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
    battleOptions.donePatterns := [patterns.raid.appear.advanceInStory, patterns.battle.prompt.quitBattle, patterns.events.title]

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
        else if InStr(result.comment, "battle.start") {
            DoBattle(battleOptions)
            PollPattern(loopTargets, { callback : Func("MiddleClickCallback"), pollInterval : 250 })
            sleep 2000
        }
        else if InStr(result.comment, "battle.prompt.quitBattle") {
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
                PollPattern(loopTargets, { callback : Func("MiddleClickCallback"), pollInterval : 250 })
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
                    sleep 1000
                    ClickResult(result)
                    continue
                }

                DoBattle(settings.battleOptions.raid)
                PollPattern(patterns.raid.activeBoss, { callback : Func("RaidClickCallback"), pollInterval : 250 })
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

EventRaidAutoClaim() {
    global mode, patterns
    SetStatus(A_ThisFunc)
    
    Loop
    {
        result := FindPattern([patterns.raid.claim.prize, patterns.prompt.close], { variancePct : 20 })
        if (result.IsSuccess)
        {
            ClickResult(result)
        }

        sleep 250

        if (!result.IsSuccess)
        {
            ScrollDown()
        }

        if (FindPattern(patterns.scroll.down.max).IsSuccess) {
            Break
        }
    }

    if (mode) {
        ExitApp
    }
}

EventRaidAutoVault() {
    global mode, patterns
    SetStatus(A_ThisFunc)
    
    Loop
    {
        result := PollPattern([patterns.events.vault.acquired, patterns.prompt.close], { maxCount : 10 })
        if (result.IsSuccess)
        {
            ClickResult(result)
        }
        else {
            Break
        }

        sleep 250
    }

    if (mode) {
        ExitApp
    }
}