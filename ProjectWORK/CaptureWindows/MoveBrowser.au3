#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
;#RequireAdmin
; Script Start - Add your code below here
#include-once
Global $windows_W = 3
Global $windows_H = 2
Global $ScreenX_offset = 0
Global $ScreenY_offset = 0

MoveBrowser("[CLASS:UBeta]")

Func MoveBrowser($win)
	Static $Display_w = 0
	Static $Display_h = 0
	Local $hWnd = WinGetHandle($win)
	ConsoleWrite ("win=" & $hWnd &@CRLF)
	$x = Int(1920/$windows_W)
	$y = Int(1080/$windows_H)
	WinMove ($hWnd,"", 110 , 110 ,500,500)
	;WinActivate($hWnd)
	$Display_w += 1
	If $Display_w = $windows_W Then
		$Display_w = 0
		$Display_h += 1
	EndIf
EndFunc