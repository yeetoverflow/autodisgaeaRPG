#include patterns/bluestacksPatterns.ahk
#include patterns/noxPatterns.ahk

;order matters here
metadata := GenerateSettingMetadata()
settings := InitSettings()
patterns := InitPatterns()

InitPatterns() {
    global settings, metadata

    switch (settings.window.emulator) {
        case "nox":
            patterns := GenerateNoxPatterns()
        case "testPaintNox":
            patterns := GenerateNoxPatterns()
        default:
            patterns := GenerateBluestacksPatterns()
    }

    InitUserPatterns(patterns, settings.userPatterns)

    metadata.userPatterns.companions.targets.checked := true
    metadata.userPatterns.battle.target.ally.checked := true
    metadata.userPatterns.battle.skills.checked := true
    metadata.userPatterns.battle.skills.props := {}
    metadata.userPatterns.battle.skills.props.singleTarget := {}
    metadata.userPatterns.battle.skills.props.singleTarget.type := "Checkbox"
    metadata.userPatterns.battle.skills.props.priority := {}
    metadata.userPatterns.battle.skills.props.priority.type := "DropDown"
    metadata.userPatterns.battle.skills.props.priority.options := "High|Normal||Low"

    Return patterns
}

GenerateSettingMetadata() {
    metadata := {}
    metadata.debug := {}
    metadata.debug.drop := {}
    metadata.debug.drop.newLine := true
    metadata.debug.drop.type := "Checkbox"    
    metadata.debug.doLog := {}
    metadata.debug.doLog.type := "Checkbox"
    
    metadata.window := {}
    metadata.window.emulator := {}
    metadata.window.emulator.type := "Radio"
    metadata.window.emulator.options := ["blueStacks", "nox", "testPaintBs", "testPaintNox"]
    metadata.window.emulator.callback := Func("InitWindow")
    metadata.window.emulator.blueStacks := {}
    metadata.window.emulator.blueStacks.targetWidth := 600
    metadata.window.emulator.blueStacks.targetHeight := 1040
    metadata.window.emulator.nox := {}
    metadata.window.emulator.nox.targetWidth := 608
    metadata.window.emulator.nox.targetHeight := 1040
    metadata.window.emulator.testPaintBs := {}
    metadata.window.emulator.testPaintBs.targetWidth := 800
    metadata.window.emulator.testPaintBs.targetHeight := 1200
    metadata.window.emulator.testPaintNox := {}
    metadata.window.emulator.testPaintNox.targetWidth := 800
    metadata.window.emulator.testPaintNox.targetHeight := 1200

    metadata.window.name := {}
    metadata.window.name.type := "Text"
    metadata.window.name.callback := Func("InitWindow")
    metadata.window.scanMode := {}
    metadata.window.scanMode.type := "Radio"
    metadata.window.scanMode.options := [0, 1, 2, 3, 4]
    metadata.window.scanMode.callback := Func("InitWindow")

    metadata.battleOptions := {}

    battleOptionsMetadata := {}
    battleOptionsMetadata.displayOrder := ["auto", "targetEnemyMiddle", "selectStandby", "autoRefillAP"]
    battleOptionsMetadata.auto := {}
    battleOptionsMetadata.auto.newLine := true
    battleOptionsMetadata.auto.type := "Checkbox"
    battleOptionsMetadata.auto.optsOverride := "xp yp"
    battleOptionsMetadata.targetEnemyMiddle := {}
    battleOptionsMetadata.targetEnemyMiddle.type := "Checkbox"
    battleOptionsMetadata.selectStandby := {}
    battleOptionsMetadata.selectStandby.type := "Checkbox"
    battleOptionsMetadata.selectStandby.newLine := true
    battleOptionsMetadata.autoRefillAP := {}
    battleOptionsMetadata.autoRefillAP.type := "Checkbox"

    metadata.battleOptions.default := battleOptionsMetadata
    metadata.battleOptions.event := battleOptionsMetadata
    metadata.battleOptions.itemWorld := battleOptionsMetadata
    metadata.battleOptions.sweep := battleOptionsMetadata
    metadata.battleOptions.raid := battleOptionsMetadata
    metadata.battleOptions.darkGateMats := battleOptionsMetadata
    metadata.battleOptions.darkGateHL := battleOptionsMetadata

    metadata.eventOptions := {}
    metadata.eventOptions.story := {}
    metadata.eventOptions.story.displayOrder := ["farmTarget"]
    metadata.eventOptions.story.farmTarget := {}
    metadata.eventOptions.story.farmTarget.type := "Radio"
    metadata.eventOptions.story.farmTarget.options := ["oneStar", "exp", "hl"]
    metadata.eventOptions.raid := {}
    metadata.eventOptions.raid.displayOrder := ["appearAction", "fightAttempts", "loopNumChecksBeforeRefresh"]
    metadata.eventOptions.raid.appearAction := {}
    metadata.eventOptions.raid.appearAction.type := "Radio"
    metadata.eventOptions.raid.appearAction.options := ["askForHelp", "fight", "advanceInStory", "fightThenPullOut"]
    metadata.eventOptions.raid.fightAttempts := {}
    metadata.eventOptions.raid.fightAttempts.type := "Radio"
    metadata.eventOptions.raid.fightAttempts.options := ["1", "2", "3"]
    metadata.eventOptions.raid.loopNumChecksBeforeRefresh := {}
    metadata.eventOptions.raid.loopNumChecksBeforeRefresh.type := "Number"
    metadata.eventOptions.raid.claimType := {}
    metadata.eventOptions.raid.claimType.type := "Radio"
    metadata.eventOptions.raid.claimType.options := ["claim", "vault", "innocent"]


    metadata.general := {}
    metadata.general.darkAssembly := {}
    metadata.general.darkAssembly.maxGoldenCandy := {}
    metadata.general.darkAssembly.maxGoldenCandy.type := "Radio"
    metadata.general.darkAssembly.maxGoldenCandy.options := [0, 1, 2, 3, 4, 5]
    metadata.general.darkAssembly.maxGoldBar := {}
    metadata.general.darkAssembly.maxGoldBar.type := "Radio"
    metadata.general.darkAssembly.maxGoldBar.options := [0, 1, 2, 3, 4, 5]
    metadata.general.darkAssembly.maxCrabMiso := {}
    metadata.general.darkAssembly.maxCrabMiso.type := "Radio"
    metadata.general.darkAssembly.maxCrabMiso.options := [0, 1, 2, 3, 4, 5]
    metadata.general.darkAssembly.targetBill := {}
    metadata.general.darkAssembly.targetBill.type := "Radio"
    metadata.general.darkAssembly.targetBill.options := ["drops", "hl", "event60mins"]

    metadata.shop := {}
    metadata.shop.shopType := {}
    metadata.shop.shopType.type := "Radio"
    metadata.shop.shopType.options := ["items", "equipment"]
    metadata.shop.skipRefresh := {}
    metadata.shop.skipRefresh.type := "Checkbox"

    metadata.fishingFleet := {}
    metadata.fishingFleet.bribe := {}
    metadata.fishingFleet.bribe.maxGoldenCandy := {}
    metadata.fishingFleet.bribe.maxGoldenCandy.type := "Radio"
    metadata.fishingFleet.bribe.maxGoldenCandy.options := [0, 1, 2, 3, 4]
    metadata.fishingFleet.bribe.maxGoldBar := {}
    metadata.fishingFleet.bribe.maxGoldBar.type := "Radio"
    metadata.fishingFleet.bribe.maxGoldBar.options := [0, 1, 2]
    metadata.fishingFleet.bribe.maxCrabMiso := {}
    metadata.fishingFleet.bribe.maxCrabMiso.type := "Radio"
    metadata.fishingFleet.bribe.maxCrabMiso.options := [0, 1]

    metadata.darkGateOptions := {}
    metadata.darkGateOptions.selectedGate := {}
    metadata.darkGateOptions.selectedGate.type := "Radio"
    metadata.darkGateOptions.selectedGate.options := ["hl", "matsHuman", "matsMonster"]
    metadata.darkGateOptions.hl := {}
    metadata.darkGateOptions.hl.count := {}
    metadata.darkGateOptions.hl.count.type := "Number"
    metadata.darkGateOptions.hl.skip := {}
    metadata.darkGateOptions.hl.skip.type := "Number"
    metadata.darkGateOptions.matsHuman := {}
    metadata.darkGateOptions.matsHuman.count := {}
    metadata.darkGateOptions.matsHuman.count.type := "Number"
    metadata.darkGateOptions.matsHuman.skip := {}
    metadata.darkGateOptions.matsHuman.skip.type := "Number"
    metadata.darkGateOptions.matsMonster := {}
    metadata.darkGateOptions.matsMonster.count := {}
    metadata.darkGateOptions.matsMonster.count.type := "Number"
    metadata.darkGateOptions.matsMonster.skip := {}
    metadata.darkGateOptions.matsMonster.skip.type := "Number"

    InitMetaDataItemWorldOptions(metadata)

    metadata.dailies := {}
    metadata.dailies.displayOrder := ["AutoShopItems", "AutoFriends", "AutoDailySummon", "AutoDope", "AutoFish", "AutoDailyCharacterGate1", "AutoDailyEventReview1"
                                    , "AutoDarkAssemblyDrops", "AutoDailyDarkGateMatsHuman"
                                    , "AutoDarkAssemblyHL", "AutoDailyDarkGateHL", "AutoDarkAssemblyDrops2", "AutoDailyDarkGateMatsMonster"
                                    , "AutoDarkAssemblyEvent60", "EventStory500Pct", "AutoDailyEventStoryFarm"
                                    , "GrindItemWorldLoop1", "GrindItemWorldLoop2", "EventRaidLoop"]
    dailiesOptions := ""
    for k, v in metadata.dailies.displayOrder {
        metadata.dailies[v] := {}
        metadata.dailies[v].type := "Checkbox"
        metadata.dailies[v].newLine := true
        dailiesOptions .= v . "|"
    }

    metadata.dailies.current := {}
    metadata.dailies.current.type := "DropDown"
    metadata.dailies.current.options := dailiesOptions

    metadata.dailies.event := {}
    metadata.dailies.event.story := {}
    metadata.dailies.event.story.farmCount := {}
    metadata.dailies.event.story.farmCount.type := "Number"
    ; metadata.dailies.event.story.farmTarget := {}
    ; metadata.dailies.event.story.farmTarget.type := "Radio"
    ; metadata.dailies.event.story.farmTarget.options := ["oneStar", "exp", "hl"]

    metadata.userPatterns := {}

    Return metadata
}

