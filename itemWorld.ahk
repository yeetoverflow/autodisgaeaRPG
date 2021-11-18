#Include common.ahk

FarmItemWorldAnyLoop(type := "") {
    global patterns, settings
    SetStatus(A_ThisFunc)
    
    sortDone := false
    doWeapon := settings.itemWorldOptions.loop.itemType = "weapon" ? true : false
    settings.itemWorldOptions.bribe := ""        ;shouldn't want to spend game resources while in loop mode
    settings.itemWorldOptions.targetItem := "any"
    settings.itemWorldOptions.farmTrigger := patterns.itemWorld.level
    battleOptions := settings.battleOptions.itemWorld
    battleOptions.preBattle := Func("ItemWorldPreBattle")
    battleOptions.onBattleAction := Func("ItemWorldOnBattleAction")
    battleOptions.donePatterns := [patterns.itemWorld.title, patterns.itemWorld.leave, patterns.itemWorld.armor]
    targetSort := "ascending"
    targetItem := patterns.itemWorld.item.name
    
    if (type = "farmLegendary") {
        settings.itemWorldOptions.targetItem := "legendary"
        settings.itemWorldOptions.farmTrigger := patterns.itemWorld.level.100
        targetSort := "descending"
        targetItem := patterns.itemWorld.item.legendary
        doWeapon := settings.itemWorldOptions.farmLoop.itemType = "weapon" ? true : false
    }

    targeSortInverse := targetSort = "ascending" ? "descending" : "ascending"

    loopTargets := [patterns.stronghold.gemsIcon, patterns.dimensionGate.background, patterns.itemWorld.title, patterns.itemWorld.armor, patterns.itemWorld.leave, patterns.battle.auto]
    Loop {
        result := PollPattern(loopTargets)

        if InStr(result.comment, "stronghold.gemsIcon") {
            FindPattern(patterns.tabs.dimensionGate, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "dimensionGate.background") {
            FindPattern(patterns.dimensionGate.itemWorld, { doClick : true })
            sleep 1000
        }
        else if InStr(result.comment, "itemWorld.title") || InStr(result.comment, "itemWorld.armor") {
            PollPattern(patterns.itemWorld.armor.disabled, { doClick : true, predicatePattern : patterns.itemWorld.armor.enabled })
            if (doWeapon) {
                PollPattern(patterns.itemWorld.weapon.disabled, { doClick : true, predicatePattern : patterns.itemWorld.weapon.enabled })
            }
            
            if (!sortDone) {
                PollPattern(patterns.sort.button, { doClick : true, predicatePattern : patterns.sort.title })
                if (FindPattern(patterns.sort.rarity.disabled).IsSuccess) {
                    PollPattern(patterns.sort.rarity.disabled, { doClick : true, predicatePattern : patterns.sort.rarity.enabled })
                    sleep 100
                }
                if (FindPattern(patterns["sort"][targeSortInverse]["checked"], { variancePct: 5 }).IsSuccess) {
                    PollPattern(patterns["sort"][targetSort]["label"], { variancePct: 5, doClick : true, offsetX : 40, predicatePattern : patterns["sort"][targetSort]["checked"] })
                    sleep 100
                }
                if (FindPattern(patterns["sort"]["prioritizeEquippedItems"]["checked"], { variancePct: 5 }).IsSuccess) {
                    PollPattern(patterns["sort"]["prioritizeEquippedItems"]["checked"], { variancePct: 5, doClick : true, offsetX : 40, predicatePattern : patterns["sort"]["prioritizeEquippedItems"]["unchecked"] })
                    sleep 100
                }

                PollPattern(patterns.prompt.ok, { doClick : true, predicatePattern : itemWorld.title })
                sortDone := true
            }
            
            sleep 500
            PollPattern(targetItem, { doClick : true, predicatePattern : patterns.itemWorld.go })
            PollPattern(patterns.itemWorld.go, { doClick : true, predicatePattern : patterns.battle.start })
            PollPattern(patterns.battle.start, { doClick : true })
            DoItem()
        }
        else if InStr(result.comment, "itemWorld.leave") {
            ClickResult(result)
            sleep 1000
        }
        else if InStr(result.comment, "battle.auto") {
            DoItem()
            sleep 1000
        }
    }
}

FarmItemWorldLegendaryLoop() {
    FarmItemWorldAnyLoop("farmLegendary")
}

FarmItemWorldSingle() {
    global patterns, settings

    settings.itemWorldOptions.farmTrigger := patterns.itemWorld.level
    battleOptions := settings.battleOptions.itemWorld
    battleOptions.preBattle := Func("ItemWorldPreBattle")
    battleOptions.onBattleAction := Func("ItemWorldOnBattleAction")
    battleOptions.donePatterns := [patterns.itemWorld.title, patterns.itemWorld.leave]

    PollPattern(patterns.battle.skills.label, { doClick : true })

    result := FindDrop()
    if (result.IsSuccess && (settings.itemWorldOptions.targetItem = "any" || InStr(settings.itemWorldOptions.targetItem, result.type))) {
        Return
    }

    if (FindPattern(patterns.battle.wave.3over3).IsSuccess && !FindPattern(patterns.enemy.A).IsSuccess)
    {
        GiveUpAndTryAgain(battleOptions)
    }
    DoItem()
}

ItemWorldPreBattle() {
    SetStatus("DoItem")
    global patterns, settings

    result := FindPattern(settings.itemWorldOptions.farmTrigger, { variancePct : 1 })

    if (result.IsSuccess) {
        if (!FindPattern([patterns.battle.done, patterns.itemWorld.drop], { variancePct : 15 }).IsSuccess)
        {
            DoItemDrop()
        }
    }
}

ItemWorldOnBattleAction(result) {
    global patterns

    IF FindPattern(patterns.prompt.innocentIsAppearing).IsSuccess {
        FindPattern(patterns.prompt.no, { doClick : true })
        sleep 1000
    }

    IF FindPattern(patterns.itemWorld.subdue).IsSuccess
        DoSubdue()
    Else If (result)
        ClickResult(result)
}

; DoItemLoop() {
;     SetStatus(A_ThisFunc)
;     global patterns

;     result := FindPattern(patterns.battle.auto) 
;     if (InStr(result.comment, "battle.auto")) {
;         DoItem()
;     }

;     Loop {
;         FindPattern(patterns.itemWorld.leave, { doClick : true })
;         PollPattern(patterns.itemWorld.armorDisabled, { doClick : true, predicatePattern : patterns.itemWorld.armor.enabled })
;         PollPattern(patterns.itemWorld.item.name, { doClick : true, predicatePattern : patterns.itemWorld.go })
;         PollPattern(patterns.itemWorld.go, { doClick : true, predicatePattern : patterns.battle.start })
;         PollPattern(patterns.battle.start, { doClick : true })
;         DoItem()
;     }
; }

DoItem() {
    SetStatus(A_ThisFunc)
    global patterns, settings

    battleOptions := settings.battleOptions.itemWorld

    Loop {
        DoBattle(battleOptions)
        PollPattern([patterns.itemWorld.nextLevel, patterns.itemWorld.leave], { predicatePattern: [patterns.itemWorld.armor, patterns.battle.auto], doClick : true, doubleCheck : true, doubleCheckDelay : 250, callback : Func("MiddleClickCallback") })
        if (FindPattern(patterns.itemWorld.armor)) {
            sleep 1000
            Break
        }
    }
}

DoItemDrop() {
    SetStatus(A_ThisFunc, 2)
    global patterns, settings

    battleOptions := settings.battleOptions.itemWorld

    actions := []
    singleTargetActions := []

    ;loop through skill list
    for k, v in battleOptions.skills
    {
        actions.Push(patterns.battle.skills[v])
    }

    for k, v in battleOptions.singleTargetSkills
    {
        singleTargetActions.Push(patterns.battle.skills[v])
    }

    actions.Push(patterns.battle.attack)
    singleTargetActions.Push(patterns.battle.attack)

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
        
        loop {
            PollPattern(patterns.enemy.A, { variancePct : 1, doClick : true, offsetX : 40, offsetY : -30 })
            sleep 400
            result := FindPattern(patterns.enemy.target)
        } until (result.IsSuccess)

        ;check 4 times just in case
        loop 4 {
            loop {
                if (FindPattern(patterns.battle.skills.label.IsSuccess)) {
                    result := FindPattern(singleTargetActions)
                    if (FindPattern(patterns.enemy.A, { variancePct : 1 }).IsSuccess) {
                        ClickResult(result)
                    }
                }

                sleep 200
                result := FindPattern(patterns.enemy.A, { variancePct : 1 })
            } until (!result.IsSuccess)
        }
        
        sleep 1500
        result := FindDrop()

        if (result.IsSuccess && (settings.itemWorldOptions.targetItem = "any" || InStr(settings.itemWorldOptions.targetItem, result.type))) {
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
    PollPattern(patterns.menu.button, { doClick : true, predicatePattern : patterns.menu.giveUp })
    PollPattern(patterns.menu.giveUp, { doClick : true, predicatePattern : patterns.prompt.yes })
    PollPattern(patterns.prompt.yes, { doClick : true, predicatePattern : patterns.prompt.retry })
    PollPattern(patterns.prompt.retry, { doClick : true })
    PollPattern(patterns.battle.auto)

    if (battleOptions.allyTarget && battleOptions.allyTarget != "None") {
        sleep 500
        allyTarget := patterns.battle.target[battleOptions.allyTarget]
        Loop {
            FindPattern(allyTarget, { doClick : true })
            sleep 250
            result := FindPattern(patterns.battle.target.on, { variancePct : 20 })
        } until (result.IsSuccess)
    }
}

FindDrop() {
    global patterns

    legendResult := FindPattern(patterns.itemWorld.drop, { variancePct : 15, bounds : { x1 : 359, y1 : 51, x2 : 378, y2 : 89 } })
    rareResult := FindPattern(patterns.itemWorld.drop, { variancePct : 15, bounds : { x1 : 291, y1 : 51, x2 : 312, y2 : 89 } })
    anyResult := FindPattern(patterns.itemWorld.drop, { variancePct : 15 })
    
    result := {}

    if (legendResult.IsSuccess) {
        Return { type : "legendary", IsSuccess : true }
    }

    if (rareResult.IsSuccess) {
        Return { type : "rare", IsSuccess : true }
    }
    
    if (anyResult.IsSuccess) {
        Return { type : "any", IsSuccess : true }
    }

    Return { IsSuccess : false }
}

DoSubdue() {
    global patterns, settings
    
    if (settings.itemWorldOptions.bribe && settings.itemWorldOptions.bribe != "None") {
        PollPattern(patterns.itemWorld.bribe, { doClick : true, predicatePattern : patterns.itemWorld.bribe[settings.itemWorldOptions.bribe] })
        PollPattern(patterns.itemWorld.bribe[settings.itemWorldOptions.bribe], { doClick : true })
        PollPattern(patterns.itemWorld.bribe.confirm, { doClick : true, predicatePattern : patterns.itemWorld.subdue })
    }

    PollPattern([patterns.itemWorld.subdue], { doClick : true })
}



