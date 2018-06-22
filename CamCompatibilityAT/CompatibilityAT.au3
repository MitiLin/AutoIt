#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Fileversion=1.3
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
#include <GUIConstantsEx.au3>
#include <zip.au3>
#include <ScreenCapture.au3>
#include <file.au3>
#include <FTPEx.au3>
#include <HTTP.au3>
 #include <Color.au3>

Global $dbgView
Global $pStub_MouseProc, $hHookMouse, $pStub_KeyProc, $hHookKeyboard
Global $timerRunTime = TimerInit()

$logPath = @LocalAppDataDir & "\AutoIt"
$meetingID = 120404031
$UID = StringTrimRight(StringTrimLeft(_WinAPI_UniqueHardwareID($UHID_All),1),1)







OnAutoItExitRegister("AutoItexit")
HotKeySet("{ESC}", "Terminate")

;=========GUI==============
$guiWidth = 270
$guiHeight = 150
GUICreate("Compatibility check" ,$guiWidth , $guiHeight , Int((@DesktopWidth - $guiWidth)/2), Int((@DesktopHeight - $guiHeight)/2))
$guiBlockMouse = GUICtrlCreateCheckbox("Block mouse",10,10)
GUICtrlSetState(-1,1)
$guiBlockKeyboard = GUICtrlCreateCheckbox('Block keyboard ("F8" to release)',10,30)
GUICtrlSetState(-1,0)

GUICtrlCreateLabel("Name" , 15 , 54 , 80)
$idComboBox = GUICtrlCreateCombo("QAWork", 70,50 , 80)
$idComboBox2 = GUICtrlCreateCombo("Albert Chang", 70, 70, 150)
GUICtrlSetData($idComboBox, "QADF|QAME|Others", "QAWork")
GUICtrlSetData($idComboBox2, "Biaggi Li|Bill Kuo|Casper Chiu|Dave Huang|Dylan Liu|Eason Yeh|Jim Huang|Mike Huang|Miti Lin| _Nicklous Chen|Sam Chang|Terence Chang|Zony Chen", "Albert Chang")
$idInputName = GUICtrlCreateInput("Your name?",70,70,150)
GUICtrlSetState($idInputName,$GUI_HIDE)

GUICtrlCreateLabel("Platform" , 15 , 99 , 80)
$inputPlatform = GUICtrlCreateInput("", 70,95 , 150)
GUICtrlSetState(-1,256) ; focus on display name

GUICtrlCreateLabel('Hit "ESC" to stop.' , 10 , 130)
$btnStart = GUICtrlCreateButton("Start!" , 120 , 118 , 50, 25)

$iENTER = GUICtrlCreateDummy()
Dim $AccelKeys[1][2] = [["{ENTER}", $iENTER]]; Set accelerators
GUISetAccelerators($AccelKeys)

GUISetState()
$displayName = ""
Global $isBlockMouse = False
Global $isBlockKeyboard = False
While 1
        Switch GUIGetMsg()
            Case -3
                Exit
			Case $btnStart
				ExitLoop
			Case $iENTER
				ExitLoop
			Case $idComboBox
                $sComboRead = GUICtrlRead($idComboBox)
                Switch $sComboRead
					Case "QAWork"
						GUICtrlSetState($idComboBox2,$GUI_SHOW)
						GUICtrlSetState($idInputName,$GUI_HIDE)
						GUICtrlSetData($idComboBox2, "|Albert Chang|Biaggi Li|Bill Kuo|Casper Chiu|Dave Huang|Dylan Liu|Eason Yeh|Jim Huang|Mike Huang|Miti Lin|Nicklous Chen|Sam Chang|Terence Chang|Zony Chen", "Albert Chang")
   					Case "QADF"
						GUICtrlSetState($idComboBox2,$GUI_SHOW)
						GUICtrlSetState($idInputName,$GUI_HIDE)
						GUICtrlSetData($idComboBox2, "|Cindy Chang|Dino Wei|Eason Peng|Enya Chuang|Frank Chen|Jerry Chang|Jim Chen|Mark Chang|Michelle Jiang|Ramon Chen|Ryan Chang|Ryu Chu|Shawn Huang|Will Chiang|Yeva Huang", "Cindy Chang")
					Case "QAME"
						GUICtrlSetState($idComboBox2,$GUI_SHOW)
						GUICtrlSetState($idInputName,$GUI_HIDE)
						GUICtrlSetData($idComboBox2, "|Alix Kao|Allan Hsieh|Angol Huang|Aquino Lin|Arlon Chou|Bally Hsu|Duncan Su|Ego Chen|Eka Wu|Ernesto Huang|Gary Hsieh|Ivan Wang|Jason Yeng|John Shih|Mike Lu|Mike Yu|Morris Liao|Volath Liu", "Alix Kao")
					Case "Others"
						GUICtrlSetState($idComboBox2,$GUI_HIDE)
						GUICtrlSetState($idInputName,$GUI_SHOW)
				EndSwitch
        EndSwitch