GenerateSettingDefaults() {
    defaults := {}
    defaults.window := {}
    defaults.window.emulator := "blueStacks"
    defaults.window.name := "DisgaeaRPG"
    defaults.window.scanMode := 4

    defaults.battleOptions := {}
    defaults.battleOptions.default := { allyTarget : [], auto : 1, targetEnemyMiddle : 0, selectStandby : 0, autoRefillAP : 0
        , companions : ["50Pct"], skills : [] }
    defaults.battleOptions.event := { allyTarget : [], auto : 1, targetEnemyMiddle : 0, selectStandby : 0, autoRefillAP : 1
        , companions : ["50Pct"], skills : [] }
    defaults.battleOptions.itemWorld := { allyTarget : [], auto : 0, targetEnemyMiddle : 0, selectStandby : 0, autoRefillAP : 0
        , companions : [], skills : ["blastCleave", "doppelganger", "darkBeam"] }
    defaults.battleOptions.sweep := { allyTarget : ["OverlordAsagi"], auto : 0, targetEnemyMiddle : 0, selectStandby : 0, autoRefillAP : 1
        , companions : ["OverlordAsagi"], skills : [ "blastCleave", "megaBraveheart"] }
    defaults.battleOptions.raid := { allyTarget : ["OverlordAsagi"], auto : 0, targetEnemyMiddle : 1, selectStandby : 0, autoRefillAP : 0
        , companions : ["OverlordAsagi"], skills : [ "annihilationCannon", "darkBeam", "megaBraveheart"] }
    defaults.battleOptions.darkGateMats := { allyTarget : [], auto : 0, targetEnemyMiddle : 0, selectStandby : 0, autoRefillAP : 1
        , companions : ["SantaLaharl"], skills : ["doppelganger"] }
    defaults.battleOptions.darkGateHL := { allyTarget : [], auto : 0, targetEnemyMiddle : 0, selectStandby : 0, autoRefillAP : 1
        , companions : ["Seraphina"] , skills : ["blastCleave", "doppelganger"] }
    ; defaults.battleOptions.skills := { "annihilationCannon": "|<battle.skills.annihilationCannon>0xFFFFFF@0.70$69.3U0000M0600kg0000300k064kTVy6Tla7Vsa36AMn6Al668MMlX6MFa0El336AMX2AkS6TwMlX4MFaAEm1X6AMn2Al26kAMlX6MFaAko1n6AMn2Alv700000000000000000000000000000000000000000000001s0000000000lU000000000A0000000000300000000000M0D3QBkC3Q0702AMlX6AMk0s01X6AMkX60700QMlXA6Mk0M0NX6ANUn60306AMlXA6Mk0A2lX6AMlX600vXSMlX3MMk01U8000040004"
    ;                                  , "blastCleave": "|<battle.skills.blastCleave>*126$54.TsU000000E4U000s00HmU001800GFU001800GGUz7vC00HWU0g6200E6VQdpA00HlUwMt800G9UUQ9800G9VAL5800G9X8RZ800E3XAPZC00ECZ2QB200DkQzrsw0000000000000A0000001w000000061W0000008xW000000F7W03zqU0G2WD1zzzs20WUY7D+220WCJn7QmW0XCLn6McW0X0K2as1m0XDsmWczl3X+tGEc2swXDNnN4ww1WUM1962zyQTbz63wU"
    ;                                  , "darkBeam": "|<battle.skills.darkBeam>0xFFFFFF@0.70$70.zU000U0Dw0033U00200kM00A70008031U00kA000V0A60030lwDW80ksD1w34Ms903z1W8kA1X0s0C6AA30kyA3U0kAzkw76Mk/030n0AkMlX0a0A3A0n336A2A0kMM3Dk7wkMs3z0yDU"
    ;                                  , "doppelganger": "|<battle.skills.doppelganger>*122$84.T00000000U0000U80000000E0000bW0000000E0000Ym0000000E0000Y17Vz7w7UnmT5YY9E+0c20EY2UU2Y93WCMt38dkC0tY9Ya2Mdb8dEyEdY9YaE98U0tEUF9YFYaGN8bsQZ6F9YWYa2M9YMIt+F9b4n6CMtHcMBAEdUMMO0c2M8o309dT07WT9yDXdkTrC0002E9s00+8000U"
    ;                                  , "megaBraveheart": "|<battle.skills.megaBraveheart>#292@0.70$41.U200001UA00003UQ000071k0000/2Uw7swL9XANUAanA8V0976Tl63uCAk3AMo8NU20Vc0lWA1bE1VwTnq0000VU0000330000026000003k00000000Ns00000kk00001Uk0000333ksMEzw62MkXAQ80Nn4MAE3lYMkMUNX8lUl1X3VX3W3671bw47Q43U002000k"}
    ; defaults.battleOptions.companions := { "50Pct" : ["|<>0x56E168@0.71$29.z3kwFyDltXUTan60nhgDXbDMTbCTU7iQ3yDQsBgQNkPMsz0anVy3Dk", "|<>0x4EDF6B@0.71$27.z7llbsyD8kCvP71rPEzCty7tr0j7isBstr1/7DsNtky3DU"]
    ;                                      , "Guest" : ["|<>0xFF599A@0.80$70.03U000000S0A0z0000001zzkDw0000007zz1zk000000TzwTz0070801zznzk7UwDw7U7kDs0S3kzlz0T1z01sD3yDw1w7s07UwD0y07kz00S3kw3s0T3w7lsD3yDs1wDkz7UwDsTk7kzXwS3kzUzUT1zDlwD3k0y1w7zz3lwD03k7kDzwDzUzlz0T0Tzkzw3z7s1w0Tz0zkDwS07k030000000002"]
    ;                                      , "OverlordAsagi" : ["|<>**50$39.10000W8Dk208l0zkE18M6PW0+20nyE0sk2JG0R70OeU6cc+RY1pD1HgU/fM+9Y3JL1N0Umcc9z8AL/181TVcE+0+s1W1U1q0QcA0AU6Z101Y05880800e10100A080801010000M080002010000k08000A01004350A000lc1k00Q/07U073E0j01UK05i0M3wkgQ609XTGzU1AhWEk09bqS7k1A3PUW09U9oBk1A0gVC0NU2gDs3D1B1n0No"
    ;                                                         , "|<>**50$39.M0A7E5K00Uu8eM040F5F00U29OLk40a+2bkU5XIIT40sSWbMU2WoIuc3orWbP0OZcIP87px2mM1evMHMERKu2Dm3/VEGMEkoK2U3w1mUI0P0+o303MWJVE0E02c+0202l1E0E0I0/0001U3M00080F0003028000k0t008AU5800351tk00kc//00Q91FD071w7BC1UAUkgwM146Dpy08UpWUs146qQS08UnL3E146BcL08Ukx3w17yNMQU8xo"]
    ;                                      , "SantaLaharl" : ["|<>**50$49.000000000000000000000000000000000000Q/XQM02CPTvzz04xswDGtYTQM209ULTw8108U7t280U4E60U40E2M60F4081400/a000+0U5m010X0U4e00UJ002rU0E1U01Hx089U00tjE45U008ao20U0043D10k00+13kWk0050UM1M002UEC1A0218A5Ua010Y762X00UH0W1FVcE8kn0kko8AAD0EiI463V00L+6200009X2120007m10U000080cE000046o8000023GI000019fe07U00VJr04A00oihU30M0mWKs1Y0kMzNsUN1UMHcwA80UsNo33W0lsAu0sM0lk6P063U3U7B01ly7U1aU0CXz02n001k001dy000000oy000000q0E"
    ;                                                       , "|<>**50$49.0000000000000000000000000000000000000000000000000000000000000000000000000000U1XsrA009nPyzq01Hz71oi09xX0k2EARsl0828CTYF041A7s28U20W401IU10J100is0UFVk0JE008U80Kc004k40+T024k6079o12k1U34j0UI100UHkEM080E8Q88020c474g010I23mK00U911NH00M4UlUsV04289UMksW167U8CIN0VlU07O6UED000c1UMU000r0Q80000M0240000440u000026UJ020012EDU2s01dM6k1300lB1Q0U70lzsyURUktaw/A00UsXP7X20ksFhUMM0Fk8qM73U3UATA0sy3U6/a06rz054j01sS03Xk"]
    ;                                      , "Seraphina" : ["|<>*150$41.zzzI7DXzzzjyTzzzyTwzzzzsztzzzTVzXzzwzXzDzzvsbyjzzbUDwTzzS0Tkzzxs0zVzzz01z3zzXy3w7zyDwDsTzszyTXzznjwzDzzaDtyTzzMTbtjzylzDnzzxWSTXzzt4xr7xzn8HqDzzW8i0Ljz2E00izz0M00Bzy0001Lvw0001zzw0003zTw0007yys000LtwM000Trw0000zjs0001zzk0007zzU000TzzU001zzz0007zzyA00TzzwC03zzzsbUDzzznbxzzbzrzzzTDk"
    ;                                                     , "|<>*148$41.zzzVXtzzzzr1nvzzzvzbzzzzrzDzzzzDyTzzvwTszzzroznzzzT1znzzyw3z7zzvk7wDzzi0DsTzzL0TkzzwTkz3zzlzlyTzzaznszzzMTjnzzwkyThzzx7wyDzzvBfgTzzm/qszTzYFSFSzz4WU2vzy0U04rzy0U05TTw0006yzw000Dzzs000Trys001TjwE001zTs0003zzs0007zzk000TzzU001zzzU007zzz800TzzyA03zzzwD0DzzztbtzzzzvjzywTzzTzxszzzzzzlk"
    ;                                                     , "|<>**50$39.E2K11W60r088EU5U11241Xw8ME09zl2C0yC78nk8nQP4q+6lXEYl0qTGBY86nGnaV0KOLMUE2F6r720H8j8jEW9Y05o0M6006Y10E03gV8000Do5U001bkg000Ru5k002fkn000CR60001GsE000OF20002WAM040o0Wk00QU49U0780l701V028D0s/sFAzyDN3BqD3G88uU0OF17Q3um8DV0nKF1g05iy/5U0ValsY005KBYUE0ilQY006q4"] }
    ; defaults.battleOptions.allyTargets := { "None" : ""
    ;                                      , "OverlordAsagi" : ["|<>**50$39.b00U50XM020d0A000780k000103000080DU00042zU00H0IT102k2XC8040IMl0102W200u0KQO09F2HW02e8GQU0pH2F404ekHAU1ZF2BUUMe0Ez467k2E0fU20I07M0s2U0n050M06E1B200m018E04009200U030E0400M2000060E0000k30000A080003010000k0800EA81U0031EC000kG1A00Q2U9M070Y0hk1U005XUM00muLq004"
    ;                                                         , "|<>#633@0.84$41.00Ty00k007w0100j1M0401S1E0002s100005lW00E0/X002U0QaE0A00tAU0u01kt03Y03lq07MU7wQ0Sl0Dzs1y00Tzk7z00jzWTy01TzAzv01zyPzg07zxrzs0Dzvzzk0TzrzzU0zzjzw01zzzzwE3zzzzk07zzzz007zzzs00DzzzU40Tzzz0E0zzzw0U1Tzzk103Dzz0402jzw0M04rzk0W09ly02301UM003830000182000008000000807k0008U8000030E0000A0600E"] }

    defaults.itemWorldOptions := {}
    defaults.itemWorldOptions.findDropMode := "default"
    defaults.itemWorldOptions.1 := {}
    defaults.itemWorldOptions.1.farmLevels := [30, 60, 100]
    defaults.itemWorldOptions.1.bribe := "none"
    defaults.itemWorldOptions.1.targetItemType := "armor" ;armor, weapon
    defaults.itemWorldOptions.1.targetItemSort := "gained"
    defaults.itemWorldOptions.1.targetItemSortOrder := "ascending"
    defaults.itemWorldOptions.1.prioritizeEquippedItems := "no"
    defaults.itemWorldOptions.1.targetItemRarity := "any" ;any, rare, legendary
    defaults.itemWorldOptions.1.lootTarget := "any" ;any, rare, legendary
    defaults.itemWorldOptions.2 := {}
    defaults.itemWorldOptions.2.farmLevels := [30, 60, 100]
    defaults.itemWorldOptions.2.bribe := "none"
    defaults.itemWorldOptions.2.targetItemType := "armor" ;armor, weapon
    defaults.itemWorldOptions.2.targetItemSort := "rarity"
    defaults.itemWorldOptions.2.targetItemSortOrder := "descending"
    defaults.itemWorldOptions.2.prioritizeEquippedItems := "no"
    defaults.itemWorldOptions.2.targetItemRarity := "legendary" ;any, rare, legendary
    defaults.itemWorldOptions.2.lootTarget := "legendary" ;any, rare, legendary

    defaults.eventOptions := {}
    defaults.eventOptions.story := {}
    defaults.eventOptions.story.farmTarget := "oneStar"
    defaults.eventOptions.banners := {}
    defaults.eventOptions.banners.story := "|<>**50$49.U100E00CE3U0C00683003k0303400Q01U62U03U0U62E0EQ0E4180U7U0A0Y0G0s0A0E09170400U4kVk200E29MC100814Y1kw2W0VG0TXlN0Edkzl1408B838U1045W0YE0k23VDHw7B11UkU05m0VVw002wUFbe001/k8b4U00YD4C3k00T6nS3M00BWBXVg006P3EtY005bVs7a002M0Q0Z001a0200U00k01U0k0080000E0060000M0030000A001U000A000M0004000A0002U0030000k000k001k000C001k0003U03k0001w03U02007U7k05010sDc06U00Dz402E004zW038002010140000SE0W00000001"
    defaults.eventOptions.banners.raid := "|<>**50$49.zzq0BzHzk0z06VdMM0DyzErgA73zz8Pq67Uk0Dw333kTzvwzVVsDzxzzUkwD06Vk0M0703Ek0A073VcMQ623Xko8D33XVsO05VVkkoD06kksAS7U1sMS2700UwA/1000M06AkE00A036Qs00701znzzzzzzk"
    defaults.eventOptions.raid := {}
    defaults.eventOptions.raid.appearAction := "askForHelp"
    defaults.eventOptions.raid.fightAttempts := "3"

    defaults.userPatterns := {}
    defaults.userPatterns.battle := {}
    defaults.userPatterns.battle.skills := { "annihilationCannon": { 1 : "|<battle.skills.annihilationCannon>0xFFFFFF@0.70$69.3U0000M0600kg0000300k064kTVy6Tla7Vsa36AMn6Al668MMlX6MFa0El336AMX2AkS6TwMlX4MFaAEm1X6AMn2Al26kAMlX6MFaAko1n6AMn2Alv700000000000000000000000000000000000000000000001s0000000000lU000000000A0000000000300000000000M0D3QBkC3Q0702AMlX6AMk0s01X6AMkX60700QMlXA6Mk0M0NX6ANUn60306AMlXA6Mk0A2lX6AMlX600vXSMlX3MMk01U8000040004"
                                        ;, 2 : "|<battle.skills.annihilationCannon.userPattern.1>0xFFFFFF@0.70$69.3U0000M0600kg0000300k064kTVy6Tla7Vsa36AMn6Al668MMlX6MFa0El336AMX2AkS6TwMlX4MFaAEm1X6AMn2Al26kAMlX6MFaAko1n6AMn2Alv700000000000000000000000000000000000000000000001s0000000000lU000000000A0000000000300000000000M0D3QBkC3Q0702AMlX6AMk0s01X6AMkX60700QMlXA6Mk0M0NX6ANUn60306AMlXA6Mk0A2lX6AMlX600vXSMlX3MMk01U8000040004"
                                        , singleTarget : 1 }
                                    , "blastCleave": { 1 : "|<battle.skills.blastCleave>*126$54.TsU000000E4U000s00HmU001800GFU001800GGUz7vC00HWU0g6200E6VQdpA00HlUwMt800G9UUQ9800G9VAL5800G9X8RZ800E3XAPZC00ECZ2QB200DkQzrsw0000000000000A0000001w000000061W0000008xW000000F7W03zqU0G2WD1zzzs20WUY7D+220WCJn7QmW0XCLn6McW0X0K2as1m0XDsmWczl3X+tGEc2swXDNnN4ww1WUM1962zyQTbz63wU"
                                        , 2 : "|<settings.userPatterns.battle.skills.blastCleave.1>**50$47.whQPXUU03OaIvb01Xpydx807ndlEuE08bKusIU0HCdoQd01yRHjtH023uaAmZ07wRzyxy0000k00k00000000073U00001vx000002Qu000005xo00000CCc03XVls1HyRrbjk2gqgtfqU5HZwvpT0+b/tnSy0J0Smqw41eTnZZPs" }
                                    , "darkBeam": { 1 : "|<battle.skills.darkBeam>0xFFFFFF@0.70$70.zU000U0Dw0033U00200kM00A70008031U00kA000V0A60030lwDW80ksD1w34Ms903z1W8kA1X0s0C6AA30kyA3U0kAzkw76Mk/030n0AkMlX0a0A3A0n336A2A0kMM3Dk7wkMs3z0yDU"
                                        , 2 : "|<settings.userPatterns.battle.skills.darkBeam.1>**50$56.Ak00+03N81YS7ub0qG09QvOfMBgbWJmWfA3CN8Zoduq0k7q9T+EX0ByNaKGY8M3Ma/7Sd6m0qNbXbiFgkBgRXhlYPa38BDV6T7jUyyS"
                                        , singleTarget : 1, priority : "Low" }
                                    , "doppelganger": { 1 : "|<battle.skills.doppelganger>*122$84.T00000000U0000U80000000E0000bW0000000E0000Ym0000000E0000Y17Vz7w7UnmT5YY9E+0c20EY2UU2Y93WCMt38dkC0tY9Ya2Mdb8dEyEdY9YaE98U0tEUF9YFYaGN8bsQZ6F9YWYa2M9YMIt+F9b4n6CMtHcMBAEdUMMO0c2M8o309dT07WT9yDXdkTrC0002E9s00+8000U"
                                        , 2 : "|<settings.userPatterns.battle.skills.doppelganger.1>**50$63.FA03EBU8+1uAjRxrrCtHhEZAwHlBBerO4vnjCwvpIvEaGR9qqSeZ+AmHdiak5KvHCGR9oqTekvnPnjCwvzGz0lAwnnDAukQ" }
                                    , "megaBraveheart": "|<battle.skills.megaBraveheart>#292@0.70$41.U200001UA00003UQ000071k0000/2Uw7swL9XANUAanA8V0976Tl63uCAk3AMo8NU20Vc0lWA1bE1VwTnq0000VU0000330000026000003k00000000Ns00000kk00001Uk0000333ksMEzw62MkXAQ80Nn4MAE3lYMkMUNX8lUl1X3VX3W3671bw47Q43U002000k"}
    defaults.userPatterns.battle.target := {}
    defaults.userPatterns.battle.target.ally := {}
    defaults.userPatterns.battle.target.ally.overlordAsagi := ["|<battle.target.ally.overlordAsagi.1>**50$39.b00U50XM020d0A000780k000103000080DU00042zU00H0IT102k2XC8040IMl0102W200u0KQO09F2HW02e8GQU0pH2F404ekHAU1ZF2BUUMe0Ez467k2E0fU20I07M0s2U0n050M06E1B200m018E04009200U030E0400M2000060E0000k30000A080003010000k0800EA81U0031EC000kG1A00Q2U9M070Y0hk1U005XUM00muLq004"
                                                            , "|<battle.target.ally.overlordAsagi.2>#633@0.84$41.00Ty00k007w0100j1M0401S1E0002s100005lW00E0/X002U0QaE0A00tAU0u01kt03Y03lq07MU7wQ0Sl0Dzs1y00Tzk7z00jzWTy01TzAzv01zyPzg07zxrzs0Dzvzzk0TzrzzU0zzjzw01zzzzwE3zzzzk07zzzz007zzzs00DzzzU40Tzzz0E0zzzw0U1Tzzk103Dzz0402jzw0M04rzk0W09ly02301UM003830000182000008000000807k0008U8000030E0000A0600E"]

    defaults.general := {}
    defaults.general.darkAssembly := {}
    defaults.general.darkAssembly.maxGoldenCandy := 5
    defaults.general.darkAssembly.maxGoldBar := 2
    defaults.general.darkAssembly.maxCrabMiso := 2

    return defaults
}

