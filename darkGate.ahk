
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
    
    targetCompanions := []
    for k, v in battleOptions.companions
        targetCompanions.push(patterns["companions"][v])

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
            FindAndClickListTarget(patterns.darkGates.stage.threeStars, patterns.companions.refresh)
            sleep 1000
        }
        else if InStr(result.comment, "companions.title") {
            FindAndClickListTarget(targetCompanions)
            sleep 1000
        }
        else if InStr(result.comment, "battle.title") {
            FindPattern(patterns.battle.start, { doClick : true })
            sleep 500
            if (HandleInsufficientAP()) {
                PollPattern(patterns.battle.start, { variancePct : 5, doClick : true }) 
            }
            sleep 1000
        }
        else if InStr(result.comment, "battle.auto") {
            DoBattle(battleOptions)
            PollPattern(loopTargets, { callback : Func("MiddleClickCallback"), pollInterval : 250 })
        }
        else if InStr(result.comment, "battle.prompt.battleAgain") {
            FindPattern(patterns.battle.prompt.battle, { doClick : true })
            sleep 500
            if (HandleInsufficientAP()) {
                PollPattern(patterns.battle.prompt.battle, { variancePct : 5, doClick : true }) 
            }
        }
    }

    if (mode) {
        ExitApp
    }
}