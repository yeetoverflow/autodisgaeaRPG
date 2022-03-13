#SingleInstance, off
#include settings.ahk
#Include common.ahk
#Include itemWorld.ahk
#Include events.ahk
#Include darkGate.ahk
#include ui.ahk

;A_Args.1 is the executable
;A_Args.2 is the mode (function to be called)

mode := StrReplace(A_Args.2, "mode=")
msgToMode := { 0x1001 : "EventStoryFarm"
             , 0x1002 : "EventStory500Pct"
             , 0x1003 : "EventRaidLoop"
             , 0x1004 : "AutoShop"
             , 0x1005 : "AutoDarkAssembly"
             , 0x1006 : "AutoDailyDarkGateHL"
             , 0x1007 : "AutoDailyDarkGateMatsHuman"
             , 0x1008 : "AutoDailyDarkGateMatsMonster"
             , 0x1009 : "AutoClear"
             , 0x1010 : "FarmItemWorldSingle"
             , 0x1011 : "EventAutoClear"
             , 0x1012 : "EventRaidAutoClaim"
             ;, 0x1013 : "EventRaidAutoVault"
             , 0x1014 : "GrindItemWorldLoop1"
             , 0x1015 : "GrindItemWorldSingle1"
             , 0x1016 : "GrindItemWorldLoop2"
             , 0x1017 : "GrindItemWorldSingle2"
             , 0x1018 : "Battle"
             , 0x1019 : "AutoFriends"
             , 0x1020 : "AutoFish"
             , 0x1021 : "AutoDailyCharacterGate1"
             , 0x1022 : "AutoDailyEventReview1"
             , 0x1023 : "AutoDailySummon"
             , 0x1024 : "AutoDope"
             , 0x1025 : "AutoDarkGate"
             , 0x1026 : "AutoDarkAssemblyHL"
             , 0x1027 : "AutoDarkAssemblyDrops"
             , 0x1028 : "AutoDarkAssemblyEvent60"
             , 0x1029 : "AutoDailies"
             , 0x1030 : "GoToStronghold"
             , 0x1031 : "AutoDailyEventStoryFarm"
             , 0x1032 : "AutoShopItems"
             , 0x1033 : "AutoMissionClaim" }
modeToMsg := {}
handlers := {}

OnMessage(0x1000, "OnCustomMessage")
for k, v in msgToMode {
    modeToMsg[v] := k
    handlers[v] := { Func : Func(v) }
    OnMessage(k, "OnCustomMessage")
}

if (mode) {
    windowTarget := StrReplace(A_Args.1, "id=")
    
    InitWindow()
    
    msg := modeToMsg[mode]
    if (!msg) {
        MsgBox, % "Unmapped message: " . msg
        ExitApp
    }
    ;Send a start message
    PostMessage, % msg, 1, 0, , % "ahk_id " . guiHwnd

    ;https://www.autohotkey.com/board/topic/21727-change-tooltip-on-trayicon-hover/
    Menu, Tray, Tip, % windowTarget . " - " . mode
    %mode%()
}
else {
    OnMessage(0x201,"WM_LBUTTONDOWN")

    ResetUI()

    WinSetTitle, % "ahk_id " . guiHwnd,, % settings.window.name
    ;WinSetTitle, % "ahk_id " . guiHwnd,, % guiHwnd
    Menu, Tray, Tip, % settings.window.name
}

Return

Battle() {
    SetStatus(A_ThisFunc)
    global settings, patterns, battleCountHwnd, mode
    Gui Submit, NoHide
    
    battleOptions := settings["battleOptions"][settings.battleContext]
    battleOptions.donePatterns := [patterns.raid.appear.advanceInStory]
    battleOptions.startPatterns := [patterns.battle.start]
    ControlGetText, battleCount,, % "ahk_id " . battleCountHwnd

    result := FindPattern([patterns.battle.auto.enabled, patterns.battle.auto.disabled]) 
    if (InStr(result.comment, "battle.auto")) {
        DoBattle(battleOptions)
        battleCount--
        ControlSetText,, % battleCount, % "ahk_id " . battleCountHwnd
    }

    SetStatus(battleCount, 2)

    while battleCount > 0 {
        PollPattern([patterns.battle.start, patterns.battle.prompt.battle])
        result := PollPattern([patterns.battle.start, patterns.battle.prompt.battle], { doClick : true
            , predicatePattern : [patterns.battle.auto, patterns.companions.refresh, patterns.prompt.insufficientAP] })
        sleep 500
        
        DoBattle(battleOptions)
        
        sleep 1000
        battleCount--
        ControlSetText,, % battleCount, % "ahk_id " . battleCountHwnd

        PollPattern([patterns.battle.start, patterns.battle.prompt.battle], { clickPattern : patterns.battle.done, pollInterval : 250 })
    }

    if (mode && mode != "AutoDailies") {
        ExitApp
    }
}

