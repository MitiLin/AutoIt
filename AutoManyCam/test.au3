
#include <SendMessage.au3>

#Include <WinAPI.au3>


Global $wHandle = WinGetHandle("[TITLE:ManyCam;CLASS:Qt5QWindowIcon]")
ConsoleWrite($wHandle)
ControlClickDrag($wHandle,"left",490,490,490,490)

Func ControlClickDrag($wHandle, $Button="left", $X1="", $Y1="", $X2="", $Y2="")

Local $MK_LBUTTON = 0x0001

Local $WM_LBUTTONDOWN = 0x0201

Local $WM_LBUTTONUP = 0x0202

Local $MK_RBUTTON = 0x0002

Local $WM_RBUTTONDOWN = 0x0204

Local $WM_RBUTTONUP = 0x0205

Local $WM_MOUSEMOVE = 0x0200

Local $i = 0

Select

Case $Button = "left"

$Button = $MK_LBUTTON

$ButtonDown = $WM_LBUTTONDOWN

$ButtonUp = $WM_LBUTTONUP

Case $Button = "right"

$Button = $MK_RBUTTON

$ButtonDown = $WM_RBUTTONDOWN

$ButtonUp = $WM_RBUTTONUP

EndSelect

DllCall("user32.dll", "int", "SendMessage", "hwnd", $wHandle, "int", $ButtonDown, "int", $Button, "long", _MakeLong($X1, $Y1))

DllCall("user32.dll", "int", "SendMessage", "hwnd", $wHandle, "int", $ButtonUp, "int", 0, "long", _MakeLong($X2, $Y2))

EndFunc

Func _MakeLong($LoWord,$HiWord)

Return BitOR($HiWord * 0x10000, BitAND($LoWord, 0xFFFF))

EndFunc