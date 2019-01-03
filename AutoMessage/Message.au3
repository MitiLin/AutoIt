#AutoIt3Wrapper_UseX64=y
#NoTrayIcon
#include <winapi.au3>
#include <array.au3>

#include <ScreenCapture.au3>
#include <GetLastMessage.au3>

HotKeySet("{ESC}", "Terminate")


Global $isBlockMouse = False
Global $isBlockKeyboard = False
Global $pStub_MouseProc, $hHookMouse, $pStub_KeyProc, $hHookKeyboard

OnAutoItExitRegister("AutoItExit")
;BlockInitial()

Global $aName[] = ["Monitor1", "Monitor2", "Monitor3", "Monitor4"]
local $aAccount[] = ["qaworkbvt+mon1@gmail.com", "qaworkbvt+mon2@gmail.com", "qaworkbvt+mon3@gmail.com", "qaworkbvt+mon4@gmail.com"]
local $aPw[] = ["cyberlink", "cyberlink", "cyberlink", "cyberlink"]

If @OSVersion = "WIN_81" or @OSVersion = "WIN_8" or @OSVersion = "WIN_10" Then
	$ratioDPI = int(RegRead("HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics","AppliedDPI"))/96
Else
	$ratioDPI = 1
EndIf

Initial()

Global $aPID[UBound($aAccount)]
; $aPC = [[hMain0,ChildChatroom0, ChildChatroom1 .. 3] , [PC2, hWnd2 ...3] ...3]
Global $aPC = GetHWndPC($aAccount , $aPw)

$Pass=0
$Fail=0
for $i = 1 to 100
	$sender = Random(0,3,1)
	$Receiver = $sender + Random(1,3,1)
	If $Receiver >3 Then $Receiver -= 4
	$randomCode = Random(100000000,999999999,1)
	ToolTip("Pass:" & $pass & " / Fail:" & $Fail & @CRLF & "Sending [" & $aName[$sender] & "] to " & $aName[$Receiver] & " code:" & $randomCode,0,0)
	IMSend($sender,$Receiver,$randomCode)
	ToolTip("Pass:" & $pass & " / Fail:" & $Fail & @CRLF & "Verify " & $aName[$sender] & " to [" & $aName[$Receiver] & "] code:" & $randomCode,0,0)
	If IMVerify($sender,$Receiver,$randomCode) Then
		$Pass += 1
	Else
		MsgBox(0,"","Fail , Code is " & $randomCode)
		$Fail += 1
	EndIf
Next
MsgBox(0,"","Pass " & $pass & " times")



Func Initial()
	DirCreate(@LocalAppDataDir&"\AutoMessage")
	FileInstall("_TopLeft_receive.png", @LocalAppDataDir&"\AutoMessage\_TopLeft_receive.png",0)
	FileInstall("_BotRight_receive.png", @LocalAppDataDir&"\AutoMessage\_BotRight_receive.png",0)
EndFunc




