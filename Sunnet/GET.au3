#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include "WinHttp.au3"

Global $sGet = HttpGet("http://www.google.com/")
FileWrite("Google.txt", $sGet)