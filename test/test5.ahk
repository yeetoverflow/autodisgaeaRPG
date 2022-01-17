#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


; hwind := DllCall("user32\FindWindow", "Str","Qt5QWindowIcon", "Str","DisgaeaRPG", "Ptr")

; x := 1

; currentDateUTC := A_NowUTC
; MsgBox, % currentDateUTC
; FormatTime, hour, % currentDateUTC, H
; MsgBox, % hour
; if (hour < 4) {    ;UTC reset hour
;     currentDateUTC += -1, D
; }
; FormatTime, date, % currentDateUTC, yyyyMMdd

; MsgBox, % date

; MsgBox, % date

;currentDateUTC += -1, D

;MsgBox, % currentDateUTC

; seconds := 43238

; x := Mod(seconds, 60)

; MsgBox, % Format("{:02d}m {:02d}s", seconds / 60, Mod(seconds, 60))

FormatTime, TimeString, %A_Now%, yyyyMMdd HH:mm:ss

MsgBox, % TimeString