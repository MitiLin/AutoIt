;===============================================================================
  ;
  ; Function Name:  _MouseClickPlus()
  ; Version added:  0.1
  ; Description:    Sends a click to window, not entirely accurate, but works
  ;                 minimized.
  ; Parameter(s):   $Window     =  Title of the window to send click to
  ;                 $Button     =  "left" or "right" mouse button
  ;                 $X          =  X coordinate
  ;                 $Y          =  Y coordinate
  ;                 $Clicks     =  Number of clicks to send
  ; Remarks:        You MUST be in "MouseCoordMode" 0 to use this without bugs.
  ; Author(s):      Insolence <insolence_9@yahoo.com>
  ;
  ;===============================================================================
#include <WindowsConstants.au3>
#include <WINAPI.au3>


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
	$winLoc= WinGetPos($hWnd)

	WinActivate($hWnd)
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