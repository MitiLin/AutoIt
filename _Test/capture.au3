#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <ScreenCapture.au3>

Example()

Func Example()

    ; Capture region
    _ScreenCapture_Capture(@MyDocumentsDir & "\GDIPlus_Image2.jpg", 0, 0,1920*2 -1 , 1080*2 -1)

    ShellExecute(@MyDocumentsDir & "\GDIPlus_Image2.jpg")
EndFunc   ;==>Example
