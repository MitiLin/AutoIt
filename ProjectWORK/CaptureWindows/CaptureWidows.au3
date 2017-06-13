
#include <ScreenCapture.au3>
#include <array.au3>

Opt("WinTitleMatchMode", 2)

HotKeySet("{ESC}", "Terminate")

Global $windows_W = 3
Global $windows_H = 2
Global $ScreenX_offset = -1920
Global $ScreenY_offset = 0
Global $Timer = TimerInit()

MoveBrowser("[CLASS:Chrome_WidgetWin_1;TITLE:Webinars - Google Chrome]")
MoveBrowser("[CLASS:IEFrame;TITLE:Webinars - Internet Explorer]")
MoveBrowser("[CLASS:MozillaWindowClass;TITLE:Webinars - Mozilla Firefox]")
MoveBrowser("[CLASS:ApplicationFrameWindow;TITLE:Webinars ‎- Microsoft Edge]")
MoveBrowser("[CLASS:Koan;TITLE:U Webinar]")

$DisplayTimer = TimerInit()
$SnapshotTimer = TimerInit()
RunWait(@ComSpec & " /c " & "adb kill-server", "",@SW_HIDE )
RunWait(@ComSpec & " /c " & "adb devices", "",@SW_HIDE )
DirCreate("D:\dropbox\android")
DirCreate("D:\dropbox\screenshots")

CaptureScreen()
While True
	If TimerDiff($DisplayTimer) > 500 Then
		$DisplayTimer = TimerInit()
		ToolTip("Running:" & TimePassed(),$ScreenX_offset,$ScreenY_offset)
	EndIf

	If TimerDiff($SnapshotTimer) >  5 * 60 * 1000 Then	; 6000 = 6 sec
		$SnapshotTimer = TimerInit()
		CaptureScreen()
	EndIf
	Sleep(10)
WEnd

Func MoveBrowser($win)
	Static $Display_w = 0
	Static $Display_h = 0
	Local $hWnd = WinGetHandle($win)
	$x = Int(1920/$windows_W)
	$y = Int(1080/$windows_H)
	WinMove ($hWnd,"", $x * $Display_w + $ScreenX_offset , $y * $Display_h + $ScreenY_offset , $x, $y)
	;WinActivate($hWnd)
	$Display_w += 1
	If $Display_w = $windows_W Then
		$Display_w = 0
		$Display_h += 1
	EndIf
EndFunc

Func TimePassed()
	$SecPassed = TimerDiff($Timer) / 1000
	$h =  Floor($SecPassed / (60 * 60))
	$m = Floor(($SecPassed - $h * 60 * 60)/ 60)
	$s = Floor($SecPassed - $h * 60 *60 - $m * 60)
	Return $H&":"&$M&":"&$S
EndFunc

Func CaptureScreen()
	Run(@ComSpec & " /c " & "adb  exec-out screencap -p > D:\dropbox\android\"  & @mon &"-"&@MDAY&"-"&@HOUR&"-"&@MIN&"-"&@SEC&".png","",@SW_HIDE )
	$hBmp = _ScreenCapture_Capture("",$ScreenX_offset,$ScreenY_offset,1920 -1 ,1080 -1)
	_ScreenCapture_SaveImage("D:\dropbox\screenshots\" & @mon &"-"&@MDAY&"-"&@HOUR&"-"&@MIN&"-"&@SEC&".PNG", $hBmp)
EndFunc

Func Terminate()
    Exit
EndFunc   ;==>Terminate