BattleMiddleClickCallback() {
    global patterns

    Click("x300 y150")

    result := FindPattern(patterns.raid.appear.advanceInStory)
    if (result.IsSuccess) {
        ClickResult(result)
    }

    Resize()
}

ScreenCap() {
    global hwnd
    Resize()
    sleep 500

    ; FindText().ScreenShot()
    ; FindText().SavePic("cap_" . A_Now . ".png")

    FindText().BindWindow(hwnd)>
    FindText().ScreenShot()
    FindText().SavePic("cap_mode_0.png")

    sleep 250

    FindText().BindWindow(hwnd,1)>
    FindText().ScreenShot()
    FindText().SavePic("cap_mode_1.png")

    sleep 250

    FindText().BindWindow(hwnd,2)>
    FindText().ScreenShot()
    FindText().SavePic("cap_mode_2.png")

    sleep 250

    FindText().BindWindow(hwnd,3)>
    FindText().ScreenShot()
    FindText().SavePic("cap_mode_3.png")

    sleep 250

    FindText().BindWindow(hwnd,4)>
    FindText().ScreenShot()
    FindText().SavePic("cap_mode_4.png")

    ; FindText().BindWindow(0)>
    ; FindText().ScreenShot()
    ; FindText().SavePic("cap_mode_none.png")

    ; sleep 250
}

AutoClear() {
    global patterns, settings
    SetStatus(A_ThisFunc)
    AddLog(A_ThisFunc)

    battleOptions := settings["battleOptions"][settings.battleContext]
    autoRefillAP.autoRefillAP := false
    battleOptions.donePatterns := [patterns.raid.appear.advanceInStory]
    battleOptions.startPatterns := [patterns.battle.start]

    loopTargets := [patterns.general.autoClear.new, patterns.companions.title, patterns.general.autoClear.skip, patterns.general.autoClear.areaClear, patterns.raid.appear.advanceInStory]
    Loop {
        result := PollPattern(loopTargets)

        if InStr(result.comment, "general.autoClear.new") || InStr(result.comment, "general.autoClear.skip") || InStr(result.comment, "general.autoClear.areaClear") {
            ClickResult(result)
            sleep, 50
            ClickResult(result)

            if InStr(result.comment, "general.autoClear.skip") {
                PollPattern(loopTargets)
            }
        }
        else if InStr(result.comment, "companions.title") {
            DoBattle(battleOptions)
            PollPattern(loopTargets, { clickPattern : patterns.battle.done, pollInterval : 250 })
        }
        else if InStr(result.comment, "raid.appear.advanceInStory") {
            PollPattern(patterns.raid.helpRequests, { doClick : true, predicatePattern : patterns.prompt.ok })
            PollPattern(patterns.prompt.ok, { doClick : true, predicatePattern : patterns.raid.appear.advanceInStory })
            PollPattern(patterns.raid.appear.advanceInStory, { doClick : true, predicatePattern : patterns.stage.back })
            sleep, 1000
        }
    }
}

AutoShopItems() {
    AutoShop("items")
}

