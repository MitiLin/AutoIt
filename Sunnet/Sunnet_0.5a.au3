#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=favicon.ico
#AutoIt3Wrapper_Res_Fileversion=0.6.0.0
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
$privacy = IniRead($dataPath, "data", "privacy", "Yes")
$HostWatermark = IniRead($dataPath, "data", "HostWatermark", "Yes")
$position = IniRead($dataPath, "data", "position", "Top_Right")
$SSO = IniRead($dataPath, "data", "sso", "")
$join = IniRead($dataPath, "data", "join", "")
$startTime = @YEAR &"-"& @MON &"-"& @MDAY &"T"& @HOUR &":"& @MIN &":"& @SEC &"+08"
$endTime = @YEAR &"-"& @MON &"-"& @MDAY &"T"& @HOUR+1 &":"& @MIN &":"& @SEC &"+08"

$apiKey_b = "BI2AYWBI5SXNK3T4ZXXH"
$apiSecret_b = "VvFDnav2BDyTzXnekedSUM9fu3jKpYbSt2tdtnYy"
$apiKey_p = "NVE9VUYLN90L2OIADRMP"
$apiSecret_p = "zoTpN44AIWP014dWEYVro2kvpf3EHurGNkIhnGh5"
$apiKey =  $apiKey_b
$apiSecret = $apiSecret_b

GUICreate("Sunnet Project URL Creater v0.6", 550, 330, @DesktopWidth / 2 - 275, @DesktopHeight / 2 - 165)
GUICtrlCreateLabel("Account", 30, 23, 70, 20)
$inputAccount = GUICtrlCreateInput($account, 100, 20, 320, 20)
$ComboServer = GUICtrlCreateCombo("Beta", 440, 20, 90, 20)
GUICtrlSetData($ComboServer,"Production",$server)


;~ password is unneceaasry
;~ GUICtrlCreateLabel("Password", 20, 53, 70, 20)
;~ $inputPassword = GUICtrlCreateInput($password, 100, 50, 300, 20, 0x0820)

; ------------ host --------------
GUICtrlCreateGroup("=Host=", 10,43, 530, 110)

GUICtrlCreateLabel("Title", 30, 63, 70, 20)
$inputTitle = GUICtrlCreateInput($title, 100, 60, 320, 20)

GUICtrlCreateLabel("Description", 30, 93, 70, 20)
$inputDescription = GUICtrlCreateInput($description, 100, 90, 320, 20)

GUICtrlCreateLabel("Privacy", 20, 123, 70, 20)
$ComboPrivacy = GUICtrlCreateCombo("Yes", 60, 120, 45, 20)
GUICtrlSetData($ComboPrivacy,"No",$privacy)

GUICtrlCreateLabel("Watermark", 115, 123, 70, 20)
$ComboHostWatermark = GUICtrlCreateCombo("Yes", 170, 120, 45, 20)
GUICtrlSetData($ComboHostWatermark,"No",$HostWatermark)

GUICtrlCreateLabel("Position", 230, 123, 70, 20)
$ComboPosition = GUICtrlCreateCombo($position, 270, 120, 95, 20)
GUICtrlSetData($ComboPosition,"Top_Left|Bottom_Right|Bottom_Left","T_Right")

GUICtrlCreateLabel("Start", 375, 123, 50, 20)
$inputStartTime = GUICtrlCreateInput($startTime, 400, 120, 130, 20 , 0x0880)

; ----------- viewer -----------
GUICtrlCreateGroup("=Viewer=", 10,153, 530, 140)

GUICtrlCreateLabel("Watermark", 30, 173, 70, 20)
$inputWatermark = GUICtrlCreateInput($watermark, 100, 170, 320, 20)


GUICtrlCreateLabel("Display Name", 30, 203, 70, 20)
$inputDisplayname = GUICtrlCreateInput($displayName, 100, 200, 320, 20)


GUICtrlCreateLabel("SSO link", 30, 233, 70, 20)
$inputSSO = GUICtrlCreateInput("", 100, 230, 320, 20, 0x0880)
GUICtrlSetBkColor(-1, 0xD0D0D0)

$Btn_copySSO = GUICtrlCreateButton("copy", 430, 230, 50, 20)


