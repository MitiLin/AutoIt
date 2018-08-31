#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#cs
#include <array.au3>
HotKeySet("{ESC}", "Terminate")

Dim $callingSchedule[][] = [[2],["Meeting1",19,01],["Meeting2",21,10]]
Dim $receivingSchedule[][] = [[1],["Receive1",19,00,20,00]]
$callee = "2"
$reveiveDuration = 60 * 1000

While -1
	If AlarmCalling($callingSchedule) Then
		VoiceCall($callee)
	ElseIf AlarmReceiving($receivingSchedule) Then
		ReceiveCall($reveiveDuration)
	Else
		sleep(250)
	EndIf
WEnd
Func Terminate()
    Exit
EndFunc   ;==>Terminate
#ce

Func AlarmCalling($schedule)
	$callNumber = $schedule[0][0]
	For $i = 1 to $callNumber
		$alarmHour = $schedule[$i][1]
		$alarmMin = $schedule[$i][2]
		If $alarmHour = @HOUR And $alarmMin = @MIN Then return $schedule[$i][3]
	Next
	Return False
EndFunc

Func AlarmReceiving($schedule)
	$receiveNumber = $schedule[0][0]
	For $i = 1 to $receiveNumber
		$alarmTimeCodeStart = $schedule[$i][1] * 60 + $schedule[$i][2]
		$alarmTimeCodeEnd = $schedule[$i][3] * 60 + $schedule[$i][4]
		$alarmTimeCodeCurrent = @HOUR*60 + @MIN
		$alarmTimeCodeEnd = $alarmTimeCodeEnd < $alarmTimeCodeStart? $alarmTimeCodeEnd + 24*60 : $alarmTimeCodeEnd					;Handle cross day case
		$alarmTimeCodeCurrent = $alarmTimeCodeCurrent < $alarmTimeCodeStart? $alarmTimeCodeCurrent + 24*60 : $alarmTimeCodeCurrent	;Handle cross day case
		If $alarmTimeCodeCurrent >= $alarmTimeCodeStart and $alarmTimeCodeCurrent <= $alarmTimeCodeEnd Then
			return True
		Else
			Return False
		EndIf
	Next
EndFunc