AutoShop(shopType := "") {
    global settings, patterns, mode
    SetStatus(A_ThisFunc)
    AddLog(A_ThisFunc)
    
    done := false

    if (!shopType) {
        shopType := settings.shop.shopType
        skipRefresh := settings.shop.skipRefresh
    }

    switch (shopType) {
        case "items":
            Loop {
                result := FindPattern([patterns.stronghold.gemsIcon, patterns.shop.items.tab, patterns.shop.items.hl.disabled, patterns.shop.items.hl.enabled])
                
                if InStr(result.comment, "stronghold.gemsIcon") {
                    PollPattern(patterns.tabs.shop, { doClick : true })
                } else if InStr(result.comment, "shop.items.tab") || InStr(result.comment, "shop.items.hl.disabled") {
                    ClickResult(result)
                } else if InStr(result.comment, "shop.items.hl.enabled") {
                    Loop {
                        result := FindPattern(patterns.shop.items.block)

                        if (result.IsSuccess) {
                            ClickResult(result)
                            PollPattern(patterns.slider.max, { doClick : true, variancePct : 1 })
                            PollPattern(patterns.prompt.yes, { doClick : true, predicatePattern : patterns.prompt.close })
                            PollPattern(patterns.prompt.close, { doClick : true, predicatePattern : patterns.shop.items.hl.enabled })
                            sleep, 1500
                        }
                    } until (!result.IsSuccess)

                    done := true
                }

                sleep, 250
            } until (done)
        case "equipment":
            Loop {
                result := FindPattern([patterns.stronghold.gemsIcon, patterns.shop.equipment.tab, patterns.shop.equipment.title])
                
                if InStr(result.comment, "stronghold.gemsIcon") {
                    PollPattern(patterns.tabs.shop, { doClick : true })
                } else if InStr(result.comment, "shop.equipment.tab") {
                    ClickResult(result)
                } else if InStr(result.comment, "shop.equipment.title") {
                    result := FindPattern(patterns.shop.zeroRefreshRemaining)
                    if (result.IsSuccess) {
                        done := true
                        Continue
                    }

                    if (!skipRefresh) {
                        PollPattern(patterns.shop.refresh, { doClick : true, predicatePattern : patterns.shop.customerRank.subtract })
                        PollPattern(patterns.shop.customerRank.subtract.enabled, { doClick : true, predicatePattern : patterns.shop.customerRank.subtract.disabled })
                        PollPattern(patterns.prompt.ok, { doClick : true, predicatePattern : patterns.shop.refresh })
                    }
                    
                    PollPattern(patterns.itemWorld.weapon.disabled, { doClick : true, predicatePattern : patterns.itemWorld.weapon.enabled, pollInterval : 2000 })
                    AutoShopBuyEquipmentWithInnocents()
                    PollPattern(patterns.itemWorld.armor.disabled, { doClick : true, predicatePattern : patterns.itemWorld.armor.enabled, pollInterval : 2000 })
                    AutoShopBuyEquipmentWithInnocents()
                    PollPattern(patterns.itemWorld.weapon.disabled, { doClick : true, predicatePattern : patterns.itemWorld.weapon.enabled, pollInterval : 2000 })
                    AutoShopBuyEquipmentWithInnocents()
                    PollPattern(patterns.itemWorld.armor.disabled, { doClick : true, predicatePattern : patterns.itemWorld.armor.enabled, pollInterval : 2000 })
                    AutoShopBuyEquipmentWithInnocents()
                    sleep 2000

                    if (skipRefresh) {
                        done := true
                        Continue
                    }
                }

                sleep, 250
            } until (done)
    }

    

    if (mode && mode != "AutoDailies") {
        ExitApp
    }
}

AutoShopBuyEquipmentWithInnocents() {
    global patterns

    Loop {
        targetInnocents := {}
        result := FindPattern(patterns.shop.innocent.1, { multi : true })

        for k, v in result.multi {
            targetInnocents[v.Y] := true
        }

        result := FindPattern(patterns.shop.innocent.2, { multi : true })

        for k, v in result.multi {
            targetInnocents[v.Y] := true
        }

        for k, v in targetInnocents {
            Click("x200 " . " y" . k)
            sleep, 500
        }

        if (FindPattern(patterns.scroll.down.max).IsSuccess) {
            Break
        }
        else {
            ScrollDown()
        }
        
        sleep, 700
    }

    if FindPattern(patterns.shop.purchase).IsSuccess {
        PollPattern(patterns.shop.purchase, { doClick : true, predicatePattern : patterns.prompt.yes })
        PollPattern(patterns.prompt.yes, { doClick : true, predicatePattern : patterns.prompt.ok })
        PollPattern(patterns.prompt.ok, { doClick : true, predicatePattern : patterns.shop.equipment.title, clickPattern : patterns.touchScreen })
    }
}

AutoFriends() {
    global patterns, mode
    SetStatus(A_ThisFunc)
    AddLog(A_ThisFunc)
    
    done := false
    Loop {
        result := FindPattern([patterns.stronghold.gemsIcon, patterns.stronghold.friends.title])
        
        if InStr(result.comment, "stronghold.gemsIcon") {
            PollPattern(patterns.stronghold.friends.icon, { doClick : true })
        } else if InStr(result.comment, "stronghold.friends.title") {

            result := FindPattern(patterns.stronghold.friends.giveAll)

            if (result.IsSuccess) {
                ClickResult(result)
                sleep 500
                PollPattern([patterns.prompt.close, patterns.prompt.ok], { doClick : true })
                sleep 1000
            }

            result := FindPattern(patterns.stronghold.friends.claimAll)

            if (result.IsSuccess) {
                ClickResult(result)
                sleep 500
                PollPattern([patterns.prompt.close, patterns.prompt.ok], { doClick : true })
                sleep 1000
            }

            done := true
        }

        sleep, 250
    } until (done)

    if (mode && mode != "AutoDailies") {
        ExitApp
    }
}

AutoMissionClaim(claimType := "") {
    global patterns, mode
    if (!claimType) {
        claimType := "all"
    }
    SetStatus(A_ThisFunc . "_" . claimType)
    AddLog(A_ThisFunc . "_" . claimType)

    done := false
    Loop {
        result := FindPattern([patterns.stronghold.gemsIcon, patterns.missions.title])
        
        if InStr(result.comment, "stronghold.gemsIcon") {
            PollPattern(patterns.missions.icon, { doClick : true })
        } else if InStr(result.comment, "missions.title") {
            if (claimType = "all" || claimType = "repeat") {
                PollPattern(patterns.missions.repeat.disabled, { doClick : true, predicatePattern : patterns.missions.repeat.enabled })

                sleep 1000
                result := FindPattern(patterns.missions.claimAll)
                if (result.IsSuccess) {
                    PollPattern(patterns.missions.claimAll, { doClick : true, predicatePattern : patterns.prompt.close })
                    PollPattern(patterns.prompt.close, { doClick : true, predicatePattern : patterns.missions.repeat })
                }

                sleep 1000
            }
            done := true
        }

        sleep, 250
    } until (done)
}