Func OpenChatRoom($iTargetIndex,$iOpenIndex)
	$hReturn = WinActivate($aPC[$iTargetIndex][$iOpenIndex+1])

	If not $aPC[$iTargetIndex][$iOpenIndex+1] Or Not WinWaitActive($aPC[$iTargetIndex][$iOpenIndex+1],"",10) Then
		ConsoleWrite("The windows handle [" & $iTargetIndex & "][" & $iOpenIndex & "] is not found. Open new one." &@CRLF)
		$_hU = WinActivate($aPC[$iTargetIndex][0])
		$_posU = _WinGetPos($_hU)
		If Not IsArray($_posU) Then MsgBox(0,"","Main window [" & $iTargetIndex&"] is not found.")
		_MouseClick("Left", $_posU[0] + Floor($_posU[2]/2) +95 , $_posU[1] + 85 , 1, 10)
		_MouseClick("Left", $_posU[0] + Floor($_posU[2]/2) +135 , $_posU[1] + 85 , 1, 20)
		Sleep(1000)
		_MouseClick("Left", $_posU[0] + 70 , $_posU[1] + 170 ,1, 10)
		$tmp = ClipGet()
		While ClipGet() <> $aName[$iOpenIndex]
			ClipPut($aName[$iOpenIndex])
		WEnd
		Send("^a^v")
		Sleep(1000)
		ClipPut($tmp)
		_MouseClick("Left", $_posU[0] + 80 , $_posU[1] + 230 ,2, 10)
		Sleep(1000)

		$aChildWnd = _WinAPI_EnumProcessWindows($aPID[$iTargetIndex],True)
		For $i = 1 to $aChildWnd[0][0]
			If WinGetTitle($aChildWnd[$i][0]) = $aName[$iOpenIndex] Then
				$aPC[$iTargetIndex][$iOpenIndex+1] = $aChildWnd[$i][0]
				$hReturn =  $aChildWnd[$i][0]
			EndIf
		Next
	EndIf
	Return $hReturn
EndFunc

Func IMVerify($hSender, $hReceiver, $sMsg)
	$_hChatWindow = OpenChatRoom($hReceiver, $hSender)
	$_pos = WinGetPos($_hChatWindow)
	If Not IsArray($_pos) Then MsgBox(0,"","Receiver window is not found.")
	_ScreenCapture_CaptureWnd(@TempDir & "\temp.png", $_hChatWindow,0,0, -1, -1 , False )
	$sLastMSG = GetLastMessage(@TempDir & "\temp.png")
	Return ($sLastMSG = $sMsg) ? True : False
EndFunc


Func IMSend($hSender, $hReceiver, $sMsg)
	$_hChatWindow = OpenChatRoom($hSender,$hReceiver)
	$_posChatWindow = _WinGetPos($_hChatWindow)
	Local $_posChatRoom = [ $_posChatWindow[0] + $_posChatWindow[2]/2  , $_posChatWindow[1] + $_posChatWindow[3] - 30 ]
	$timer = TimerInit
	While (TimerDiff($timer) < 5000)
		If PixelGetColor($_posChatRoom[0], $_posChatRoom[1]) = 0xFFFFFF Then ExitLoop
	WEnd
	If Not (PixelGetColor($_posChatRoom[0], $_posChatRoom[1]) = 0xFFFFFF) Then Return -1
	_MouseClick("Left", $_posChatRoom[0], $_posChatRoom[1])
	$tmp = ClipGet()
	While ClipGet() <> $sMsg
		ClipPut($sMsg)
	WEnd
	Send("^a^v")
	Sleep(500)
	Send("{Enter}")
	ClipPut($tmp)
	Sleep(1000)
EndFunc






Func Terminate()
    Exit
EndFunc   ;==>Terminate

Func AutoItExit()
	myLog("Unblock keyboard/mouse")
	If $isBlockMouse Then
		UnblockMouse()
		DllCallbackFree($pStub_MouseProc)
	EndIf
	If $isBlockKeyboard Then
		UnblockKeyboard()
		DllCallbackFree($pStub_KeyProc)
	EndIf
	myLog("Close DbgView")
	RunWait("TASKKILL /IM U.exe /F","",@SW_HIDE )
	sleep(1000)
	_RefreshNotificationAreaIcons(0)
	_RefreshNotificationAreaIcons(1)
;~ 	ProcessClose($dbgView)

EndFunc

