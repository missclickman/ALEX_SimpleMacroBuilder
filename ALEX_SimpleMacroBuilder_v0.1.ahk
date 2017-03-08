/*
# A simple macro builder aka MLLE-ALEX_KEYSTROKER

https://autohotkey.com/boards/viewtopic.php?f=19&amp;t=27708

MLLE-ALEX_KEYSTROKER.ahk

This is the Mlle ALEX simple macro builder, aka MLLE-ALEX_KEYSTROKER , i wanted it simple to use it, and i hope it is good.
I'm sure it's optimizable a lot, its total opensource, dont be shy , lets custom + re-share it!

;===================================================================================================================

*ChangeLog  : _v0.1	-First real release.
							    -Send click to a specific game/windows , but for this the specified window need to be in the foreground (MLLE-ALEX_KEYSTROKER will do it itself, dont worry)
							    -Send Keystroke to non-focused / background game ; lets automate boring actions while surfing in the net, watch videos....
								-Self-explained macro builder, just mouse-hover something to know what it will do
;===================================================================================================================

*Special features for The Secret World game :
- This script detect if your game is TSW , witch is known for his instability. So the script offers you to watch if the game crash, 
them reload it for you - turn-on macro when back in game.
For this, the script need your LOG and PASSWORD (dont be shy they are not saved)

;===================================================================================================================
*Special thanks to ppl who helped me a lot in the IRC channel :*
- tidbit  -Grendahl - GeekDude - RebelEpik - Phaleth

*Also many thanks to ppl shared script on this forum where i took some idea and part of code:*
- tmplinshi ( https://autohotkey.com/boards/viewtopic.php?f=6&t=225 ) KeypressOSD
- TheDewd  ( https://autohotkey.com/boards/viewtopic.php?p=70009#p70009 ) Microsoft Office 2016 Inspired GUI Interface

;===================================================================================================================
*/
SetControlDelay -1
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases..
SendMode, InputThenPlay  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
	try
	{
		if A_IsCompiled
			Run *RunAs "%A_ScriptFullPath%" /restart
		else
			Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
	}
	ExitApp
}
SMTO_NOTIMEOUTIFNOTHUNG := 8

;===================================================================================================================
;Global GUI :
Application := {} ; Create Application Object
Application.Name := "MLLE-ALEX_KEYSTROKER"
Application.Version := "1.2"
Window := {} ; Create Window Object
Window.Width := 400
Window.Height := 575
Window.Title := Application.Name
Menu, Tray, Icon, resources\ALEX_keystroker_icon.ico
Gui, main: +LastFound +caption
Gui, main: Color, 000000
WinSet, Transparent, 50
Gui, main: -Resize -Caption -Border +AlwaysOnTop ; alwayontop for transcolor work
Gui, main: Font, s10 cFFFFFF, Lucida Console

