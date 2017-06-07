#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

DirCreate(@AppDataDir & "\AutoIt\")
GUICreate("test", 200,300)
$label = GUICtrlCreateLabel("test" ,10,10,100,50)

GUISetState()
for $i = 30 to 0 Step -1
	GUICtrlSetData($label,$i)
	sleep(100)
Next
$a = 0
for $i = 1 to 10
	Run(@ComSpec & " /c " & "adb  exec-out screencap -p > " & @AppDataDir & "\AutoIt\Android_ScreenShot_" & $i &".png","",@SW_HIDE )
	Sleep(1000)
Next
ConsoleWrite("output path:"& @AppDataDir & "\AutoIt\Android_ScreenShot.png" & @CRLF)



#CS
_GDIPlus_Startup()
Local $g_hImage = _GDIPlus_ImageLoadFromFile( @AppDataDir& "\AutoIt\Android_ScreenShot.png")
$g_hImage = _GDIPlus_ImageResize($g_hImage,720,1280)

$sCLSID = _GDIPlus_EncodersGetCLSID("PNG")

; Save image with rotation
_GDIPlus_ImageSaveToFileEx($g_hImage, @ScriptDir & "\Android_Screen720.png", $sCLSID)




; Clean up resources

_GDIPlus_ImageDispose($g_hImage)
_GDIPlus_Shutdown()



run(@ComSpec & " /c " & "mspaint " & @ScriptDir & "\Android_Screen1080.png","",@SW_HIDE)
#CE
run(@ComSpec & " /c " & "mspaint " &  @AppDataDir & "\AutoIt\Android_ScreenShot.png","",@SW_HIDE)