CapitalizeFirstLetter(str) {
    Return RegExReplace(str, "^(.)", "$u1")
}

SettingsModal(targetSettings, opts := "")
{
    global

    opts := InitOps(opts, { })
    local settingMetaData := GetSettingMetaData(targetSettings)

    Gui, SettingsModal:Destroy
    Gui, SettingsModal:New,, % StrReplace(targetSettings, "_", ".")
    Gui, SettingsModal:Color, 404040
    Gui, SettingsModal:Font, s3
    Gui, SettingsModal:Add, Text, section
    Gui, SettingsModal:Font
    Gui, +AlwaysOnTop
    Gui, -SysMenu

    if (settingMetaData.displayOrder) {
        for i, v in settingMetaData.displayOrder
        {
            settingUnderscore := targetSettings . "_" . v
            local settingInfo := GetSettingInfo(settingUnderscore)
            AddSetting(settingInfo, "SettingsModal")
        }
    }
    else if (settingMetaData.type) {
        local settingInfo := GetSettingInfo(targetSettings)
        AddSetting(settingInfo, "SettingsModal", opts)
    } 
    else {
        for k, v in settingMetaData
        {
            settingUnderscore := targetSettings . "_" . k
            local settingInfo := GetSettingInfo(settingUnderscore)
            AddSetting(settingInfo, "SettingsModal")
        }
    }
    
    Gui, SettingsModal:Add, Button, gSettingsModalGuiClose, Done
    Gui, SettingsModal:Show
}

