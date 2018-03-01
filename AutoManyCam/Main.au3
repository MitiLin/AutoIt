#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include <MouseClick.au3>
; Script Start - Add your code below here
AdlibRegister("DetectMeeting")
HotKeySet("{ESC}", "Terminate")

Global $ManyCamWindows
Global $RestartCam = False
$ManyCamIsActivated = False
ToolTip("Meeting is off.",0,0)
DetectManyCam()

While -1
	If $RestartCam Then
		$RestartCam = False
		for $i = 5 to 1 step -1
			ToolTip("Restart Cam after " & $i & " sec." ,0,0)
			sleep(1000)
		Next
		ToolTip("Meeting is on.",0,0)
		ResetManyCamWindow()
		_MouseClick($ManyCamWindows,490,490)
	EndIf
	Sleep(1000)
WEnd


Func DetectMeeting()
	Static $MeetingIsLaunched = False
	$MeetingWindow = WinGetHandle("[CLASS:CLMeetingsMainWindow]")
	If not $MeetingIsLaunched and $MeetingWindow Then
		$MeetingIsLaunched = True
		$RestartCam = True
		ToolTip("Meeting is on.",0,0)
		ElseIf Not $MeetingWindow and $MeetingIsLaunched Then
		$MeetingIsLaunched = False
		ToolTip("Meeting is off.",0,0)
	EndIf

EndFunc



Func DetectManyCam()
	$ManyCamWindows = WinGetHandle("[TITLE:ManyCam;CLASS:Qt5QWindowIcon]")

    If WinExists($ManyCamWindows) Then
		return $ManyCamWindows
    Else
        MsgBox(0, "", "ManyCam is not found! Exit program now!")
		Exit 0
    EndIf
EndFunc

Func ResetManyCamWindow()
	WinMove($ManyCamWindows,"",0,0,900,600)
EndFunc


Func Terminate()
    Exit
EndFunc   ;==>Terminate