;Header + Headbutton
;===================================================================================================================
Gui, main: Add, Picture, % " x" 0 " y" -2 " w" Window.Width " h" 44 " +HWNDhHeader", % "resources\GUI_header.gif"
WinSet, TransColor, 13FF00
Gui, main: -AlwaysOnTop ; transcolor done, can remove alwayontop
Gui, main: Add, Picture, % " x" 360 " y" 5 " w" 30 " h" 30 " +HWNDhButtonCloseN Hidden0", % "resources\button-close.png"
Gui, main: Add, Picture, % " x" 360 " y" 5 " w" 30 " h" 30 " +HWNDhButtonCloseH Hidden1", % "resources\button-close-hover.png"
Gui, main: Add, Picture, % " x" 360 " y" 5 " w" 30 " h" 30 " +HWNDhButtonCloseP Hidden1", % "resources\button-close-pressed.png"
Gui, main: Add, Picture, % " x" 330 " y" 5 " w" 30 " h" 30 " +HWNDhButtonMinimizeN Hidden0", % "resources\button-minimize.png"
Gui, main: Add, Picture, % " x" 330 " y" 5 " w" 30 " h" 30 " +HWNDhButtonMinimizeH Hidden1", % "resources\button-minimize-hover.png"
Gui, main: Add, Picture, % " x" 330 " y" 5 " w" 30 " h" 30 " +HWNDhButtonMinimizeP Hidden1", % "resources\button-minimize-pressed.png"
;Windows title
;===================================================================================================================
Gui, main: Add, Text, % " x" 0 " y" 5 " w" Window.Width " h" 44 " +BackgroundTrans +0x101 +HWNDhTitle", % Window.Title
;Borders
;===================================================================================================================
Gui, main: Add, Picture, % " x" 24 " y" 70 " w" 2 " h" 386  , % "resources\Border.jpg"
Gui, main: Add, Picture, % " x" 374 " y" 70 " w" 2 " h" 386 , % "resources\border.jpg"
Gui, main: Add, Picture, % " x" 26 " y" 70 " w" 348 " h" 2 , % "resources\border.jpg"
Gui, main: Add, Picture, % " x" 26 " y" 454 " w" 348 " h" 2 , % "resources\border.jpg"
Gui, main: Add, Picture, % " x" 26 " y" 481 " w" 348 " h" 2 , % "resources\border.jpg"
Gui, main: Add, Picture, % " x" 24 " y" 481 " w" 2 " h" 65 , % "resources\Border.jpg"
Gui, main: Add, Picture, % " x" 374 " y" 481 " w" 2 " h" 65 , % "resources\border.jpg"
Gui, main: Add, Picture, % " x" 26 " y" 544 " w" 348 " h" 2 , % "resources\border.jpg"
;===================================================================================================================
Gui, main: Font, s16 c666666, Lucida Console
gui, main: Add, Text, x40 y53 +BackgroundTrans, MACRO:
Gui, main: Font, s8 c888888, Lucida Console
Gui, main: Add, Text, x+5 yp+5 w230 h20 -Wrap +BackgroundTrans +HWNDhAlertText, % AlertClick
Gui, main: Font, s16 c666666, Lucida Console
gui, main: Add, Text, x40 y464 +BackgroundTrans, GAME:
Gui, main: Font, s10 c888888, Lucida Console
gui, main: Add, Text, x+2 yp+7 w250 +BackgroundTrans +HWNDhGAME,
Gui, main: Font, s10 cFFFFFF, Lucida Console
;Buttons:
;===================================================================================================================
Gui, main: Add, Picture, % " x" 70 " y" 140 " w" 89 " h" 24 " +HWNDhButtonPressN Hidden0", % "resources\Button-press.png"
Gui, main: Add, Picture, % " x" 70 " y" 140 " w" 89 " h" 24 " +HWNDhButtonPressH Hidden1", % "resources\Button-press-hover.png"
Gui, main: Add, Picture, % " x" 70 " y" 140 " w" 89 " h" 24 " +HWNDhButtonPressP Hidden1", % "resources\Button-press-pressed.png"
Gui, main: Add, Picture, % " x" 70 " y" 174 " w" 89 " h" 24 " +HWNDhButtonReleaseN Hidden0", % "resources\Button-release.png"
Gui, main: Add, Picture, % " x" 70 " y" 174 " w" 89 " h" 24 " +HWNDhButtonReleaseH Hidden1", % "resources\Button-release-hover.png"
Gui, main: Add, Picture, % " x" 70 " y" 174 " w" 89 " h" 24 " +HWNDhButtonReleaseP Hidden1", % "resources\Button-release-pressed.png"
Gui, main: Add, Picture, % " x" 70 " y" 230 " w" 89 " h" 21 " +HWNDhButtonSetPosN Hidden0", % "resources\Button-setpos.png"
Gui, main: Add, Picture, % " x" 70 " y" 230 " w" 89 " h" 21 " +HWNDhButtonSetPosH Hidden1", % "resources\Button-setpos-hover.png"
Gui, main: Add, Picture, % " x" 70 " y" 230 " w" 89 " h" 21 " +HWNDhButtonSetPosP Hidden1", % "resources\Button-setpos-pressed.png"
Gui, main: Add, Picture, % " x" 70 " y" 313 " w" 89 " h" 21 " +HWNDhButtonDelayN Hidden0", % "resources\Button-delay.png"
Gui, main: Add, Picture, % " x" 70 " y" 313 " w" 89 " h" 21 " +HWNDhButtonDelayH Hidden1", % "resources\Button-delay-hover.png"
Gui, main: Add, Picture, % " x" 70 " y" 313 " w" 89 " h" 21 " +HWNDhButtonDelayP Hidden1", % "resources\Button-delay-pressed.png"
Gui, main: Add, Picture, % " x" 70 " y" 405 " w" 33 " h" 33 " +HWNDhButtonImportN Hidden0", % "resources\import-normal.png"
Gui, main: Add, Picture, % " x" 70 " y" 405 " w" 33 " h" 33 " +HWNDhButtonImportH Hidden1", % "resources\import-hover.png"
Gui, main: Add, Picture, % " x" 70 " y" 405 " w" 33 " h" 33 " +HWNDhButtonImportP Hidden1", % "resources\import-pressed.png"
Gui, main: Add, Picture, % " x" 126 " y" 405 " w" 33 " h" 33 " +HWNDhButtonSaveN Hidden0", % "resources\Save-normal.png"
Gui, main: Add, Picture, % " x" 126 " y" 405 " w" 33 " h" 33 " +HWNDhButtonSaveH Hidden1", % "resources\Save-hover.png"
Gui, main: Add, Picture, % " x" 126 " y" 405 " w" 33 " h" 33 " +HWNDhButtonSaveP Hidden1", % "resources\Save-pressed.png"
Gui, main: Add, Picture, % " x" 44 " y" 496 " w" 35 " h" 35 " +HWNDhButtonFgameN Hidden0", % "resources\findgame-normal.png"
Gui, main: Add, Picture, % " x" 44 " y" 496 " w" 35 " h" 35 " +HWNDhButtonFgameH Hidden1", % "resources\findgame-hover.png"
Gui, main: Add, Picture, % " x" 44 " y" 496 " w" 35 " h" 35 " +HWNDhButtonFgameP Hidden1", % "resources\findgame-pressed.png"
Gui, main: Add, Picture, % " x" 96 " y" 496 " w" 262 " h" 35 " +HWNDhButtonStartN Hidden0", % "resources\Start-normal.png"
Gui, main: Add, Picture, % " x" 96 " y" 496 " w" 262 " h" 35 " +HWNDhButtonStartH Hidden1", % "resources\Start-hover.png"
Gui, main: Add, Picture, % " x" 96 " y" 496 " w" 262 " h" 35 " +HWNDhButtonStartP Hidden1", % "resources\Start-pressed.png"
Gui, main: Font, s7 cFFFFFF, Lucida Console
Gui, main: Add, Button, x194 y424 w75 h14 gDeleteSelect, Del select
Gui, main: Add, Button, x279 y424 w75 h14 gAllDelete, Del All
Gui, main: Font, s10 cFFFFFF, Lucida Console

