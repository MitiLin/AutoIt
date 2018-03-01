#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
$filename = "U_05-05-00-49-00.PNG"

 ConsoleWrite(stringleft($filename,StringInStr( $filename,".",0,-1)-1)  & @CRLF)
$filename = stringleft($filename,StringInStr( $filename,".",0,-1)-1)
 ConsoleWrite(StringTrimLeft($filename,StringInStr( $filename,"_"))& @CRLF)