WEnd

$isBlockMouse = (GUICtrlRead($guiBlockMouse) = 1)? True : False	; 1 checked, 4 unchecked
$isBlockKeyboard = (GUICtrlRead($guiBlockKeyboard)=1)? True : False
;~ $isBlockMouse = False
;~ $isBlockKeyboard = False
If GUICtrlRead($idComboBox) = "Others" Then
	$displayName = GUICtrlRead($idInputName)
Else
	$displayName = GUICtrlRead($idComboBox2)
EndIf
$platformName = GUICtrlRead($inputPlatform)
If $displayName = "" Then $displayName = "[Empty]"
If $platformName = "" Then $platformName = "[PlatformEmpty]"
GUISetState(@SW_HIDE)
BlockInitial()
; ================ GUI End ============================


If @OSVersion = "WIN_81" or @OSVersion = "WIN_8" Then

	$ratioDPI = int(RegRead("HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics","AppliedDPI"))/96
Else
	$ratioDPI = 1
EndIf




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
Sleep(2000)
packageData()
UploadData()

UnblockKeyboard()
UnblockMouse()
MsgBox (0,"Compatibility","Files upload finished. Thanks for help!")




Func createTempFolder($logPath = @LocalAppDataDir & "\AutoIt")
	myLog("Create tmpFolder")
	If not FileExists($logPath) Then DirCreate($logPath)
	FileInstall(".\Dbgview.exe" , $logPath & "\Dbgview.exe",0)
	myLog("OS = " & @OSVersion )
	myLog("DPI Ratio =" & $ratioDPI)
EndFunc

Func getDxlog()
	myLog("Get DxLog")
 	Run('"' & @SystemDir & '\dxdiag"  /dontskip /t dxdiag_output.txt', $logPath, @SW_HIDE)
EndFunc

