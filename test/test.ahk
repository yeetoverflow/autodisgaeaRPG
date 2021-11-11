#SingleInstance, Force
#Persistent

guiHwnd := 0x2718fe

;GuiControlGet, out, Hwnd, % guiHwnd

; WinGet, controlListHwnd, ControlList, % guiHwnd

; Loop, % controlListHwnd
;     {
;         WinGetClass, windowClass, % "ahk_id " controlList%A_Index%
;         MsgBox, % windowClass
;     }

; x := controlList

;https://www.autohotkey.com/docs/commands/WinGet.htm
WinGet, controlHwnds, ControlListHwnd, % guiHwnd
Loop, Parse, controlHwnds, `n
{
    ;WinGetClass, this_class, ahk_id %A_LoopField%
    ControlGetText, this_text,, ahk_id %A_LoopField%
    text := "EventStage"

    if strreplace(this_text, "`n") = "Stop " . text
    {
        ;https://www.autohotkey.com/docs/commands/WinSet.htm#Redraw
        ;SendMessage, 0x000C,0,"qqq",, % "ahk_id " . A_LoopField
        Control, Style, -0x8,,% "ahk_id " . prevHwnd
        ControlSetText,, "Start " . text,  % "ahk_id " . A_LoopField
        WinHide, % "ahk_id " . A_LoopField
        WinShow, % "ahk_id " . A_LoopField
        break
    }
    
    prevHwnd := A_LoopField
}

;https://www.autohotkey.com/boards/viewtopic.php?t=82118
GetClassNN(hCtrl, isEnum := "") {
   static GA_ROOT := 2, info, className, _ := VarSetCapacity(className, 200 << !!A_IsUnicode, 0)
   DllCall("GetClassName", "Ptr", hCtrl, "Str", className, "Int", 200)
   if isEnum {
      (className = info.class && info.count++)
      Return info.handle != hCtrl
   }
   else {
      hParent := DllCall("GetAncestor", "Ptr", hCtrl, "UInt", GA_ROOT, "Ptr")
      info := {handle: hCtrl, class: className, count: 0}
      DllCall("EnumChildWindows", "Ptr", hParent, "Ptr", RegisterCallback(A_ThisFunc, "Fast", 2), "Ptr", true)
      Return className . info.count
   }
}

;ControlSetText, edit2, 22 ,  % "ahk_id " . guiHwnd
;GuiControlGet, hwnd, Hwnd, 22

;MsgBox, % out

;DisgaeaRPG2 ahk_exe HD-Player.exe

;https://www.autohotkey.com/boards/viewtopic.php?t=39351
; for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where CommandLine like '%mode=%'") {
	
; 	MsgBox, % process.CommandLine . " | " . process.ProcessId
; }

;DetectHiddenWindows, On
;Menu, Tray, Tip, Test

; test := GetHwnd("DisgaeaRPG2 ahk_exe HD-Player.exe", "EventRaidLoop")

; DetectHiddenWindows, On
; WinSetTitle, % "ahk_id " . test,, testing

; GetHwnd(targetWindow, mode) {
; 	DetectHiddenWindows, On
;     query := "Select * from Win32_Process where "
; 		;. "CommandLine like '%" . StrReplace(A_ScriptFullPath, "\", "\\") . "%' and " 
;         . "CommandLine like '%mode=" . mode . "%' and "
;         . "CommandLine like '%id=""" . targetWindow . """%'"
;     queryEnum := ComObjGet("winmgmts:").ExecQuery(query)._NewEnum()
;     queryEnum[proc]
; 	MsgBox, % proc.CommandLine
;     WinGet, hwnd, ID, % "ahk_pid" . proc.ProcessId
; 	Return hwnd
; }