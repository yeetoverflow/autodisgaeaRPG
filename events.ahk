#Include common.ahk

AutoDailyEventReview1() {
    global patterns, settings, mode
    SetStatus(A_ThisFunc)
    AddLog(A_ThisFunc)

    battleOptions := settings.battleOptions.event
    battleOptions.startPatterns := [patterns.battle.start, patterns.battle.prompt.battle]
    battleOptions.donePatterns := [patterns.raid.appear.advanceInStory, patterns.battle.prompt.quitBattle]
   
    battleCount := 0

    loopTargets := [patterns.stronghold.gemsIcon, patterns.dimensionGate.background,
        , patterns.battle.start, patterns.battle.auto, patterns.companions.title, patterns.events.review.title
        , patterns.events.title, patterns.darkGates.stage.threeStars
        , patterns.battle.prompt.battleAgain, patterns.touchScreen, patterns.events.characterGate.noMore
        , patterns.raid.message]
    Loop {
        result := PollPattern(loopTargets)

        if InStr(result.comment, "stronghold.gemsIcon") {
            FindPattern(patterns.tabs.dimensionGate, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "dimensionGate.background") {
            FindPattern(patterns.dimensionGate.eventReview, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "events.review.title") {
            FindPattern(patterns.dimensionGate.events.banners.eventReview1, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "battle.start") || InStr(result.comment, "stage.threeStars") {
            ClickResult(result)
            sleep 1000
        }
        else if InStr(result.comment, "events.title") {
            sleep 1000
            PollPattern(patterns.events.easy, { doClick : true, predicatePattern : patterns.events.easy.enabled, pollInterval : 2000 })
            sleep 500
            Click("x470 y443")
            sleep 50
            Click("x470 y443")
        }
        else if InStr(result.comment, "companions.title") || InStr(result.comment, "battle.auto") || InStr(result.comment, "battle.prompt.battleAgain") || InStr(result.comment, "touchScreen") {
            sleep 500
            DoBattle(battleOptions)
            PollPattern(loopTargets, { clickPattern : patterns.battle.done, pollInterval : 250 })
            battleCount++
            if (battleCount > 4) {
                Break
            }
        }
        else if InStr(result.comment, "raid.message") {
            HandleRaid()
        }
    }

    if (mode && mode != "AutoDailies") {
        ExitApp
    }
}

AutoDailyCharacterGate1() {
    global patterns, settings, mode
    SetStatus(A_ThisFunc)
    AddLog(A_ThisFunc)

    battleOptions := settings.battleOptions.event
    battleOptions.startPatterns := [patterns.battle.start, patterns.battle.prompt.battle]
    battleOptions.donePatterns := [patterns.raid.appear.advanceInStory, patterns.battle.prompt.quitBattle, patterns.touchScreen]
   
    loopTargets := [patterns.stronghold.gemsIcon, patterns.dimensionGate.background, patterns.dimensionGate.events.select
        , patterns.battle.start, patterns.battle.auto, patterns.companions.title, patterns.events.characterGate.enter
        , patterns.darkGates.stage.threeStars, patterns.battle.prompt.battleAgain, patterns.touchScreen, patterns.events.characterGate.noMore]
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
            ScrollUntilDetect(patterns.dimensionGate.events.banners.characterGate1, { variancePct : 30 })
            sleep 3000
        }
        else if InStr(result.comment, "events.characterGate.enter") || InStr(result.comment, "stage.threeStars") || InStr(result.comment, "touchScreen") {
            ClickResult(result)
            sleep 1000
        }
        else if InStr(result.comment, "companions.title") || InStr(result.comment, "battle.auto") || InStr(result.comment, "battle.prompt.battleAgain") || InStr(result.comment, "battle.start") {
            sleep 500
            DoBattle(battleOptions)
            PollPattern(loopTargets, { clickPattern : [patterns.battle.done, patterns.touchScreen], pollInterval : 250 })
        }
        else if InStr(result.comment, "events.characterGate.noMore") {
            Break
        }
    }

    if (mode && mode != "AutoDailies") {
        ExitApp
    }
}

EventAutoClear() {
    global patterns, settings
    SetStatus(A_ThisFunc)
    AddLog(A_ThisFunc)

    battleOptions := settings.battleOptions.event
    autoRefillAP.autoRefillAP := false
    battleOptions.startPatterns := [patterns.battle.start]
    battleOptions.donePatterns := [patterns.raid.message]

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
            ScrollUntilDetect(patterns.dimensionGate.events.banners.story)
            sleep 3000
        }
        else if InStr(result.comment, "battle.start") {
            ClickResult(result)
            sleep 500
        }
        else if InStr(result.comment, "companions.title") {
            sleep 500
            DoBattle(battleOptions)
            PollPattern(loopTargets, { clickPattern : patterns.battle.done, pollInterval : 250 })
        }
        else if InStr(result.comment, "general.autoClear.new") || InStr(result.comment, "general.autoClear.skip") || InStr(result.comment, "general.autoClear.areaClear") {
            ClickResult(result)
            sleep, 50
            ClickResult(result)

            if InStr(result.comment, "general.autoClear.skip") {
                PollPattern(loopTargets, { clickPattern : patterns.battle.done })
            }
        }
        else if InStr(result.comment, "raid.message") {
            HandleRaid()
        }
    }
}

