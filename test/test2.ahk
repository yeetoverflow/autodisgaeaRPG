; GLOBAL SETTINGS ===============================================================================================================

#Warn
#NoEnv
#SingleInstance Force

global WM_USER               := 0x00000400
global PBM_SETMARQUEE        := WM_USER + 10
global PBM_SETSTATE          := WM_USER + 16
global test := 0x410
global PBS_MARQUEE           := 0x00000008
global PBS_SMOOTH            := 0x00000001
global PBS_VERTICAL          := 0x00000004
global PBST_NORMAL           := 0x00000001
global PBST_ERROR            := 0x00000002
global PBST_PAUSE            := 0x00000003
global STAP_ALLOW_NONCLIENT  := 0x00000001
global STAP_ALLOW_CONTROLS   := 0x00000002
global STAP_ALLOW_WEBCONTENT := 0x00000004
global WM_THEMECHANGED       := 0x0000031A

; SCRIPT ========================================================================================================================

Gui, Margin, 5, 5
Gui, Font, s14 Bold
Gui, Add, Text, xm ym 0x200, Progressbar Examples

; ------------------------------------------------------------------------------------------------------
Gui, Add, Progress, w300 h20, 50

; ------------------------------------------------------------------------------------------------------
Gui, Add, Progress, w300 h20 hwndMARQ1 +%PBS_MARQUEE%, 50
DllCall("User32.dll\SendMessage", "Ptr", MARQ1, "Int", PBM_SETMARQUEE, "Ptr", 1, "Ptr", 50)

; ------------------------------------------------------------------------------------------------------
Gui, Add, Progress, w300 h20 BackgroundC9C9C9, 50

; ------------------------------------------------------------------------------------------------------
Gui, Add, Progress, w300 h20 BackgroundC9C9C9 hwndMARQ2 +%PBS_MARQUEE%, 50
DllCall("User32.dll\SendMessage", "Ptr", MARQ2, "Int", PBM_SETMARQUEE, "Ptr", 1, "Ptr", 50)

; ------------------------------------------------------------------------------------------------------
DllCall("uxtheme.dll\SetThemeAppProperties", "UInt", 0)
Gui, Add, Progress, w300 h20 c66EE66 hwndUTHEME, 50
;DllCall("User32.dll\SendMessage", "Ptr", UTHEME, "Int", WM_THEMECHANGED, "Ptr", 0, "Ptr", 0)
DllCall("uxtheme.dll\SetThemeAppProperties", "UInt", 7)

; ------------------------------------------------------------------------------------------------------
DllCall("uxtheme.dll\SetThemeAppProperties", "UInt", 0)
Gui, Add, Progress, w300 h20 c66EE66 hwndMARQ3 +%PBS_MARQUEE%, 50
DllCall("User32.dll\SendMessage", "Ptr", MARQ3, "Int", PBM_SETMARQUEE, "Ptr", 1, "Ptr", 50)
DllCall("uxtheme.dll\SetThemeAppProperties", "UInt", 7)

; ------------------------------------------------------------------------------------------------------
Gui, Add, Progress, w300 h20 -%PBS_SMOOTH%, 50

; ------------------------------------------------------------------------------------------------------
Gui, Add, Progress, w300 h20 hwndMARQ4 -%PBS_SMOOTH% +%PBS_MARQUEE%, 50
DllCall("User32.dll\SendMessage", "Ptr", MARQ4, "Int", PBM_SETMARQUEE, "Ptr", 1, "Ptr", 50)

; ------------------------------------------------------------------------------------------------------
Gui, Add, Progress, w300 h20 hwndPROG -%PBS_SMOOTH%, 50
DllCall("User32.dll\SendMessage", "Ptr", PROG, "Int", PBM_SETSTATE, "Ptr", PBST_NORMAL, "Ptr", 0)

; ------------------------------------------------------------------------------------------------------
Gui, Add, Progress, w300 h20 hwndPROR -%PBS_SMOOTH%, 50
DllCall("User32.dll\SendMessage", "Ptr", PROR, "Int", PBM_SETSTATE, "Ptr", PBST_ERROR, "Ptr", 0)

; ------------------------------------------------------------------------------------------------------
Gui, Add, Progress, w300 h20 hwndPROY -%PBS_SMOOTH%, 50
DllCall("User32.dll\SendMessage", "Ptr", PROY, "Int", PBM_SETSTATE, "Ptr", PBST_PAUSE, "Ptr", 0)

; ------------------------------------------------------------------------------------------------------

Gui, Show, AutoSize
return

; EXIT ==========================================================================================================================

Close:
GuiClose:
GuiEscape:
    exitapp