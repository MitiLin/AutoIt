#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
HotKeySet("{ESC}", "Terminate")
Func Terminate()
    Exit
EndFunc   ;==>Terminate
While true
	AutoAnswer()
	sleep(500)
WEnd

Func AutoAnswer()
	$hAnsDlg = WinActive("[CLASS:Koan]")
	;ConsoleWrite("Koan = " & $hAnsDlg &@CRLF)
	if not $hAnsDlg Then Return False
	$posDlg = WinGetPos($hAnsDlg)
;~ 	_ArrayDisplay($posDlg)	; 1870,985
	Dim $posAnsButton = [($posDlg[0] + 277), ($posDlg[1]+125)]
	MouseClick("Left",$posAnsButton[0], $posAnsButton[1])
	Return True
EndFunc

Func MeetingClosedDlg()
	$hMeetingClosedDlg = WinActive("[TITLE:CyberLink;CLASS:Koan]")
	ConsoleWrite("Koan = " & $hMeetingClosedDlg &@CRLF)
	if not $hMeetingClosedDlg Then Return False
	$posDlg = WinGetPos($hMeetingClosedDlg)
	Dim $posAnsButton = [($posDlg[0] + 232), ($posDlg[1]+155)] ; 1250 -1013 , 500-345
	MouseClick("left",$posAnsButton[0],$posAnsButton[1])
	Return True
EndFunc
