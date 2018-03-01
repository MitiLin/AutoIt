#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

DirCreate(@AppDataDir & "\AutoIt\")
RunWait(@ComSpec & " /c " & "adb -s LGD855190a4061  exec-out screencap -p > " & @AppDataDir & "\AutoIt\Android_ScreenShot.png","",@SW_HIDE )
ConsoleWrite("output path:"& @AppDataDir & "\AutoIt\Android_ScreenShot.png" & @CRLF)




_GDIPlus_Startup()
Local $g_hImage = _GDIPlus_ImageLoadFromFile( @AppDataDir& "\AutoIt\Android_ScreenShot.png")
$g_hImage = _GDIPlus_ImageResize($g_hImage,720,1280)

$sCLSID = _GDIPlus_EncodersGetCLSID("PNG")

; Save image with rotation
_GDIPlus_ImageSaveToFileEx($g_hImage, @ScriptDir & "\Android_Screen720.png", $sCLSID)




; Clean up resources

_GDIPlus_ImageDispose($g_hImage)
_GDIPlus_Shutdown()



run(@ComSpec & " /c " & "mspaint " & @ScriptDir & "\Android_Screen720.png","",@SW_HIDE)

;run(@ComSpec & " /c " & "mspaint " &  @AppDataDir & "\AutoIt\Android_ScreenShot.png","",@SW_HIDE)
