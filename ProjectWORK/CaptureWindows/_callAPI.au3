#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

;$Result = DllCall("user32.dll", "BOOL", "SetCursorPos", "int", 100, "int", 200)

#include <SendMessage.au3>

$hWnd = WinGetHandle("[CLASS:Notepad]")
ConsoleWrite("win=" & $hWnd & @CRLF)
;_SendMessage ($hWnd , 0x0003 , 0 , _MakeLong(100,100))

DllCall("user32.dll", "int", "SendMessage", _
          "hwnd",  $hWnd, _
          "int",   0x0005, _
          "long",   _MakeLong(100, 100), _
          "long",  _MakeLong(100, 100))


Func _MakeLong($LoWord,$HiWord)
    Return BitOR($HiWord * 0x10000, BitAND($LoWord, 0xFFFF))
EndFunc