AutoDailySummon() {
    global patterns, mode
    SetStatus(A_ThisFunc)
    AddLog(A_ThisFunc)
    
    done := false
    Loop {
        result := FindPattern([patterns.stronghold.gemsIcon, patterns.summon.title, patterns.summon.premium, patterns.general.autoClear.skip, patterns.touchScreen, patterns.prompt.ok, patterns.summon.result])
        
        if InStr(result.comment, "stronghold.gemsIcon") {
            FindPattern(patterns.tabs.summon, { doClick : true })
        } else if InStr(result.comment, "summon.title") {
            sleep, 1000
            result := FindPattern(patterns.summon.premium)
            if (result.IsSuccess) {
                result := FindPattern(patterns.summon.exclamation, { doClick : true })
                if (!result.IsSuccess) {
                    done := true
                }
            }
            else {
                FindPattern(patterns.summon.rightArrow, { doClick : true })
            }
        } else if InStr(result.comment, "general.autoClear.skip") || InStr(result.comment, "touchScreen") || InStr(result.comment, "prompt.ok"){
            ClickResult(result)
        }
        else if InStr(result.comment, "summon.result") {
            FindPattern(patterns.stage.back, { doClick : true })
        }

        sleep, 250
    } until (done)

    if (mode && mode != "AutoDailies") {
        ExitApp
    }
}

AutoDope() {
    SetStatus(A_ThisFunc)
    AddLog(A_ThisFunc)
    global patterns, settings, mode


    done := false
    Loop {
        result := FindPattern([patterns.stronghold.gemsIcon, patterns.netherHospital.title])
        
        if InStr(result.comment, "stronghold.gemsIcon") {
            PollPattern(patterns.tabs.facilities.tab, { doClick : true })
            sleep 500
            PollPattern(patterns.tabs.facilities.netherHospital, { doClick : true })
            sleep 3000
        } else if InStr(result.comment, "netherHospital.title") {
            result := FindPattern(patterns.netherHospital.available)

            if (result.IsSuccess) {
                PollPattern(patterns.netherHospital.available, { doClick : true, predicatePattern : patterns.prompt.close, clickPattern : patterns.touchScreen })
                PollPattern(patterns.prompt.close, { doClick : true, predicatePattern :  patterns.netherHospital.title})
            }

            done := true
        }

        sleep, 250
    } until (done)

    if (mode && mode != "AutoDailies") {
        ExitApp
    }
}