GUICtrlCreateLabel("Join link", 30, 263, 70, 20)
$inputJoin = GUICtrlCreateInput("", 100, 260, 320, 20, 0x0880)
GUICtrlSetBkColor(-1, 0xD0D0D0)

$Btn_copyJoin = GUICtrlCreateButton("copy", 430, 260, 50, 20)

$Btn_Start = GUICtrlCreateButton("Get Join URL", 230, 295, 100, 30)
$Label_Status = GUICtrlCreateLabel("", 30, 303, 200, 20)


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
			$privacy = GUICtrlRead($ComboPrivacy)
			$HostWatermark = GUICtrlRead($ComboHostWatermark)
			$position = GUICtrlRead($ComboPosition)
			$server = GUICtrlRead($ComboServer)
			if $server = "Beta" Then
				$apiKey = $apiKey_b
				$apiSecret = $apiSecret_b
			Else
				$apiKey = $apiKey_p
				$apiSecret = $apiSecret_p
			EndIf
			SetSever($server)

			GUICtrlSetData($Label_Status, "Geting token")
			ConsoleWrite("apikey=" & $apiKey & @TAB & "api secret=" & $apiSecret & @CRLF)
			$returnGrantToken = GrantToken($apiKey, $apiSecret, $account)
			;ConsoleWrite("$returnGrantToken = " & $returnGrantToken&@CRLF)
			$token = JsonGet($returnGrantToken, "token")
			ConsoleWrite("$token = " & $token & @CRLF)

			GUICtrlSetData($Label_Status, "Scheduling Webinar")
			ConsoleWrite('{"position:' & $watermarkPosition & '}' &@CRLF)
			$returnScheduleWebinar = ScheduleWebinar($token, $title, $description, $startTime, $endTime, $privacy = "Yes"?1:0, "CST", $HostWatermark="Yes"?"true":"false", $HostWatermark="Yes"?'{position:' & $watermarkPosition & '}':"")
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
			$returnJoinWebinar = JoinWebinar($token,$liveId, $watermark, $displayname)
			;ConsoleWrite("$returnJoinWebinar = " & $returnJoinWebinar)
			$join = JsonGet($returnJoinWebinar, "url")
			ConsoleWrite("$join = " & $join & @CRLF)
			GUICtrlSetData($inputJoin, $join)

			If $join = "Validation failed" Then
				GUICtrlSetData($Label_Status, "liveId = "& $liveId)
			Else
				GUICtrlSetData($Label_Status, "Done! Join link only available in 30 min.")
			EndIf
			ConsoleWrite(QueryWebinar($token,$liveId)&@CRLF)
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
				Case "Top_Right"
					$watermarkPosition = "TOP_RIGHT"
				Case "Top_Left"
					$watermarkPosition = "TOP_LEFT"
				Case "Bottom_Right"
					$watermarkPosition = "BOTTOM_RIGHT"
				Case "Bottom_Left"
					$watermarkPosition = "BOTTOM_LEFT"
			EndSwitch
			GUICtrlSetData($Label_Status, "Watermark position is " & $watermarkPosition & ".")
		Case $ComboPrivacy
			$privacy = GUICtrlRead($ComboPrivacy)
			If $privacy = "No" Then
				GUICtrlSetState($ComboHostWatermark, 128)
				GUICtrlSetState($ComboPosition, 128)
				GUICtrlSetData($ComboHostWatermark,"No")
			Else
				GUICtrlSetState($ComboHostWatermark,64)
				If $HostWatermark = "No" Then
					GUICtrlSetState($ComboPosition, 128)
				Else
					GUICtrlSetState($ComboPosition, 64)
				EndIf
			EndIf
			GUICtrlSetData($Label_Status, "Privacy is " & $privacy & ".")
		Case $ComboHostWatermark
			$HostWatermark = GUICtrlRead($ComboHostWatermark)
			If $HostWatermark = "No" Then
				GUICtrlSetState($ComboPosition, 128)
			Else
				GUICtrlSetState($ComboPosition, 64)
			EndIf
			GUICtrlSetData($Label_Status, "Watermark is " & $HostWatermark & ".")
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

