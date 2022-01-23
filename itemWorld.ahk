#Include common.ahk


GrindItemWorldLoop1() {
    global settings
    GrindItemWorld(settings.itemWorldOptions.1)
}

GrindItemWorldSingle1() {
    global settings
    GrindItemWorld(settings.itemWorldOptions.1, true)
}

GrindItemWorld(itemWorldOptions, oneTime := false) {
    global mode, patterns, settings
    SetStatus(A_ThisFunc)
    AddLog(A_ThisFunc)

    sortDone := false
    doWeapon := itemWorldOptions.targetItemType = "weapon" ? true : false
    
    targetItemSort := itemWorldOptions.targetItemSort
    targetItemSortOrder := itemWorldOptions.targetItemSortOrder
    prioritizeEquippedItems := itemWorldOptions.prioritizeEquippedItems
    targetItemSortOrderInverse := targetItemSortOrder = "ascending" ? "descending" : "ascending"
    lootTarget := itemWorldOptions.lootTarget
    bribe := itemWorldOptions.bribe

    switch (itemWorldOptions.targetItemRarity) {
        case "any":
            targetItem := patterns.itemWorld.itemTarget.rarity
        case "legendary":
            targetItem := patterns.itemWorld.itemTarget.rarity.legendary
        case "rareOrLegendary":
            targetItem := [patterns.itemWorld.itemTarget.rarity.rare, patterns.itemWorld.itemTarget.rarity.legendary]
        case "rare":
            targetItem := patterns.itemWorld.itemTarget.rarity.rare
        case "common":
            targetItem := patterns.itemWorld.itemTarget.rarity.common
    }
    
    if (itemWorldOptions.farmLevels) {
        farmTrigger := []
        for k, v in itemWorldOptions.farmLevels {
            farmTrigger.push(patterns.itemWorld.level[v])
        }
    }

    battleOptions := settings.battleOptions.itemWorld
    ;battleOptions.donePatterns := [patterns.itemWorld.title, patterns.itemWorld.leave, patterns.itemWorld.armor]
    battleOptions.donePatterns := ""
    battleOptions.preBattle := Func("ItemWorldPreBattle").Bind(farmTrigger, lootTarget)
    battleOptions.onBattleAction := Func("ItemWorldOnBattleAction").Bind(bribe)

    loopTargets := [patterns.stronghold.gemsIcon, patterns.dimensionGate.background, patterns.itemWorld.title, patterns.itemWorld.leave, patterns.battle.auto]
    Loop {
        result := PollPattern(loopTargets)

        if InStr(result.comment, "stronghold.gemsIcon") {
            FindPattern(patterns.tabs.dimensionGate, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "dimensionGate.background") {
            FindPattern(patterns.dimensionGate.itemWorld, { doClick : true, variancePct : 30 })
            sleep 1000
        }
        else if InStr(result.comment, "itemWorld.title") {
            PollPattern(patterns.itemWorld.armor.disabled, { doClick : true, predicatePattern : patterns.itemWorld.armor.enabled, pollInterval : 2000 })
            if (doWeapon) {
                PollPattern(patterns.itemWorld.weapon.disabled, { doClick : true, predicatePattern : patterns.itemWorld.weapon.enabled, pollInterval : 2000 })
            }
            
            if (!sortDone) {
                PollPattern(patterns.sort.button, { doClick : true, predicatePattern : patterns.sort.title })
                if (targetItemSort != "retain" && FindPattern(patterns["sort"][targetItemSort]["disabled"], { variancePct : 20 }).IsSuccess) {
                    PollPattern(patterns["sort"][targetItemSort]["disabled"], { variancePct : 20, doClick : true, predicatePattern : patterns["sort"][targetItemSort]["enabled"], pollInterval : 2000 })
                    sleep 100
                }

                if (targetItemSortOrder != "retain" && FindPattern(patterns["sort"][targetItemSortOrderInverse]["checked"], { variancePct: 5 }).IsSuccess) {
                    PollPattern(patterns["sort"][targetItemSortOrder]["label"], { variancePct: 5, doClick : true, offsetX : 40, predicatePattern : patterns["sort"][targetItemSortOrder]["checked"], pollInterval : 2000 })
                    sleep 100
                }

                switch (prioritizeEquippedItems) {
                    case "yes":
                        if (FindPattern(patterns["sort"]["prioritizeEquippedItems"]["unchecked"], { variancePct: 5 }).IsSuccess) {
                            PollPattern(patterns["sort"]["prioritizeEquippedItems"]["unchecked"], { variancePct: 5, doClick : true, offsetX : 40, predicatePattern : patterns["sort"]["prioritizeEquippedItems"]["checked"], pollInterval : 2000 })
                            sleep 100
                        }
                    case "no":
                        if (FindPattern(patterns["sort"]["prioritizeEquippedItems"]["checked"], { variancePct: 5 }).IsSuccess) {
                            PollPattern(patterns["sort"]["prioritizeEquippedItems"]["checked"], { variancePct: 5, doClick : true, offsetX : 40, predicatePattern : patterns["sort"]["prioritizeEquippedItems"]["unchecked"], pollInterval : 2000 })
                            sleep 100
                        }
                }

                PollPattern(patterns.prompt.ok, { doClick : true, predicatePattern : itemWorld.title })
                sortDone := true
            }
            
            sleep 500
            PollPattern(targetItem, { doClick : true, predicatePattern : patterns.itemWorld.go, pollInterval : 2000 })
            PollPattern(patterns.itemWorld.go, { doClick : true, predicatePattern : patterns.battle.start })
            PollPattern(patterns.battle.start, { doClick : true })
            DoItem()
            sleep 2000
            if (oneTime) {
                Break
            }
        }
        else if InStr(result.comment, "battle.auto") {
            DoItem()
            sleep 2000
            if (oneTime) {
                Break
            }
        }
    }

    if (mode && mode != "AutoDailies") {
        ExitApp
    }
}

GrindItemWorldLoop2() {
    global settings
    GrindItemWorld(settings.itemWorldOptions.2)
}

GrindItemWorldSingle2() {
    global settings
    GrindItemWorld(settings.itemWorldOptions.2, true)
}

ItemWorldPreBattle(farmTrigger, lootTarget) {
    SetStatus("DoItem")
    global patterns, settings

    result := FindPattern(farmTrigger, { variancePct : 1, bounds : { x1 : 168, y1 : 25, x2 : 404, y2 : 85 } })

    if (result.IsSuccess) {
        if (!FindPattern([patterns.battle.done, patterns.itemWorld.drop], { variancePct : 15 }).IsSuccess)
        {
            DoItemDrop(lootTarget)
        }
    }
}

;https://lexikos.github.io/v2/docs/objects/Functor.htm
ItemWorldOnBattleAction(bribe, result) {
    global patterns

    IF FindPattern(patterns.prompt.innocentIsAppearing, { bounds : { x1 : 128, y1 : 433, x2 : 447, y2 : 519 } }).IsSuccess {
        FindPattern(patterns.prompt.no, { doClick : true })
        sleep 1000
    }

    IF FindPattern(patterns.itemWorld.subdue, { bounds : { x1 : 270, y1 : 424, x2 : 443, y2 : 570 } }).IsSuccess
        DoSubdue(bribe)
    Else If (result)
        ClickResult(result)
}

DoItem() {
    SetStatus(A_ThisFunc)
    AddLog(A_ThisFunc)
    startTick := A_TickCount

    global patterns, settings

    battleOptions := settings.battleOptions.itemWorld

    Loop {
        DoBattle(battleOptions)

        ;Would rather know how it's getting stuck here but oh well
        if (FindPattern(patterns.itemWorld.title).IsSuccess) {
            Break
        }

        result := PollPattern([patterns.itemWorld.nextLevel, patterns.itemWorld.leave], { predicatePattern: [patterns.itemWorld.title, patterns.battle.auto], doClick : true, doubleCheck : true, doubleCheckDelay : 250, pollInterval : 250, clickPattern : patterns.battle.done })
        if (InStr(result.comment, "itemWorld.leave")) {
            Sleep, 1000
            Break
        }
    }

    FindPattern(patterns.blueStacks.trimMemory, { doClick : true})
    AddLog(A_ThisFunc . " " . DisplayTimeStampDiff(startTick, A_TickCount))
}

DoItemDrop(lootTarget) {
    SetStatus(A_ThisFunc, 2)
    AddLog(A_ThisFunc)
    global patterns, settings

    battleOptions := settings.battleOptions.itemWorld

    targetAllies := []
    for k, v in battleOptions.allyTarget
        targetAllies.push(patterns["battle"]["target"]["ally"][v])

    userPatternSkills := settings.userPatterns.battle.skills
    actions := []
    singleTargetActions := []
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

        if (userPatternSkills[v].singleTarget) {
            singleTargetActions.Push(patterns.battle.skills[v])
        }
    }

    actions.Push(highPrioritySkills)
    actions.Push(mediumPrioritySkills)
    actions.Push(lowPrioritySkills)
    actions.Push(patterns.battle.attack)
    singleTargetActions.Push(patterns.battle.attack)

    if (battleOptions.allyTarget && targetAllies.Length() > 0 && !allyTargeted) {
        sleep 500
        Loop {
            FindPattern(targetAllies, { doClick : true })
            sleep 500
            result := FindPattern(patterns.battle.target.on, { variancePct : 20 })
        } until (result.IsSuccess)
        allyTargeted := true
    }

    Loop {
        count := 0
        Loop {
            FindPattern(patterns.battle.auto.enabled, { doClick : true })

            result := FindPattern([patterns.battle.wave.1over3, patterns.battle.wave.2over3, patterns.battle.wave.3over3])
            if (result.IsSuccess) {
                RegExMatch(result.comment, "(?P<wave>\d)over(?P<numWaves>\d)", matches)
                SetStatus(A_ThisFunc . ": " . matchesWave . "/" .  matchesNumWaves . "(" . count . ")", 2)
                if (InStr(result.comment, "3over3"))
                    Break
            }

            result := FindPattern(patterns.battle.skills.label)
            if (result.IsSuccess) {
                result := FindPattern([patterns.battle.wave.3over3, actions], { variancePct : 5, doClick : true, doubleCheck: true, doubleCheckDelay: 250 })
                if (InStr(result.comment, "3over3")) {
                    Break
                }
            }

            sleep, 250
            
            if (FindPattern([patterns.battle.done, patterns.itemWorld.drop], { variancePct : 15 }).IsSuccess) {
                SetStatus(A_ThisFunc . ": Done", 2)
                Break
            }

            count++
            SetStatus(A_ThisFunc . ": " . matchesWave . "/" .  matchesNumWaves . "(" . count . ")", 2)

            if (mod(count, 250) = 0) {
                Resize(true)
            }
        }

        if (FindPattern([patterns.battle.done, patterns.itemWorld.drop], { variancePct : 15 }).IsSuccess) {
            SetStatus(A_ThisFunc . ": Done", 2)
            Break
        }

        PollPattern(patterns.battle.skills.label)

        Loop {
            FindPattern(patterns.enemy.A, { doClick : true, bounds : { x1 : 270, x2 : 330, y1 : 420, y2 : 470 }, offsetX : 40, offsetY : -30 })
            sleep 250

            Loop, 10 {
                result := FindPattern(patterns.enemy.target)
            } until (result.IsSuccess)
        } until (result.IsSuccess)

        Loop {
            PollPattern(patterns.battle.skills.label)

            Loop, 10 {
                result := FindPattern(patterns.enemy.A, { bounds : { x1 : 270, x2 : 330, y1 : 420, y2 : 470 } })
            } until (result.IsSuccess)

            if (result.IsSuccess) {
                FindPattern(singleTargetActions, { doClick : true })
                sleep 250
            }
        } until (!result.IsSuccess)
        
        sleep 1500
        result := FindDrop(lootTarget)

        AddLog("Detected drop: " . result.type)

        if (result.IsSuccess && (lootTarget = "any" || InStr(lootTarget, result.type))) {
            Break
        }
        Else {
            GiveUpAndTryAgain(battleOptions)
        }
        sleep 1000
    }
}