AutoFish() {
    SetStatus(A_ThisFunc)
    AddLog(A_ThisFunc)
    global patterns, settings, mode


    done := false
    Loop {
        result := FindPattern([patterns.stronghold.gemsIcon, patterns.fishingFleet.title])
        
        if InStr(result.comment, "stronghold.gemsIcon") {
            PollPattern(patterns.tabs.facilities.tab, { doClick : true })
            sleep 500
            PollPattern(patterns.tabs.facilities.fishingFleet, { doClick : true })
            sleep 4000
        } else if InStr(result.comment, "fishingFleet.title") {
            fleets := ["x73 y348", "x231 y506", "x405 y364"]
            maxCrabMiso := settings.fishingFleet.bribe.maxCrabMiso
            maxGoldBar := settings.fishingFleet.bribe.maxGoldBar
            maxGoldenCandy := settings.fishingFleet.bribe.maxGoldenCandy

            for k, v in fleets {
                Click(v)
                sleep 1000

                result := FindPattern(patterns.fishingFleet.complete)

                if (result.IsSuccess) {
                    PollPattern(patterns.fishingFleet.return, { doClick : true, predicatePattern : patterns.fishingFleet.setSail, clickPattern : patterns.touchScreen })
                    PollPattern(patterns.fishingFleet.setSail, { doClick : true, predicatePattern : patterns.fishingFleet.bribery.button })
                    sleep 1000

                    if (maxCrabMiso) {
                        PollPattern(patterns.fishingFleet.bribery.button, { doClick : true, predicatePattern : patterns.fishingFleet.bribery.goldenCandy })
                        FindPattern(patterns.fishingFleet.bribery.crabMiso, { doClick : true })

                        Loop, % maxCrabMiso {
                            if (A_Index = "1") {
                                Continue
                            }

                            sleep 500
                            FindPattern(patterns.fishingFleet.bribery.add, { doClick : true })
                        }
                        sleep 500
                        PollPattern(patterns.fishingFleet.bribery.use, { doClick : true, predicatePattern : patterns.prompt.close })
                        sleep 500
                        PollPattern(patterns.prompt.close, { doClick : true, predicatePattern : patterns.fishingFleet.setSail })
                        sleep 1000
                    }

                    if (maxGoldBar) {
                        PollPattern(patterns.fishingFleet.bribery.button, { doClick : true, predicatePattern : patterns.fishingFleet.bribery.goldenCandy })
                        FindPattern(patterns.fishingFleet.bribery.goldBar, { doClick : true })

                        Loop, % maxGoldBar {
                            if (A_Index = "1") {
                                Continue
                            }

                            sleep 500
                            FindPattern(patterns.fishingFleet.bribery.add, { doClick : true })
                        }
                        sleep 500
                        PollPattern(patterns.fishingFleet.bribery.use, { doClick : true, predicatePattern : patterns.prompt.close })
                        sleep 500
                        PollPattern(patterns.prompt.close, { doClick : true, predicatePattern : patterns.fishingFleet.setSail })
                        sleep 1000
                    }

                    if (maxGoldenCandy) {
                        PollPattern(patterns.fishingFleet.bribery.button, { doClick : true, predicatePattern : patterns.fishingFleet.bribery.goldenCandy })
                        FindPattern(patterns.fishingFleet.bribery.goldenCandy, { doClick : true })

                        Loop, % maxGoldenCandy {
                            if (A_Index = "1") {
                                Continue
                            }

                            sleep 500
                            FindPattern(patterns.fishingFleet.bribery.add, { doClick : true })
                        }
                        sleep 500
                        PollPattern(patterns.fishingFleet.bribery.use, { doClick : true, predicatePattern : patterns.prompt.close })
                        sleep 500
                        PollPattern(patterns.prompt.close, { doClick : true, predicatePattern : patterns.fishingFleet.setSail })
                        sleep 1000
                    }

                    PollPattern(patterns.fishingFleet.setSail, { doClick : true })
                    sleep 200
                }

                sleep 2000
            }

            done := true
        }

        sleep, 250
    } until (done)

    if (mode && mode != "AutoDailies") {
        ExitApp
    }
}

