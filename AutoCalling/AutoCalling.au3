
$Server = "UBeta"
;ControlClick("[Title:U;Class:U]","","[CLASS:Edit;INSTANCE:2]")
If @OSVersion = "WIN_81" or @OSVersion = "WIN_8" or @OSVersion = "WIN_10" Then

	$ratioDPI = int(RegRead("HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics","AppliedDPI"))/96
Else
	$ratioDPI = 1
EndIf


;AutoCalling("2")
;sleep(3000)
;ConsoleWrite(NoAnsweredDlg())

Func AutoCalling($user)
	$hU = WinActivate("[Title:U;Class:" & $Server & "]")
	If not $hU then return False
	SwitchTabChat()
	$posU = WinGetPos($hU)
	ControlClick("Title:U;Class:" & $Server & "]","","[CLASS:Edit;INSTANCE:2]")
	Send("^a")
	$tmp = ClipGet()
	While $tmp = ClipGet()
		ClipPut($user)
	WEnd
	IMEToEng()
	Sleep(500)
	Send("^v")
	ClipPut($tmp)
	Sleep(1000)
	Dim $FirstUser = [($posU[0] + $posU[2]/2 ),($posU[1] + 240)]
	MouseClick("Right",$FirstUser[0],$FirstUser[1])
	Sleep(1000)
	Dim $OpionCall = [($FirstUser[0] + 80 ),($FirstUser[1] + 55)]
	MouseClick("left",$OpionCall[0],$OpionCall[1])
	MeetingStart()
EndFunc

Func MeetingStart()
	$hMeeting = WinWait("[CLASS:CLMeetingsMainWindow]" , "" , 10)
	sleep(1000)
	WinSetState ($hMeeting,"",@SW_RESTORE)
	sleep(1000)
	myLog("Wait for Meeting windows is activate")
	WinWaitActive($hMeeting,"",10)
	ConsoleWrite($hMeeting &@CRLF)
	myLog("Meeting = " & $hMeeting)
	$posMeeting = WinGetPos($hMeeting)
	$_color = 0
	While Not $_color = 0x575757
		$_color = hex(_PixelGetColor($posMeeting[0] + 15 , $posMeeting[1] + 10))
		sleep(200)
	WEnd

	;Meeting - recording
	$_color = 0
	Sleep(4000)
	Send("{SPACE}")
	Sleep(1000)

	myLog("Count down 60 sec")
	_countDown(30)
	If NoAnsweredDlg() Then Return
	;_MouseClick("Left" , $posMeeting[0] + $posMeeting[2]/2 +50 , $posMeeting[1] + $posMeeting[3] -40 ,1,5)	; Click Recording button

	;Meeting - leaving
	_MouseClick("Left" , $posMeeting[0] + $posMeeting[2]/2 +150 , $posMeeting[1] + $posMeeting[3] -40 ,1,5)

	$_exitColor = -1
	$_timerExit = TimerInit()
	$_foundExitWindow = True
	While Not IsArray($_exitColor)
		$hMeetingExit = WinGetHandle("[CLASS:Koan]")
		;ConsoleWrite("Exit = " & $hMeetingExit &@CRLF)
		$posMeetingExit = WinGetPos($hMeetingExit)
		$_exitColor = _PixelSearch($posMeetingExit[0]+ 132, $posMeetingExit[1]+ 111,$posMeetingExit[0]+ 136, $posMeetingExit[1]+ 115,0xB6414A)
		;ConsoleWrite("Exit color = " & hex($_exitColor) &@CRLF)
		sleep(500)
		If TimerDiff($_timerExit) > 5 * 1000 Then
			ConsoleWrite("[Warning] Exit window does not exist over 5sec! switch to location mathod" &@CRLF)
			myLog("[Warning] Exit window does not exist over 5sec! switch to location mathod")
			$_foundExitWindow = False
			ExitLoop
		EndIf
	WEnd

	If $_foundExitWindow Then
		ConsoleWrite("Exit meeting window is found" &@CRLF)
		_MouseClick("Left" , $_exitColor[0], $_exitColor[1], 1 , 10)
	Else
		ConsoleWrite("Exit meeting window is NOT found" &@CRLF)
		WinActivate($hMeeting)
		_MouseClick("Left" , $posMeeting[0] + $posMeeting[2]/2 +150 , $posMeeting[1] + $posMeeting[3] -80 ,1,10)
	EndIf
