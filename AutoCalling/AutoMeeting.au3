#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Readini.au3>
#include <AutoAnswer.au3>
#include <AutoCalling.au3>
#include <Schedule.au3>
#include <array.au3>

HotKeySet("{ESC}", "Terminate")

$meetingSchedule = ReadMeetingINI("AutoMeeting.ini")
$receiveSchedule = ReadReceiveINI("AutoMeeting.ini")

While True
	$callee = AlarmCalling($meetingSchedule)
	If $callee Then

		for $i = 1 to 3
			MyToolTip($i & "/3: Calling - " & $callee)
			AutoCalling($callee)
		Next
	ElseIf AlarmReceiving($receiveSchedule) Then
		MyToolTip("Auto-answer: On" & @CRLF &  "Press [Esc] to leave.")
		AutoAnswer()
		MeetingEndDlg()
	Else
		MyToolTip("")
		sleep(250)
	EndIf
WEnd




Func MyToolTip($str)
	Static $currentTip = ""
	If $currentTip<>$str Then
		$currentTip = $str
		ToolTip($currentTip,0,0)
	EndIf
EndFunc



Func Terminate()
    Exit
EndFunc   ;==>Terminate

