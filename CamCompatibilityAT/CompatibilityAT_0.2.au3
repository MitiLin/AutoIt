#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=favicon.ico
#AutoIt3Wrapper_Res_Comment=U Webcam Compatibility AT
#AutoIt3Wrapper_Res_Fileversion=0.2.0.0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <APIDiagConstants.au3>
#include <WinAPIDiag.au3>
#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
#include <zip.au3>
#include <ScreenCapture.au3>
#include <file.au3>
#include <FTPEx.au3>
#include <HTTP.au3>

Global $dbgView
$logPath = @LocalAppDataDir & "\AutoIt"
$meetingID = 120404031
$UID = StringTrimRight(StringTrimLeft(_WinAPI_UniqueHardwareID(),1),1)

OnAutoItExitRegister("AutoItexit")
HotKeySet("{ESC}", "Terminate")
$displayName = InputBox("Display Name"," " , "","",190,115)
$ratioDPI = int(RegRead("HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics","AppliedDPI"))/96



createTempFolder()
launchDBG()
getDxlog()

If not isUInstalled() Then
	downloadInstaller()
Else
	launchU()
EndIf
waitU()
joinMeeting()

finishProcess()

packageData()
UploadData()
MsgBox (0,"Compatibility","Files upload finished. Thanks for help!")




Func createTempFolder($logPath = @LocalAppDataDir & "\AutoIt")
	myLog("Create tmpFolder")
	If not FileExists($logPath) Then DirCreate($logPath)
	FileInstall(".\Dbgview.exe" , $logPath & "\Dbgview.exe",0)
	myLog("DPI Ratio =" & $ratioDPI)
EndFunc

Func getDxlog()
	myLog("Get DxLog")
 	Run(@SystemDir & '\dxdiag /dontskip /t dxdiag_output.txt', $logPath, @SW_HIDE)
EndFunc

Func launchDBG()
	myLog("launch DBG")
	RegWrite("HKEY_CURRENT_USER\Software\Sysinternals\DbgView", "EulaAccepted", "REG_DWORD", 1)
	Run($logPath & '\dbgview /t /l ' & $logPath &"\U_Dbgview_" & $UID & ".log /p" , "", @SW_HIDE)
	$dbgView = ProcessWait ( "Dbgview.exe" , 5)
	sleep(1000)
	DllCall("kernel32.dll", "none", "OutputDebugString", "str", "AutoIt - " &@MON&@MDAY&"-"&@HOUR&@MIN&@SEC)
	myLog("debug view = " & $dbgView)
EndFunc



Func isUInstalled()
	If FileExists(@AppDataCommonDir & "\Cyberlink\U") Then
		MyLog("U folder exists")
		If FileExists(@AppDataCommonDir & "\Cyberlink\U\U.exe") Then
			Return True
		Else
			Mylog("U.exe does not exist")
		EndIf
	EndIf
	Mylog("Install U")
	return False
EndFunc

Func downloadInstaller()
	myLog("Download installer")
	InetGet("http://update.cyberlink.com/Retail/Patch/U/DL/KNG9DIC9I9/UAppInst.exe",@TempDir & "\UAppinst.exe", $INET_FORCERELOAD)
	Run(@TempDir & "\UAppinst.exe", @TempDir, @SW_HIDE)
	ConsoleWrite("waiting for downloader ready" &@CRLF)
	myLog("waiting for downloader ready")
	$hDownloader = WinWait("[CLASS:CLDownloader]")
	ConsoleWrite("waiting for installing")
	myLog("waiting for installing")
	$hDownloader = WinWaitClose("[CLASS:CLDownloader]")
	ConsoleWrite("installation is finished."&@CRLF)
	myLog("installation is finished.")
EndFunc

Func launchU()
	myLog("Launch U")
	Run(@AppDataCommonDir & "\Cyberlink\U\U.exe","",@SW_HIDE)
EndFunc

Func waitU()
	ConsoleWrite("Wait U" &@CRLF)
	myLog("Wait U")
	$_exitColor = -1
	$_timerExit = TimerInit()
	$hU = WinWaitActive("[TITLE:U;CLASS:U]","",10)
	ConsoleWrite("U is activated" &@CRLF)
	myLog("U is activated")
	While $_exitColor <> 0xB2B2B2
		;ConsoleWrite("Exit = " & $hMeetingExit &@CRLF)
		$hU = WinWaitActive("[TITLE:U;CLASS:U]","",0)
		WinActivate($hU)
		$posU = _WinGetPos($hU)
		$_exitColor = _PixelGetColor($posU[0] + Floor($posU[2]/2), $posU[1]+ 20)
		ConsoleWrite("Exit color = " & hex($_exitColor) &@CRLF)
		sleep(500)
		If TimerDiff($_timerExit) > 60 * 1000 Then
			myLog("[Warning] U window does not exist over 1min!")
			Exit 1
		EndIf

	WEnd