EventStoryFarm(battleCount := "") {
    global patterns, settings, mode, eventStoryFarmCountHwnd
    SetStatus(A_ThisFunc)
    AddLog(A_ThisFunc)

    if (!battleCount) {
        ControlGetText, battleCount,, % "ahk_id " . eventStoryFarmCountHwnd
    }
    ControlSetText,, % battleCount, % "ahk_id " . eventStoryFarmCountHwnd
    SetStatus(battleCount, 2)

    farmTarget := settings.eventOptions.story.farmTarget
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
            result := ScrollUntilDetect(patterns.dimensionGate.events.banners.story)
            sleep 3000
        }
        else if InStr(result.comment, "battle.start") {
            ClickResult(result)
            sleep 1000
        }
        else if InStr(result.comment, "battle.prompt.battle") || InStr(result.comment, "companions.title") {
            DoBattle(battleOptions)
            battleCount--
            ControlSetText,, % battleCount, % "ahk_id " . eventStoryFarmCountHwnd
            SetStatus(battleCount, 2)
            if (mode = "AutoDailies" || InStr(mode, "AutoDailyEventStoryFarm")) {
                if (mode = "AutoDailies") {
                    currentDaily := settings.dailies.current
                } else {
                    currentDaily := mode
                }
                
                dailyStats := GetDailyStats()
                if (!dailyStats[currentDaily]) {
                    dailyStats[currentDaily] := {}
                }
                if (!dailyStats[currentDaily].count) {
                    dailyStats[currentDaily].count := 0
                }
                dailyStats[currentDaily].count++
                dailyStats.save(true)
            }

            PollPattern(loopTargets, { clickPattern : patterns.battle.done, pollInterval : 250 })
            sleep 2000
            if (battleCount <= 0) {
                Break
            }
        }
        else if InStr(result.comment, "events.title") {
            sleep 1000
            PollPattern(patterns.events.hard, { doClick : true, predicatePattern : patterns.events.hard.enabled, pollInterval : 2000 })
            sleep 500
            Click("x470 y443")
            sleep 50
            Click("x470 y443")
        }
        else if InStr(result.comment, "events.stage.title") {
            FindPattern(patterns.events.stage[farmTarget], { doClick : true })
        }
        else if InStr(result.comment, "raid.message") {
            HandleRaid()
        }
    }

    if (mode && mode != "AutoDailies") {
        ExitApp
    }
}