SettingPresetChanged() 
{
    global

    local settingUnderscore := RegExReplace(A_GuiControl, "_[^_]+?$", "")
    local targetValue := ""
    RegExMatch(A_GuiControl, "[^_]+?$", targetValue)

    local settingInfo := GetSettingInfo(settingUnderscore)

    for i, v in settingInfo.metaData.options {
        GuiControl,, % settingUnderscore . "_" . v, 0
    }

    for i, v in settingInfo.metaData.presets[targetValue] {
        GuiControl,, % settingUnderscore . "_" . v, 1
    }

    local value := []
    for i, opt in settingInfo.metaData.options {
        GuiControlGet, optChecked,, % settingUnderscore . "_" . opt
        if (optChecked)
        {
            value.Push(opt)
        }
    }
    settingInfo.setting[settingInfo.key] := value
    settings.Save(true)

    local parentSettingInfo := GetSettingInfo(settingInfo.parentPathUnderscore)
    GuiControl, %guiHwnd%:Text, % StrReplace(parentSettingInfo.pathUnderscore, "Settings", "SettingsText"), % GetSettingDisplay(parentSettingInfo)
}

SettingsModalGuiClose()
{
    Gui, SettingsModal:Destroy
}

GetSettingDisplay(settingInfo)
{
    if !IsObject(settingInfo) {
        settingInfo := GetSettingInfo(settingInfo)
    }

    display := ""

    for i, v in settingInfo.metaData.displayOrder
    {
        settingUnderscore := settingInfo.pathUnderscore . "_" . v
        
        childSettingInfo := GetSettingInfo(settingUnderscore)
        strValue := ""

        settingValue := childSettingInfo.setting[childSettingInfo.key]

        if IsArray(settingValue)
        {
            for i, opt in settingValue {
                strValue := strValue . "," . opt
            }
            strValue := childSettingInfo.key . ": " . SubStr(strValue, 2)
        }
        else {
            strValue := childSettingInfo.key . ": " . settingValue
        }
        
        display .= strValue . "; "
    }

    if (!display) {
        settingValue := settingInfo.setting[settingInfo.key]
        display .= settingInfo.key . " : "
        for k, v in settingValue {
            display .= v . "; "
        }
    }

    Return display
}