EndFunc



Func joinMeeting()
	;in U window
	myLog("Join Meeting")
	$hU = WinActivate("[TITLE:U;CLASS:U]")
	If isSignIn() Then
		;sign in already
		ConsoleWrite("sign in already" &@CRLF)
		_joinMeetingSignin()
	Else
		;not sign in
		$posU = _WinGetPos($hU)
		_MouseMove($posU[0] + Floor($posU[2]/2)  , $posU[1] + 480 ,5)
		_MouseClick("Left")
		sleep(1000)
		_MouseMove($posU[0] + Floor($posU[2]/2)  , $posU[1] + 180 ,5)
		_MouseClick("Left")
		sleep(500)
		Send($meetingID)
		_MouseMove($posU[0] + Floor($posU[2]/2)  , $posU[1] + 225 ,5)
		_MouseClick("Left")
		send("^a" & @ComputerName)
		_MouseMove($posU[0] + Floor($posU[2]/2) +50  , $posU[1] + 300 ,5)
		_MouseClick("Left")

	EndIf
	$hMeeting = WinWait("[CLASS:CLMeetingsMainWindow]" , "" , 10)

	; in Meeting window
	_selectDevice()
	myLog("Wait for Meeting windows is activate")
	WinWaitActive($hMeeting,"",10)
	ConsoleWrite($hMeeting &@CRLF)
	myLog("Meeting = " & $hMeeting)
	$posMeeting = _WinGetPos($hMeeting)
	$_color = 0
	While Not $_color = 0x575757
		$_color = hex(_PixelGetColor($posMeeting[0] + 15 , $posMeeting[1] + 10))
		sleep(200)
	WEnd
	Sleep(4000)
	Send("{SPACE}")
	Sleep(1000)
	;Meeting - recording
	_MouseClick("Left" , $posMeeting[0] + $posMeeting[2]/2 +50 , $posMeeting[1] + $posMeeting[3] -40 ,1,5)
	myLog("Count down 10 sec")
	_countDown(10)
	_ScreenCapture_CaptureWnd($logPath & "\ScreenShot_" & $UID & ".jpg" , $hMeeting)
	_MouseClick("Left" , $posMeeting[0] + $posMeeting[2]/2 +50 , $posMeeting[1] + $posMeeting[3] -40 ,1,5)

	;Meeting - leaving
	_MouseClick("Left" , $posMeeting[0] + $posMeeting[2]/2 +150 , $posMeeting[1] + $posMeeting[3] -40 ,1,5)

	$_exitColor = -1
	$_timerExit = TimerInit()
	$_foundExitWindow = True
	While Not IsArray($_exitColor)
		$hMeetingExit = WinGetHandle("[CLASS:Koan]")
		;ConsoleWrite("Exit = " & $hMeetingExit &@CRLF)
		$posMeetingExit = _WinGetPos($hMeetingExit)
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

	;close encode window
	ConsoleWrite("exit encode" &@CRLF)
	myLog("exit encode")

	$timerWaitEnc = TimerInit()
	While TimerDiff($timerWaitEnc) < 10 * 1000
		$hMeetingEnc = WinWait("[TITLE:CyberLink;CLASS:Koan;w:402\h:186]" , "" , 1)
		If IsHWnd($hMeetingEnc) Then ExitLoop
		$hMeetingEnc = WinWait("[TITLE:CyberLink;CLASS:Koan;w:401\h:185]" , "" , 1)
		If IsHWnd($hMeetingEnc) Then ExitLoop
	WEnd
	ConsoleWrite("$hMeetingEnc = " &$hMeetingEnc &@CRLF)
	myLog("hMeetingEnc = " &$hMeetingEnc)
	If not $hMeetingEnc Then
		ConsoleWrite("Encode windows does not exist over 10sec" &@CRLF)
		myLog("Encode windows does not exist over 10sec")
		Exit 1
	EndIf

	$posMeetingEnc = _WinGetPos($hMeetingEnc)
	$_exitColor = 0
	$_timerEnc = TimerInit()
	ConsoleWrite("Waiting for encode task" &@CRLF)
	myLog("Waiting for encode task")
	WinSetOnTop($posMeetingEnc,"",1)
	While Not IsArray($_exitColor)
		$_exitColor = _PixelSearch($posMeetingEnc[0]+ 283 , $posMeetingEnc[1]+ 148 , $posMeetingEnc[0]+ 287 , $posMeetingEnc[1]+ 152 , 0x43A5F0)
		sleep(1000)
		If TimerDiff($_timerEnc) > 300 * 1000 Then
			myLog("[Error] Encode over 5min!")
			Exit 1
		EndIf
	WEnd
	ConsoleWrite("close encode window" &@CRLF)
	_MouseClick("Left",$_exitColor[0], $_exitColor[1],1,5)


