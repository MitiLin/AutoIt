#AutoIt3Wrapper_UseX64=n ; In order for the x86 DLLs to work
#include "OpenCV-Match_UDF.au3"

_OpenCV_Startup();loads opencv DLLs
_OpenCV_EnableLogging(True,True,True) ;Logs matches, errors in a log file and autoit console output. 

;Please note that these examples might not work as the match pictures have to be found with the exact same size on your screen.

;Example 1
ShellExecute("http://www.tv.com/");Open Website tv.com
$Match1 = _MatchPicture(@ScriptDir&"\Match\1.png", 0.70,False,10,500);Try to find the match picture on the screen. Number of tries: 10, Sleep between each try: 500ms. 
If Not @error Then
	_MarkMatch($Match1) ;Debugging: Draws a rect on the screen/coordinates of the match to show the user where the match was found
	Sleep(100)
	_ClickMouse($Match1, "left",1) ;Calculates the center of the match and clicks the left mouse once on click position
EndIf

Sleep(1000)

;Example 2, matching on a specific area of the screen
ShellExecute("notepad.exe");open nodepad
WinWait("[CLASS:Notepad]","",5)
WinMove("[CLASS:Notepad]","",0,0,500,500)

Local $sCoords[4] = [0, 0, 500,500]
$Match2 = _MatchPicture(@ScriptDir&"\Match\2.png", 0.80,$sCoords,3,500)
If Not @error Then
	_MarkMatch($Match2) 
	Sleep(100)
	_ClickMouse($Match2, "left", 1) 
EndIf

_OpenCV_Shutdown();Closes DLLs
