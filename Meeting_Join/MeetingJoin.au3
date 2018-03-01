#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include <String.au3>
#include <BlockInputEx.au3>

; Script Start - Add your code below here
HotKeySet("{ESC}", "Terminate")
_BlockInputEx(2)
$MeetingID = "795159327"
If $CmdLine[0] > 1 Then
	$startNumber = $CmdLine[1]
Else
	$startNumber = 101
EndIf

For $i = 160 to 199
	ToolTip("NO." & $i , 1020,0)
	ConsoleWrite("No.=" & $i &@CRLF)
	Local $hWnd = WinWait("[CLASS:UBeta]", "", 10)
	WinActivate($hWnd)
	WinMove($hWnd,"",0,0,400,800)
	MouseClick("left",200,300)
	sleep(500)
	Send("webinarsbugverify0621+" & $i & "@gmail.com",1)
	Send("{TAB}")
	sleep(500)
	Send("123123")
	Send("{Enter}")
	sleep(1000)
	WaitColor(170,140,"008AF5")
	MouseClick("left",120,85)
	WaitColor(37,282,"008AF5")
	MouseClick("left",40,285)
	Local $dlg = WinWait("[CLASS:KOAN MSO DLG]", "", 10)
	Send($MeetingID)
	Sleep(2000)
	Send("{Enter}")
	Local $meeting = WinWait("[CLASS:CLMeetingsMainWindow]", "", 10)
	WinMove($meeting,"",0,0,1200,800)
	WaitColor(745,780,"89203B")
	sleep(1000)
	MouseClick("left",745,780)
	Sleep(1500)
	ConsoleWrite("Wait for Exit dialog" & @CRLF)
	While -1
		Local $exit = WinWait("[CLASS:Koan]", "", 60)
		ConsoleWrite("dialog found= " & $exit & @CRLF)
		Sleep(1000)
		$exit_pos = WinGetPos ( $exit )
		ConsoleWrite("x=" & $exit_pos[0] &@CRLF)
		If $exit_pos[0] > 100 Then ExitLoop
	WEnd
	WaitColor($exit_pos[0]+ 135,$exit_pos[1] + 110,"B6414A")
	sleep(500)
	MouseClick("left",$exit_pos[0]+ 135 , $exit_pos[1] + 110)
	While WinExists($meeting)
		Sleep(500)
	WEnd
	Sleep(500)
	MouseClick("left",70,50)
	Sleep(2000)
	MouseClick("left",120,235)
	Sleep(1500)
Next



Func WaitColor($x,$y,$color="FFFFFF")
		While not ($color=Hex(PixelGetColor($x,$y),6))
			Sleep(100)
		WEnd
EndFunc
Func Terminate()
    Exit
EndFunc   ;==>Terminate