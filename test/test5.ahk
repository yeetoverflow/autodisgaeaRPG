#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

hwind := DllCall("user32\FindWindow", "Str","Qt5QWindowIcon", "Str","DisgaeaRPG", "Ptr")

x := 1