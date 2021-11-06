#Include common.ahk

if (!patterns)
{
    patterns := {}
}

patterns.events := {}
;patterns.events.story := "|<>**50$69.A8sn03U00C01V3180Mzbsk0A89906E30H01V1A80k001M0g89Z06bsz/05V1BjzoV69T3g89VkwY8l9xzV1A004V690wQ89U00Y8l823V1Ac1kV6826A89Y0048l05ZV1A7y7VyDwFY89VkxU2E1ku11As1Y02036089aTak6EwBV91BW4TVyDVsY89gEV48l654V1B3w8V68k0k89cTz48l60391B3zsV68k0N89gE0A8l6B1V1AXzlV68lg489a0648l6NY"
patterns.events.easy := {}
patterns.events.easy.enabled := "|<>0xFFFFFF@0.80$57.000007k407zk303XVk3s00Q0s4C0T007U600s6s00y0k07Vb00Bk700QAs0170y01n7zU8s3y0CEzw3307w0y700EQ0Dk3Us063U0C0Q700zy00s3Us0A1k070Q701UD40k3Us0M0skC0Q7zv07brU3U00000Dk004"
patterns.events.easy.disabled := "|<>0xA2A2A2@0.80$57.000807sQ0Dzk3U3nXk3s00w0s6D0z007U600s6s00y0s07Vb00Bk700QAs01b0z01n7zUMs3y0Dszw37UDw0y700kQ0Dk7Us07zk0T0Q700zy01s3Us0A1k070Q701UDA0s3Us0M0tkC0Q7zv07bzU3UzyE0MDs0A4"
patterns.events.normal := {}
patterns.events.normal.enabled := "|<>0xFFFFFF@0.80$100.0003k000000000003U61ks3zkA070C0C0C0MC1kA3Us0Q0s0s0w1Vk3Uk73k3k3k3U3s670630QD0T0T0C0BkMs0QA1ky1w1C0s0rVXU1kkD2sBkAs3U3D6C073Vs9kb0VUC0AQMs0QDy0XaQ270s0ktXU1klk2CFkMQ3U31qC0733U8T71VsC0A3ss0QA70VsQDzUs0kDVk1UkQ331kU73U30S70C30sA4760QC0A0sC1kA1kk0QM1ss0k1USS0k7X01n03Xzy"
patterns.events.normal.disabled := "|<>0xA6A6A6@0.80$100.E0U7s000300U101U3U61ts7zkA070C0C0D0MC1kS3Us0w0s0s0w1Vk3Uk73k3k7k3U3s670730QD0T0T0C0DkMs0QA1ky1w1C0s0rVXU1kkD3sBkAs3U3D6C073XsBkb0nkC0ASMs0QDy0raQ670s0ktXU1ktk3ClkMS3U31qC0773UAT71zsC0A7ss0QQD0lsQDzUs0kDXk3lsS33VkkD3U30S70C7UwAA760QC0A0sC1kS3kk0QM1ss0k3UTy1s7X01nU7Xzy060TU30C80600+A3c"
patterns.events.hard := {}
patterns.events.hard.enabled := "|<>0xFFFFFF@0.80$63.k3U307zkDy60Q0w0s71UQk3U7U70QA1q0Q1g0s3VU7k3UBk70QA0y0Q1C0s71U3zzUMs73sA0Tzw270zw1U3k3UkQ770A0S0Q63UsM1U7k3Uzw73UA0y0QA1ksC1UCk3V0C70sA1q0QM0ss7VUwk3W0770SDy4"
patterns.events.hard.disabled := "|<>0xA4A4A4@0.80$64.k3U307zkTz30C0S0Q3UsSA0s1s1k73UQk3UDk70QC0v0C0r0Q1ks3g0s2Q1kC3UDzzUMs73sC0zzy13UTy0s3w0sAD1nk3UDk3Uzw77UC0v0C7zsQD0s3g0sM3VkQ7USs3X0D71sS3nUCA0wQ3lsSC0tk1tk7bzUU"

patterns.events.stage := {}
patterns.events.stage.title := "|<>0xFFFFFF@0.80$72.0w00000000007z0000000000S3k000000000Q1kC00000000s00C00000000s00C00000000w00C00000000y01zkD00Rs3kTk0zkzk3zUDwTw0C1ks73UQC7z0C00sD3UsC1zkC00wC3Us70DkC01wC3ks703sC0TwC3Uzz01sC0sw73Vzy00sC1kQ3z0s000sC3kQ3s0s0k1sC3kQ700s0s3kC3kw7s0Q2TzUDlzy7zUDC7y07kyC3zk7s000000061s000000000C0s000000000A0s000000000C1k00000000063k0000000003z000U"
patterns.events.stage.500Pct := "|<>0x67E462@0.80$99.zs700000TkTkTky67zUs00003y3z3z7sksw700000Q0wsxsrA73ks00003U7b7b6NUsQD00000Q0wswsrM7zbyTk0M3y7bbbbv0zwzny030Tswwwwyk7z1sS00M077bbbU6ys0D3s0Ts1wwwww1bz01sDU7z0D7b7b0Ars0D0y0zs1swsws3Cz01sTk0M0T7z7z0Mrk0D3y0303kTsTs67q00sTU0M0Q3y3y0kyU"
patterns.events.overview := {}
patterns.events.overview.500Pct := "|<>0x5EE365@0.80$79.zUk0007sTVyD4TsM0003wDlz5WCQA0001k6QtaG7CD0000s7CQnN3zDns0kTnbCQxVz7tw0MDtnbC0js0ks0A0Qtnb0rs0MD0zkCQtn0KQ0A3UTk76QtUPC067k1U73yTk9x003s0k3U00081"
patterns.events.title := "|<>0xFFFFFF@0.92$72.zzk000000000s0000000000Es0000000000ks0000000000ks0000000000ks01U00008k1ss03U61z0vw3zw03k433UwC0kzzVkA61Us70kw01s861ks70ks00sMC1ks70ks00sEC1ks70ks00QED00s70ks00QkC00s70ks00CUC00s70ks00DU600s70ks007070Us70kzzk703VUs70szzk201z0s70TU"

