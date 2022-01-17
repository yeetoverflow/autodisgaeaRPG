SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

LogDir := A_ScriptDir . "\logs"
FormatTime, TimeString, %A_Now%, yyyyMMdd

IF !FileExist(LogDir)
{
	FileCreateDir, %LogDir%
}

LogFile := "logs/log" . TimeString . ".txt"

AddLog(message)
{
	global LogFile, editLogHwnd, settings

    if (settings.debug.doLog) {
        FileAppend, %A_Now% %message%`n, %LogFile%
        AppendText(editLogHwnd, A_Now . " " message . "`r`n")
        SendMessage, 0x0115, 7, 0,, ahk_id %editLogHwnd% ;WM_VSCROLL
    }
}

ToolTipExpire(message)
{
	ToolTip, %message%
	SetTimer, RemoveToolTip, -1000
}

RemoveToolTip()
{
	ToolTip
	return
}

;https://www.autohotkey.com/docs/commands/Run.htm
RunWaitOne(command) {
	; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99
	shell := ComObjCreate("WScript.Shell")
	; Execute a single command via cmd.exe
	exec := shell.Exec(ComSpec " /C " command)
	; Read and return the command's output
	return exec.StdOut.ReadAll()
}

ResizeWin(WinTitle, Width = 0,Height = 0)
{
  WinGetPos,X,Y,W,H,%WinTitle%

  If (Width = W && Height = H)
	Return

  If %Width% = 0
    Width := W

  If %Height% = 0
    Height := H

  WinMove,%WinTitle%,,%X%,%Y%,%Width%,%Height%
}

ClickResult(result) {
    Click("x" result.X " y" result.Y)
}

Click(target) {
    global hwnd
    ControlClick, %target%, % "ahk_id" hwnd
}

PollPattern(pattern, opts := "") {
	opts := InitOps(opts, { doClick : false, clickDelay : 0, bounds : "", pollInterval : 500, doubleCheck: false, doubleCheckDelay: 500, predicatePattern : "", maxCount : "", clickPattern : ""})

    opts.callback()
    count := 0
	originalDoClick := opts.doClick
    originalDoubleCheck := opts.doubleCheck
    opts.doClick := false
    opts.doubleCheck := false

    ;keep polling until predicatePattern is found
    if (opts.predicatePattern) {
        result := FindPattern(pattern, opts)
        targetResult := FindPattern(opts.predicatePattern, opts)

        if (targetResult.IsSuccess)
        {
            if (originalDoClick) {
                sleep, opts.clickDelay
                ClickResult(result)
            }
        }
        else {
            while (!targetResult.IsSuccess) {
                SetStatus("Try " . count, 2)
                
                opts.callback()
                sleep, opts.pollInterval
                result := FindPattern(pattern, opts)

                if (originalDoubleCheck) {
                    sleep, opts.doubleCheckDelay
                    result := FindPattern(pattern, opts)
                }

                if (result.IsSuccess && originalDoClick) {
                    successResult := result
                    sleep, opts.clickDelay
                    ClickResult(result)
                    sleep, opts.pollInterval
                }

                if (opts.clickPattern) {
                    FindPattern(opts.clickPattern, { doClick : true })
                }

                targetResult := FindPattern(opts.predicatePattern, opts)
            }
        }
        
        if (!result.comment) {
            result := initialResult
        }

        if (opts.maxCount && opt.maxCount >= count) {
            result.IsSuccess := false
        }

        if (!successResult) {
            successResult := result
        }

        Return successResult
    }

    result := FindPattern(pattern, opts)
    while (!result.IsSuccess && (!opts.maxCount || count < opts.maxCount)) {
        SetStatus("Try " . count, 2)
        sleep, opts.pollInterval
        opts.callback()

        if (opts.clickPattern) {
            FindPattern(opts.clickPattern, { doClick : true })
        }

        result := FindPattern(pattern, opts)
        count++
    }

    if (originalDoubleCheck) {
        sleep, opts.doubleCheckDelay
        result := FindPattern(pattern, opts)
    }
    
    if (originalDoClick) {
        sleep, opts.clickDelay
        ClickResult(result)
    }

	return result
}

FindPattern(pattern, opts := "") {
	global hwnd

	opts := InitOps(opts, { multi : false, variancePct : 15, fgVariancePct : 0, bgVariancePct : 0, bounds : "", doClick : false, clickDelay : 0, offsetX : 0, offsetY : 0, doubleCheck: false, doubleCheckDelay: 500})
    arrPattern := ToFlatArray(pattern)
    updateCallback := opts.updateCallback

    fgVariancePct := (opts.fgVariancePct ? opts.fgVariancePct : opts.variancePct) / 100
    bgVariancePct := (opts.bgVariancePct ? opts.bgVariancePct : opts.variancePct) / 100

    result := FindPatternLoop(arrPattern, { multi: opts.multi, err1 : fgVariancePct, err0 : bgVariancePct, bounds : opts.bounds })

    if (opts.doubleCheck) {
        sleep, opts.doubleCheckDelay
        result := FindPatternLoop(arrPattern, { multi: false, err1 : fgVariancePct, err0 : bgVariancePct, bounds : bounds })
    }

    if (result.IsSuccess && opts.offsetX) {
        result.X += opts.offsetX
    }

    if (result.IsSuccess && opts.offsetY) {
        result.Y += opts.offsetY
    }

	if (result.IsSuccess && opts.doClick) {
		sleep, opts.clickDelay
		ClickResult(result)
	}

	Return result
}

FindPatternLoop(arrPattern, opts := "") {
    global hwnd
    result := { IsSuccess: false }
    opts := InitOps(opts, { multi : false, err1 : 0, err0 : 0, bounds : "" })

    if (opts.bounds) {
        FindText().ClientToScreen(x1, y1, opts.bounds.x1, opts.bounds.y1, hwnd)
        FindText().ClientToScreen(x2, y2, opts.bounds.x2, opts.bounds.y2, hwnd)
        opts.bounds := { x1 : x1, y1 : y1, x2 : x2, y2 : y2 }
    }
    else {
        opts.bounds := { x1 : 0, y1 : 0, x2 : 0, y2 : 0 }
    }

    for index, pattern in arrPattern {
        RegExMatch(pattern, "<(?P<comment>.*)>", matches)   ;https://www.autohotkey.com/docs/commands/RegExMatch.htm#NamedSubPat
        SetStatus("Finding: " . matchesComment, 3)

        ok := FindText(X, Y, opts.bounds.x1, opts.bounds.y1, opts.bounds.x2, opts.bounds.y2, opts.err1, opts.err0, pattern, 1, opts.multi)
        if (ok)
        {
            result.IsSuccess := true
            FindText().ScreenToWindow(x, y, ok.1.x, ok.1.y, hwnd)
            result.X := x
            result.Y := y
            if (matchesComment)
                result.comment := matchesComment

            if (opts.multi) {
                result.multi := []
                for k, v in ok {
                    FindText().ScreenToWindow(x, y, v.x, v.y, hwnd)
                    result.multi.push({ X : x, Y : y })
                }
            }
            Break
        }
    }

    return result
}

InitOps(opts, defaultOpts) {
    if (opts) {
        for key, val in defaultOpts
        {
            if (!opts.HasKey(key)) {
                opts[key] := val
            }
        }
    }
    else {
        opts := defaultOpts
    }

    Return opts
}

ToFlatArray(obj) {
    arr := []

    if (IsObject(obj)) {
        for index, val in obj
        {
            for index2, val2 in ToFlatArray(val)
            {
                arr.push(val2)
            }
        }
    } else {
        arr.Push(obj)
    }

    Return arr
}

;https://www.autohotkey.com/boards/viewtopic.php?t=64332
;has integer keys 1 to n with no gaps, or is an empty object
IsArray(oArray)
{
    local
    if (!IsObject(oArray))
        Return 0
    if !ObjCount(oArray)
        return 1
    if !(ObjCount(oArray) = ObjLength(oArray))
        || !(ObjMinIndex(oArray) = 1)
    return 0
    for vKey in oArray
        if !(vKey = A_Index)
        return 0
    return 1
}

Traverse(node, data, opts) {
    opts := InitOps(opts, { dataCallback : "", callBack : "", skipFields : "" })
    ; if (!data.path) {
    ;     data.path := ""
    ; }

    ;use data callback to pass data from parent to child (path is automatic)
    if (opts.dataCallback) {
        dataCallback := opts.dataCallback
        data := %dataCallback%(node, data, opts)
    }

    if (opts.callBack) {
        callBack := opts.callBack
        %callBack%(node, data, opts)
    }

    if (opts.doDebug) {
        OutputDebug, % data.path
    }

    for k, v in node {
        if hasValue(opts.skipFields, k) {
            Continue
        }

        childData := ObjFullyClone(data)
        childData.key := k
        childData.value := v
        childData.path := childData.path . (childData.path ? "." : "") . k
        childData.parent := node
        childData.parentPath := data.path
        Traverse(v, childData, opts)
    }
}

LetUserSelectRect()
{
    ;global windowX, windowY
    CoordMode, Mouse ; Required: change coord mode to screen vs relative.

    ToolTip, Left Click (Hold) and Drag to create a rectangle
    SetSystemCursor("IDC_CROSS")
    static r := 3
    ; Create the "selection rectangle" GUIs (one for each edge).
    Loop 4 {
        Gui, r%A_Index%: -Caption +ToolWindow +AlwaysOnTop
        Gui, r%A_Index%: Color, Red
    }
    ; Disable LButton.
    Hotkey, *LButton, lusr_return, On

    ; Wait for user to press LButton or Escape
	Loop {
		
		if GetKeyState("LButton", "P") {
			Break
		}
		if GetKeyState("Esc", "P") {
            abort := true
            Break
		}

		sleep, 50
	}

    if (!abort) {
        ; Get initial coordinates.
        MouseGetPos, xorigin, yorigin
        ; Set timer for updating the selection rectangle.
        SetTimer, lusr_update, 10
        ; Wait for user to release LButton.
        KeyWait, LButton
    }
    
    ; Re-enable LButton.
    Hotkey, *LButton, Off
    ; Disable timer.
    SetTimer, lusr_update, Off
    ; Destroy "selection rectangle" GUIs.
    Loop 4
        Gui, r%A_Index%: Destroy
    RestoreCursors()
    ToolTip
    ;CoordMode, Mouse
    return abort ? "" : { x1 : x1, y1 : y1, x2 : x2, y2 : y2 }
 
    lusr_update:
        CoordMode, Mouse ; Required: change coord mode to screen vs relative.
        MouseGetPos, x, y
        if (x = xlast && y = ylast)
            ; Mouse hasn't moved so there's nothing to do.
            return
        if (x < xorigin)
             x1 := x, x2 := xorigin
        else x2 := x, x1 := xorigin
        if (y < yorigin)
             y1 := y, y2 := yorigin
        else y2 := y, y1 := yorigin

        ; Update the "selection rectangle".
        Gui, r1:Show, % "NA X" x1 " Y" y1 " W" x2-x1 " H" r
        Gui, r2:Show, % "NA X" x1 " Y" y2-r " W" x2-x1 " H" r
        Gui, r3:Show, % "NA X" x1 " Y" y1 " W" r " H" y2-y1
        Gui, r4:Show, % "NA X" x2-r " Y" y1 " W" r " H" y2-y1

        ; x1 := x1 - windowX
        ; x2 := x2 - windowX
        ; y1 := y1 - windowY
        ; y2 := y2 - windowY
    lusr_return:
    return
}

LetUserSelectPoint()
{
    ;global windowX, windowY
    CoordMode, Mouse ; Required: change coord mode to screen vs relative.

    SetSystemCursor("IDC_CROSS")
    
    ; Disable LButton.
    Hotkey, *LButton, nothing, On

    ; Wait for user to press LButton or Escape
	Loop {
		
		if GetKeyState("LButton", "P") {
			Break
		}
		if GetKeyState("Esc", "P") {
            abort := true
            Break
		}

		sleep, 50
	}

    if (!abort) {
        ; Get initial coordinates.
        MouseGetPos, x, y
        ; Wait for user to release LButton.
        KeyWait, LButton
    }
    
    ; Re-enable LButton.
    Hotkey, *LButton, Off
    
    RestoreCursors()
    ;CoordMode, Mouse
    return abort ? "" : { x : x, y : y }

    nothing:
    Return
}

;https://www.autohotkey.com/board/topic/32608-changing-the-system-cursor/
SetSystemCursor( Cursor = "", cx = 0, cy = 0 )
{
	BlankCursor := 0, SystemCursor := 0, FileCursor := 0 ; init
	
	SystemCursors = 32512IDC_ARROW,32513IDC_IBEAM,32514IDC_WAIT,32515IDC_CROSS
	,32516IDC_UPARROW,32640IDC_SIZE,32641IDC_ICON,32642IDC_SIZENWSE
	,32643IDC_SIZENESW,32644IDC_SIZEWE,32645IDC_SIZENS,32646IDC_SIZEALL
	,32648IDC_NO,32649IDC_HAND,32650IDC_APPSTARTING,32651IDC_HELP
	
	If Cursor = ; empty, so create blank cursor 
	{
		VarSetCapacity( AndMask, 32*4, 0xFF ), VarSetCapacity( XorMask, 32*4, 0 )
		BlankCursor = 1 ; flag for later
	}
	Else If SubStr( Cursor,1,4 ) = "IDC_" ; load system cursor
	{
		Loop, Parse, SystemCursors, `,
		{
			CursorName := SubStr( A_Loopfield, 6, 15 ) ; get the cursor name, no trailing space with substr
			CursorID := SubStr( A_Loopfield, 1, 5 ) ; get the cursor id
			SystemCursor = 1
			If ( CursorName = Cursor )
			{
				CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )	
				Break					
			}
		}	
		If CursorHandle = ; invalid cursor name given
		{
			Msgbox,, SetCursor, Error: Invalid cursor name
			CursorHandle = Error
		}
	}	
	Else If FileExist( Cursor )
	{
		SplitPath, Cursor,,, Ext ; auto-detect type
		If Ext = ico 
			uType := 0x1	
		Else If Ext in cur,ani
			uType := 0x2		
		Else ; invalid file ext
		{
			Msgbox,, SetCursor, Error: Invalid file type
			CursorHandle = Error
		}		
		FileCursor = 1
	}
	Else
	{	
		Msgbox,, SetCursor, Error: Invalid file path or cursor name
		CursorHandle = Error ; raise for later
	}
	If CursorHandle != Error 
	{
		Loop, Parse, SystemCursors, `,
		{
			If BlankCursor = 1 
			{
				Type = BlankCursor
				%Type%%A_Index% := DllCall( "CreateCursor"
				, Uint,0, Int,0, Int,0, Int,32, Int,32, Uint,&AndMask, Uint,&XorMask )
				CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
				DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
			}			
			Else If SystemCursor = 1
			{
				Type = SystemCursor
				CursorHandle := DllCall( "LoadCursor", Uint,0, Int,CursorID )	
				%Type%%A_Index% := DllCall( "CopyImage"
				, Uint,CursorHandle, Uint,0x2, Int,cx, Int,cy, Uint,0 )		
				CursorHandle := DllCall( "CopyImage", Uint,%Type%%A_Index%, Uint,0x2, Int,0, Int,0, Int,0 )
				DllCall( "SetSystemCursor", Uint,CursorHandle, Int,SubStr( A_Loopfield, 1, 5 ) )
			}
			Else If FileCursor = 1
			{
				Type = FileCursor
				%Type%%A_Index% := DllCall( "LoadImageA"
				, UInt,0, Str,Cursor, UInt,uType, Int,cx, Int,cy, UInt,0x10 ) 
				DllCall( "SetSystemCursor", Uint,%Type%%A_Index%, Int,SubStr( A_Loopfield, 1, 5 ) )			
			}          
		}
	}	
}

RestoreCursors()
{
	SPI_SETCURSORS := 0x57
	DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
}

GetPatternGrayDiff50() {
    return GetPatternGrayDiff(50)
}

GetPatternGrayDiff(grayDiff := 50) {
    result := LetUserSelectRect()

    if (!result) {
        return
    }

    px := result.x1 + 2
    py := result.y1 + 3
    ww := result.x2 - result.x1 - 2
    hh := result.y2 - result.y1 - 8

    ;----------getCors
    nW:=ww, nH:=hh
    FindText().ScreenShot()
    cors:=[], gray:=[], k:=0
    Loop %nH%
    {
        j:=py+A_Index-1, i:=px
        Loop %nW%
        cors[++k]:=c:=FindText().GetColor(i++,j,0)
        , gray[k]:=(((c>>16)&0xFF)*38+((c>>8)&0xFF)*75+(c&0xFF)*15)>>7
    }

    ;------------reset
    show:=[], ascii:=[], bg:=""
    Loop % nW*nH
        show[++k]:=1, c:=cors[k]
        
    ;------------GrayDiff2Two
    color:="**" grayDiff, k:=i:=0
    Loop % nW*nH
    {
        j:=gray[++k]+grayDiff
        , ascii[k]:=v:=( gray[k-1]>j or gray[k+1]>j
        or gray[k-nW]>j or gray[k+nW]>j
        or gray[k-nW-1]>j or gray[k-nW+1]>j
        or gray[k+nW-1]>j or gray[k+nW+1]>j )
        i:=(v?i+1:i-1)
    }

    ;-----------getTxt
    txt:=""
    k:=0
    Loop %nH%
    {
        v:=""
        Loop %nW% {
            v.=ascii[++k] ? "1":"0"
        }
        txt.=v="" ? "" : v "`n"
    }

    txt:= "|<>**" . grayDiff . "$" . Format("{:d}",InStr(txt,"`n")-1) "." FindText().bit2base64(txt)

    Return txt
}

