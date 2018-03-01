
#include <GUIConstantsEx.au3>
#include <File.au3>
#include <Encode.au3>
#include <SunnetAPI.au3>

OnAutoItExitRegister("WriteIni")


$dataPath = @AppDataDir & "\AutoitSunnet\data.ini"
If Not FileExists($dataPath) Then _FileCreate($dataPath)

$account = IniRead ( $dataPath, "data", "account", "" )
$password = IniRead ( $dataPath, "data", "password", "" )
$password = PWout($password)
$title = IniRead ( $dataPath, "data", "title", "Auto-" &@mon &"-"&@MDAY &" "& @HOUR&":"&@MIN )
$description = IniRead ( $dataPath, "data", "description", "Genarated by Autoit" )
$watermark = IniRead ( $dataPath, "data", "watermark", "訊連浮水印" )
$displayName = IniRead ( $dataPath, "data", "display", "機器人🌸" )
$SSO = IniRead ( $dataPath, "data", "sso", "" )
$join = IniRead ( $dataPath, "data", "join", "" )


GUICreate("Sunnet Project URL Creater v0.1",440,330,@DesktopWidth/2 - 200,@DesktopHeight/2 - 150)
GUICtrlCreateLabel("Account",20,23,70,20)
$inputAccount = GUICtrlCreateInput($account,100,20,300,20)

GUICtrlCreateLabel("Password",20,53,70,20)
$inputPassword = GUICtrlCreateInput($password,100,50,300,20,0x0020)

GUICtrlCreateLabel("Title",20,83,70,20)
$inputTitle = GUICtrlCreateInput($title,100,80,300,20)

GUICtrlCreateLabel("Description",20,113,70,20)
$inputDescription = GUICtrlCreateInput($description,100,110,300,20)

GUICtrlCreateLabel("Watermark",20,143,70,20)
$inputWatermark = GUICtrlCreateInput($watermark,100,140,300,20)

GUICtrlCreateLabel("Display Name",20,173,70,20)
$inputDisplayname = GUICtrlCreateInput($displayName,100,170,300,20)


GUICtrlCreateLabel("SSO link",20,203,70,20)
$inputSSO = GUICtrlCreateInput("",100,200,300,20,0x0880)
GUICtrlSetBkColor(-1, 0xD0D0D0)


GUICtrlCreateLabel("Join link",20,233,70,20)
$inputJoin = GUICtrlCreateInput("",120,230,300,20,0x0880)
GUICtrlSetBkColor(-1, 0xD0D0D0)

$Btn_Start = GUICtrlCreateButton("Get Join URL", 150 , 265, 100,30 )
$Label_Status = GUICtrlCreateLabel("",20,303,300,20)


GUISetState(@SW_SHOW)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $Btn_Start
				GUICtrlSetState($Btn_Start,128)
				GUICtrlSetData($Label_Status, "Start!")

				$account = GUICtrlRead($inputAccount)
				$password = GUICtrlRead($inputPassword)
				$title = GUICtrlRead($inputTitle)
				$description = GUICtrlRead($inputDescription)
				$inputWatermark = GUICtrlRead($watermark)
				$inputDisplayname = GUICtrlRead($displayName)

				GUICtrlSetData($Label_Status, "Geting token")
				$returnGrantToken = GrantToken("E0DJ73GS0IOKOFU3TFH0","jom5PSKg0JfvOd5lU8g8SjnMOTeMNSlsMwVwjXyQ",$account)
				;ConsoleWrite("$returnGrantToken = " & $returnGrantToken&@CRLF)
				$token = JsonGet($returnGrantToken , "token")
				ConsoleWrite("$token = " & $token&@CRLF)

				GUICtrlSetData($Label_Status, "Scheduling Webinar")
				$returnScheduleWebinar = ScheduleWebinar($token,$title,$description,"2018-03-1T12:00:00Z","2018-03-2T12:00:00Z",1,"CST","true")
				;ConsoleWrite("$returnScheduleWebinar = " & $returnScheduleWebinar &@CRLF)
				$liveId = JsonGet($returnScheduleWebinar,"id")
				ConsoleWrite("$liveId = " & $liveId&@CRLF)

				GUICtrlSetData($Label_Status, "Getting SSO deeplink")
				$returnStartWebinar = StartWebinar($token, $liveId)
				;ConsoleWrite("$returnStartWebinar = " & $returnStartWebinar &@CRLF)
				$SSO = JsonGet($returnStartWebinar , "url")
				ConsoleWrite("$SSO = " & $SSO&@CRLF)
				GUICtrlSetData($inputSSO, $SSO)

				GUICtrlSetData($Label_Status, "Getting join link")
				$returnJoinWebinar = JoinWebinar($liveId,$watermark,$displayName &@CRLF)
				;ConsoleWrite("$returnJoinWebinar = " & $returnJoinWebinar)
				$join = JsonGet($returnJoinWebinar , "url")
				ConsoleWrite("$join = " & $join&@CRLF)
				GUICtrlSetData($inputJoin, $join)

				GUICtrlSetData($Label_Status, "Done! Join link only available in 60 sec.")
				GUICtrlSetState($Btn_Start,64)
	EndSwitch
WEnd


Func WriteIni()
	$account = IniWrite ( $dataPath, "data", "account", $account )
	$password = PWin($password)
	$password = IniWrite ( $dataPath, "data", "password",$password )
	$title = IniWrite ( $dataPath, "data", "title", $title )
	$description = IniWrite ( $dataPath, "data", "description", $description )
	$watermark = IniWrite ( $dataPath, "data", "watermark", $watermark )
	$displayName = IniWrite ( $dataPath, "data", "display", $displayName )
EndFunc


Func JsonGet($source, $key)
	$a = StringTrimLeft($source,StringInStr($source,$key))
	$a = StringTrimLeft($a,StringInStr($a,'"'))
	$a = StringTrimLeft($a,StringInStr($a,':'))
	If StringInStr($a,'"') = 0 Then
		$a = StringTrimRight($a,StringLen($a) - StringInStr($a,'}')+1)
	Else
		$a = StringTrimLeft($a,StringInStr($a,'"'))
		$a = StringTrimRight($a,StringLen($a) - StringInStr($a,'"')+1)
	EndIf
	return $a
EndFunc
