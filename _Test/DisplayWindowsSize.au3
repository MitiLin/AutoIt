#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GUIConstantsEx.au3>

GUICreate("Display",500,500)
GUICtrlCreateLabel ("width=" & @DesktopWidth , 10 , 10)
GUICtrlCreateLabel ("hieght="& @DesktopHeight , 10 , 30)
GUISetState()






While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			ExitLoop
	EndSwitch
WEnd