GetPatternColor2Two(color, similarity) {
    result := LetUserSelectRect()

    if (!result) {
        return
    }

    px := result.x1 + 2
    py := result.y1 + 3
    ww := result.x2 - result.x1 - 2
    hh := result.y2 - result.y1 - 8

    ;----------getCors
    nW:=ww, nH:=hh
    FindText().ScreenShot()
    cors:=[], gray:=[], k:=0
    Loop %nH%
    {
        j:=py+A_Index-1, i:=px
        Loop %nW%
        cors[++k]:=c:=FindText().GetColor(i++,j,0)
        , gray[k]:=(((c>>16)&0xFF)*38+((c>>8)&0xFF)*75+(c&0xFF)*15)>>7
    }

    ;------------reset
    show:=[], ascii:=[], bg:=""
    Loop % nW*nH
        show[++k]:=1, c:=cors[k]
        
    ;------------Color2Two
    c:=color
    ;UsePos:=(cmd="ColorPos2Two") ? 1:0
    ;GuiControlGet, n,, Similar1
    n:=similarity
    n:=Round(n/100,2), color:=c "@" n
    , n:=Floor(512*9*255*255*(1-n)*(1-n)), k:=i:=0
    , rr:=(c>>16)&0xFF, gg:=(c>>8)&0xFF, bb:=c&0xFF
    Loop % nW*nH
    {
      c:=cors[++k], r:=((c>>16)&0xFF)-rr
      , g:=((c>>8)&0xFF)-gg, b:=(c&0xFF)-bb, j:=r+rr+rr
      , ascii[k]:=v:=((1024+j)*r*r+2048*g*g+(1534-j)*b*b<=n)
      ;if (show[k])
      i:=(v?i+1:i-1), c:=(v?"Black":"White")
    }
    ;bg:=i>0 ? "1":"0"

    ;-----------getTxt
    txt:=""
    k:=0
    Loop %nH%
    {
        v:=""
        Loop %nW% {
            v.=ascii[++k] ? "1":"0"
        }
        txt.=v="" ? "" : v "`n"
    }


    txt:= "|<>" . color . "$" . Format("{:d}",InStr(txt,"`n")-1) "." FindText().bit2base64(txt)

    Return txt
}