GiveUpAndTryAgain(battleOptions) {
    global patterns

    result := FindPattern(patterns.prompt.close)

    if (!result.IsSuccess) {
        PollPattern(patterns.menu.button, { doClick : true, predicatePattern : patterns.menu.giveUp })
    }
    
    PollPattern(patterns.menu.giveUp, { doClick : true, predicatePattern : patterns.prompt.yes })
    PollPattern(patterns.prompt.yes, { doClick : true, predicatePattern : patterns.prompt.retry })
    PollPattern(patterns.prompt.retry, { doClick : true })
    PollPattern(patterns.battle.auto)

    targetAllies := []
    for k, v in battleOptions.allyTarget
        targetAllies.push(patterns["battle"]["target"]["ally"][v])

    if (battleOptions.allyTarget && targetAllies.Length() > 0 && !allyTargeted) {
        sleep 500
        Loop {
            FindPattern(targetAllies, { doClick : true })
            sleep 500
            result := FindPattern(patterns.battle.target.on, { variancePct : 20 })
        } until (result.IsSuccess)
        allyTargeted := true
    }
}

FindDrop(lootTarget := "") {
    global settings, patterns

    findDropMode := settings.itemWorldOptions.findDropMode

    if (findDropMode = "menu") {
        PollPattern(patterns.menu.button, { doClick : true, predicatePattern : patterns.menu.giveUp })
        sleep 1000
        ; legendResult := FindPattern(patterns.itemWorld.drop, { variancePct : 15, bounds : { x1 : 462, y1 : 0, x2 : 491, y2 : 1000 } })
        ; rareResult := FindPattern(patterns.itemWorld.drop, { variancePct : 15, bounds : { x1 : 374, y1 : 0, x2 : 404, y2 : 1000 } })
        legendResult := FindPattern(patterns.itemWorld.drop, { variancePct : 15, bounds : { x1 : 452, y1 : 0, x2 : 501, y2 : 1000 } })
        rareResult := FindPattern(patterns.itemWorld.drop, { variancePct : 15, bounds : { x1 : 364, y1 : 0, x2 : 414, y2 : 1000 } })
        anyResult := FindPattern(patterns.itemWorld.drop, { variancePct : 15 })

        if (settings.debug.drop) {
            FindText().ScreenShot()
        }
    }
    else {
        ; legendResult := FindPattern(patterns.itemWorld.drop, { variancePct : 15, bounds : { x1 : 359, y1 : 51, x2 : 378, y2 : 89 } })
        ; rareResult := FindPattern(patterns.itemWorld.drop, { variancePct : 15, bounds : { x1 : 291, y1 : 51, x2 : 312, y2 : 89 } })
        legendResult := FindPattern(patterns.itemWorld.drop, { variancePct : 15, bounds : { x1 : 349, y1 : 0, x2 : 388, y2 : 1000 } })
        rareResult := FindPattern(patterns.itemWorld.drop, { variancePct : 15, bounds : { x1 : 281, y1 : 0, x2 : 322, y2 : 1000 } })
        anyResult := FindPattern(patterns.itemWorld.drop, { variancePct : 15 })
        if (settings.debug.drop) {
            FindText().ScreenShot()
        }
    }

    result := { IsSuccess : false, type : "none" }

    if (legendResult.IsSuccess) {
        result := { type : "legendary", IsSuccess : true, X : legendResult.X, Y : legendResult.Y }
    }
    else if (rareResult.IsSuccess) {
        result := { type : "rare", IsSuccess : true, X : rareResult.X, Y : rareResult.Y }
    }
    else if (anyResult.IsSuccess) {
        result := { type : "any", IsSuccess : true, X : anyResult.X, Y : anyResult.Y }
    }

    if (findDropMode = "menu" && result.IsSuccess && (lootTarget = "any" || InStr(lootTarget, result.type))) {
        PollPattern(patterns.prompt.close, { doClick : true, predicatePattern : patterns.menu.button })
    }

    if (settings.debug.drop) {
        IF !FileExist("screenCaps")
        {
            FileCreateDir, screenCaps
        }

        FindText().SavePic("screenCaps/" . A_Now . "_" . (result.type ? result.type : "none") . ".png")
    }

    Return result
}

DoSubdue(bribe) {
    global patterns
    AddLog(A_ThisFunc)
    
    if (bribe && bribe != "None") {
        PollPattern(patterns.itemWorld.bribe.block, { doClick : true, predicatePattern : patterns.itemWorld.bribe[bribe] })
        PollPattern(patterns.itemWorld.bribe[bribe], { doClick : true })
        PollPattern(patterns.itemWorld.bribe.confirm, { doClick : true, predicatePattern : patterns.itemWorld.subdue })
    }

    PollPattern([patterns.itemWorld.subdue], { doClick : true })
}