patterns.events.stage.oneStar := "|<>0xFFFFFF@0.80$47.2000000U40E00U0UE3U0301VUT0060161a00C03A0A00w06M0M03w07k0k3zzkDU1U3zz0T0301zs0y0601zU1w0A03z03s0M07y06k0k0Dy0BU1U0wQ0n0701UM1X0C020E32000000A6000000E40000012"
patterns.events.stage.exp := "|<>0xFCFBFB@0.80$59.200000000UA8770A0A1UEzy70kSD1VUk0C30s7361U0CA1k73A300CM3UC6M600RU70QDkA00S0C0sTUTy0Q0Q3UT0s00s0zy0y1U03s1zU1w300As3U03s600Es700CkA01VkC00RUM061kQ00n0k0M3ks01X1zwk3lk06200000000A600000000k4000000012"
patterns.events.stage.hl := "|<>0xFFFFFF@0.80$44.20000041VU73U0UEs1ks0AAC0QC0161U73U0NUM1ks06M60QC00y1U73U0DUTzks03s60QC00y1U73U0DUM1ks03s60QC00q1U73U0BUs1ks06AC0QC01X3U73zsEE000008200000600000012"

patterns.events.vault := {}
patterns.events.vault.acquired := "|<>0xEEEAEB@0.80$113.000000000006000000C0M000000000Q000000Q1s000000000s000000s3k000000001k000001kDk0000000000000003UTU00000000000000071bU00000000600000DC3D01zUTi70sQCw7s1zw4C0D33nwC1ksTsQQ7VsMS0w0D1sQ3Vkw1kMC3kkQ1k0Q3ks73Vk3Uss3X0w7U0s3VkC73UC1lk761sD03k73UQC70S3XUCTzsS070C70sQC0zz70Qzzkw0C0QC1ksQ1k0C0tU3Vs0S0sQ3Vks3U0Q1q07Xk0Q3ks73Vk7U0s3g0D3k0s7VsS73U70EsDs0D3kMsT1lwC70D3VszU0S3zUzy1zsQC07y1zQ0000s0QQ0000001U0000000000s000000000000000001k000000000000000003U000000000000000007000000000000000000C00000000002"

EventStoryFarm() {
    global patterns, settings, guiHwnd, mode
    SetStatus(A_ThisFunc)
    ControlGetText, battleCount, edit2, % "ahk_id " . guiHwnd
    SetStatus(battleCount, 2)

    done := false
    battleOptions := settings.battleOptions.event
    battleOptions.donePatterns := [patterns.raid.appear.advanceInStory, patterns.battle.prompt.quitBattle]

    targetCompanions := []
    for k, v in battleOptions.companions
        targetCompanions.push(patterns.companions[v])

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
            FindAndClickListTarget(patterns.dimensionGate.events.story)
            sleep 2000
        }
        else if InStr(result.comment, "battle.start") {
            ClickResult(result)
            sleep 1000
        }
        else if InStr(result.comment, "battle.prompt.battle") {
            PollPattern(patterns.battle.prompt.battle, { doClick : true })
            sleep 500
            if (HandleInsufficientAP()) {
                PollPattern(patterns.battle.prompt.battle, { doClick : true })
                sleep 500
            }
            FindAndClickListTarget(targetCompanions)
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
        else if InStr(result.comment, "companions.title") {
            FindAndClickListTarget(targetCompanions)
            PollPattern(patterns.battle.start, { doClick : true })
            sleep 500
            if (HandleInsufficientAP()) {
                PollPattern(patterns.battle.start, { doClick : true })
                sleep 500
            }
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
        else if InStr(result.comment, "raid.message") {
            HandleRaid()
        }
    } until (done)

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
    global patterns, settings
    SetStatus(A_ThisFunc)

    done := false
    battleOptions := settings.battleOptions.event
    battleOptions.donePatterns := [patterns.raid.appear.advanceInStory, patterns.battle.prompt.quitBattle]

    targetCompanions := []
    for k, v in battleOptions.companions
        targetCompanions.push(patterns.companions[v])

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
            FindAndClickListTarget(patterns.dimensionGate.events.story)
            sleep 2000
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
                FindAndClickListTarget(targetCompanions)
                PollPattern(patterns.battle.start, { doClick : true })
                sleep 500
                if (HandleInsufficientAP()) {
                    PollPattern(patterns.battle.start, { doClick : true })
                }
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
            FindAndClickListTarget(patterns.dimensionGate.events.raid)
            sleep 2000
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