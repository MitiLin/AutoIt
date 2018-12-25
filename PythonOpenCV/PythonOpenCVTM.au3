#cs ----------------------------------------------------------------------------

Version: 1.5

Func _openCVTM($image1 , $image2 , $threshold = 0.9 , $multipleSearch = false)
	$image1 = Source image path
	$image2 = Target image path
	$threshold = Similarity limitation
	$multipleSearch = return multiple results that meets threshold

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
If @OSVersion = "Win_81" or @OSVersion ="Win8" or @OSVersion = "WIN_10" Then
	$ratio = int(RegRead("HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics","AppliedDPI"))/96
Else
	$ratio = 1
EndIf

Func _openCVTM($image1 , $image2 , $threshold = 0.9 , $multiple = false)
	;ConsoleWrite("Source->" &_PathFull($image1,@ScriptDir)&@CRLF)
	;ConsoleWrite("Target->" &_PathFull($image2,@ScriptDir)&@CRLF)
	$iPID = Run('C:\ProgramData\OpenCVTM\OpenCVTM.exe "' & _PathFull($image1,@ScriptDir) & '" "'& _PathFull($image2,@ScriptDir)& '" ' & $threshold & ($multiple?" -m":""), @ScriptDir, @SW_HIDE, $STDOUT_CHILD)
	;ConsoleWrite('C:\ProgramData\OpenCVTM\OpenCVTM.exe "' & _PathFull($image1,@ScriptDir) & '" "'& _PathFull($image2,@ScriptDir)& '" ' & $threshold & ($multiple?" -m":"") &@CRLF)
	ProcessWaitClose($iPID)
	$sOutput = StdoutRead($iPID)
	ConsoleWrite($sOutput)
	$aString = StringRegExp($sOutput, '(\d+\.?\d*)', $STR_REGEXPARRAYGLOBALMATCH)
	$iStringNumber = UBound($aString)
	local $return2DArray[Ceiling($iStringNumber/5)][5]
	If $iStringNumber >= 5 Then
		$index = 0
		For $i = 0 to $iStringNumber -1
			ConsoleWrite(Floor($i/5) &":"& $index &@CRLF)
			$return2DArray[Floor($i/5)][$index] = $aString[$i]
			$index = $index>=4? 0 : $index+1
		Next
		Return $multiple? $return2DArray:$aString
	Else
		Return -1
	EndIf

EndFunc

Func _ImageSearch($target,$resultPosition, ByRef $x1, ByRef $y1,$tolerance=0.9)
	$Source = @TempDir & "\openCVSource.png"

	;ConsoleWrite("Ratio=" & $ratio &@CRLF)
	;ConsoleWrite("OS=" & @OSVersion &@CRLF)
	_ScreenCapture_Capture($Source,0,0,@DesktopWidth*$ratio-1,@DesktopHeight*$ratio-1,False)
	$aString = _openCVTM($Source,_PathFull($target,@ScriptDir))
	#include <array.au3>
	_ArrayDisplay($aString)
	If not IsArray($aString) Then return 0
	$x1 = $aString[0]
	$y1 = $aString[1]
	If $resultPosition=1 Then
		$x1 += int($aString[2]/2)
		$y1 += int($aString[3]/2)
	EndIf
	Return 1
EndFunc

Func _MouseClick($mClickBtn="Left",$mClickX = "xx", $mClickY = "yy", $mClickClicks=1, $mClickSpeed=10)
	If $mClickX = "xx" Then
		MouseClick($mClickBtn)
	ElseIf $mClickY = "yy" Then
		MouseClick($mClickBtn,Int($mClickX/$ratio))
	Else
		MouseClick($mClickBtn,Int($mClickX/$ratio),Int($mClickY/$ratio),$mClickClicks,$mClickSpeed)
	EndIf
EndFunc
Func _MouseMove($mMoveX, $mMoveY, $mMoveSpeed=10)
	MouseMove(Int($mMoveX/$ratio),Int($mMoveY/$ratio),$mMoveSpeed)
EndFunc