GetPixelColor() {
    point := LetUserSelectPoint()
    FindText().ScreenShot()
    color := FindText().GetColor(point.x, point.y)

    Return color
}

;https://www.autohotkey.com/boards/viewtopic.php?t=55032
;https://www.autohotkey.com/boards/viewtopic.php?f=5&t=55014
ObjFullyClone(obj) {
	nobj := obj.Clone()
	for k,v in nobj
		if IsObject(v)
			nobj[k] := A_ThisFunc.(v)
	return nobj
}

;https://stackoverflow.com/questions/33591667/how-to-check-if-string-is-contained-in-an-array-in-autohotkey
hasValue(haystack, needle) {
    if(!isObject(haystack))
        return false
    if(haystack.Length()==0)
        return false
    for k,v in haystack
        if(v==needle)
            return true
    return false
}

;https://www.autohotkey.com/board/topic/52441-append-text-to-an-edit-control/
AppendText(hEdit, text) {
    SendMessage, 0x000E, 0, 0,, ahk_id %hEdit% ;WM_GETTEXTLENGTH
    SendMessage, 0x00B1, ErrorLevel, ErrorLevel,, ahk_id %hEdit% ;EM_SETSEL
    SendMessage, 0x00C2, False, &text,, ahk_id %hEdit% ;EM_REPLACESEL
}