HandleRaid() {
    global settings, patterns
    AddLog(A_ThisFunc)

    switch (settings.eventOptions.raid.appearAction)
    {
        case "fight":
        {
            PollPattern(patterns.raid.appear.fightRaidBoss, { doClick : true, predicatePattern : patterns.raid.helpRequests })

            battleCount := 0
            Loop {
                result := PollPattern([patterns.battle.start, patterns.raid.finder, patterns.stage.back])
                if InStr(result.comment, "raid.finder") {
                    ClickResult(result)
                    sleep 1000
                    Continue
                }
                else if InStr(result.comment, "stage.back") {
                    sleep 1000
                    Break
                }
                else {
                    ClickResult(result)
                }

                PollPattern([patterns.battle.auto])
                DoBattle(settings.battleOptions.raid)
                battleCount++
                PollPattern(patterns.raid.activeBoss, { clickPattern : patterns.battle.done, callback : Func("RaidClickCallback"), pollInterval : 250 })
            } Until (settings.eventOptions.raid.fightAttempts && battleCount >= settings.eventOptions.raid.fightAttempts)

            result := PollPattern([patterns.raid.finder, patterns.stage.back])

            if (InStr(result.comment, "raid.finder") && settings.eventOptions.raid.fightAttempts && battleCount >= settings.eventOptions.raid.fightAttempts) {
                PollPattern(patterns.raid.finder, { doClick : true, predicatePattern : patterns.raid.helpRequests })
                PollPattern(patterns.raid.helpRequests, { doClick : true, predicatePattern : patterns.prompt.ok })
                PollPattern(patterns.prompt.ok, { doClick : true, predicatePattern : patterns.stage.back })
                sleep 1000
            }

            result := PollPattern([patterns.stronghold.gemsIcon, patterns.prompt.close], { clickPattern : patterns.stage.back })
            if InStr(result.comment, "prompt.close") {
                PollPattern(patterns.prompt.close, { doClick : true, predicatePattern : patterns.tabs.stronghold })
                PollPattern(patterns.tabs.stronghold, { doClick : true, predicatePattern : patterns.stronghold.gemsIcon })
            }
        }
        case "fightThenPullOut":
        {
            PollPattern(patterns.raid.appear.fightRaidBoss, { doClick : true, predicatePattern : patterns.raid.helpRequests })
            PollPattern(patterns.battle.start, { doClick : true, predicatePattern : patterns.menu.button })
            PollPattern(patterns.menu.button, { doClick : true, predicatePattern : patterns.menu.giveUp })
            PollPattern(patterns.menu.giveUp, { doClick : true, predicatePattern : patterns.prompt.yes })
            PollPattern(patterns.prompt.yes, { doClick : true, predicatePattern : patterns.battle.done })
            PollPattern(patterns.raid.activeBoss, { clickPattern : patterns.battle.done, callback : Func("RaidClickCallback"), pollInterval : 250 })
            PollPattern(patterns.raid.finder, { doClick : true, predicatePattern : patterns.raid.helpRequests })
            PollPattern(patterns.raid.helpRequests, { doClick : true, predicatePattern : patterns.prompt.ok })
            PollPattern(patterns.prompt.ok, { doClick : true, predicatePattern : patterns.stage.back })
            sleep 1000

            result := PollPattern([patterns.stronghold.gemsIcon, patterns.prompt.close], { clickPattern : patterns.stage.back })
            if InStr(result.comment, "prompt.close") {
                PollPattern(patterns.prompt.close, { doClick : true, predicatePattern : patterns.tabs.stronghold })
                PollPattern(patterns.tabs.stronghold, { doClick : true, predicatePattern : patterns.stronghold.gemsIcon })
            }
        }
        case "advanceInStory":
        {
            PollPattern(patterns.raid.appear.advanceInStory, { doClick : true })
            sleep 1000
        }
        default:    ;askForHelp
        {
            PollPattern(patterns.raid.appear.fightRaidBoss, { doClick : true, predicatePattern : patterns.raid.helpRequests })
            PollPattern(patterns.raid.helpRequests, { doClick : true, predicatePattern : patterns.prompt.ok })
            PollPattern(patterns.prompt.ok, { doClick : true, predicatePattern : patterns.stage.back })
            result := PollPattern([patterns.stronghold.gemsIcon, patterns.prompt.close], { clickPattern : patterns.stage.back })
            if InStr(result.comment, "prompt.close") {
                PollPattern(patterns.prompt.close, { doClick : true, predicatePattern : patterns.tabs.stronghold })
                PollPattern(patterns.tabs.stronghold, { doClick : true, predicatePattern : patterns.stronghold.gemsIcon })
            }
        }
    }
    
}

