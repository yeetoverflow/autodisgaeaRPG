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

    opts := InitOps(opts, { offsetX : 10 })
    local settingUnderscore := settingInfo.pathUnderScore

    switch (settingInfo.metaData.type)
    {
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
            Gui,  %targetGui%:Add, Text, xs y+5 cWhite, % settingInfo.path

            for i, opt in settingInfo.metaData.options {
                local newRow := false
                if (i = 1 || Mod(i - 1, settingInfo.metaData.itemsPerRow) = 0) {
                    newRow := true
                }
                
                Gui %targetGui%:Add, Radio, % "cWhite gSettingChanged v" . settingUnderscore . "_" . opt
                    . (newRow ? " xs+10 y+5" : " x+10"), % opt
            }

            GuiControl,, % settingUnderscore . "_" . settingInfo.setting[settingInfo.key], 1

            Gui, %targetGui%:Add, Text, xs y+5 0x10 w400 cWhite
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
            Gui, %targetGui%:Add, TreeView, % (settingInfo.metaData.checked ? "checked " : "" ) . "xs+10 y+5 h300 cBlack AltSubmit gSelectPatternSetting vPatternSettingSelect_" 
                . settingUnderscore . (opts.battleContext ? "_battleContext_" . opts.battleContext . "_" . opts.setting : "")

            if (!settingInfo.metaData.disableAdd) {
                Gui, %targetGui%:Add, Text, x+10 ys+30 cWhite, Key: 
                Gui, %targetGui%:Add, Edit, % "x+10 w100 vPatternSettingKey_" . settingUnderscore, Key
                Gui, %targetGui%:Add, Button, % "gAddPatternSetting vPatternSettingAdd_" . settingUnderscore, Add
                Gui, %targetGui%:Add, Button, % "gDeletePatternSetting vPatternSettingDelete_" . settingUnderscore, Delete
            }

            if (settingInfo.metaData.props) {
                for k, v in settingInfo.metaData.props {
                    if (v.type = "Checkbox") {
                        Gui, %targetGui%:Add, Checkbox, % "cWhite gCheckedChangedPatternSettingProp vPatternSettingCheckBoxProp_"
                            . settingUnderscore . "_" . k, % k
                    }
                    else if (v.type = "Dropdown") {
                        Gui, %targetGui%:Add, Text, cWhite, % k . ": "
                        Gui, %targetGui%:Add, DropDownList, % "cWhite gDropDownChangedPatternSettingProp vPatternSettingDropDownProp_"
                            . settingUnderscore . "_" . k, % v.options
                    }
                }
            }
           
            Gui, %targetGui%:Add, Edit, % "xs+10 ys+330 cBlack w400 vPatternSettingValue_" . settingUnderscore

            Gui, %targetGui%:Font, cBlack
            Gui, %targetGui%:Font, s3
            Gui, %targetGui%:Add, Edit, % "xs+10 y+5 cBlack w400 r20 vPatternSettingPreview_" . settingUnderscore
            Gui, %targetGui%:Font
            Gui, %targetGui%:Add, Button, % "gPickPatternSettingColor vPatternSettingColorPick_" . settingUnderscore, Pick Color
            Gui, %targetGui%:Add, Edit, % "cBlack x+5 w100 vPatternSettingColor_" . settingUnderscore,
            Gui, %targetGui%:Add, Text, cWhite x+5, Variance: 
            Gui, %targetGui%:Add, Edit, % "cBlack x+5 w30 cBlack vPatternSettingColorVariance_" . settingUnderscore, 10
            Gui, %targetGui%:Add, Button, % "x+5 gApplyPatternSettingColor vPatternSettingColorApply_" . settingUnderscore, DoColorPattern
            Gui, %targetGui%:Add, Text, cWhite xs+10 y+5, Gray Diff: 
            Gui, %targetGui%:Add, Edit, % "cBlack x+5 w100 cBlack vPatternSettingGrayDiff_" . settingUnderscore, 50
            Gui, %targetGui%:Add, Button, % "x+5 gApplyPatternSettingGrayDiff vPatternSettingGrayDiffApply_" . settingUnderscore, DoGrayPattern
            Gui Add, Text, cWhite xs+10 y+10, FG Variance:
            Gui Add, Slider, % "w200 tickinterval5 tooltip vPatternSettingTestVariance_" . settingUnderscore
            Gui Add, Checkbox, % "cWhite xs+10 y+5 vPatternSettingTestMulti_" . settingUnderscore, Multi
            Gui Add, Button, % "xs+10 y+5 gTestPatternSetting vPatternSettingTest_" . settingUnderscore, Test

            InitPatternSettingTreeView(settingUnderscore, opts)
            ; if (!settingInfo.metaData.isArrayItem || settingInfo.setting[settingInfo.key].isLeaf) {
            ;     InitPatternSettingTreeView(settingUnderscore)
            ; }
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

    opts := { multi : patternTestMulti, fgVariancePct : patternVariance, bgVariancePct : patternVariance }
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
    global settings

    settingUnderscore := StrReplace(A_GuiControl, "PatternSettingColorApply_", "")
    settingInfo := GetSettingInfo(settingUnderscore)
    GuiControlGet, patternColorPick,, % "PatternSettingColor_" . settingUnderscore
    GuiControlGet, patternColorVariance,, % "PatternSettingColorVariance_" . settingUnderscore

    nodePath := GetNodePath()
    pattern := RegExReplace(pattern, "<.*?>", "<" . StrReplace(settingUnderscore, "_", ".") . "." . nodePath . ">")

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

    InitUserPatterns(settings.userPatterns)

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

    InitUserPatterns(settings.userPatterns)

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
    InitPatternsTree(settingInfo.setting[settingInfo.key], { startPath : StrReplace(settingUnderScore, "_", "."), skipFields : ["disableAdd", "isLeaf", "checked", "props", "singleTarget", "priority"]})

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