AutoDarkAssembly(targetBill := "") {
    global patterns, settings, mode
    SetStatus(A_ThisFunc . "_" . targetBill)
    AddLog(A_ThisFunc . "_" . targetBill)
    
    maxCrabMiso := settings.general.darkAssembly.maxCrabMiso
    maxGoldBar := settings.general.darkAssembly.maxGoldBar
    maxGoldenCandy := settings.general.darkAssembly.maxGoldenCandy

    senators := ["x315 y210", "x215 y265", "x115 y296", "x428 y293", "x227 y387", "x74 y451", "x427 y405", "x176 y521"]

    if (!targetBill) {
        targetBill := settings.general.darkAssembly.targetBill
    }

    done := false
    Loop {
        result := FindPattern([patterns.stronghold.gemsIcon, patterns.darkAssembly.title, patterns.prompt.corner, patterns.darkAssembly.startVoting])
        
        if InStr(result.comment, "stronghold.gemsIcon") {
            PollPattern(patterns.tabs.facilities.tab, { doClick : true })
            sleep 500
            PollPattern(patterns.tabs.facilities.darkAssembly, { doClick : true })
            sleep 3000
        } else if InStr(result.comment, "darkAssembly.title") {
            sleep 500
            ;check if insufficient assembly points
            result := FindPattern([patterns.darkAssembly.0over100, patterns.darkAssembly.25over100], { variancePct : 5 })
            if (result.IsSuccess) {
                PollPattern(patterns.darkAssembly.addAssemblyPts, { doClick : true, predicatePattern : patterns.prompt.yes })
                PollPattern(patterns.prompt.yes, { doClick : true, predicatePattern : patterns.prompt.close })
                PollPattern(patterns.prompt.close, { doClick : true, predicatePattern : patterns.darkAssembly.title })
            }

            ScrollUntilDetect(patterns.darkAssembly.bills[targetBill], { variancePct : 5 })
        } else if InStr(result.comment, "prompt.corner") {
            FindPattern(patterns.prompt.yes, { doClick : true })
            sleep 2000
        } else if InStr(result.comment, "darkAssembly.startVoting") {
            sleep 2000

            ;crabMiso loop
            for k, v in senators {
                if (maxCrabMiso <= 0) {
                    Break
                }

                result := FindPattern(patterns.darkAssembly.viability)
                viability := StrReplace(result.comment, "darkAssembly.viability.")
                
                if (viability = "almostCertain") {
                    Break
                }
                
                Click(v)
                sleep, 250
                Click(v)
                sleep, 250

                result := FindPattern(patterns.darkAssembly.affinity)
                affinity := StrReplace(result.comment, "darkAssembly.affinity.")

                ;MsgBox, % viability . "`n" . affinity
                if (maxCrabMiso > 0 && affinity = "negative") {
                    FindPattern(patterns.darkAssembly.bribe.crabMiso, { doClick : true })
                    maxCrabMiso--
                }

                sleep, 250
            }

            ;goldenBar loop
            for k, v in senators {
                if (maxGoldBar <= 0) {
                    Break
                }

                result := FindPattern(patterns.darkAssembly.viability)
                viability := StrReplace(result.comment, "darkAssembly.viability.")
                
                if (viability = "almostCertain") {
                    Break
                }
                
                Click(v)
                sleep, 250
                Click(v)
                sleep, 250

                result := FindPattern(patterns.darkAssembly.affinity)
                affinity := StrReplace(result.comment, "darkAssembly.affinity.")

                ;MsgBox, % viability . "`n" . affinity
                if (maxGoldBar > 0 && affinity != "feelingTheLove" && affinity != "prettyFavorable" && affinity != "favorable") {
                    FindPattern(patterns.darkAssembly.bribe.goldBar, { doClick : true })
                    maxGoldBar--
                } 

                sleep, 250
            }

            ;goldenCandy loop
            for k, v in senators {
                if (maxGoldenCandy <= 0) {
                    Break
                }

                result := FindPattern(patterns.darkAssembly.viability)
                viability := StrReplace(result.comment, "darkAssembly.viability.")
                
                if (viability = "almostCertain") {
                    Break
                }
                
                Click(v)
                sleep, 250
                Click(v)
                sleep, 250

                result := FindPattern(patterns.darkAssembly.affinity)
                affinity := StrReplace(result.comment, "darkAssembly.affinity.")

                ;MsgBox, % viability . "`n" . affinity
                if (maxGoldenCandy > 0 && affinity != "feelingTheLove" && affinity != "prettyFavorable" && affinity != "favorable") {
                    FindPattern(patterns.darkAssembly.bribe.goldenCandy, { doClick : true })
                    maxGoldenCandy--
                } 

                sleep, 250
            }

            sleep 1000
            PollPattern(patterns.darkAssembly.startVoting, { doClick : true, predicatePattern : patterns.prompt.corner })
            PollPattern(patterns.prompt.yes, { doClick : true })
            PollPattern(patterns.prompt.corner)
            result := PollPattern([patterns.darkAssembly.billPassed, patterns.darkAssembly.votedDown])
            if InStr(result.comment, "billPassed") {
                done := true
            }
            PollPattern(patterns.prompt.back, { doClick : true })
            sleep 2000
        }

        sleep, 250
    } until (done)

    if (mode && mode != "AutoDailies") {
        ExitApp
    }
}

AutoDarkAssemblyHL() {
    AutoDarkAssembly("hl")
}

AutoDarkAssemblyDrops() {
    AutoDarkAssembly("drops")
}

AutoDarkAssemblyDrops2() {
    AutoDarkAssembly("drops")
}

AutoDarkAssemblyEvent60() {
    AutoDarkAssembly("event60mins")
}

AutoDailyDarkGate(type) {
    global settings, mode

    dailyStats := InitDailyStats()
    count := settings["darkGateOptions"][type]["count"]
    skip := settings["darkGateOptions"][type]["skip"]
    useGateKeysOnFirstSkip := settings["darkGateOptions"][type]["useGateKeysOnFirstSkip"]
    currentDaily := A_ThisFunc . type

    if (dailyStats[currentDaily]) {
        if (dailyStats[currentDaily].count) {
            count := count - dailyStats[currentDaily].count
        }
        if (dailyStats[currentDaily].skip) {
            skip := skip - dailyStats[currentDaily].skip
            useGateKeysOnFirstSkip := false
        }
    }

    if (count > 0) {
        AutoDarkGate(type, { count : count, skip : skip, useGateKeysOnFirstSkip : useGateKeysOnFirstSkip })
    }

    if (mode && mode != "AutoDailies") {
        ExitApp
    }
}

AutoDailyDarkGateHL() {
    AutoDailyDarkGate("hl")
}

AutoDailyDarkGateMatsHuman() {
    AutoDailyDarkGate("matsHuman")
}

AutoDailyDarkGateMatsMonster() {
    AutoDailyDarkGate("matsMonster")
}

AutoDailyEventStoryFarm() {
    global settings

    dailyStats := InitDailyStats()
    farmCount := settings["dailies"]["event"]["story"]["farmCount"]
    currentDaily := A_ThisFunc

    if (dailyStats[currentDaily]) {
        if (dailyStats[currentDaily].count) {
            farmCount := farmCount - dailyStats[currentDaily].count
        }
    }

    EventStoryFarm(farmCount)
}