;Text and Edits :
;===================================================================================================================
Gui, main: Add, Text, x44 y90 w115 h20 +section +center , KEY : ;												+Section
Gui, main: Add, Edit, xs+0 ys+20 wp hp vNewKey +ReadOnly +Center ,
Gui, main: add, Checkbox, xs+0 y+16 h15 w15 vMyCheckbox +HWNDhMyCheckbox,
Gui, main: Add, Text, xs+0 ys+120 w115 h20 +center , MOUSECLICK :
Gui, main: Add, Text, xs+0 ys+173 wp hp +center , DELAY :
Gui, main: Add, Edit, xs+0 ys+193 wp hp Number +Center cblack vNewDelay +HWNDhNewDelay, ex : 1000(ms)
Gui, main: Add, Text, xs+0 ys+256 wp hp , KEY Play/stop:
Gui, main: Add, Hotkey, xs+0 ys+278 wp hp +Center vHotkeyForStart,
Gui, main: Add, ListBox, xs+150 ys w160 h315 VScroll vListboxResult +AltSubmit +HWNDhResult cblack 0x1100 , ;0x1000 is "scroll" even if no scroll needed +section
Gui, main: Font, s8 cFFFFFF, Lucida Console
TotalTime := 0
Gui, main: Add, Text, xp-0 y+2 wp +BackgroundTrans +HWNDhTotalTime +Right, % "Total: " . 0 . " mn " . 0 . " s " . 0 . " ms"
Gui, main: Show, % " w" Window.Width " h" Window.Height, % Window.Title

;The mini windows while macro running
;===================================================================================================================
Gui, mini: Font, s10 cffffff, Lucida Console
Gui, mini: +LastFound -Resize -Caption -Border +AlwaysOnTop
Gui, mini: Color, 000000
Gui, mini: Add, Text, y14 +BackgroundTrans +HWNDhTitle2 +0x101 , % Window.Title
Gui, mini: Add, Picture, % " x" 180 " y" 5 " w" 30 " h" 30 " +HWNDhButtonCallbackN Hidden0", % "resources\button-close.png"
Gui, mini: Add, Picture, % " x" 180 " y" 5 " w" 30 " h" 30 " +HWNDhButtonCallbackH Hidden1", % "resources\button-close-hover.png"
Gui, mini: Add, Picture, % " x" 180 " y" 5 " w" 30 " h" 30 " +HWNDhButtonCallbackP Hidden1", % "resources\button-close-pressed.png"
Gui, mini: Font, s8 cffffff norm, Lucida Console
Gui, mini: Add, Text, x15 y+10 w200 +BackgroundTrans , Game:
Gui, mini: Add, Text, x15 y+5 w200 +BackgroundTrans +HWNDhGameName, GameName
Gui, mini: Add, Text, x15 y+10 w80 +BackgroundTrans , Reading:
Gui, mini: Add, Text, x+5 yp w65 +BackgroundTrans , Sleep:
Gui, mini: Font, cGreen s8 Bold
Gui, mini: Add, Progress, x15 y+5 w80 h30 +section Background001111 ;										+section
Gui, mini: Add, Text, xs+2 ys+4 w76 h30 +BackgroundTrans +HWNDhRead, &Key
Gui, mini: Add, Progress, xs+85 ys w65 h30 +section Background001111 ; 										+section
Gui, mini: Add, Text, xs+2 ys+4 w63 h30 +BackgroundTrans +HWNDhSleep, Wait
Gui, mini: Font, s8 cffffff norm, Lucida Console
Gui, mini: Add, Text, x15 y+5 h30 w200 +BackgroundTrans +HWNDhShortcut, Play/Pause:
Gui, mini: Add, Picture, % " x" 170 " y" 98 " w" 30 " h" 30 " +HWNDhButtonPlayN Hidden0", % "resources\button-play.png"
Gui, mini: Add, Picture, % " x" 170 " y" 98 " w" 30 " h" 30 " +HWNDhButtonPlayH Hidden1", % "resources\button-play-hover.png"
Gui, mini: Add, Picture, % " x" 170 " y" 98 " w" 30 " h" 30 " +HWNDhButtonPauseN Hidden1", % "resources\button-pause.png"
Gui, mini: Add, Picture, % " x" 170 " y" 98 " w" 30 " h" 30 " +HWNDhButtonPauseH Hidden1", % "resources\button-pause-hover.png"

;===================================================================================================================
OnMessage(0x200, "WM_MOUSEMOVE")
OnMessage(0x201, "WM_LBUTTONDOWN")
OnMessage(0x202, "WM_LBUTTONUP")
OnMessage(0x2A3, "WM_MOUSELEAVE")
CreateHotkey()
return

;Optional Gui For TSW
;===================================================================================================================
TswGui:
if  (Name = "")
	Name:="Username"
if (Pass = "")
	Pass:="Password"