Func launchDBG()
	myLog("launch DBG")
	RegWrite("HKEY_CURRENT_USER\Software\Sysinternals\DbgView", "EulaAccepted", "REG_DWORD", 1)
	Run('"' & $logPath & '\dbgview" /t /l "' & $logPath &'\U_Dbgview_' & $UID & '.log" /p' , "", @SW_HIDE)
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
	Run('"' & @AppDataCommonDir & '\Cyberlink\U\U.exe"',"",@SW_HIDE)
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
		MyLog("pos = " & $posU[0] & "," & $posU[1] & " / color = " & $_exitColor &@CRLF )
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
		MyLog("sign in already")
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
		$tmp = ClipGet()
		ToolTip("ID = " & $meetingID,0,0)
		While $meetingID <> ClipGet()
			ClipPut($meetingID)
			sleep(200)
		WEnd
		UnblockKeyboard()
		sleep(1000)
		Send("^v")
		ClipPut($tmp)
		sleep(1000)
		BlockKeyboard()
		_MouseMove($posU[0] + Floor($posU[2]/2)  , $posU[1] + 225 ,5)
		_MouseClick("Left")
		Sleep(1000)
		send("^a" & @ComputerName)
		_MouseMove($posU[0] + Floor($posU[2]/2) +50  , $posU[1] + 300 ,5)
		_MouseClick("Left")

	EndIf
	$hMeeting = WinWait("[CLASS:CLMeetingsMainWindow]" , "" , 10)
	sleep(1000)
	WinSetState ($hMeeting,"",@SW_RESTORE)
	sleep(1000)
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

	;Meeting - recording
	$_color = 0
	UnblockKeyboard()
	Sleep(4000)
	Send("{SPACE}")
	Sleep(1000)
	BlockKeyboard()
	myLog("Wait rec button is ready")
	While Not $_color = 0x2A888F
		$_color = hex(_PixelGetColor($posMeeting[0] + $posMeeting[2]/2 +50 , $posMeeting[1] + $posMeeting[3] -60))
		sleep(200)
	WEnd
	myLog("Waiting for recording")
	Do
	_MouseClick("Left" , $posMeeting[0] + $posMeeting[2]/2 +50 , $posMeeting[1] + $posMeeting[3] -40 ,1,5)
	Until _isRecording($hMeeting)

	myLog("Count down 20 sec")
	_countDown(20)
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
	myLog("Waiting for encode task:" & $posMeetingEnc)
	WinSetOnTop($posMeetingEnc,"",1)
	While Not IsArray($_exitColor)
		$hMeetingEnc = WinWait("[TITLE:CyberLink;CLASS:Koan;w:402\h:186]" , "" , 1)
		$hMeetingEnc = IsHWnd($hMeetingEnc)?$hMeetingEnc:WinWait("[TITLE:CyberLink;CLASS:Koan;w:401\h:185]" , "" , 1)
		If IsHWnd($hMeetingEnc) Then $posMeetingEnc = _WinGetPos($hMeetingEnc)

		$_exitColor = _PixelSearch($posMeetingEnc[0]+ 385 , $posMeetingEnc[1]+ 155 , $posMeetingEnc[0]+ 387 , $posMeetingEnc[1]+ 157 , 0x43A5F0)	; prevent to get running process bar
;~ 		sleep(1000)
;~ 		If mod(TimerDiff($_timerEnc),5) = 0 Then
;~ 		$posTemp = MouseGetPos()
;~ 			_MouseMove($posMeetingEnc[0]+ 283 , $posMeetingEnc[1]+ 148 , 0)
;~ 			_MouseMove($posMeetingEnc[0]+ 287 , $posMeetingEnc[1]+ 152, 5)
;~ 			MouseMove($posTemp[0],$posTemp[1])	; do not user _mousemove
;~ 		EndIf


		If TimerDiff($_timerEnc) > 300 * 1000 Then
			myLog("[Error] Encode over 5min!")
			Exit 1
		EndIf
	WEnd
	ConsoleWrite("close encode window" &@CRLF)
	_MouseClick("Left",$_exitColor[0] - 50, $_exitColor[1],1,5)


EndFunc