AddSetting(settingInfo, targetGui, opts := "") {
    global

    if (!IsObject(settingInfo)) {
        settingInfo := GetSettingInfo(settingInfo)
    }

    opts := InitOps(opts, { offsetX : 10 })
    local settingUnderscore := settingInfo.pathUnderScore

    switch (settingInfo.metaData.type)
    {
        case "Text":
        {
            Gui, %targetGui%:Add, Text, xs+5 y+5 cWhite, % settingInfo.path

            local targetKey := ""
            RegExMatch(settingUnderscore, "[^_]+?$", targetKey)
            local newRow := settingInfo.metaData.newLine
            local controlOpts := "x+10 gSettingChanged v" . settingUnderscore 
                . (newRow ? " xs+" . opts.offsetX . " y+5" : " x+10")
            if (settingInfo.metaData.optsOverride) {
                controlOpts := "x+10 gSettingChanged v" . settingUnderscore . " " . settingInfo.metaData.optsOverride
            }
            if (opts.optsOverride) {
                controlOpts := "x+10 gSettingChanged v" . settingUnderscore . " " . opts.optsOverride
            }
            ;Gui %targetGui%:Add, Text, cWhite, % CapitalizeFirstLetter(targetKey) . ": "
            Gui %targetGui%:Add, Edit, % controlOpts,
            GuiControl,, % settingUnderscore, % settingInfo.setting[settingInfo.key]
            Gui, %targetGui%:Add, Text, xs y+5 0x10 w400 cWhite
        }
        case "Number":
        {
            Gui, %targetGui%:Add, Text, xs+5 y+5 cWhite, % settingInfo.path

            local targetKey := ""
            RegExMatch(settingUnderscore, "[^_]+?$", targetKey)
            local newRow := settingInfo.metaData.newLine
            local controlOpts := "x+10 w25 gSettingChanged v" . settingUnderscore 
                . (newRow ? " xs+" . opts.offsetX . " y+5" : " x+10")
            if (settingInfo.metaData.optsOverride) {
                controlOpts := "x+10 Number gSettingChanged v" . settingUnderscore . " " . settingInfo.metaData.optsOverride
            }
            if (opts.optsOverride) {
                controlOpts := "x+10 Number gSettingChanged v" . settingUnderscore . " " . opts.optsOverride
            }
            ;Gui %targetGui%:Add, Text, cWhite, % CapitalizeFirstLetter(targetKey) . ": "
            Gui %targetGui%:Add, Edit, % controlOpts,
            GuiControl,, % settingUnderscore, % settingInfo.setting[settingInfo.key]
            Gui, %targetGui%:Add, Text, xs y+5 0x10 w400 cWhite
        }
        case "Checkbox":
        {
            local targetKey := ""
            RegExMatch(settingUnderscore, "[^_]+?$", targetKey)
            local newRow := settingInfo.metaData.newLine
            local controlOpts := "cWhite gSettingChanged v" . settingUnderscore 
                . (newRow ? " xs+" . opts.offsetX . " y+5" : " x+10")
            if (settingInfo.metaData.optsOverride) {
                controlOpts := "cWhite gSettingChanged v" . settingUnderscore . " " . settingInfo.metaData.optsOverride
            }
            if (opts.optsOverride) {
                controlOpts := "cWhite gSettingChanged v" . settingUnderscore . " " . opts.optsOverride
            }
            Gui %targetGui%:Add, Checkbox, % controlOpts, % CapitalizeFirstLetter(targetKey)
            GuiControl,, % settingUnderscore, % settingInfo.setting[settingInfo.key] ? 1 : 0
        }
        case "Radio":
        {
            if (!opts.hideLabel) {
                Gui,  %targetGui%:Add, Text, xs+5 y+5 cWhite, % settingInfo.path
            }

            for i, opt in settingInfo.metaData.options {
                local newRow := false
                if (i = 1 || Mod(i - 1, settingInfo.metaData.itemsPerRow) = 0) {
                    newRow := true
                }
                local controlOpts := % "cWhite gSettingChanged v" . settingUnderscore . "_" . opt . (newRow ? " xs+10 y+5" : " x+10")

                if (opts.optsOverride) {
                    controlOpts := "cWhite gSettingChanged v" . settingUnderscore . "_" . opt . " " . opts.optsOverride
                }

                Gui %targetGui%:Add, Radio, % controlOpts, % opt
            }

            GuiControl,, % settingUnderscore . "_" . settingInfo.setting[settingInfo.key], 1

            if (!opts.hideLabel) {
                Gui, %targetGui%:Add, Text, xs y+5 0x10 w400 cWhite
            }
        }
        case "Dropdown":
        {
            if (!opts.hideLabel) {
                Gui,  %targetGui%:Add, Text, xs+5 y+5 cWhite, % settingInfo.path
            }

            local controlOpts := "x+10 gSettingChanged v" . settingUnderscore 
                . (newRow ? " xs+" . opts.offsetX . " y+5" : " x+10")
            if (settingInfo.metaData.optsOverride) {
                controlOpts := "x+10 gSettingChanged v" . settingUnderscore . " " . settingInfo.metaData.optsOverride
            }
            if (opts.optsOverride) {
                controlOpts := "x+10 gSettingChanged v" . settingUnderscore . " " . opts.optsOverride
            }

            Gui %targetGui%:Add, DropDownList, % controlOpts, % settingInfo.metaData.options
            GuiControl, ChooseString, % settingUnderscore, % settingInfo.setting[settingInfo.key]

            if (!opts.hideLabel) {
                Gui, %targetGui%:Add, Text, xs y+5 0x10 w400 cWhite
            }
        }
        case "Array":
        {
            Gui, %targetGui%:Add, Text, xs y+5 cWhite, % settingInfo.path

            local index := 1
            for key, preset in settingInfo.metaData.presets {
                local newRow := false
                if (index = 1) {
                    newRow := true
                }
                Gui %targetGui%:Add, Radio, % "cWhite gSettingPresetChanged v" . settingUnderscore . "_" . key
                    . (newRow ? " xs y+5" : " x+10"), % key
                index++
            }

            for i, opt in settingInfo.metaData.options {
                local newRow := false
                if (i = 1 || Mod(i - 1, settingInfo.metaData.itemsPerRow) = 0) {
                    newRow := true
                }
                
                Gui %targetGui%:Add, Checkbox, % "cWhite gSettingChanged v" . settingUnderscore . "_" . opt
                    . (newRow ? " xs y+5" : " x+10"), % opt
            }

            for i, v in settingInfo.setting[settingInfo.key] {
                GuiControl,, % settingUnderscore . "_" . v, 1
            }

            Gui, %targetGui%:Add, Text, xs y+5 0x10 w400 cWhite
        }
        case "Pattern":
        {
            for k, v in settingInfo.metaData {
                if (k = "type" || k = "isArrayItem") {
                    Continue
                }

                if (!settingInfo.setting[settingInfo.key]) {
                    settingInfo.setting[settingInfo.key] := {}
                }

                if (k != "default" && k != "userPattern" && !settingInfo.setting[settingInfo.key][k]) {
                    settingInfo.setting[settingInfo.key][k] := {}
                }
            }

            Gui, %targetGui%:Add, Text, xs y+5 cWhite, % settingInfo.path
            Gui, %targetGui%:Add, TreeView, % (settingInfo.metaData.checked ? "checked " : "" ) . "xs+10 y+5 w170 h340 cBlack AltSubmit gSelectPatternSetting vPatternSettingSelect_" 
                . settingUnderscore . (opts.battleContext ? "_battleContext_" . opts.battleContext . "_" . opts.setting : "")

            Gui, %targetGui%:Add, Groupbox, x+10 w300 h200 section cWhite, Preview
            Gui, %targetGui%:Add, Edit, % "xp+5 yp+15 cBlack w280 vPatternSettingValue_" . settingUnderscore
            Gui, %targetGui%:Font, cBlack
            Gui, %targetGui%:Font, s3
            Gui, %targetGui%:Add, Edit, % "y+5 cBlack w280 r30 vPatternSettingPreview_" . settingUnderscore
            Gui, %targetGui%:Font

            if (!settingInfo.metaData.disableAdd) {
                Gui, %targetGui%:Add, Groupbox, xp y+5 w200 h40 cWhite, Add
                Gui, %targetGui%:Add, Text, xp+5 yp+15 cWhite, Key: 
                Gui, %targetGui%:Add, Edit, % "x+10 w100 vPatternSettingKey_" . settingUnderscore, Key
                Gui, %targetGui%:Add, Button, % "x+10 gAddPatternSetting vPatternSettingAdd_" . settingUnderscore, Add

                Gui, %targetGui%:Add, Groupbox, xp-146 y+5 w200 h40 cWhite, Delete
                Gui, %targetGui%:Add, Button, % "xp+5 yp+15 gDeletePatternSetting vPatternSettingDelete_" . settingUnderscore, Delete
            }

            if (settingInfo.metaData.props) {
                h := settingInfo.metaData.props.Count() * 15
                Gui, %targetGui%:Add, Groupbox, xp-5 y+5 w200 h%h% section cWhite, Props

                firstProp := true
                for k, v in settingInfo.metaData.props {
                    
                    position := "xs+5 y+5"

                    if (k != "default" && firstProp) {
                        position := "xs+5 ys+15"
                        firstProp := false
                    }

                    if (v.type = "Checkbox") {
                        Gui, %targetGui%:Add, Checkbox, % position . " cWhite gCheckedChangedPatternSettingProp vPatternSettingCheckBoxProp_"
                            . settingUnderscore . "_" . k, % k
                    }
                    else if (v.type = "Dropdown") {
                        Gui, %targetGui%:Add, Text, % position . " cWhite", % k . ": "
                        Gui, %targetGui%:Add, DropDownList, % "x+10 cWhite gDropDownChangedPatternSettingProp vPatternSettingDropDownProp_"
                            . settingUnderscore . "_" . k, % v.options
                    }
                }
            }
            
            Gui, %targetGui%:Add, Groupbox, x10 y380 w400 h70 section cWhite, Edit

            Gui, %targetGui%:Add, Button, % "x15 yp+15 gPickPatternSettingColor vPatternSettingColorPick_" . settingUnderscore, Pick Color
            Gui, %targetGui%:Add, Edit, % "cBlack x+5 w100 vPatternSettingColor_" . settingUnderscore,
            Gui, %targetGui%:Add, Text, cWhite x+5, Variance: 
            Gui, %targetGui%:Add, Edit, % "cBlack x+5 w30 cBlack vPatternSettingColorVariance_" . settingUnderscore, 10
            Gui, %targetGui%:Add, Button, % "x+5 gApplyPatternSettingColor vPatternSettingColorApply_" . settingUnderscore, DoColorPattern
            Gui, %targetGui%:Add, Text, cWhite x15 y+5, Gray Diff: 
            Gui, %targetGui%:Add, Edit, % "cBlack x+5 w100 cBlack vPatternSettingGrayDiff_" . settingUnderscore, 50
            Gui, %targetGui%:Add, Button, % "x+106 gApplyPatternSettingGrayDiff vPatternSettingGrayDiffApply_" . settingUnderscore, DoGrayPattern

            Gui, %targetGui%:Add, Groupbox, x10 y+15 w400 h80 section cWhite, Test

            Gui Add, Checkbox, % "x15 yp+15 cWhite vPatternSettingTestMulti_" . settingUnderscore, Multi
            Gui Add, Text, cWhite x+5, FG Variance:
            Gui Add, Slider, % "x+5 w200 tickinterval5 tooltip vPatternSettingTestVariance_" . settingUnderscore, 15
            Gui Add, Button, % "x15 y+5 gTestPatternSetting vPatternSettingTest_" . settingUnderscore, Test

            Gui Add, Text, x15 y+5,

            InitPatternSettingTreeView(settingUnderscore, opts)
        }
    }
}