Gui, TSW: +LastFound -Resize -Caption -Border +AlwaysOnTop
Gui, TSW: Color, 000000
Gui, TSW: Font, s10 cFFFFFF, lucida
Gui, TSW: Add, Text, x0 y20 w300 +center, I see your game is THE SECRET WORLD
Gui, TSW: Add, Text, x0 y+4 w300 +center, This game is known for his crash-tendency.
Gui, TSW: Add, Text, x0 y+4 w300 +center, Do you want i check if the game crash and
Gui, TSW: Add, Text, x0 y+4 w300 +center, reload it automatically?
Gui, TSW: Add, Text, x0 y+10 w300 +center, ( If yes, i need your login and password )
Gui, TSW: Font, s10 c000000, lucida
Gui, TSW: Add, Edit, vName x25 y+20 w250 h20 center , %Name%
Gui, TSW: Add, Edit, vPass x25 y+15 w250 h20 center , %Pass%
Gui, TSW: add, Button, x40 y+30 w90 h25 gOkTSW, Yes
Gui, TSW: add, Button, x+40 w90 h25 gConsentStartMacro, No, thank
Gui, TSW: show, w300 h270
return

;DISPLAY-Function:
;===================================================================================================================
WM_MOUSEMOVE(wParam, lParam, Msg, Hwnd) {
	Global
	DllCall("TrackMouseEvent", "UInt", &TME)
	MouseGetPos,,,, MouseCtrl, 2
	GuiControl, % (MouseCtrl = hButtonMinimizeN || MouseCtrl = hButtonMinimizeH) ? "Show" : "Hide", % hButtonMinimizeH
	GuiControl, % (MouseCtrl = hButtonCloseN || MouseCtrl = hButtonCloseH) ? "Show" : "Hide", % hButtonCloseH
	GuiControl, % (MouseCtrl = hButtonPressN || MouseCtrl = hButtonPressH) ? "Show" : "Hide", % hButtonPressH
	GuiControl, % (MouseCtrl = hButtonReleaseN || MouseCtrl = hButtonReleaseH) ? "Show" : "Hide", % hButtonReleaseH
	GuiControl, % (MouseCtrl = hButtonDelayN || MouseCtrl = hButtonDelayH) ? "Show" : "Hide", % hButtonDelayH
	GuiControl, % (MouseCtrl = hButtonImportN || MouseCtrl = hButtonImportH) ? "Show" : "Hide", % hButtonImportH
	GuiControl, % (MouseCtrl = hButtonSaveN || MouseCtrl = hButtonSaveH) ? "Show" : "Hide", % hButtonSaveH
	GuiControl, % (MouseCtrl = hButtonStartN || MouseCtrl = hButtonStartH) ? "Show" : "Hide", % hButtonStartH
	GuiControl, % (MouseCtrl = hButtonFgameN || MouseCtrl = hButtonFgameH) ? "Show" : "Hide", % hButtonFgameH
	GuiControl, % (MouseCtrl = hButtonSetPosN || MouseCtrl = hButtonSetPosH) ? "Show" : "Hide", % hButtonSetPosH
	;MiniGUI
	GuiControl, % (MouseCtrl = hButtonCallbackN || MouseCtrl = hButtonCallbackH) ? "Show" : "Hide", % hButtonCallbackH
	GuiControl, % (MouseCtrl = hButtonPlayN || MouseCtrl = hButtonPlayH) ? "Show" : "Hide", % hButtonPlayH
	GuiControl, % (MouseCtrl = hButtonPauseN || MouseCtrl = hButtonPauseH) ? "Show" : "Hide", % hButtonPauseH
	if (t != 1) {
		ToolTip, % (MouseCtrl = hButtonSaveH) ? "Save MACRO" : "", , , 1
		ToolTip, % (MouseCtrl = hButtonImportH) ? "Import MACRO" : "", , , 2
		ToolTip, % (MouseCtrl = hButtonFgameH) ? "Search the path of the`n.exe of your game" : "", , , 3
		ToolTip, % (MouseCtrl = hNewDelay) ? "Set a delay between Key stroke`nIn millisecond (1s = 1000ms)" : "", , , 4
		ToolTip, % (MouseCtrl = hButtonSetPosH) ? "Set a mouse click X and Y position" : "", , , 5
		ToolTip, % (MouseCtrl = hButtonPressH) ? "Simulates key press`n(so must be released after)" : "", , , 6
		ToolTip, % (MouseCtrl = hButtonReleaseH) ? "Simulates key release`n(this key must be pressed before)" : "", , , 7
		ToolTip, % (MouseCtrl = hMyCheckbox) ? "Lazy mode, faster for building macro!`nBut dont allow you to do something`nlike Shift+F1 or Ctrl+V" : "", , , 8
		}
}
WM_LBUTTONDOWN(wParam, lParam, Msg, Hwnd) {
	Global
	if (MouseCtrl ="" || MouseCtrl = hHeader || MouseCtrl = hTitle || MouseCtrl = hTitle2) { ; if HWND's control is blank or title or header
		PostMessage, 0xA1, 2
	}
	GuiControl, % (MouseCtrl = hButtonMinimizeH) ? "Show" : "Hide", % hButtonMinimizeP
	GuiControl, % (MouseCtrl = hButtonCloseH) ? "Show" : "Hide", % hButtonCloseP
	GuiControl, % (MouseCtrl = hButtonPressH) ? "Show" : "Hide", % hButtonPressP
	GuiControl, % (MouseCtrl = hButtonReleaseH) ? "Show" : "Hide", % hButtonReleaseP
	GuiControl, % (MouseCtrl = hButtonDelayH) ? "Show" : "Hide", % hButtonDelayP
	GuiControl, % (MouseCtrl = hButtonSaveH) ? "Show" : "Hide", % hButtonSaveP
	GuiControl, % (MouseCtrl = hButtonImportH) ? "Show" : "Hide", % hButtonImportP
	GuiControl, % (MouseCtrl = hButtonStartH) ? "Show" : "Hide", % hButtonStartP
	GuiControl, % (MouseCtrl = hButtonFgameH) ? "Show" : "Hide", % hButtonFgameP
	GuiControl, % (MouseCtrl = hButtonSetPosH) ? "Show" : "Hide", % hButtonSetPosP
	;MiniGui
	GuiControl, % (MouseCtrl = hButtonCallbackH) ? "Show" : "Hide", % hButtonCallbackP
}
WM_LBUTTONUP(wParam, lParam, Msg, Hwnd) {
	Global
	If (MouseCtrl = hButtonMinimizeP)
		WinMinimize
	If (MouseCtrl = hButtonCloseP)
		ExitApp
	If (MouseCtrl = hButtonPressP)
		gosub, SbmtDownKey
	If (MouseCtrl = hButtonReleaseP)
		gosub, SbmtUpKey
	If (MouseCtrl = hButtonDelayP)
		gosub, SbmtDelay
	If (MouseCtrl = hButtonImportP)
		gosub, ImportMacro
	If (MouseCtrl = hButtonSaveP)
		gosub, SaveMacro
	If (MouseCtrl = hButtonStartP)
		Gosub, AskTSWoption
	If (MouseCtrl = hButtonFgameP)
		Gosub, FindGame
	if (MouseCtrl = hButtonSetPosP)
		Gosub, SetPos
	GuiControl, Hide, % hButtonMinimizeP
	GuiControl, Hide, % hButtonCloseP
	GuiControl, Hide, % hButtonPressP
	GuiControl, Hide, % hButtonReleaseP
	GuiControl, Hide, % hButtonDelayP
	GuiControl, Hide, % hButtonSaveP
	GuiControl, Hide, % hButtonImportP
	GuiControl, Hide, % hButtonStartP
	GuiControl, Hide, % hButtonFgameP
	GuiControl, Hide, % hButtonSetPosP
	;MiniGui
	If (MouseCtrl = hButtonCallbackP)
		Gosub, CallBack
	GuiControl, Hide, % hButtonCallbackP
	If (MouseCtrl = hButtonPlayH || MouseCtrl = hButtonPauseH)
		Gosub, StartStop
	GuiControl, Hide, % hButtonPlayH
	GuiControl, Hide, % hButtonPauseH
}
WM_MOUSELEAVE(wParam, lParam, Msg, Hwnd) {
	Global
	GuiControl, Hide, % hButtonMinimizeH
	GuiControl, Hide, % hButtonCloseH
	GuiControl, Hide, % hButtonDelayH
	GuiControl, Hide, % hButtonPressH
	GuiControl, Hide, % hButtonReleaseH
	GuiControl, Hide, % hButtonSaveH
	GuiControl, Hide, % hButtonImportH
	GuiControl, Hide, % hButtonStartH
	GuiControl, Hide, % hButtonFgameH
	GuiControl, Hide, % hButtonSetPosH
	GuiControl, Hide, % hButtonImportP
	GuiControl, Hide, % hButtonCloseP	
	GuiControl, Hide, % hButtonPressP
	GuiControl, Hide, % hButtonReleaseP
	GuiControl, Hide, % hButtonDelayP
	GuiControl, Hide, % hButtonMinimizeP
	GuiControl, Hide, % hButtonSaveP
	GuiControl, Hide, % hButtonStartP
	GuiControl, Hide, % hButtonFgameP
	GuiControl, Hide, % hButtonSetPosP
	;MiniGui
	GuiControl, Hide, % hButtonCallbackH
	GuiControl, Hide, % hButtonCallbackP
	GuiControl, Hide, % hButtonPlayH
	GuiControl, Hide, % hButtonPauseH
}