EndFunc

Func _joinMeetingSignin()
	$_hU = WinActivate("[TITLE:U;CLASS:U]")
	$_posU = _WinGetPos($_hU)
	_MouseClick("Left", $_posU[0] + Floor($_posU[2]/2) -135 , $_posU[1] + 85 , 1, 10)
	_MouseClick("Left", $_posU[0] + 40 , $_posU[1] + 280 ,1, 20)
	$_idDialog= WinWait("[CLASS:KOAN MSO DLG;W:400\H:360]","",3)
	Sleep(1000)
	ConsoleWrite("$_idDialog=" & $_idDialog &@CRLF)
	myLog("$_idDialog=" & $_idDialog)
	$_posidDialog = _WinGetPos($_idDialog)
	If IsArray($_posidDialog) Then
		ConsoleWrite($_posidDialog[0] + Floor($_posidDialog[2]/2) &":"& $_posidDialog[1] + Floor($_posidDialog[3]/2) - 10 &@CRLF )
		_MouseClick("Left", $_posidDialog[0] + Floor($_posidDialog[2]/2), $_posidDialog[1] + Floor($_posidDialog[3]/2) - 10, 0 , 30 )
		Send($meetingID)
		_MouseClick("Left", $_posidDialog[0] + Floor($_posidDialog[2]/2) + 50, $_posidDialog[1] + Floor($_posidDialog[3]/2) + 130 , 20)
	EndIf

EndFunc


Func _selectDevice()
	$_cam = IniRead(@LocalAppDataDir & "\Cyberlink\U\settings.ini","meetings" , "defaultvideo" , "")
	ConsoleWrite("cam = " &$_cam &@CRLF)
	myLog("cam = " &$_cam)
	If $_cam <> ""  Then
		myLog("skip device selection")
		Return
	EndIf
	ToolTip("")
	Do
		$hMeeting = WinWait("[CLASS:CLMeetingsMainWindow]" , "",20)
		WinActivate($hMeeting)
		Sleep(200)
		$posMeeting = _WinGetPos($hMeeting)

	Until _PixelGetColor($posMeeting[0] +20 , $posMeeting[1] +10) = 0x575757
	$_timerSearch = TimerInit()
	myLog("Seatch Button")
	Do
		$posButton = _PixelSearch( _
			Floor($posMeeting[0]+ $posMeeting[2] /2) - 2, Floor($posMeeting[1]+ $posMeeting[3] /2) -200 , _
			Floor($posMeeting[0]+ $posMeeting[2] /2) + 2 ,Floor($posMeeting[1]+ $posMeeting[3] /2) +200 , 0x43A5F0 _
			)
	Until IsArray($posButton) or TimerDiff($_timerSearch) > 10 *1000

	ConsoleWrite("Found button? " & IsArray($posButton) &@CRLF)
	myLog("Found button? " & IsArray($posButton) &@CRLF)
	if IsArray($posButton) Then
		ConsoleWrite("click it" & @CRLF)

		_MouseClick("Left" , $posButton[0], $posButton[1]+5)
	EndIf
EndFunc

Func isSignIn()
	return FileExists(@LocalAppDataDir & "\Cyberlink\U\userinfo.cache")? True : False
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

Func myLog($_data1 = '[empty]', $_data2 = '', $_data3 = '', $_data4 = '', $_data5  = '')
	ToolTip($_data1,0,0)
	FileWriteLine($logPath & "\UCompatibility_" & $UID & ".log", _
	@YEAR &"-"& @MON &"-"& @MDAY  &"/"& @HOUR &":"& @MIN &":"& @SEC & @TAB & $_data1 & _
	(($_data2="")?"": ", " & $_data2) & _
	(($_data3="")?"": ", " & $_data3) & _
	(($_data4="")?"": ", " & $_data4) & _
	(($_data5="")?"": ", " & $_data5) _
	)
EndFunc
;& $_data2 = ''?"":$_data2 & $_data3 = ''?"":$_data3 & $_data4 = ''?"":$_data4 & $_data5 = ''?"":$_data5


Func finishProcess()
	ProcessClose($dbgView)
	MyLog("Script Finish normally.")
EndFunc