Func GetHWndPC($aAccount, $aPW)

	Local $aReturn[UBound($aAccount)][5]

	For $i = 0 to UBound($aAccount)-1
		$aPID[$i] = Run(@AppDataCommonDir & "\Cyberlink\U\U.exe multipleinstance=" & $i & " email=" & $aAccount[$i] & " pwd=" & $aPW[$i] )
	Next
	$timer = TimerInit()
	For $i = 0 to UBound($aAccount)-1
		While TimerDiff($timer) < 15000 ; wait launch for MAX 15 sec
			$aWND = _WinAPI_EnumProcessWindows($aPID[$i],True)
			If IsArray($aWND) Then
				$aReturn[$i][0] = $aWnd[1][0]
				ExitLoop
			EndIf
		WEnd
	Next
	If TimerDiff($timer) > 20000 Then
		MsgBox(0,"","Didn't found all U Windows in 20 sec.")
		Exit 1
	Else
		Return $aReturn
	EndIf
EndFunc











;=====================================
; Log
;=====================================

Func myLog($_data1 = '[empty]', $_data2 = '', $_data3 = '', $_data4 = '', $_data5  = '')
	Return
;~ 	ToolTip($_data1,0,0)
;~ 	FileWriteLine($logPath & "\UCompatibility_" & $UID & '.log', _
;~ 	@YEAR &"-"& @MON &"-"& @MDAY  &"/"& @HOUR &":"& @MIN &":"& @SEC & @TAB & $_data1 & _
;~ 	(($_data2="")?"": ", " & $_data2) & _
;~ 	(($_data3="")?"": ", " & $_data3) & _
;~ 	(($_data4="")?"": ", " & $_data4) & _
;~ 	(($_data5="")?"": ", " & $_data5) _
;~ 	)
EndFunc



;=====================================
; handle HighDPI case
;=====================================
Func _WinGetPos($_hWindow , $_txt="")
	$_pos = WinGetPos($_hWindow,$_txt)
	If @error then return $_pos
;~ 	For $i = 0 to 3
;~ 		$_pos[$i] = Int($_pos[$i]*$ratioDPI)
;~ 	Next
	Return $_pos
EndFunc

Func __MouseMove($_x, $_y, $_speed = 10)
	UnblockMouse()
	;MouseMove( int($_x / $ratioDPI), int($_y /$ratioDPI ), $_speed)
	MouseMove( $_x , $_y , $_speed)
	BlockMouse()
EndFunc

Func __MouseClick($_btn,$_x="xx",$_y = "yy",$_clicks = 1,$_spd = 10)
	UnblockMouse()
	$_posMouse = MouseGetPos()
;~ 	$_x = $_x="xx"?$_posMouse[0]:int($_x/$ratioDPI)
;~ 	$_y = $_y="yy"?$_posMouse[1]:int($_y/$ratioDPI)
	$_x = $_x="xx"?$_posMouse[0]:$_x
	$_y = $_y="yy"?$_posMouse[1]:$_y
	MouseClick($_btn,$_x,$_y ,$_clicks ,$_spd )
	BlockMouse()
EndFunc


Func _PixelGetColor($_x,$_y)
	$color = PixelGetColor(int($_x * $ratioDPI),int($_y* $ratioDPI))
	myLog("pos = " & int($_x * $ratioDPI & "." & int($_y* $ratioDPI) & " / color = " & hex($color) ))
	Return $color
EndFunc

Func _PixelSearch($_t,$_l,$_r,$_b,$_color)
	$_pos = PixelSearch(int($_t * $ratioDPI),int($_l * $ratioDPI),int($_r * $ratioDPI),int($_b * $ratioDPI),$_color)
	If IsArray($_pos) Then
		$_pos[0] = Int($_pos[0]/$ratioDPI)
		$_pos[1] = Int($_pos[1]/$ratioDPI)
		EndIf
	Return $_pos
EndFunc

;==================================
; Block mouse/keyboard
;==================================
Func BlockInitial()
	If $isBlockMouse then
		$pStub_MouseProc = DllCallbackRegister ("_Mouse_Handler", "int", "int;ptr;ptr")
		$hHookMouse = _WinAPI_SetWindowsHookEx($WH_MOUSE_LL, DllCallbackGetPtr($pStub_MouseProc), _WinAPI_GetModuleHandle(0), 0)
	EndIf
	If $isBlockKeyboard Then
		$pStub_KeyProc = DllCallbackRegister("_KeyProc", "int", "int;ptr;ptr")
		$hHookKeyboard = _WinAPI_SetWindowsHookEx($WH_KEYBOARD_LL, DllCallbackGetPtr($pStub_KeyProc), _WinAPI_GetModuleHandle(0), 0)
	EndIf