OnKeyPressed:
GuiControlGet, caca, Main:FocusV
key := SubStr(A_ThisHotkey, 3)
if ( SubStr(key, 1, 2) = "sc" )
	key := ReturnObject(key)
If caca = NewKey
	GuiControl, Main: , NewKey, %key%
return

ToolTipSetPos:
MouseGetPos, xpos, ypos
WinGetTitle, ActivTitle, A
ToolTip, % "Go on the game's window and" . "`n" . "put your cursor where you want."
. "`n" . """Press ctrl + space"" to record the" . "`n" . "current mouse position."
. "`n`n" . "xpos: " .  xpos . A_Tab . "Window's Title :" . "`n" . "ypos: " . ypos . A_Tab . ActivTitle , , , 9
return

AlertTextMoving:
StringTrimLeft, AlertClick%n% , AlertClick, 1
AlertClick := AlertClick%n%
GuiControl, text, % hAlertText, % AlertClick
n++
if (StrLen(AlertClick) < 10) {
	n := 1
	AlertClick := "Warning : Click can't be sent to game windows in the background yet"
	GuiControl, text, % hAlertText, % AlertClick
	Sleep, 2000
}
return

;About Keyboard
;===================================================================================================================
GetKeyboardLayout(ByRef window) {
    return DllCall("GetKeyboardLayout", "UInt", DllCall("GetWindowThreadProcessId", "Int", WinExist(window), "Int", 0), "UShort")
}

CreateHotkey() {

	OtherLanguageKeys := "²|é|è|à|ù|<|ç" ;Accents for french language
	FrenchLayout := "1036|4108|3084|2060|5132|6156" ; FR-FR|FR-SW|FR-CA|FR-BE|FR-LUX|FR-MONACO
	Loop, parse, FrenchLayout, |
	{
		If (GetKeyboardLayout("A") = A_LoopField) {
			Loop, parse, OtherLanguageKeys, |
				Hotkey, % "~*" A_LoopField, OnKeyPressed
			break
		}
	}

	Loop, 95
	{
		k := Chr(A_Index + 31)
		k := (k = " ") ? "Space" : k
		Hotkey, % "~*" k, OnKeyPressed
	}

	Loop, 24 ; F1-F24
		Hotkey, % "~*F" A_Index, OnKeyPressed

	Loop, 10 ; Numpad0 - Numpad9
		Hotkey, % "~*Numpad" A_Index - 1, OnKeyPressed

	Otherkeys := "XButton1|XButton2|Browser_Forward|Browser_Back|Browser_Refresh|Browser_Stop|Browser_Search|Browser_Favorites"
		. "|Browser_Home|Volume_Mute|Volume_Down|Volume_Up|Media_Next|Media_Prev|Media_Stop|Media_Play_Pause|Launch_Mail"
		. "|Launch_Media|Launch_App1|Launch_App2|Help|Sleep|PrintScreen|CtrlBreak|Break|AppsKey|NumpadDot|NumpadDiv"
		.	"|NumpadMult|NumpadAdd|NumpadSub|NumpadEnter|Tab|Enter|Esc|BackSpace|Del|Insert|Home|End|PgUp|PgDn|Up|Down"
		. "|Left|Right|ScrollLock|CapsLock|NumLock|Pause|sc145|sc146|sc046|sc123"
	Loop, parse, Otherkeys, |
		Hotkey, % "~*" A_LoopField, OnKeyPressed

	for i, mod in ["Ctrl", "Shift", "RShift", "Alt", "LWin", "RWin", "RAlt"]
		Hotkey, % "~*" mod, OnKeyPressed
}

ReturnObject(sc) {
	static k := {sc046: "ScrollLock", sc145: "NumLock", sc146: "Pause", sc123: "Genius LuxeMate Scroll"}
	return k[sc]
}

;GUI Function:
;===================================================================================================================
SetPos:
SetTimer, ToolTipSetPos, % (t:=!t) ? "50" : "Off"
ToolTip, , , , 9
Hotkey, ^Space, GetPos, On
return

GetPos:
NewMousePos := % "Click, " . xpos . ", " . ypos
GuiControlGet, Position, Main:, % hResult
SendMessage, (LB_INSERTSTRING:=0x181), %Position%, &NewMousePos, , ahk_id %hResult%
SetTimer, ToolTipSetPos, % (t:=!t) ? "50" : "Off"
Hotkey, ^Space, Off
ToolTip, , , , 9
WinActivate, % Window.Title
ControlSend, , {Down} , ahk_id %hResult%
GuiControl, Choose, % hResult , % Position + 1
n := 1
AlertClick := "Warning : Click can't be sent to game windows in the background yet"
GuiControl, Text, % hAlertText , % AlertClick
Sleep, 2000
SetTimer, AlertTextMoving, 200
return

SbmtDelay:
Gui, Submit, NoHide
IF !(NewDelay = "" OR NewDelay = "ex : 1000(ms)")
{
	NewDelayString := % "Sleep, " . NewDelay
	GuiControlGet, Position, Main:, % hResult
	SendMessage, (LB_INSERTSTRING:=0x181), %Position%, &NewDelayString, , ahk_id %hResult%
	ControlSend, , {Down} , ahk_id %hResult%
	GuiControl, Choose, % hResult , % Position + 1
	TotalTime += NewDelay
	GuiControl, Text, % hTotalTime , % TimeConverter(TotalTime)
}
return

TimeConverter(TotalTime)
{
	numMins := floor(mod(TotalTime, 3600000) / 60000)
	numSec := floor(mod(mod(TotalTime, 3600000), 60000) / 1000)
	numMs := mod(mod(mod(TotalTime, 3600000), 60000), 1000)
	return, % "Total: " . numMins . " mn " . numSec . " s " . numMs . " ms"
}

SbmtDownKey:
Gui, Submit, NoHide
IF !(NewKey = "")
{
	NewKeyString := % "{" . NewKey . " down}"
	GuiControlGet, Position, Main:, % hResult
	if (MyCheckbox = 1) {
		NewKeyString := % "{" . NewKey . " down}{" . NewKey . " up}"
	}
	SendMessage, (LB_INSERTSTRING:=0x181), %Position%, &NewKeyString, , ahk_id %hResult%
	ControlSend, , {Down} , ahk_id %hResult%
	GuiControl, Choose, % hResult , % Position + 1
}
return

SbmtUpKey:
Gui, Submit, NoHide
IF !(NewKey = "")
{
	NewKeyString := % "{" . NewKey . " up}"
	GuiControlGet, Position, Main:, % hResult
	SendMessage, (LB_INSERTSTRING:=0x181), %Position%, &NewKeyString, , ahk_id %hResult%
	ControlSend, , {Down} , ahk_id %hResult%
	GuiControl, Choose, % hResult , % Position + 1
}
return

DeleteSelect:
ControlGet, Element, Choice, , , ahk_id %hResult%
if RegExMatch( Element, "Sleep, (\d+)", Time )
{
	TotalTime -= Time1
	GuiControl, Text, % hTotalTime , % TimeConverter(TotalTime)
}
GuiControlGet, Position, Main:, % hResult
SendMessage, (LB_DELETESTRING:=0x182), (Position -1), &NewKeyString, , ahk_id %hResult%
ControlSend, , {Down} , ahk_id %hResult%
GuiControl, Choose, % hResult , %Position%
ControlGet, AllListBox, List, , , ahk_id %hResult%
IfNotInString, AllListBox, Click
{
	SetTimer, AlertTextMoving, Off
	GuiControl, Text, % hAlertText , % ""
}
return

AllDelete:
SendMessage, (LB_RESETCONTENT:=0x0184), 0, 0, , ahk_id %hResult%
TotalTime := 0 ; reset total time variable
GuiControl, Text, % hTotalTime , % TimeConverter(TotalTime)
SetTimer, AlertTextMoving, Off
GuiControl, Text, % hAlertText , % ""
return

ImportMacro:
TotalTime := 0 ; reset total time variable
PathLoadList := 0
FileSelectFile, PathLoadList, 0, , Load your presets, *txt
if PathLoadList =
	MsgBox, , , Nothing loaded...
else
{
	SendMessage, (LB_RESETCONTENT:=0x0184), 0, 0, , ahk_id %hResult% ; all delete before
	FileRead, ListLoaded, %PathLoadList%
	StringReplace, AllListBox, ListLoaded, `r`n, |, All
	GuiControl, , % hResult, %AllListBox%
	ControlSend, , {End} , ahk_id %hResult%
	Element := StrSplit(AllListBox, "|")
	for each, line in Element
	{
		if RegExMatch( line, "Sleep, (\d+)", Time )
			TotalTime += Time1
	}
	GuiControl, Text, % hTotalTime , % TimeConverter(TotalTime)
}
return

SaveMacro:
ControlGet, AllListBox, List, , , ahk_id %hResult%
PathSaveList := 0
FileSelectFile, PathSaveList, S25, , Save your presets, *txt
FileAppend , %AllListBox%, %PathSaveList%.txt
if PathSaveList =
	MsgBox, , Save, Nothing saved...
else
	MsgBox, , Save, File saved!, 10
return

FindGame:
FileSelectFile, GamePath, 0, , Select The GAME ".exe", *exe
if (GamePath = "")
{	
	MsgBox, , , You didn't select a file!
	return
}
SplitPath, GamePath, Filename, Directory, , Gamename, Drive
GuiControl, Text, % hGAME , % Drive . "\...\" . Gamename
return

;===================================================================================================================
AskTSWoption:
IfInString, GamePath, TheSecretWorld    ; If game is TSW
	Gosub, TswGui
else
	gosub, ConsentStartMacro
return

OkTSW:
Gui TSW: Submit, NoHide
if (Name = "Username") || (Name = "")
{
	MsgBox, 4096, , Please, i really need your login to restart TSW...
	if (Pass = "Password") || (Pass = "")
		MsgBox, 4096, , Please, i really need your Password to restart TSW...
	return
}
else
{
	UserChoice := 1
	Gosub, ConsentStartMacro
}
return

ConsentStartMacro:
Gui TSW: Destroy
Gui main: Default
Gui main: submit, NoHide
ControlGet, AllListBox, List, , , ahk_id %hResult%
if (AllListBox = "") || (HotkeyForStart = "blank") || (HotkeyForStart = "") || (GamePath = "") {
	if GamePath =
		MsgBox, , , You didn't show me the game path!
	if AllListBox =
		MsgBox, , , Macro list is empty!
	if HotkeyForStart =
		MsgBox, , , You must designate a key to start / stop!
	ConsentStart := false
	return
} else {
	Gui, mini: Show, x0 y0 h160 w215 , % Window.Title
	Gui, main: Hide
	ConsentStart := true
	Hotkey, %HotkeyForStart%, StartStop, On
	DisplayHotkeyForS := % HotkeyForStart

	if ( SubStr(DisplayHotkeyForS, 1, 2) = "sc" ) {
		DisplayHotkeyForS := ReturnObject(DisplayHotkeyForS)
	} else {
		AHKmodifiers := {"Ctrl ": "^", "Shift ": "+", "Alt ": "!"}
		For key, value in AHKmodifiers {
		DisplayHotkeyForS := RegExReplace(DisplayHotkeyForS, "\" . value, key)
		}
	}
	GuiControl, Text, % hShortcut , % "Play/Pause: " . StrReplace(DisplayHotkeyForS, " ", "+")
	GuiControl, Text, % hGameName , % Drive . "\...\" . Gamename
	i:=0 
}
return

;MACRO Function:
;===================================================================================================================

StartStop:
WinSetTitle, ahk_exe %GamePath%, , % Drive . "\...\" . Gamename
WinGet, ID, ID, ahk_exe %GamePath%
GuiControl, % (i:=!i) ? "Show" : "Hide", % hButtonPauseN
GuiControl, % (i:=!i) ? "Show" : "Hide", % hButtonPlayN
SetTimer, Macro, % (i:=!i) ? "100" : "Off" ; uses ternary
if UserChoice = 1
{
	SetTimer, CheckTSW, 20000
}
return

Macro:
if ConsentStart = 1
{
	lines := StrSplit(AllListBox, "`n")
	for each, line in lines
	{
		if i = 0
			break
		if RegExMatch( line, "Sleep, (\d+)", Time )
		{
			GuiControl, Text, % hSleep , % time1 . "ms"
			Sleep, % Time1
		}
		else if RegExMatch( line, "O)Click, (\d+), (\d+)", OutputVar)
		{
			GuiControl, Text, % hRead , % "x: " . OutputVar.1  . "`ny: " . OutputVar.2
			MouseGetPos, currentX, CurrentY, hCurrentWindow
			WinActivate, ahk_id %ID%
			Click % OutputVar.1 . "," . OutputVar.2
			WinActivate, ahk_id %hCurrentWindow%
			MouseMove, currentX, currentY
		}
		else if (line)
		{
			GuiControl, Text, % hRead , % RegExReplace(line, "\{(\S+)[\S\s]+", "&$1")
			ControlFocus, , ahk_id %ID%
			ControlSend, , % line , ahk_id %ID%
		}
	}
}
return

;===================================================================================================================
CallBack:
ConsentStart := 0 ; dont allow user to press hotkey to start macro while he adjust this macro
i := 1 ; To be sure next gosub will  set i = 0  . resolve issue when user clicked "back" whan macro was not running
Gosub, StartStop ; to invert "i " value+ show button play / hide pause one
Gui, mini: Hide
Gui, main: Default
Gui, main: Show
Hotkey, %HotkeyForStart%, Off 
return

CheckTSW:
SetTitleMatchMode, 2
SetTimer, CheckTSW, Off
DllCall("SendMessageTimeout", UInt, ID, UInt, 0, Int,0, Int,0 , UInt, SMTO_NOTIMEOUTIFNOTHUNG, Int, 3, "UInt *", Result )
IfNotEqual, Result, 0
{
	Gosub, Alert
	return
}
SetTimer, CheckTSW, 20000
Return

Alert: ; This routine can be used to repeat testing & offer a WinKill.
SetTitleMatchMode, 1
WinKill, ahk_id %ID%, , 5
SetTimer, CheckTSW, Off
Secs := 10
SetTimer, CountDown, 1000
MsgBox, 4100, TSW probably hung?!, Would you like to restart the game?`n`n(the game will restart after %Secs%s) , %Secs%
SetTimer, CountDown, Off
;===================================================================================================================
;					RE-ask for restart
;===================================================================================================================
IfMsgBox, No
{
	return
}
if (MsgBox = Timeout) || (MsgBox = OK)
{
	ConsentStart := 0
	i := 1
	Gosub, StartStop
	SetTimer, CheckTSW, Off
	Gosub, StartGame
	return
}
CountDown:
Secs -= 1
ControlSetText, Button1, %Secs%, TSW probably hung?!
return
;===================================================================================================================
;					RESTART THE GAME
;===================================================================================================================
StartGame:
MsgBox, 64, ALEXSCRIPT:, I try to restart the game..., 10
ConsentStart := 0
Run *RunAs %Filename%, %Directory%
WinWait, ahk_class ConanPatcherWindow
WinActivate, ahk_class ConanPatcherWindow
ErrorLevel := 1
Loop
{
	ImageSearch, foundX, foundY, 470, 460, 520, 545, *10 %A_ScriptDir%\resources\arrowSTARTGAME.bmp
	If(ErrorLevel == 0)
		Break
}
Click, 400, 485
sleep 1000
Click, 300, 423 ; For accept eventual update
WinWait, ahk_class TSW
WinActivate, ahk_class TSW
sleep 3000
WinGet, ID, ID, ahk_class TSW ; TSW restart = New ID!
ErrorLevel := 1
Loop
{
	ImageSearch, foundX, foundY, 1442, 1045, 1459, 1062, *10 %A_ScriptDir%\resources\NowLogin.bmp
	If(ErrorLevel == 0)
		Break
}
SetKeyDelay, 100
ControlSend, , {ctrl}%Name%{Tab}%Pass%{Enter}, ahk_class TSW
Sleep, 1000
ControlSend, , {Enter}, ahk_class TSW
ErrorLevel := 1
Loop
{
	ImageSearch, foundX, foundY, 1770, 1045, 1787, 1062, *10 %A_ScriptDir%\resources\PlayNow.bmp
	If(ErrorLevel == 0)
		Break
}
ControlSend, , {Enter}, ahk_class TSW
StartGame := false
Sleep, 30000
ConsentStart := 0
i := 1
Goto, StartStop
return

MainGuiClose:
ExitApp
MiniGuiClose: ;User closed the mini window
Gosub, CallBack
return