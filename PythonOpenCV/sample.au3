#cs ----------------------------------------------------------------------------


#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <PythonOpenCVTM.au3>
#include <array.au3>


; ===== _openCVTM sample =====
$Source = @ScriptDir & "\1.png"
$Target = @ScriptDir & "\1_.png"

$aResult = _openCVTM($Source,$Target)
_ArrayDisplay($aResult,"x ,y ,width, height, similar")

; ===== _openCVTM multiple search =====
$Source = @ScriptDir & "\2.png"
$Target = @ScriptDir & "\2_.png"
$aResult = _openCVTM($Source,$Target,0.9,True)
_ArrayDisplay($aResult)



; ===== _ImageSearch sample =====
$x=0
$y=0
$target = @ScriptDir&"/WinStart.png"
_ScreenCapture_Capture($target,0 ,@DesktopHeight -40 , 45, @DesktopHeight-1,False)

If _ImageSearch($target,1,$x,$y)=1 Then
	MouseMove($x,$y,10)
	ConsoleWrite("$x="& $x &@CRLF &"$y=" & $y & @CRLF)
Else
	ConsoleWrite("Not Found!"&@CRLF )
EndIf