AutoDailies() {
    SetStatus(A_ThisFunc)
    AddLog(A_ThisFunc)
    global settings, metadata, guiHwnd, mode

    currentDaily := settings.dailies.current
    dailies := metadata.dailies.displayOrder

    if (!currentDaily) {
        currentDaily := dailies.1
        settings.dailies.current := dailies.1
        settings.save(true)
        Control, ChooseString, % currentDaily, ComboBox1,  % "ahk_id " . guiHwnd
        foundCurrent := true
    }

    for k, v in dailies {
        if (!foundCurrent && v != currentDaily) {
            Continue
        } else if (!foundCurrent && v == currentDaily) {
            foundCurrent := true
        }
        else {
            currentDaily := v
            settings.dailies.current := v
            settings.save(true)
            Control, ChooseString, % currentDaily, ComboBox1,  % "ahk_id " . guiHwnd
        }

        val := settings["dailies"][v]

        if (settings["dailies"][v]) {
            func := Func(v)
            %func%()
            GoToStronghold()
        }
    }

    if (mode) {
        ExitApp
    }
}

GoToStronghold() {
    global patterns, mode
    
    done := false
    Loop {
        result := FindPattern([patterns.stronghold.gemsIcon, patterns.tabs.stronghold, patterns.raid.message, patterns.battle.prompt.quitBattle])
        
        if InStr(result.comment, "stronghold.gemsIcon") {
            done := true
        } else if InStr(result.comment, "tabs.stronghold") || InStr(result.comment, "battle.prompt.quitBattle") {
            ClickResult(result)
            Sleep, 2000
        } else if InStr(result.comment, "raid.message") {
            HandleRaid()
        }

        sleep, 250
    } until (done)
}

Verify() {
    global hwnd, metadata, settings

    WinGetPos,X,Y,W,H, % "ahk_id " . hwnd

    ; size := metadata.window.emulator[settings["window"]["emulator"]]
    size := metadata.window.emulator[settings.window.emulator]

    MsgBox, % "(Window) " . (hwnd ? "ATTACHED" : "DETACHED") . " => "  . (hwnd ? "GOOD" : "BAD") . "`n"
            . "(Window Size) " . W . "x" . H . " => " . (W = size.targetWidth && H = size.targetHeight ? "GOOD" : "BAD (Target " . size.targetWidth . "x" . size.targetHeight . ")")
}

TestDrop() {
    result := FindDrop()
    MsgBox, % result.Type . " : " . result.X . "x" . result.Y . "y"
}

Test() {
    ;global patterns, settings, hwnd, guiHwnd
    global patterns, hwnd, settings, itemWorldBattleCountHwnd
    SetStatus(A_ThisFunc)

    ; battleCount := 100
    ; ControlSetText,, % battleCount, % "ahk_id " . itemWorldBattleCountHwnd

    FindText().ScreenShot()

    ; IF !FileExist("screenCaps")
    ; {
    ;     FileCreateDir, screenCaps
    ; }

    ;FindText().SavePic("screenCaps/current.png")
    ;FindText().SavePic("screenCaps/lastMinute.png")
    
    ;lastMinute := LoadPicture("screenCaps/lastMinute.png")
    ; VarSetCapacity(bm, size:=(A_PtrSize=8 ? 32:24), 0)
    ; r:=DllCall("GetObject", "Ptr",lastMinute, "int",size, "Ptr",&bm)
    ; w:=NumGet(bm,4,"int"), h:=Abs(NumGet(bm,8,"int"))

    ; x := 5

    ;FileRead, lastMinute, screenCaps/lastMinute.png
    ;FileRead, current, screenCaps/current.png
    ;MsgBox % Memory_Compare(lastMinute,current)


    ;x := pBitmap

    ;MsgBox, % JEE_FilesMatchContents("screenCaps/lastMinute.png", "screenCaps/current.png")
    ; Recover("ItemWorldGrind1")
}