EndFunc

Func BlockMouse()
	If $isBlockMouse Then
		$hHookMouse = _WinAPI_SetWindowsHookEx($WH_MOUSE_LL, DllCallbackGetPtr($pStub_MouseProc), _WinAPI_GetModuleHandle(0), 0)
	EndIf
EndFunc

Func UnblockMouse()
	If $isBlockMouse Then
		_WinAPI_UnhookWindowsHookEx($hHookMouse)
	EndIf
EndFunc

Func BlockKeyboard()
	If not $isBlockKeyboard then Return 1
	$hHookKeyboard = _WinAPI_SetWindowsHookEx($WH_KEYBOARD_LL, DllCallbackGetPtr($pStub_KeyProc), _WinAPI_GetModuleHandle(0), 0)
EndFunc

Func UnblockKeyboard()
	If not $isBlockKeyboard then Return 1
	_WinAPI_UnhookWindowsHookEx($hHookKeyboard)
EndFunc

;============================
; Refresh tray icons
;============================
Func _RefreshNotificationAreaIcons($iTbar = 0)
	Switch @OSVersion
		Case "WIN_2000", "WIN_XP", "WIN_2003", "WIN_XPe"
			Return SetError(1, 1, 0)
	EndSwitch
	Local $hOwnerWin, $i_uID, $aRet, $iRet, $hTrayNotifyWnd, $iButtonCount = 0, _
			$hToolbar, $iCount, $iDLLUser32, $iDLLKrnl32, $iDLLShll32, _
			$tTBBUTTON, $pTBBUTTON, $iTBBUTTON, $tTRAYDATA, $pTRAYDATA, $iTRAYDATA, _
			$tNOTIFYICONDATA, $pNOTIFYICONDATA, $iProcessID, $hProcess, $pAddress
	$hTrayNotifyWnd = ControlGetHandle(WinGetHandle("[CLASS:Shell_TrayWnd]"), "", "[CLASS:TrayNotifyWnd]")
	Switch $iTbar
		Case 0
			$hToolbar = ControlGetHandle(ControlGetHandle($hTrayNotifyWnd, "", "[CLASS:SysPager]"), "", "[CLASS:ToolbarWindow32; INSTANCE:1]")
		Case 1
			$hToolbar = ControlGetHandle(WinGetHandle("[CLASS:NotifyIconOverflowWindow]"), "", "[CLASS:ToolbarWindow32; INSTANCE:1]")
		Case 2
			$hToolbar = ControlGetHandle($hTrayNotifyWnd, "", "[CLASS:ToolbarWindow32; INSTANCE:2]")
	EndSwitch
	$aRet = DllCall("user32.dll", "lparam", "SendMessageW", "hwnd", $hToolbar, "int", 0x418, "wparam", 0, "lparam", 0)
	If @error Or $aRet[0] < 1 Then Return SetError(2, @error, 0)
	$iCount = $aRet[0] - 1
	$iProcessID = WinGetProcess($hToolbar)
	If @error Or $iProcessID = -1 Then Return SetError(3, @error, 0)
	$aRet = DllCall("kernel32.dll", "ptr", "OpenProcess", "dword", 0x00000018, "int", 0, "int", $iProcessID)
	If @error Or $aRet[0] = 0 Then Return SetError(4, @error, 0)
	$hProcess = $aRet[0]
	$tTBBUTTON = DllStructCreate("int;int;byte;byte;align;dword_ptr;int_ptr")
	$pTBBUTTON = DllStructGetPtr($tTBBUTTON)
	$iTBBUTTON = DllStructGetSize($tTBBUTTON)
	If @error Or $iTBBUTTON = 0 Then Return SetError(5, @error, 0)
	$aRet = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "ptr", $hProcess, "ptr", 0, "int", $iTBBUTTON, "dword", 0x00001000, "dword", 0x00000004)
	If @error Or $aRet[0] = 0 Then
		DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hProcess)
		Return SetError(6, @error, 0)
	EndIf
	$pAddress = $aRet[0]
	$iDLLUser32 = DllOpen("user32.dll")
	$iDLLKrnl32 = DllOpen("kernel32.dll")
	$iDLLShll32 = DllOpen("shell32.dll")
	$tTRAYDATA = DllStructCreate("hwnd;uint;uint;dword[2];ptr")
	$pTRAYDATA = DllStructGetPtr($tTRAYDATA)
	$iTRAYDATA = DllStructGetSize($tTRAYDATA)
	$tNOTIFYICONDATA = DllStructCreate("dword;hwnd;uint;uint;uint;ptr;wchar[128];dword;dword;wchar[256];uint;wchar[64];dword;int;short;short;byte[8];ptr")
	$pNOTIFYICONDATA = DllStructGetPtr($tNOTIFYICONDATA)
	DllStructSetData($tNOTIFYICONDATA, 1, DllStructGetSize($tNOTIFYICONDATA))
	For $iID = $iCount To 0 Step -1
		If IsHWnd($hToolbar) = False Then ExitLoop
		$aRet = DllCall($iDLLUser32, "lparam", "SendMessageW", "hwnd", $hToolbar, "int", 0x417, "wparam", $iID, "lparam", $pAddress)
		If @error Or $aRet[0] <> 1 Then ContinueLoop
		$aRet = DllCall($iDLLKrnl32, "int", "ReadProcessMemory", "ptr", $hProcess, "ptr", $pAddress, "ptr", $pTBBUTTON, "int", $iTBBUTTON, "int*", -1)
		If @error Or $aRet[5] <> $iTBBUTTON Then ContinueLoop
		$aRet = DllCall($iDLLKrnl32, "int", "ReadProcessMemory", "ptr", $hProcess, "dword_ptr", DllStructGetData($tTBBUTTON, 5), "ptr", $pTRAYDATA, "int", $iTRAYDATA, "int*", -1)
		If @error Or $aRet[5] <> $iTRAYDATA Then ContinueLoop
		$hOwnerWin = DllStructGetData($tTRAYDATA, 1)
		If @error Or $hOwnerWin = 0 Then ContinueLoop
		If IsPtr($hOwnerWin) = 0 Or IsHWnd($hOwnerWin) = True Then ContinueLoop
		$i_uID = DllStructGetData($tTRAYDATA, 2)
		If @error Or $i_uID < 0 Then ContinueLoop
		$iRet = WinGetProcess($hOwnerWin)
		If @error Or $iRet <> -1 Then ContinueLoop
		DllStructSetData($tNOTIFYICONDATA, 2, $hOwnerWin)
		DllStructSetData($tNOTIFYICONDATA, 3, $i_uID)
		$aRet = DllCall($iDLLShll32, "int", "Shell_NotifyIconW", "dword", 0x2, "ptr", $pNOTIFYICONDATA)
		If @error Or $aRet[0] <> 1 Then ContinueLoop
		$iButtonCount += $aRet[0]
	Next
	DllCall($iDLLKrnl32, "int", "VirtualFreeEx", "ptr", $hProcess, "ptr", $pAddress, "int", 0, "dword", 0x00008000)
	DllCall($iDLLKrnl32, "int", "CloseHandle", "ptr", $hProcess)
	DllClose($iDLLShll32)
	DllClose($iDLLUser32)
	DllClose($iDLLKrnl32)
	Return SetError(0, 0, $iButtonCount)
EndFunc   ;==>_RefreshNotificationAreaIcons