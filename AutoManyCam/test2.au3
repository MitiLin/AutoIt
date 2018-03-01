;=================================================================================================
; Function:			_PostMessage_ClickDrag($hWnd, $X1, $Y1, $X2, $Y2, $Button = "left")
; Description:		Sends a mouse click and drag command to a specified window.
; Parameter(s):		$hWnd - The handle or the title of the window.
;					$X1, $Y1 - The x/y position to start the drag operation from.
;					$X2, $Y2 - The x/y position to end the drag operation at.
;					$Button - (optional) The button to click, "left", "right", "middle". Default is the left button.
;					$Delay - (optional) Delay in milliseconds. Default is 50.
; Requirement(s):	A window handle/title.
; Return Value(s):	On Success - Returns true
;					On Failure - Returns false
;					@Error - 0 = No error.
;							 1 = Invalid window handle or title.
;							 2 = Invalid start position.
;							 3 = Invalid end position.
;							 4 = Failed to open the dll.
;							 5 = Failed to send a MouseDown command.
;							 5 = Failed to send a MouseMove command.
;							 7 = Failed to send a MouseUp command.
; Author(s):		KillerDeluxe
;=================================================================================================
#include <WindowsConstants.au3>
#include <WINAPI.au3>
Global $wHandle = WinGetHandle("[TITLE:ManyCam;CLASS:Qt5QWindowIcon]")
ConsoleWrite($wHandle)

_MouseClick($wHandle,490,490)


Func _MouseClick($hWnd, $X, $Y, $Button = "left")
	If Not IsHWnd($hWnd) And $hWnd <> "" Then
		$hWnd = WinGetHandle($hWnd)
	EndIf

	If Not IsHWnd($hWnd) Then
		Return SetError(1, "", False)
	EndIf

	If Not IsInt($X) Or Not IsInt($Y) Then
		Return SetError(2, "", False)
	EndIf


	If StringLower($Button) == "left" Then
		$Button = $WM_LBUTTONDOWN
		$Pressed = 1
	ElseIf StringLower($Button) == "right" Then
		$Button = $WM_RBUTTONDOWN
		$Pressed = 2
	ElseIf StringLower($Button) == "middle" Then
		$Button = $WM_MBUTTONDOWN
		$Pressed = 10
	EndIf

	$User32 = DllOpen("User32.dll")
	If @error Then Return SetError(4, "", False)

	$Mouseloc = MouseGetPos()
	$winLoc= WinGetPos($wHandle)


	MouseMove($winLoc[0]+$X,$winLoc[1]+$Y,0)

	DllCall($User32, "bool", "PostMessage", "hwnd", $hWnd, "int", $Button, "int", $Pressed, "long", _WINAPI_MakeLong($X, $Y))
	If @error Then Return SetError(5, "", False)

	DllCall($User32, "bool", "PostMessage", "hwnd", $hWnd, "int", $Button + 1, "int", "0", "long", _WINAPI_MakeLong($X, $Y))
	If @error Then Return SetError(7, "", False)
	sleep(1)

	MouseMove($Mouseloc[0],$Mouseloc[1],0)

	DllClose($User32)
	Return SetError(0, 0, True)
EndFunc