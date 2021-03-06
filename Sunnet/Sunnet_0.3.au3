#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=favicon.ico
#AutoIt3Wrapper_Res_Fileversion=0.3.0.0
#AutoIt3Wrapper_Res_Language=1028
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIConstantsEx.au3>
#include <File.au3>
#include <Encode.au3>
#include <SunnetAPI.au3>

OnAutoItExitRegister("WriteIni")


$dataPath = @AppDataDir & "\AutoitSunnet\data.ini"
If Not FileExists(@AppDataDir & "\AutoitSunnet\") Then DirCreate(@AppDataDir & "\AutoitSunnet\")
If Not FileExists($dataPath) Then FileClose(FileOpen ( $dataPath,34 ))

$account = IniRead($dataPath, "data", "account", "")
$password = IniRead($dataPath, "data", "password", "")
$password = PWout($password)
;$title = IniRead($dataPath, "data", "title", "Auto-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN)
;$description = IniRead($dataPath, "data", "description", "Genarated by Autoit")
$title =  "Sunnet Project " & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN
$description = "Genarated by Autoit"
$watermark = IniRead($dataPath, "data", "watermark", "訊連浮水印")
Global $watermarkPosition = "TOP_RIGHT"
$displayName = IniRead($dataPath, "data", "display", "AutoIt機器人🌸")
$server = IniRead($dataPath, "data", "server", "Beta")
$SSO = IniRead($dataPath, "data", "sso", "")
$join = IniRead($dataPath, "data", "join", "")
$apiKey_b = "BI2AYWBI5SXNK3T4ZXXH"
$apiSecret_b = "VvFDnav2BDyTzXnekedSUM9fu3jKpYbSt2tdtnYy"
$apiKey_p = "NVE9VUYLN90L2OIADRMP"
$apiSecret_p = "zoTpN44AIWP014dWEYVro2kvpf3EHurGNkIhnGh5"
$apiKey =  $apiKey_b
$apiSecret = $apiSecret_b

GUICreate("Sunnet Project URL Creater v0.3", 550, 330, @DesktopWidth / 2 - 275, @DesktopHeight / 2 - 165)
GUICtrlCreateLabel("Account", 20, 23, 70, 20)
$inputAccount = GUICtrlCreateInput($account, 100, 20, 270, 20)
$ComboServer = GUICtrlCreateCombo($server, 380, 20, 50, 20)
GUICtrlSetData($ComboServer,"Prod","Beta")

;~ password is unneceaasry
;~ GUICtrlCreateLabel("Password", 20, 53, 70, 20)
;~ $inputPassword = GUICtrlCreateInput($password, 100, 50, 300, 20, 0x0820)
GUICtrlCreateGroup("Host", 20, 53, 400, 240)

GUICtrlCreateLabel("Title", 20, 83, 70, 20)
$inputTitle = GUICtrlCreateInput($title, 100, 80, 300, 20)

GUICtrlCreateLabel("Description", 20, 113, 70, 20)
$inputDescription = GUICtrlCreateInput($description, 100, 110, 300, 20)

GUICtrlCreateLabel("Watermark", 20, 143, 70, 20)
$inputWatermark = GUICtrlCreateInput($watermark, 100, 140, 250, 20)
$ComboPosition = GUICtrlCreateCombo("T_Right", 360, 140, 70, 20)
GUICtrlSetData($ComboPosition,"T_Left|B_Right|B_Left","T_Right")

GUICtrlCreateLabel("Display Name", 20, 173, 70, 20)
$inputDisplayname = GUICtrlCreateInput($displayName, 100, 170, 300, 20)


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


GUISetState(@SW_SHOW)
While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $Btn_Start
			GUICtrlSetState($Btn_Start, 128)
			GUICtrlSetData($Label_Status, "Start!")

			$account = GUICtrlRead($inputAccount)
;~ 			$password = GUICtrlRead($inputPassword)
			$title = GUICtrlRead($inputTitle)
			$description = GUICtrlRead($inputDescription)
			$watermark = GUICtrlRead($inputWatermark)
			$displayname = GUICtrlRead($inputDisplayname)

			GUICtrlSetData($Label_Status, "Geting token")
			$returnGrantToken = GrantToken($apiKey, $apiSecret, $account)
			;ConsoleWrite("$returnGrantToken = " & $returnGrantToken&@CRLF)
			$token = JsonGet($returnGrantToken, "token")
			ConsoleWrite("$token = " & $token & @CRLF)

			GUICtrlSetData($Label_Status, "Scheduling Webinar")
			ConsoleWrite('{"position:' & $watermarkPosition & '}' &@CRLF)
			$returnScheduleWebinar = ScheduleWebinar($token, $title, $description, "2018-03-7T12:00:00Z", "2018-03-8T12:00:00Z", 1, "CST", "true", '{position:' & $watermarkPosition & '}')
			;ConsoleWrite("$returnScheduleWebinar = " & $returnScheduleWebinar &@CRLF)
			$liveId = JsonGet($returnScheduleWebinar, "id")
			ConsoleWrite("$liveId = " & $liveId & @CRLF)

			GUICtrlSetData($Label_Status, "Getting SSO deeplink")
			$returnStartWebinar = StartWebinar($token, $liveId)
			;ConsoleWrite("$returnStartWebinar = " & $returnStartWebinar &@CRLF)
			$SSO = JsonGet($returnStartWebinar, "url")
			ConsoleWrite("$SSO = " & $SSO & @CRLF)
			GUICtrlSetData($inputSSO, $SSO)

			GUICtrlSetData($Label_Status, "Getting join link")
			ConsoleWrite("STARTliveId = " & $liveId & @CRLF &"STARTwater=" &$watermark &@CRLF& "STARTname=" &$displayname)
			$returnJoinWebinar = JoinWebinar($liveId, $watermark, $displayname)
			;ConsoleWrite("$returnJoinWebinar = " & $returnJoinWebinar)
			$join = JsonGet($returnJoinWebinar, "url")
			ConsoleWrite("$join = " & $join & @CRLF)
			GUICtrlSetData($inputJoin, $join)

			If $join = "Validation failed" Then
				GUICtrlSetData($Label_Status, "liveId = "& $liveId)
			Else
				GUICtrlSetData($Label_Status, "Done! Join link only available in 30 min.")
			EndIf
			GUICtrlSetState($Btn_Start, 64)

		Case $Btn_copySSO
			ClipPut(GUICtrlread($inputSSO))
			GUICtrlSetData($Label_Status, "Copy SSO deeplink to clipboard!")
		Case $Btn_copyJoin
			ClipPut(GUIctrlread($inputJoin))
			GUICtrlSetData($Label_Status, "Copy Webianr join link to clipboard!")
		Case $ComboServer
			$server = GUICtrlRead($ComboServer)
			if $server = "Beta" Then
				$apiKey = $apiKey_b
				$apiSecret = $apiSecret_b
			Else
				$apiKey = $apiKey_p
				$apiSecret = $apiSecret_p
			EndIf
			SetSever($server)
			GUICtrlSetData($Label_Status, "Change server to " & $server & ".")
		Case $ComboPosition
			$position = GUICtrlRead($ComboPosition)
			Switch  $position
				Case "T_Right"
					$watermarkPosition = "TOP_RIGHT"
				Case "T_Left"
					$watermarkPosition = "TOP_LEFT"
				Case "B_Right"
					$watermarkPosition = "BOTTOM_RIGHT"
				Case "B_Left"
					$watermarkPosition = "BOTTOM_LEFT"
			EndSwitch
			GUICtrlSetData($Label_Status, "Watermark position is " & $watermarkPosition & ".")
	EndSwitch
WEnd


Func WriteIni()
	$account = IniWrite($dataPath, "data", "account", $account)
	$password = PWin($password)
	$password = IniWrite($dataPath, "data", "password", $password)
	$title = IniWrite($dataPath, "data", "title", $title)
	$description = IniWrite($dataPath, "data", "description", $description)
	$watermark = IniWrite($dataPath, "data", "watermark", $watermark)
	$displayName = IniWrite($dataPath, "data", "display", $displayName)
	$server = IniWrite($dataPath, "data", "server", $server)
EndFunc   ;==>WriteIni


Func JsonGet($source, $key)
	$a = StringTrimLeft($source, StringInStr($source, $key))
	$a = StringTrimLeft($a, StringInStr($a, '"'))
	$a = StringTrimLeft($a, StringInStr($a, ':'))
	If StringInStr($a, '"') = 0 Then
		$a = StringTrimRight($a, StringLen($a) - StringInStr($a, '}') + 1)
	Else
		$a = StringTrimLeft($a, StringInStr($a, '"'))
		$a = StringTrimRight($a, StringLen($a) - StringInStr($a, '"') + 1)
	EndIf
	Return $a
EndFunc   ;==>JsonGet