DropDownChangedPatternSettingProp() {
    global settings

    GuiControlGet, state,, % A_GuiControl
    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingDropDownProp_", "")
    settingUnderscore := RegExReplace(settingUnderscore, "_[^_]+?$", "")
    targetProp := ""
    RegExMatch(A_GuiControl, "[^_]+?$", targetProp)

    settingInfo := GetSettingInfo(settingUnderscore)
    patternObject := settingInfo.setting[settingInfo.key]

    selectedItem := TV_GetSelection()
    parentId := TV_GetParent(selectedItem)
    
    if (parentId = "0") {
        TV_GetText(targetKey, selectedItem)

        if (!IsObject(patternObject[targetKey]))
        {
            patternObject[targetKey] := { 1 : patternObject[targetKey] }
            reset := true
        }

        patternObject[targetKey][targetProp] := state
        settings.save(true)

        if (reset) {
            InitPatternSettingTreeView(settingUnderscore)
        }
    }
    else {
        MsgBox, 262144, Warning, Setting only valid for top level items
    }
}

CheckedChangedPatternSettingProp() {
    global settings

    GuiControlGet, state,, % A_GuiControl
    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingCheckBoxProp_", "")
    settingUnderscore := RegExReplace(settingUnderscore, "_[^_]+?$", "")
    targetProp := ""
    RegExMatch(A_GuiControl, "[^_]+?$", targetProp)

    settingInfo := GetSettingInfo(settingUnderscore)
    patternObject := settingInfo.setting[settingInfo.key]

    selectedItem := TV_GetSelection()
    parentId := TV_GetParent(selectedItem)
    
    if (parentId = "0") {
        TV_GetText(targetKey, selectedItem)

        if (!IsObject(patternObject[targetKey]))
        {
            patternObject[targetKey] := { 1 : patternObject[targetKey] }
            reset := true
        }

        patternObject[targetKey][targetProp] := state
        settings.save(true)

        if (reset) {
            InitPatternSettingTreeView(settingUnderscore)
        }
    }
    else {
        MsgBox, 262144, Warning, Setting only valid for top level items
    }
}

TestPatternSetting() {
    global hwnd, settings

    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingTest_", "")
    settingInfo := GetSettingInfo(settingUnderscore)
    GuiControlGet, pattern,, % "PatternSettingValue_" . settingUnderscore
    GuiControlGet, patternVariance,, % "PatternSettingTestVariance_" . settingUnderscore
    GuiControlGet, patternTestMulti,, % "PatternSettingTestMulti_" . settingUnderscore

    opts := { multi : patternTestMulti, variancePct : patternVariance }
    result := FindPattern(pattern, opts)

    if (result.IsSuccess) {
        ToolTipExpire("Pattern " . settingUnderscore . " FOUND " . result.multi.Length())
        if (testPatternMulti) {
            for k, v in result.multi {
                FindText().ClientToScreen(x, y, v.X, v.Y, hwnd)
                FindText().MouseTip(x, y)
            }
        }
        Else {
            ToolTipExpire("Pattern " . settingUnderscore . " FOUND")
            FindText().ClientToScreen(x, y, result.X, result.Y, hwnd)
            FindText().MouseTip(x, y)
        }
    }
    Else {
        ToolTipExpire("Pattern " . settingUnderscore . " NOT FOUND")
    }
}

ApplyPatternSettingColor() {
    global settings, patterns

    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingColorApply_", "")
    settingInfo := GetSettingInfo(settingUnderscore)
    GuiControlGet, patternColorPick,, % "PatternSettingColor_" . settingUnderscore
    GuiControlGet, patternColorVariance,, % "PatternSettingColorVariance_" . settingUnderscore

    nodePath := GetNodePath()
    pattern := GetPatternColor2Two(patternColorPick, 100-patternColorVariance)

    if (!pattern) {
        Return
    }

    ascii := FindText().ASCII(pattern)

    segments := StrSplit(nodePath, ".")
    target := settingInfo.setting[settingInfo.key]
    for k, v in segments {
        lastParent := target
        lastKey := v
        target := target[v]
    }

    lastParent[lastKey] := pattern
    settings.save(true)

    GuiControl,, % "PatternSettingValue_" . settingUnderscore, % pattern
    If InStr(pattern, "|<") {
        ascii := FindText().ASCII(pattern)
        GuiControl,, % "PatternSettingPreview_" . settingUnderscore, % Trim(ascii,"`n")
    }

    InitUserPatterns(patterns, settings.userPatterns)

    Gui 1:Default
    TV_Delete()
    InitPatternsTree()
}

PickPatternSettingColor() {
    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingColorPick_", "")
    color := GetPixelColor()
    GuiControl,, % "PatternSettingColor_" . settingUnderscore, % color
}

