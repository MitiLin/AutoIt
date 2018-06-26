#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_HiDpi=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ScreenCapture.au3>
#include <Misc.au3>
#include "MetroGUI-UDF\MetroGUI_UDF.au3"
#include <EditConstants.au3>


_SetTheme("DarkGreen")
_Metro_EnableHighDPIScaling()
Global $iX1, $iY1, $iX2, $iY2, $aPos, $sMsg, $sBMP_Path, $ProjectFolder=IniRead(@ScriptDir&"\Settings.ini","Settings","ProjectPath",@DesktopDir& "\")
; Create GUI
$hMain_GUI = _Metro_CreateGUI("Example", 500, 185, -1, -1, False)
_Metro_SetGUIOption($hMain_GUI, True)
$Control_Buttons = _Metro_AddControlButtons(True, False, True, False, False)
$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]

$Create_MatchImg = _Metro_CreateButtonEx("Create Match-Image", 255, 120, 130, 40, $ButtonBKColor, $FontThemeColor, "Arial", 10, 1)
$Get_ScreenCoords = _Metro_CreateButtonEx("Get Mark-Coordinates", 105, 120, 130, 40, $ButtonBKColor, $FontThemeColor, "Arial", 10, 1)

GUICtrlCreateLabel("Project Folder:", 10 * $gDPI, 60 * $gDPI, 130 * $gDPI, 25 * $gDPI)
GUICtrlSetFont(-1, 12, 600, 1, "Calibri", 5)
GUICtrlSetColor(-1, $FontThemeColor)
$Input = GUICtrlCreateInput($ProjectFolder, 130 * $gDPI, 60 * $gDPI, 290 * $gDPI, 25 * $gDPI, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
GUICtrlSetFont(-1, 10, 400, 1, "Calibri", 5)
$ChangeProjectPath = _Metro_CreateButtonEx("Change", 425, 60, 60, 25, $ButtonBKColor, $FontThemeColor, "Arial", 8, 1)

GUISetState()

While 1
	_Metro_HoverCheck_Loop($hMain_GUI)
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE, $GUI_CLOSE_BUTTON
			_Metro_GUIDelete($hMain_GUI)
			Exit
		Case $GUI_MINIMIZE_BUTTON
			GUISetState(@SW_MINIMIZE, $hMain_GUI)
		Case $Create_MatchImg
			MouseUp("")
			GUISetState(@SW_HIDE, $hMain_GUI)
			Mark_Rect()
			; Capture selected area
			DirCreate($ProjectFolder & "Match\")
			$sBMP_Path = _GetFileName($ProjectFolder & "Match\")
			_ScreenCapture_Capture($sBMP_Path[0], $iX1, $iY1, $iX2, $iY2, False)
			GUISetState(@SW_SHOW, $hMain_GUI)
			ShellExecute($sBMP_Path[0])
			ClipPut('$Match' & $sBMP_Path[1] & ' = _MatchPicture("' & $sBMP_Path[0] & '", 0.90)')
			TrayTip("Snapshot-Tool", "Picture has been saved and the match code has been copied to the clipboard.", 0, 1)
		Case $Get_ScreenCoords
			MouseUp("")
			GUISetState(@SW_HIDE, $hMain_GUI)
			Mark_Rect()
			ClipPut('Local $sCoords[4] = [' & $iX1 & ', ' & $iY1 & ', ' & $iX2 & ',' & $iY2 & ']')
			GUISetState(@SW_SHOW, $hMain_GUI)
			TrayTip("Snapshot-Tool", "Match-Coordinates been copied to the clipboard.", 0, 1)
		Case $ChangeProjectPath
			$SetProjectFolder = FileSelectFolder("Select the project folder for the match images.", @ScriptDir)
			If Not @error Then
				$ProjectFolder = $SetProjectFolder& "\"
				IniWrite(@ScriptDir&"\Settings.ini","Settings","ProjectPath",$ProjectFolder)
				GUICtrlSetData($Input, $ProjectFolder)
			EndIf
	EndSwitch
WEnd

Func _GetFileName($hPath)
	For $i = 1 To 200 Step +1
		If Not FileExists($hPath & $i & ".png") Then
			Local $hImagePath[2] = [$hPath & $i & ".png", $i]
			Return $hImagePath
			ExitLoop
		EndIf
	Next

EndFunc   ;==>_GetFileName
Func _ScreenSize();Returns complete Width+Height of all monitors
	Local $MonSizePos[2], $MonNumb = 1
	$MonSizePos[0] = @DesktopWidth
	$MonSizePos[1] = @DesktopHeight
	;Get Monitors
	Local $aPos, $MonList = _WinAPI_EnumDisplayMonitors()
	If @error Then Return $MonSizePos
	If IsArray($MonList) Then
		ReDim $MonList[$MonList[0][0] + 1][5]
		For $i = 1 To $MonList[0][0]
			$aPos = _WinAPI_GetPosFromRect($MonList[$i][1])
			For $j = 0 To 3
				$MonList[$i][$j + 1] = $aPos[$j]
			Next
			Local $width=$MonList[$i][1]+$MonList[$i][3]
			Local $height=($MonList[$i][2]+$MonList[$i][4])
			If $MonSizePos[0] < ($width) then $MonSizePos[0]=$width
			If $MonSizePos[1] < ($height) then $MonSizePos[1]=$height
		Next
	EndIf
	Return $MonSizePos
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: Mark_Rect
; Syntax ........: Mark_Rect()
; Author ........: Melba23
; Modified ......: BB_19
; ===============================================================================================================================
Func Mark_Rect()

	Local $aMouse_Pos, $hMask, $hMaster_Mask, $iTemp
	Local $UserDLL = DllOpen("user32.dll")

	; Create transparent GUI with Cross cursor
	Local $Screensize=_ScreenSize()
	$hCross_GUI = GUICreate("Test", $Screensize[0], $Screensize[1], 0, 0, $WS_POPUP, $WS_EX_TOPMOST)
	WinSetTrans($hCross_GUI, "", 8)
	GUISetState(@SW_SHOW, $hCross_GUI)
	GUISetCursor(3, 1, $hCross_GUI)

	Global $hRectangle_GUI = GUICreate("", $Screensize[0], $Screensize[1], 0, 0, $WS_POPUP, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
	GUISetBkColor(0x000000)

	; Wait until mouse button pressed
	While Not _IsPressed("01", $UserDLL)
		Sleep(10)
	WEnd

	; Get first mouse position
	$aMouse_Pos = MouseGetPos()
	$iX1 = $aMouse_Pos[0]
	$iY1 = $aMouse_Pos[1]

	; Draw rectangle while mouse button pressed
	While _IsPressed("01", $UserDLL)

		$aMouse_Pos = MouseGetPos()

		$hMaster_Mask = _WinAPI_CreateRectRgn(0, 0, 0, 0)
		$hMask = _WinAPI_CreateRectRgn($iX1, $aMouse_Pos[1], $aMouse_Pos[0], $aMouse_Pos[1] + 1) ; Bottom of rectangle
		_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
		_WinAPI_DeleteObject($hMask)
		$hMask = _WinAPI_CreateRectRgn($iX1, $iY1, $iX1 + 1, $aMouse_Pos[1]) ; Left of rectangle
		_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
		_WinAPI_DeleteObject($hMask)
		$hMask = _WinAPI_CreateRectRgn($iX1 + 1, $iY1 + 1, $aMouse_Pos[0], $iY1) ; Top of rectangle
		_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
		_WinAPI_DeleteObject($hMask)
		$hMask = _WinAPI_CreateRectRgn($aMouse_Pos[0], $iY1, $aMouse_Pos[0] + 1, $aMouse_Pos[1]) ; Right of rectangle
		_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
		_WinAPI_DeleteObject($hMask)
		; Set overall region
		_WinAPI_SetWindowRgn($hRectangle_GUI, $hMaster_Mask)

		If WinGetState($hRectangle_GUI) < 15 Then GUISetState()
		Sleep(10)

	WEnd

	; Get second mouse position
	$iX2 = $aMouse_Pos[0]
	$iY2 = $aMouse_Pos[1]

	; Set in correct order if required
	If $iX2 < $iX1 Then
		$iTemp = $iX1
		$iX1 = $iX2
		$iX2 = $iTemp
	EndIf
	If $iY2 < $iY1 Then
		$iTemp = $iY1
		$iY1 = $iY2
		$iY2 = $iTemp
	EndIf

	GUIDelete($hRectangle_GUI)
	GUIDelete($hCross_GUI)
	DllClose($UserDLL)

EndFunc   ;==>Mark_Rect