Recover(mode) {
    global patterns, settings

    ; AddLog("Recover " . mode . " Invoked...")
    Resize()

    if (settings.window.recover.freeze)
    {
        IF !FileExist("screenCaps")
        {
            FileCreateDir, screenCaps
        }

        FindText().ScreenShot()
        FindText().SavePic("screenCaps/current.png")

        frozenScreen := JEE_FilesMatchContents("screenCaps/lastMinute.png", "screenCaps/current.png")
        if (frozenScreen) {
            Loop 5 {
                sleep 1000
                FindText().ScreenShot()
                FindText().SavePic("screenCaps/current.png")
                frozenScreen := JEE_FilesMatchContents("screenCaps/lastMinute.png", "screenCaps/current.png")
            } until (!frozenScreen)
        }

        if (frozenScreen) {
            AddLog("Frozen Screen Detected")
            if (FindPattern(patterns.homeScreen.tasks).IsSuccess) {
                PollPattern(patterns.homeScreen.tasks, { doClick : true, predicatePattern : patterns.homeScreen.clearAllTasks})
                PollPattern(patterns.homeScreen.clearAllTasks, { doClick : true, predicatePattern : patterns.homeScreen.playStore})
                sleep 3000
                AddLog("Recovered From Screen Detected")
            }
        }
    }

    result := FindPattern([patterns.homeScreen.playStore, patterns.homeScreen.openAppAgain])
    
    doRecover := false
    doClickDisgaeaIcon := false

    if InStr(result.comment, "homeScreen.playStore") {
        if(FindPattern([patterns.homeScreen.disgaea]).IsSuccess)
        {
            doRecover := true
            PollPattern([patterns.homeScreen.disgaea], { doClick : true, predicatePattern : patterns.criware, pollInterval : 1000 })
        }
    } else if InStr(result.comment, "homeScreen.openAppAgain") {
        doRecover := true
        PollPattern([patterns.homeScreen.openAppAgain], { doClick : true, predicatePattern : patterns.criware, pollInterval : 1000 })
    }

    result := FindPattern(patterns.prompt.corner)

    if (result.IsSuccess)
    {
        result := FindPattern([patterns.prompt.dateHasChanged, patterns.prompt.invalidRequest, patterns.prompt.failedToConnect])
        if (result.IsSuccess) {
            FindPattern(patterns.prompt.ok, { doClick : true, predicatePattern : patterns.criware, clickPattern : patterns.homeScreen.disgaea })
            doRecover := true
        }

        result := FindPattern(patterns.prompt.communicationError)
        if (result.IsSuccess) {
            FindPattern(patterns.prompt.ok, { doClick : true})
        }
    }

    if (doRecover) {
        AddLog("Recover " . mode)
        HandleAction("Stop", mode)
        PollPattern([patterns.criware], { doClick : true, predicatePattern : patterns.stronghold.gemsIcon, clickPattern : patterns.homeScreen.disgaea, pollInterval : 1000, callback : Func("RecoverCallback") })
        Resize()
        HandleAction("Start", mode)
    }

    if (settings.window.recover.freeze) {
        FindText().ScreenShot()
        FindText().SavePic("screenCaps/lastMinute.png")
    }
}

RecoverCallback() {
    global patterns

    Resize()
    result := FindPattern(patterns.prompt.unfinishedBattle)
    if (result.IsSuccess) {
        PollPattern(patterns.prompt.no, { doClick : true })
    }

    FindPattern(patterns.prompt.close, { doClick : true })

    Click("x500 y300")
}

TestHandler() {
    global handlers, HandlersTree
    ;Gui Submit, NoHide

    Gui TreeView, HandlersTree
    nodePath := GetNodePath()
    segments := StrSplit(nodePath, ".")
    target := handlers

    for k, v in segments {
        lastParent := target
        lastKey := v
        target := target[v]
    }

    node := lastParent[lastKey]
    handler := node.Func
    %handler%(node.Arg1, node.Arg2, node.Arg3)
}

TestPattern() { 
    global hwnd, patterns, PatternsTree, testPatternMulti, testPatternVariance

    Gui Submit, NoHide
    Gui TreeView, PatternsTree
    nodePath := GetNodePath()
    segments := StrSplit(nodePath, ".")
    target := patterns

    for k, v in segments
        target := target[v]

    opts := { multi : testPatternMulti, variancePct : testPatternVariance }
    result := FindPattern(target, opts)

    if (result.IsSuccess) {
        ToolTipExpire("Pattern " . nodePath . " FOUND " . result.multi.Length())
        if (testPatternMulti) {
            for k, v in result.multi {
                FindText().ClientToScreen(x, y, v.X, v.Y, hwnd)
                FindText().MouseTip(x, y)
            }
        }
        Else {
            ToolTipExpire("Pattern " . nodePath . " FOUND")
            FindText().ClientToScreen(x, y, result.X, result.Y, hwnd)
            FindText().MouseTip(x, y)
        }
    }
    Else {
        ToolTipExpire("Pattern " . nodePath . " NOT FOUND")
    }
}

PatternsSelect() {
    ;https://www.autohotkey.com/docs/commands/TreeView.htm
    if (A_GuiEvent != "S")  ; i.e. an event other than "select new tree item".
        return  ; Do nothing.

    global hwnd, patterns, patternsTree

    Gui Submit, NoHide
    Gui TreeView, patternsTree
    nodePath := GetNodePath()
    segments := StrSplit(nodePath, ".")
    target := patterns

    for k, v in segments
        target := target[v]
    
    If InStr(target, "|<") {
        ascii := FindText().ASCII(target)
        GuiControl,, patternsPreview, % Trim(ascii,"`n")

    }
    else {
        GuiControl,, patternsPreview,
    }
}