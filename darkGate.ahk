
if (!patterns)
{
    patterns := {}
}

DoDarkGateHL() {
    DoDarkGate("hl")
}

DoDarkGateMatsHuman() {
    DoDarkGate("matsHuman")
}

DoDarkGateMatsMonster() {
    DoDarkGate("matsMonster")
}

DoDarkGate(type) {
    global mode, patterns, settings, guiHwnd
    ControlGetText, gateCount, edit3, % "ahk_id " . guiHwnd
    SetStatus(gateCount, 2)

    gateCount++

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
            FindPattern(patterns.dimensionGate.darkGates, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "darkGates.title") {
            FindPattern(targetBlock, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "darkGates.stage.title") {
            gateCount--
            ControlSetText, edit3, % gateCount,  % "ahk_id " . guiHwnd
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
            PollPattern(loopTargets, { callback : Func("MiddleClickCallback"), pollInterval : 250 })
        }
    }

    if (mode) {
        ExitApp
    }
}