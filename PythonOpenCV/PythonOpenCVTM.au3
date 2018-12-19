#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

Func _openCVTM($image1 , $image2)
	$image1 = Source image path
	$image2 = Target image path

	Return = array -> [x , y , width , height]

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <file.au3>
#include <ScreenCapture.au3>
If FileExists("C:\ProgramData\OpenCVTM\OpenCVTM.exe") Then
	;ConsoleWrite("OpenCV is installed!" &@CRLF)
Else
	MsgBox(0,"Python OpenCV Error!","Please install OpenCVTM module first!")
EndIf


Func _openCVTM($image1 , $image2)
	;ConsoleWrite("Source->" &_PathFull($image1,@ScriptDir)&@CRLF)
	;ConsoleWrite("Target->" &_PathFull($image2,@ScriptDir)&@CRLF)
	$iPID = Run("C:\ProgramData\OpenCVTM\OpenCVTM.exe " & _PathFull($image1,@ScriptDir)  &" "& _PathFull($image2,@ScriptDir), @ScriptDir,@SW_HIDE,$STDOUT_CHILD)
	ProcessWaitClose($iPID)
	$sOutput = StdoutRead($iPID)
	;ConsoleWrite($sOutput)
	$aString = StringRegExp($sOutput, '(?:\d)+(?!\d)', $STR_REGEXPARRAYGLOBALMATCH)
	If UBound($aString) = 4 Then
		Return $aString
	Else
		Return -1
	EndIf

EndFunc

Func _ImageSearch($target,$resultPosition, ByRef $x1, ByRef $y1,$tolerance=0)
	$Source = @TempDir & "\openCVSource.png"
	_ScreenCapture_Capture($Source,0,0,-1,-1,False)
	$aString = _openCVTM($Source,_PathFull($target,@ScriptDir))
	If not IsArray($aString) Then return 0
	$x1 = $aString[0]
	$y1 = $aString[1]
	If $resultPosition=1 Then
		$x1 += int($aString[2]/2)
		$y1 += int($aString[3]/2)
	EndIf
	Return 1
EndFunc