EventStory500Pct() {
    global mode, patterns, settings
    SetStatus(A_ThisFunc)
    AddLog(A_ThisFunc)

    done := false
    clickedHard := false
    battleOptions := settings.battleOptions.event
    battleOptions.startPatterns := [patterns.battle.start, patterns.battle.prompt.battle]
    battleOptions.donePatterns := [patterns.raid.appear.advanceInStory, patterns.battle.prompt.quitBattle, patterns.events.title]

    loopTargets := [patterns.stronghold.gemsIcon, patterns.dimensionGate.background, patterns.dimensionGate.events.select, patterns.events.overview.500Pct
        , patterns.battle.start, patterns.events.title, patterns.events.stage.title, patterns.battle.prompt.quitBattle, patterns.raid.message]
    Loop {
        result := PollPattern(loopTargets, { variancePct : 20 })

        if InStr(result.comment, "stronghold.gemsIcon") {
            FindPattern(patterns.tabs.dimensionGate, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "dimensionGate.background") {
            FindPattern(patterns.dimensionGate.events.block, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "dimensionGate.events.select") {
            ScrollUntilDetect(patterns.dimensionGate.events.banners.story)
            sleep 3000
        }
        else if InStr(result.comment, "battle.start") {
            DoBattle(battleOptions)
            PollPattern(loopTargets, { clickPattern : patterns.battle.done, pollInterval : 250 })
            sleep 2000
        }
        else if InStr(result.comment, "battle.prompt.quitBattle") {
            ClickResult(result)
            sleep 1000
        }
        else if InStr(result.comment, "events.overview.500Pct") {
            PollPattern(patterns.events.overview.500Pct, { variancePct : 20, doClick : true, offsetY : 30 })
            sleep 1000
        }
        else if InStr(result.comment, "events.title") {
            sleep 1000

            if (!clickedHard) {
                PollPattern(patterns.events.hard, { doClick : true, predicatePattern : patterns.events.hard.enabled, pollInterval : 2000 })
                clickedHard := true
                Continue
            }

            result := FindPattern([patterns.events.overview.500Pct], { variancePct : 20 })
            
            if InStr(result.comment, "overview.500Pct") {
                result.Y := result.Y + 30
                ClickResult(result)
                sleep 250
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
                PollPattern(loopTargets, { clickPattern : patterns.battle.done, pollInterval : 250 })
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

    if (mode && mode != "AutoDailies") {
        ExitApp
    }
}

EventRaidLoop() {
    global patterns, settings
    SetStatus(A_ThisFunc)
    AddLog(A_ThisFunc)

    loopNumChecksBeforeRefresh := settings.eventOptions.raid.loopNumChecksBeforeRefresh ? settings.eventOptions.raid.loopNumChecksBeforeRefresh : 50

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
            ScrollUntilDetect(patterns.dimensionGate.events.banners.raid)
            sleep 3000
        }
        else if InStr(result.comment, "raid.activeBoss") {
            Loop {
                result := PollPattern(patterns.raid.helper, { maxCount : loopNumChecksBeforeRefresh })
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
                PollPattern(patterns.raid.activeBoss, { clickPattern : patterns.battle.done, callback : Func("RaidClickCallback"), pollInterval : 250 })
            }
        }

        sleep 250
    }
}

RaidClickCallback() {
    global patterns, hwnd

    FindPattern(patterns.prompt.close, { doClick : true })
}

EventRaidAutoClaim() {
    global settings, mode, patterns
    SetStatus(A_ThisFunc)
    AddLog(A_ThisFunc)
    
    switch (settings.eventOptions.raid.claimType) {
        case "claim":
            Loop
            {
                result := FindPattern([patterns.raid.claim.prize, patterns.prompt.close], { variancePct : 30, bounds : { x1 : 16, y1 : 282, x2 : 571, y2 : 1200 } })
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
        case "vault":
            Loop
            {
                result := PollPattern([patterns.events.vault.acquired, patterns.prompt.close], { maxCount : 20 })
                if (result.IsSuccess)
                {
                    ClickResult(result)
                }
                else {
                    Break
                }

                sleep 250
            }
        case "innocent":
            Loop
            {
                result := PollPattern([patterns.events.vault.innocentChance, patterns.prompt.close], { maxCount : 20 })
                if (result.IsSuccess)
                {
                    ClickResult(result)
                }
                else {
                    Break
                }

                sleep 250
            }
    }

    if (mode && mode != "AutoDailies") {
        ExitApp
    }
}