#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


; hwind := DllCall("user32\FindWindow", "Str","Qt5QWindowIcon", "Str","DisgaeaRPG", "Ptr")

; x := 1

currentDateUTC := A_NowUTC
MsgBox, % currentDateUTC
FormatTime, hour, % currentDateUTC, H
MsgBox, % hour
if (hour < 4) {    ;UTC reset hour
    currentDateUTC += -1, D
}
FormatTime, date, % currentDateUTC, yyyyMMdd

MsgBox, % date

; MsgBox, % date

;currentDateUTC += -1, D

;MsgBox, % currentDateUTC