ApplyPatternSettingGrayDiff() {
    global settings, patterns, patternsTree
    
    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingGrayDiffApply_", "")
    settingInfo := GetSettingInfo(settingUnderscore)
    GuiControlGet, grayDiff,, % "PatternSettingGrayDiff_" . settingUnderscore
    pattern := GetPatternGrayDiff(grayDiff)

    if (!pattern) {
        Return
    }

    nodePath := GetNodePath()
    pattern := RegExReplace(pattern, "<.*?>", "<" . StrReplace(settingUnderscore, "_", ".") . "." . nodePath . ">")

    ascii := FindText().ASCII(pattern)

    segments := StrSplit(nodePath, ".")
    target := settingInfo.setting[settingInfo.key]
    for k, v in segments {
        lastParent := target
        lastKey := v
        target := target[v]
    }
    
    lastParent[lastKey] := pattern

    ;userPattern and default happens in InitUserPatterns; Can't figure out how to prevent it. Don't know how to deep clone
    lastParent.Delete("userPattern")
    lastParent.Delete("default")
    settings.save(true)

    GuiControl,, % "PatternSettingValue_" . settingUnderscore, % pattern
    If InStr(pattern, "|<") {
        ascii := FindText().ASCII(pattern)
        GuiControl,, % "PatternSettingPreview_" . settingUnderscore, % Trim(ascii,"`n")
    }

    InitUserPatterns(patterns, settings.userPatterns)

    Gui 1:Default
    TV_Delete()
    InitPatternsTree()
}

InitPatternSettingTreeView(settingUnderScore, opts := "") {
    global settings
    opts := InitOps(opts, { })

    TV_Delete()
    settingInfo := GetSettingInfo(settingUnderscore)
    if (!settingInfo.setting[settingInfo.key]) {
        settingInfo.setting[settingInfo.key] := {}
    }
    InitPatternsTree(settingInfo.setting[settingInfo.key], { startPath : StrReplace(settingUnderScore, "_", "."), skipFields : ["disableAdd", "isLeaf", "checked", "props", "singleTarget", "priority", "label"]})

    if (opts.battleContext) {
        battleContext := opts.battleContext
        setting := opts.setting

        value := settings["battleOptions"][battleContext][setting]
        strValue := ","
        for k, v in value {
            strValue .= v . ","
        }

        item := TV_GetNext(0, "Full")

        while (item) {
            TV_GetText(name, item)
            parentId := TV_GetParent(item)

            if (parentId = "0" && InStr(strValue, "," . name . ",")) {
                TV_Modify(item, "Check")
            }
            item := TV_GetNext(item, "Full")
        }
    }
}

SelectPatternSetting() {
    global settings, guiHwnd

    RegExMatch(A_GuiControl, "(?P<control>.*?)_(?P<battleContext>battleContext.*?)$", battleContextMatch)   ;https://www.autohotkey.com/docs/commands/RegExMatch.htm#NamedSubPat
    guiControl := (battleContextMatch ? battleContextMatchControl : A_GuiControl)

    selectedItem := TV_GetSelection()
    TV_GetText(targetKey, selectedItem)
    parentId := TV_GetParent(selectedItem)

    if (battleContextMatch) {
        parts := StrSplit(battleContextMatchBattleContext, "_")
        battleContext := parts.2
        setting := parts.3

        if (A_GuiEvent = "Normal") {
            items := []
            checkedItem := TV_GetNext(0, "Checked")
            while (checkedItem) {
                TV_GetText(name, checkedItem)
                parentId := TV_GetParent(checkedItem)

                if (parentId = "0") {
                    items.Push(name)
                }
                checkedItem := TV_GetNext(checkedItem, "Checked")
            }

            settings["battleOptions"][battleContext][setting] := items
            settings.save(true)

            GuiControl, %guiHwnd%:Text, % "battleOptionsText_" . battleContext . "_" . setting, % GetSettingDisplay("settings_battleOptions_" . battleContext . "_" . setting)
        }

        if (setting = "skills") {
            if (!parentId) {
                GuiControl, Enable, PatternSettingCheckBoxProp_settings_userPatterns_battle_skills_singleTarget
                GuiControl, Enable, PatternSettingDropDownProp_settings_userPatterns_battle_skills_priority

                singleTarget := settings["userPatterns"]["battle"]["skills"][targetKey]["singleTarget"]
                GuiControl,, PatternSettingCheckBoxProp_settings_userPatterns_battle_skills_singleTarget, % (singleTarget ? 1 : 0)
                priority := settings["userPatterns"]["battle"]["skills"][targetKey]["priority"]
                if (!priority) {
                    priority := "Normal"
                }
                GuiControl, ChooseString, PatternSettingDropDownProp_settings_userPatterns_battle_skills_priority, % priority
            }
            else {
                GuiControl, Disable, PatternSettingCheckBoxProp_settings_userPatterns_battle_skills_singleTarget
                GuiControl, Disable, PatternSettingDropDownProp_settings_userPatterns_battle_skills_priority
            }
        }
    }

    settingUnderscore := StrReplace(guiControl, "PatternSettingSelect_", "")
    settingInfo := GetSettingInfo(settingUnderscore)

    nodePath := GetNodePath()
    segments := StrSplit(nodePath, ".")
    target := settingInfo.setting[settingInfo.key]

    for k, v in segments
        target := target[v]

    GuiControl,, % "PatternSettingValue_" . settingUnderscore, % target
    If InStr(target, "|<") {
        ascii := FindText().ASCII(target)
        GuiControl,, % "PatternSettingPreview_" . settingUnderscore, % Trim(ascii,"`n")
    }
    else {
        GuiControl,, % "PatternSettingPreview_" . settingUnderscore,
    }

    if (!parentId && settingInfo.setting[settingInfo.key][targetKey].1) {
        GuiControl, Disable, % "PatternSettingColorApply_" . settingUnderscore
        GuiControl, Disable, % "PatternSettingGrayDiffApply_" . settingUnderscore
    }
    else {
        GuiControl, Enable, % "PatternSettingColorApply_" . settingUnderscore
        GuiControl, Enable, % "PatternSettingGrayDiffApply_" . settingUnderscore
    }

    if (!parentId) {
        GuiControl, Enable, % "PatternSettingDelete_" . settingUnderscore
    }
    else {
        GuiControl, Disable, % "PatternSettingDelete_" . settingUnderscore
    }

}

AddPatternSetting() {
    global settings, patterns

    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingAdd_", "")
    GuiControlGet, key,, % "PatternSettingKey_" . settingUnderscore
    settingInfo := GetSettingInfo(settingUnderscore)
    patternObject := settingInfo.setting[settingInfo.key]
    
    if (!patternObject || IsArray(patternObject)) {
        settingInfo.setting[settingInfo.key] := {}
        patternObject := settingInfo.setting[settingInfo.key]
    }
    
    if (patternObject[key]) {
        MsgBox, 262144, Warning, Key already exists...
        Return
    }

    patternObject[key] := "Placeholder"
    patternObject.Delete("userPattern")
    patternObject.Delete("default")

    settings.save(true)
    InitPatternSettingTreeView(settingUnderScore)

    Gui 1:Default
    TV_Delete()
    InitPatternsTree()
}

DeletePatternSetting() {
    global settings, patterns

    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingDelete_", "")
    settingInfo := GetSettingInfo(settingUnderscore)
    patternObject := settingInfo.setting[settingInfo.key]
    
    if (!patternObject || IsArray(patternObject)) {
        settingInfo.setting[settingInfo.key] := {}
        patternObject := settingInfo.setting[settingInfo.key]
    }
    
    selectedId := TV_GetSelection()
    TV_GetText(key, selectedId)
    patternObject.Delete(key)

    settings.save(true)
    InitPatternSettingTreeView(settingUnderScore)

    Gui 1:Default
    TV_Delete()
    InitPatternsTree()
}

SettingChanged()
{
    global

    local settingUnderscore := RegExReplace(A_GuiControl, "_[^_]+?$", "")
    local targetValue := ""
    RegExMatch(A_GuiControl, "[^_]+?$", targetValue)

    local settingInfo := GetSettingInfo(settingUnderscore)
    
    if (!settingInfo.metaData.type) {
        local settingInfo := GetSettingInfo(A_GuiControl)
    }

    switch (settingInfo.metaData.type)
    {
        case "Text":
        {
            GuiControlGet, textVal, , % A_GuiControl
            settingInfo.setting[settingInfo.key] := textVal
            settings.Save(true)
        }
        case "Number":
        {
            GuiControlGet, textVal, , % A_GuiControl
            settingInfo.setting[settingInfo.key] := textVal
            settings.Save(true)
        }
        case "Checkbox":
        {
            GuiControlGet, boolVal, , % A_GuiControl
            settingInfo.setting[settingInfo.key] := boolVal
            settings.Save(true)
        }
        case "Radio":
        {
            settingInfo.setting[settingInfo.key] := targetValue
            settings.Save(true)
        }
        case "DropDown":
        {
            GuiControlGet, textVal, , % A_GuiControl
            settingInfo.setting[settingInfo.key] := textVal
            settings.Save(true)
        }
        case "Array":
        {
            local value := []
            strValue := ""
            for i, opt in settingInfo.metaData.options {
                GuiControlGet, optChecked,, % settingUnderscore . "_" . opt
                if (optChecked)
                {
                    value.Push(opt)
                    strValue := strValue . "," . opt
                }
            }
            strValue := SubStr(strValue, 2)
            settingInfo.setting[settingInfo.key] := value
            settings.Save(true)
        }
    }

    if (settingInfo.metaData.callBack) {
        settingInfo.metaData.callBack()
    }

    local parentSettingInfo := GetSettingInfo(settingInfo.parentPathUnderscore)
    local targetControl := StrReplace(parentSettingInfo.pathUnderscore, "Settings", "SettingsText")
    GuiControl, %guiHwnd%:Text, % StrReplace(parentSettingInfo.pathUnderscore, "Settings", "SettingsText"), % GetSettingDisplay(parentSettingInfo)
}

