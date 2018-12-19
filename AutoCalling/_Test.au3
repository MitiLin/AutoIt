#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <array.au3>


;~ Local $aArray = StringRegExp('<test>a</test> <test>b</test> <test>c</Test>', '(?i)<test>(.*?)</test>', $STR_REGEXPARRAYFULLMATCH)
;~ For $i = 0 To UBound($aArray) - 1
;~     MsgBox($MB_SYSTEMMODAL, "RegExp Test with Option 2 - " & $i, $aArray[$i])
;~ Next
sleep(2000)
ConsoleWrite(WinGetHandle("[Title:CyberLink;Class:Koan;W:320\H:180]"))