EndFunc

Func NoAnsweredDlg()
	WinActivate("[Title:CyberLink;Class:Koan;W:320\H:180]")
	$hNoAnswer = WinWaitActive("[Title:CyberLink;Class:Koan;W:320\H:180]","",5)
	;ConsoleWrite("win = " & $hNoAnswer &@CRLF)
	$posDlg = WinGetPos($hNoAnswer)
	If IsArray($posDlg) then
		MouseClick("Left",$posDlg[0]+255,$posDlg[1]+155)
		Return True
	Else
		Return False
	EndIf

EndFunc


Func _countDown($__duration = 10)
	$__last = -1
	$__timer = TimerInit()
	While TimerDiff($__timer) < $__duration *1000
		$__new = Floor(TimerDiff($__timer)/1000)
		If $__new <> $__last Then ToolTip($__duration - $__new,0,0)
		Sleep(100)
	WEnd
	ToolTip("")
EndFunc

Func _MouseMove($_x, $_y, $_speed = 10)
	;UnblockMouse()
	;MouseMove( int($_x / $ratioDPI), int($_y /$ratioDPI ), $_speed)
	MouseMove( $_x , $_y , $_speed)
	;BlockMouse()
EndFunc

Func _MouseClick($_btn,$_x="xx",$_y = "yy",$_clicks = 1,$_spd = 10)
	;UnblockMouse()
	$_posMouse = MouseGetPos()
;~ 	$_x = $_x="xx"?$_posMouse[0]:int($_x/$ratioDPI)
;~ 	$_y = $_y="yy"?$_posMouse[1]:int($_y/$ratioDPI)
	$_x = $_x="xx"?$_posMouse[0]:$_x
	$_y = $_y="yy"?$_posMouse[1]:$_y
	MouseClick($_btn,$_x,$_y ,$_clicks ,$_spd )
	;BlockMouse()
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


Func myLog($_data1 = '[empty]', $_data2 = '', $_data3 = '', $_data4 = '', $_data5  = '')
	ToolTip($_data1,0,0)
;~ 	FileWriteLine($logPath & "\UCompatibility_" & $UID & '.log', _
;~ 	@YEAR &"-"& @MON &"-"& @MDAY  &"/"& @HOUR &":"& @MIN &":"& @SEC & @TAB & $_data1 & _
;~ 	(($_data2="")?"": ", " & $_data2) & _
;~ 	(($_data3="")?"": ", " & $_data3) & _
;~ 	(($_data4="")?"": ", " & $_data4) & _
;~ 	(($_data5="")?"": ", " & $_data5) _
;~ 	)
EndFunc
Func SwitchTabHome()
	$hU = WinActivate("[Title:U;Class:" & $Server & "]")
	ConsoleWrite($hu)
	If not $hU then return False
	$posU = WinGetPos($hU)
	MouseClick("Left", $posU[0] + Floor($posU[2]/2) -95 , $posU[1] + 85 ,1,10)
	MouseClick("Left", $posU[0] + Floor($posU[2]/2) -135 , $posU[1] + 85 ,1,20)
EndFunc


Func SwitchTabChat()
	$hU = WinActivate("[Title:U;Class:" & $Server & "]")
	If not $hU then return False
	$posU = WinGetPos($hU)
	MouseClick("Left", $posU[0] + Floor($posU[2]/2) -35 , $posU[1] + 85 ,1,10)
	MouseClick("Left", $posU[0] + Floor($posU[2]/2) -45 , $posU[1] + 85 ,1,20)
EndFunc
Func IMEToEng()
	$hWnd=WinGetHandle("[ACTIVE]")
	$ret=DllCall("user32.dll","long","LoadKeyboardLayout","str","08040804","int",1+0)
	DllCall("user32.dll","ptr","SendMessage","hwnd",$hWnd,"int",0x50,"int",1,"int",$ret[0])
EndFunc