Func _joinMeetingSignin()
	$_hU = WinActivate("[TITLE:U;CLASS:U]")
	$_posU = _WinGetPos($_hU)
	_MouseClick("Left", $_posU[0] + Floor($_posU[2]/2) -95 , $_posU[1] + 85 , 1, 10)
	_MouseClick("Left", $_posU[0] + Floor($_posU[2]/2) -135 , $_posU[1] + 85 , 1, 20)
	Sleep(1500)
	_MouseClick("Left", $_posU[0] + 40 , $_posU[1] + 280 ,1, 10)
	$_idDialog= WinWait("[CLASS:KOAN MSO DLG;W:400\H:360]","",3)
	ConsoleWrite("$_idDialog=" & $_idDialog &@CRLF)
	myLog("$_idDialog=" & $_idDialog)
	$_posidDialog = _WinGetPos($_idDialog)
	If IsArray($_posidDialog) Then
		ConsoleWrite($_posidDialog[0] + Floor($_posidDialog[2]/2) &":"& $_posidDialog[1] + Floor($_posidDialog[3]/2) - 10 &@CRLF )
		_MouseClick("Left", $_posidDialog[0] + Floor($_posidDialog[2]/2), $_posidDialog[1] + Floor($_posidDialog[3]/2) - 10, 1 , 30 )
		$tmp = ClipGet()
		ToolTip("ID = " & $meetingID,0,0)
		While $tmp = ClipGet()
			ClipPut($meetingID)
		WEnd
		BlockKeyboard()
		sleep(1000)
		Send("^v")
		ClipPut($tmp)
		Sleep(1000)
		UnblockKeyboard()
		_MouseClick("Left", $_posidDialog[0] + Floor($_posidDialog[2]/2) + 50, $_posidDialog[1] + Floor($_posidDialog[3]/2) + 130 , 1,20)
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
	MyLog("Selecting device")
	$timerWaitMeeting = TimerInit()
	$flagMeetingWindow = True
	Do
		$hMeeting = WinWait("[CLASS:CLMeetingsMainWindow]" , "",3)
		WinActivate($hMeeting)
		Sleep(200)
		$posMeeting = _WinGetPos($hMeeting)
		If TimerDiff($timerWaitMeeting) > 20 * 1000 Then
			$flagMeetingWindow = False
			ExitLoop
		EndIf

	Until _PixelGetColor($posMeeting[0] + int($posMeeting[2]/2) , $posMeeting[1] +10) = 0x575757
	If Not $flagMeetingWindow Then
		myLog ("Meeting window error = " & hex(_PixelGetColor(Floor($posMeeting[0] + int($posMeeting[2]/2)) , $posMeeting[1] +10)) &@CRLF)
		_MouseMove(Floor($posMeeting[0] + int($posMeeting[2]/2)) , $posMeeting[1] +10)
		exit 1
	EndIf
	$_timerSearch = TimerInit()
	myLog("Waiting for cam selection Button")
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
	return FileExists( @LocalAppDataDir & '\Cyberlink\U\userinfo.cache')? True : False
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
	FileWriteLine($logPath & "\UCompatibility_" & $UID & '.log', _
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
	sleep(500)
	_Zip_AddFile($Zip,$logPath &'\dxdiag_output.txt')
	ConsoleWrite("zip2"&@CRLF)
	myLog("zip2")
	sleep(500)
	_Zip_AddFile($Zip,$logPath &'\UCompatibility_' & $UID & '.log')
	ConsoleWrite("zip3"&@CRLF)
	myLog("zip3")
	sleep(500)
	_Zip_AddFile($Zip,$logPath &'\ScreenShot_' & $UID & '.jpg')
	ConsoleWrite("zip4"&@CRLF)
	myLog("zip4")
	sleep(500)
	_Zip_AddFile($Zip,$logPath & "\U_Dbgview_" & $UID & ".log")

	$videoList = _FileListToArray(@UserProfileDir & "\Videos\U Meeting Recordings")
	ConsoleWrite("zip5"&@CRLF)
	sleep(500)
	myLog("zip5")
	_Zip_Addfolder($Zip,@UserProfileDir & "\Videos\U Meeting Recordings\" & $videoList[$videoList[0]]& "\", 0)
	ConsoleWrite("zip6"&@CRLF)
	sleep(500)
	myLog("zip6")
	_Zip_Addfolder($Zip,@LocalAppDataDir & "\CyberLink\U\dmp\", 0)
EndFunc



Func UploadData()

	For $i = 1 to 5
		ConsoleWrite("upload now -" & $i)
		myLog("upload now -"  & $i)
		Local $hOpen = _FTP_Open('MyFTP Control')
		Local $hConn = _FTP_Connect($hOpen, "mitilin.mooo.com", "AutoScript" , "123123" ,1 )
		sleep(1000)
		$a = _FTP_FilePut( $hConn, $logPath & '\' &$UID& '.zip', $UID& '.zip' )
		Local $iFtpc = _FTP_Close($hConn)
		Local $iFtpo = _FTP_Close($hOpen)
		If $a = 1 Then ExitLoop
		ToolTip("waiting for 3 sec then retry upload.",0,0)
		myLog("waiting for 3 sec then retry upload.")
		Sleep(3000)
	Next
	$iFileSize = FileGetSize($logPath & '\' &$UID& '.zip')
	ConsoleWrite("Result=" & $a &@CRLF & "error= " & @error &@CRLF)
	myLog("Result=" & $a  & " error= " & @error)
	myLog("update Google excel")
	_HTTP_Post("https://docs.google.com/forms/u/1/d/e/1FAIpQLSf4VLDMkYaU9knZR8jy9NC0ybjd5tx3xqkpag96exxMutf2eA/formResponse", _
	"entry.1767768977=" & urlencode($displayName) & _
	"&entry.1475700249=" & urlencode(@ComputerName) & _
	"&entry.1418934191=" & urlencode($UID) & _
	"&entry.992188141=" & urlencode(($a=1)? True : False) & _
	"&entry.192209300=" & urlencode($iFileSize) & _
	"&entry.717725288=" & urlencode(Int(TimerDiff($timerRunTime)/1000)) & _
	"&entry.786528118=" & urlencode($platformName)  _
	)
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
	UnblockMouse()
	;MouseMove( int($_x / $ratioDPI), int($_y /$ratioDPI ), $_speed)
	MouseMove( $_x , $_y , $_speed)
	BlockMouse()
EndFunc

Func _MouseClick($_btn,$_x="xx",$_y = "yy",$_clicks = 1,$_spd = 10)
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

Func _KeyProc($nCode, $wParam, $lParam)
    If $nCode < 0 Then Return _WinAPI_CallNextHookEx($hHookKeyboard, $nCode, $wParam, $lParam)

    Local $KBDLLHOOKSTRUCT = DllStructCreate("dword vkCode;dword scanCode;dword flags;dword time;ptr dwExtraInfo", $lParam)
    Local $vkCode = DllStructGetData($KBDLLHOOKSTRUCT, "vkCode")
	myLog("keyboard proc = " & $vkCode & @CRLF)
;~     If $vkCode <> 0x77 Then Return 1 ; 77 = F8
;~ 	If $vkCode <> 0x1B Then Terminate() ; 0x1B = esc
;~     _WinAPI_CallNextHookEx($hHookKeyboard, $nCode, $wParam, $lParam)
	Switch $vkCode
		Case 0x1B
			_WinAPI_CallNextHookEx($hHookKeyboard, $nCode, $wParam, $lParam)
		Case 0x77
			UnblockKeyboard()
			$isBlockKeyboard = False
			Return 1
		Case Else
			Return 1
	EndSwitch



EndFunc
Func _isRecording($_hMeeting)
	$_posMeeting = WinGetPos($_hMeeting)
	_mousemove($_posMeeting[0] + Floor($_posMeeting[2]/2) , $_posMeeting[1] + $_posMeeting[3] - 40)
	_mousemove($_posMeeting[0] + Floor($_posMeeting[2]/2) + 50 , $_posMeeting[1] + $_posMeeting[3] - 40 , 15)
	Sleep(1000)
	$_color = _PixelGetColor($_posMeeting[0] + Floor($_posMeeting[2]/2) + 30 , $_posMeeting[1] + $_posMeeting[3] - 40)
	$col = _ColorGetRGB($_color)
	ConsoleWrite("Rec Button =" & hex($col) &@CRLF)
	If $col[0]-0x98 < 0x03 And $col[1]-0x1c < 0x03 And $col[2]-0x3D < 0x03 Then
		Return True
	Else
		Return	False
	EndIf
EndFunc

Func _Mouse_Handler($nCode, $wParam, $lParam)
    If $nCode < 0 Then Return _WinAPI_CallNextHookEx($hHookMouse, $nCode, $wParam, $lParam)

    Return 1
EndFunc


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
	ProcessClose($dbgView)

EndFunc

