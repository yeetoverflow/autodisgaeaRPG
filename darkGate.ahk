
if (!patterns)
{
    patterns := {}
}

AutoDarkGate(type = "", opts = "") {
    global mode, patterns, settings, darkGateCountHwnd, darkGateSkipCountHwnd, darkGateUseGateKeysOnFirstSkipHwnd

    firstGate := true
    if (!type && !settings.darkGateOptions.selectedGate) {
        MsgBox, No gate type selected
        return
    } else if (!type) {
        type := settings.darkGateOptions.selectedGate
    }

    if (opts.count) {
        ControlSetText,, % opts.count, % "ahk_id " . darkGateCountHwnd
        ControlSetText,, % opts.skip, % "ahk_id " . darkGateSkipCountHwnd
    }

    if (opts.useGateKeysOnFirstSkip) {
        Control, Check,,, % "ahk_id " . darkGateUseGateKeysOnFirstSkipHwnd
    }
    
    SetStatus(A_ThisFunc . "_" . type)
    AddLog(A_ThisFunc . "_" . type)

    ControlGetText, gateCount,, % "ahk_id " . darkGateCountHwnd
    ControlGetText, gateSkipCount,, % "ahk_id " . darkGateSkipCountHwnd
    SetStatus(gateCount, 2)

    if (type = "hl") {
        battleOptions := settings.battleOptions.darkGateHL
        targetBlock := patterns.darkGates.hl.block
    }
    else {
        battleOptions := settings.battleOptions.darkGateMats
        if (type == "matsHuman") {
            targetBlock := patterns.darkGates.mats.human.block
        } else if (type == "matsMonster") {
            targetBlock := patterns.darkGates.mats.monster.block
        }
    }

    battleOptions.skipTicketCount := gateSkipCount
    battleOptions.startPatterns := [patterns.battle.start, patterns.battle.prompt.battle]

    loopTargets := [patterns.stronghold.gemsIcon, patterns.dimensionGate.background, patterns.darkGates.title
        , patterns.darkGates.stage.title, patterns.companions.title, patterns.battle.title, patterns.battle.auto
        , patterns.battle.prompt.battleAgain]

    Loop {
        result := PollPattern(loopTargets)

        if InStr(result.comment, "stronghold.gemsIcon") {
            FindPattern(patterns.tabs.dimensionGate, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "dimensionGate.background") {
            FindPattern(patterns.dimensionGate.darkGates, { variancePct : 30, doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "darkGates.title") {
            FindPattern(targetBlock, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "darkGates.stage.title") {
            if (firstGate) {
                firstGate := false
            }
            else {
                gateCount--
                if (mode = "AutoDailies" || InStr(mode, "AutoDailyDarkGate")) {
                    if (mode = "AutoDailies") {
                        currentDaily := settings.dailies.current
                    } else {
                        currentDaily := mode
                    }
                    
                    IncrementDailyStat([currentDaily, "count"])
                }
            }
            
            ControlSetText,, % gateCount, % "ahk_id " . darkGateCountHwnd
            SetStatus(gateCount, 2)

            if (gateCount <= 0) {
                Break
            }
            ; FindAndClickListTarget(patterns.darkGates.stage.threeStars, patterns.companions.refresh)
            ScrollUntilDetect(patterns.darkGates.stage.threeStars, { predicatePattern : patterns.companions.refresh })
            sleep 1000
        }
        else if InStr(result.comment, "companions.title") || InStr(result.comment, "battle.auto") || InStr(result.comment, "battle.title") || InStr(result.comment, "battle.prompt.battleAgain") {
            DoBattle(battleOptions)
            PollPattern(loopTargets, { clickPattern : patterns.battle.done, pollInterval : 250 })
        }
    }

    if (mode && mode != "AutoDailies") {
        ExitApp
    }
}