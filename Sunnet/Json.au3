#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
GUICreate("Sunnet Project URL Creater v0.1", 440, 330, @DesktopWidth / 2 - 200, @DesktopHeight / 2 - 150)
GUICtrlCreateLabel("Account", 20, 23, 70, 20)
$inputAccount = GUICtrlCreateInput("1", 100, 20, 300, 20)

GUICtrlCreateLabel("Password", 20, 53, 70, 20)
$inputPassword = GUICtrlCreateInput("1", 100, 50, 300, 20, 0x0020)

GUICtrlCreateLabel("Title", 20, 83, 70, 20)
$inputTitle = GUICtrlCreateInput("1", 100, 80, 300, 20)

GUICtrlCreateLabel("Description", 20, 113, 70, 20)
$inputDescription = GUICtrlCreateInput("1", 100, 110, 300, 20)

GUICtrlCreateLabel("Watermark", 20, 143, 70, 20)
$inputWatermark = GUICtrlCreateInput("1", 100, 140, 300, 20)

GUICtrlCreateLabel("Display Name", 20, 173, 70, 20)
$inputDisplayname = GUICtrlCreateInput("1", 100, 170, 300, 20)


GUICtrlCreateLabel("SSO link", 20, 203, 70, 20)
$inputSSO = GUICtrlCreateInput("", 100, 200, 270, 20, 0x0880)
GUICtrlSetBkColor(-1, 0xD0D0D0)

$Btn_copySSO = GUICtrlCreateButton("copy", 380, 200, 50, 20)


GUICtrlCreateLabel("Join link", 20, 233, 70, 20)
$inputJoin = GUICtrlCreateInput("", 100, 230, 270, 20, 0x0880)
GUICtrlSetBkColor(-1, 0xD0D0D0)

$Btn_copyJoin = GUICtrlCreateButton("copy", 380, 230, 50, 20)

$Btn_Start = GUICtrlCreateButton("Get Join URL", 150, 265, 100, 30)
$Label_Status = GUICtrlCreateLabel("", 20, 303, 300, 20)
GUICtrlSetData($inputJoin,"33332222")

GUISetState(@SW_SHOW)


While 1
	Switch GUIGetMsg()
		Case -3
			ExitLoop
		Case $Btn_copyJoin
			ClipPut(GUIctrlread($inputJoin))
	EndSwitch
WEnd