GetSettingMetaData(settingUnderscore)
{
    global metadata

    path := StrReplace(settingUnderscore, "_", ".")
    segments := StrSplit(settingUnderscore, "_")
    numSegments := segments.Length()
    settingMetaData := metadata
    targetKey := segments[numSegments]

    Loop, % numSegments - 1
    {
        if (A_Index = 1) {  ;first segment is settings
            Continue
        }

        key := segments[A_Index]
        settingMetaData := settingMetaData[key]
    }

    settingMetaData := settingMetaData[targetKey]

    Return settingMetaData
}

GetSettingInfo(settingUnderscore) {
    global settings, metadata

    path := StrReplace(settingUnderscore, "_", ".")
    parentPath := RegExReplace(path, "\.[^\.]+?$", "")
    parentPathUnderScore := StrReplace(parentPath, ".", "_")
    segments := StrSplit(settingUnderscore, "_")
    numSegments := segments.Length()
    targetSetting := settings
    settingMetaData := metadata
    targetKey := segments[numSegments]

    Loop, % numSegments - 1
    {
        if (A_Index = 1) {  ;first segment is settings
            Continue
        }

        key := segments[A_Index]
        if (!targetSetting[key])
        {
            targetSetting[key] := {}
        }

        targetSetting := targetSetting[key]
        settingMetaData := settingMetaData[key]
    }

    settingMetaData := settingMetaData[targetKey]

    Return { setting : targetSetting, metaData : settingMetaData, key : targetKey, path : path, pathUnderScore : settingUnderscore, parentPath : parentPath, parentPathUnderScore : parentPathUnderScore }
}

InitMetaDataItemWorldOptions(metadata) {
    itemWorldOptionsMetaData := {}
    itemWorldOptionsMetaData.displayOrder := ["targetItemType", "targetItemSort", "targetItemSortOrder", "prioritizeEquippedItems", "targetItemRarity", "lootTarget", "bribe", "farmLevels", "lootTargetLegendaryOnLvl100"]
    itemWorldOptionsMetaData.targetItemType := {}
    itemWorldOptionsMetaData.targetItemType.type := "Radio"
    itemWorldOptionsMetaData.targetItemType.options := ["armor", "weapon"]
    itemWorldOptionsMetaData.targetItemSort := {}
    itemWorldOptionsMetaData.targetItemSort.type := "Radio"
    itemWorldOptionsMetaData.targetItemSort.options := ["gained", "rarity", "innocents", "retain"]
    itemWorldOptionsMetaData.targetItemRarity := {}
    itemWorldOptionsMetaData.targetItemRarity.type := "Radio"
    itemWorldOptionsMetaData.targetItemRarity.options := ["any", "legendary", "rareOrLegendary", "rare", "common"]
    itemWorldOptionsMetaData.targetItemSortOrder := {}
    itemWorldOptionsMetaData.targetItemSortOrder.type := "Radio"
    itemWorldOptionsMetaData.targetItemSortOrder.options := ["ascending", "descending", "retain"]
    itemWorldOptionsMetaData.prioritizeEquippedItems := {}
    itemWorldOptionsMetaData.prioritizeEquippedItems.type := "Radio"
    itemWorldOptionsMetaData.prioritizeEquippedItems.options := ["yes", "no", "retain"]
    itemWorldOptionsMetaData.lootTarget := {}
    itemWorldOptionsMetaData.lootTarget.type := "Radio"
    itemWorldOptionsMetaData.lootTarget.options := ["any", "legendary", "rareOrLegendary", "rare"]
    itemWorldOptionsMetaData.bribe := {}
    itemWorldOptionsMetaData.bribe.type := "Radio"
    itemWorldOptionsMetaData.bribe.options := ["none", "goldenCandy", "goldBar", "crabMiso"]
    itemWorldOptionsMetaData.farmLevels := {}
    itemWorldOptionsMetaData.farmLevels.type := "Array"
    itemWorldOptionsMetaData.farmLevels.options := [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    itemWorldOptionsMetaData.farmLevels.itemsPerRow := 5
    itemWorldOptionsMetaData.farmLevels.presets := {}
    itemWorldOptionsMetaData.farmLevels.presets.default := [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    itemWorldOptionsMetaData.farmLevels.presets.none := []
    itemWorldOptionsMetaData.farmLevels.presets.higherDropRate := [30, 60, 100]
    itemWorldOptionsMetaData.lootTargetLegendaryOnLvl100 := {}
    itemWorldOptionsMetaData.lootTargetLegendaryOnLvl100.newLine := true
    itemWorldOptionsMetaData.lootTargetLegendaryOnLvl100.type := "CheckBox"
    
    metadata.itemWorldOptions := {}
    metadata.itemWorldOptions.findDropMode := {}
    metadata.itemWorldOptions.findDropMode.type := "Radio"
    metadata.itemWorldOptions.findDropMode.options := ["default", "menu"]
    metadata.itemWorldOptions.1 := itemWorldOptionsMetaData
    metadata.itemWorldOptions.2 := itemWorldOptionsMetaData
}

;https://www.autohotkey.com/boards/viewtopic.php?t=33843
InitSettings()
{
    global patterns
	fileName := "settings.json"
	;fileDir := ""
	;filePath := fileDir . "\" . fileName
	filePath := fileName

	; IF !FileExist(fileDir)
	; {
	; 	FileCreateDir, %fileDir%
	; }
	
    defaults := GenerateSettingDefaults()

	IF !FileExist(filePath)
	{
		settings := new JsonFile(filePath) ;- Create instance.

        settings.battleOptions := {}
        settings.window := defaults.window
        settings.battleOptions.event := defaults.battleOptions.event
        settings.battleOptions.default := defaults.battleOptions.default
        settings.battleOptions.itemWorld := defaults.battleOptions.itemWorld
        settings.battleOptions.sweep := defaults.battleOptions.sweep
        settings.battleOptions.raid := defaults.battleOptions.raid
        settings.battleOptions.darkGateMats := defaults.battleOptions.darkGateMats
        settings.battleOptions.darkGateHL := defaults.battleOptions.darkGateHL
        settings.itemWorldOptions := defaults.itemWorldOptions
        settings.eventOptions := defaults.eventOptions
        settings.userPatterns := defaults.userPatterns
        settings.general := defaults.general
		settings.save(true)
	}
	Else
	{
		settings := new JsonFile(filePath) ;- Create instance.
	}

	Return settings
}

InitUserPatterns(patterns, node, path := "") {
    If InStr(path, "userPattern") || InStr(path, "default") {
        Return
    }

    ; OutputDebug, % path

    ; if (node.isLeaf || !IsObject(node)) {
    if (!IsObject(node) || IsArray(node) || (IsObject(node) && node.1)) {
        target := patterns
        segments := StrSplit(path, ".")

        ; OutputDebug, Not Object Or Array

        for i, seg in segments {
            if (!seg) {
                Continue
            }

            lastParent := target
            lastKey := seg
            target := target[seg]
        }

        if (!lastParent[lastKey]) {
            lastParent[lastKey] := {}
        }

        lastParent[lastKey] := { default : lastParent[lastKey] }
        lastParent[lastKey].userPattern := node
    }
    else {
        for k, v in node
        {
            InitUserPatterns(patterns, v, path . "." . k)
        }
    }
}

GetDailyStats() {
    currentDateUTC := A_NowUTC
    FormatTime, hour, % currentDateUTC, H
    if (hour < 4) {    ;UTC reset hour
        currentDateUTC += -1, D
    }
    FormatTime, date, % currentDateUTC, yyyyMMdd

    fileName := date . ".json"
	fileDir := "dailies"
	filePath := fileDir . "\" . fileName

	IF !FileExist(fileDir)
	{
		FileCreateDir, %fileDir%
	}

    IF !FileExist(filePath)
	{
		dailyStats := new JsonFile(filePath) ;- Create instance.
        settings.save(true)
	}
	Else
	{
		dailyStats := new JsonFile(filePath) ;- Create instance.
	}

    Return dailyStats
}