#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
HotKeySet("{ESC}", "Terminate")
$timer =TimerInit()
;ConsoleWrite( floor(1.555555 / (60*60)))

$timer = TimerInit()

$DisplayTimer = TimerInit()
sleep(1000)

While True

		If TimerDiff($DisplayTimer) > 500 Then
		$DisplayTimer = TimerInit()
		ToolTip("Running:" & TimePassed(),0,0)
	EndIf

WEnd


ConsoleWrite(TimePassed() & @CRLF)
Func TimePassed()
	$SecPassed = TimerDiff($Timer) / 1000
	$SecPassed = $SecPassed * 500
	$h =  Floor($SecPassed / (60 * 60))
	$m = Floor(($SecPassed - $h * 60 * 60)/ 60)
	$s = Floor($SecPassed - ($h * 60 *60) - $m * 60)
	Return $H&":"&$M&":"&$S
EndFunc

Func Terminate()
    Exit
EndFunc