Func packageData()
	$zipName = $logPath & '\' &$UID& '.zip'
	$Zip = _Zip_Create($zipName)
	ConsoleWrite("zip1"&@CRLF)
	myLog("zip1")
	_Zip_AddFile($Zip,$logPath &'\dxdiag_output.txt')
	ConsoleWrite("zip2"&@CRLF)
	myLog("zip2")
	_Zip_AddFile($Zip,$logPath &'\UCompatibility_' & $UID & '.log')
	ConsoleWrite("zip3"&@CRLF)
	myLog("zip3")
	_Zip_AddFile($Zip,$logPath &'\ScreenShot_' & $UID & '.jpg')
	ConsoleWrite("zip4"&@CRLF)
	myLog("zip4")
	_Zip_AddFile($Zip,$logPath & "\U_Dbgview_" & $UID & ".log")
	$videoList = _FileListToArray(@UserProfileDir & "\Videos\U Meeting Recordings")
	ConsoleWrite("zip5"&@CRLF)
	myLog("zip5")
	_Zip_Addfolder($Zip,@UserProfileDir & "\Videos\U Meeting Recordings\" & $videoList[$videoList[0]]& "\", 0)
	ConsoleWrite("zip6"&@CRLF)
	myLog("zip6")
	_Zip_Addfolder($Zip,@LocalAppDataDir & "\CyberLink\U\dmp\", 0)
EndFunc



Func UploadData()
	ConsoleWrite("upload now")
	myLog("upload now")
	Local $hOpen = _FTP_Open('MyFTP Control')
	Local $hConn = _FTP_Connect($hOpen, "mitilin.mooo.com", "AutoScript" , "123123" ,1 )
	$a = _FTP_FilePut( $hConn, $logPath & '\' &$UID& '.zip', $UID& '.zip' )
	ConsoleWrite("Result=" & $a &@CRLF & "error= " & @error &@CRLF)
	myLog("Result=" & $a  & " error= " & @error)
	Local $iFtpc = _FTP_Close($hConn)
	Local $iFtpo = _FTP_Close($hOpen)
	myLog("update Google excel")
	_HTTP_Post("https://docs.google.com/forms/u/1/d/e/1FAIpQLSf4VLDMkYaU9knZR8jy9NC0ybjd5tx3xqkpag96exxMutf2eA/formResponse", "entry.1767768977=" & urlencode($displayName) & "&entry.1475700249=" & urlencode(@ComputerName) & "&entry.1418934191=" & urlencode($UID) )
	;https://docs.google.com/forms/u/1/d/e/1FAIpQLSf4VLDMkYaU9knZR8jy9NC0ybjd5tx3xqkpag96exxMutf2eA/formResponse?entry.1767768977=1&entry.1475700249=2&entry.1418934191=3&Summit=Summit
EndFunc


Func _WinGetPos($_hWindow , $_txt="")
	$_pos = WinGetPos($_hWindow,$_txt)
	If @error then return $_pos
;~ 	For $i = 0 to 3
;~ 		$_pos[$i] = Int($_pos[$i]*$ratioDPI)
;~ 	Next
	Return $_pos
EndFunc

Func _MouseMove($_x, $_y, $_speed = 10)
	;MouseMove( int($_x / $ratioDPI), int($_y /$ratioDPI ), $_speed)
	MouseMove( $_x , $_y , $_speed)
EndFunc

Func _MouseClick($_btn,$_x="xx",$_y = "yy",$_clicks = 1,$_spd = 10)
	$_posMouse = MouseGetPos()
;~ 	$_x = $_x="xx"?$_posMouse[0]:int($_x/$ratioDPI)
;~ 	$_y = $_y="yy"?$_posMouse[1]:int($_y/$ratioDPI)
	$_x = $_x="xx"?$_posMouse[0]:$_x
	$_y = $_y="yy"?$_posMouse[1]:$_y
	MouseClick($_btn,$_x,$_y ,$_clicks ,$_spd )
EndFunc


Func _PixelGetColor($_x,$_y)
	Return PixelGetColor(int($_x * $ratioDPI),int($_y* $ratioDPI))
EndFunc

Func _PixelSearch($_t,$_l,$_r,$_b,$_color)
	$_pos = PixelSearch(int($_t * $ratioDPI),int($_l * $ratioDPI),int($_r * $ratioDPI),int($_b * $ratioDPI),$_color)
	If IsArray($_pos) Then
		$_pos[0] = Int($_pos[0]/$ratioDPI)
		$_pos[1] = Int($_pos[1]/$ratioDPI)
		EndIf
	Return $_pos
EndFunc


Func Terminate()
    Exit
EndFunc   ;==>Terminate
Func AutoItExit()
	ProcessClose($dbgView)
	myLog("Close DbgView")
EndFunc

