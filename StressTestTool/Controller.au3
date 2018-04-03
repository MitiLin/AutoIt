#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GUIConstantsEx.au3>
#include <inet.au3>



DirCreate ( @AppDataDir & "\AutoIt" )
FileInstall ( ".\PsExec.exe", @AppDataDir & "\AutoIt\PsExec.exe" )
FileInstall ( ".\Receiver.exe", @AppDataDir & "\AutoIt\Reveiver.exe" )
$exeFile = @AppDataDir & "\AutoIt\Receiver.exe"
$iniList = IniReadSection("list.ini", "Server")
$iniAccount =  IniReadSection("list.ini", "Account")
; ConsoleWrite("list number = " $iniList[0][0]&@CRLF)

dim $client[$iniList[0][0]+1][6] ; UI controler
dim $cmdPid[$iniList[0][0]+1] ; cmdPid
local $publicIP = _GetPublicIP()

$mainControler = GUICreate ("Controller", 1200, $iniList[0][0] * 22 + 80)

; Caption bar
$cbox_all = GUICtrlCreateCheckbox("all" , 10, 10 , 50 , 22)
$lab_name = GUICtrlCreatelabel("Client Name" , 60, 15 , 60 , 22)
$lab_alive = GUICtrlCreatelabel("Alive" , 220, 15 , 60 , 22)
$lab_downloadbps = GUICtrlCreatelabel("Download k Byte/s" , 320, 15 , 100 , 22)
$lab_Responds = GUICtrlCreatelabel("Responds" , 520, 15 , 100 , 22)

; Items
for $i = 1 to $iniList[0][0]
	$client[$i][1] = GUICtrlCreateCheckbox( $iniList[$i][1] , 10, 12+ $i*22 ,200,22)
	$client[$i][2] = GUICtrlCreateCheckbox( "" , 220, 12+ $i*22 ,15,15,0x5)
	$client[$i][3] = GUICtrlCreateLabel( "DL" , 350, 12+ $i*22 ,200,22)
	$client[$i][4] = GUICtrlCreateLabel( "Pending" , 500, 12+ $i*22 ,300,22)
Next


; bottom items
$btn_Execute = GUICtrlCreateButton ("Start Receivers" , 10 , $iniList[0][0] * 22 + 40 ,100 , 30)
$txt_SessionId = GUICtrlCreateInput ("1", 110 , $iniList[0][0] * 22 + 45 , 20, 20, -1,	0x0001)
$btn_Network = GUICtrlCreateButton ("Get network status" , 130 , $iniList[0][0] * 22 + 40 ,100 , 30)
$btn_Start = GUICtrlCreateButton ("Start Download" , 230 , $iniList[0][0] * 22 + 40 ,100 , 30 )
$txt_LiveId = GUICtrlCreateInput ("", 330 , $iniList[0][0] * 22 + 45 , 200, 20, -1,	0x0001)
$btn_Stop = GUICtrlCreateButton ("Stop Download" , 630 , $iniList[0][0] * 22 + 40 ,100 , 30)
GUISetState()


; == Setup TCP
TCPStartup()
OnAutoItExitRegister("OnAutoItExit")
Local $sIPAddress = @IPAddress1	; This IP Address only works for testing on your own computer.; 111.248.196.86
Local $iPort = 80 ; Port used for the connection.
Local $iListenSocket = TCPListen($sIPAddress, $iPort, 1000)
Local $iError = 0
Local $sReceived = ""
If @error Then
	; Someone is probably already listening on this IP Address and Port (script already running?).
	$iError = @error
	MsgBox(BitOR($MB_SYSTEMMODAL, $MB_ICONHAND), "", "Server:" & @CRLF & "Could not listen, Error code: " & $iError)
	Exit
EndIf
; Assign a Local variable to be used by the Client socket.
Local $iSocket = 0
;== setup TCP
While 1
	$iSocket = TCPAccept($iListenSocket)
	; If an error occurred display the error code and return False.
	If @error Then
		$iError = @error
		MsgBox(BitOR($MB_SYSTEMMODAL, $MB_ICONHAND), "", "Server:" & @CRLF & "Could not accept the incoming connection, Error code: " & $iError)

	EndIf

	If $iSocket <> -1 Then
		;TCPCloseSocket($iListenSocket)
		$sReceived = TCPRecv($iSocket, 100)
		TCPCloseSocket($iSocket)
		ConsoleWrite("iSocket= " & $iSocket & @tab & "Receive = " & $sReceived & @CRLF)
		local $command = StringSplit($sReceived,"//",1) ; [0]para number [1] IP [2] command [3] para
		If $command[0] < 3 Then
			Break
		EndIf
		$command[0] = IPtoIndex($command[1],$iniList) ; [0]index [1] IP [2] command [3] para
		ConsoleWrite("command2=" & $command[2] &"command0=" & $command[0] &@CRLF)
		GUICtrlSetData($client[$command[0]][4],$command[2])
		GUICtrlSetState($client[$command[0]][2],1)
		Switch $command[2]
			Case "Responds"
				GUICtrlSetData($client[$command[0]][4],$command[3])
			Case "Bandwidth"
				GUICtrlSetData($client[$command[0]][3],$command[3])
		EndSwitch

	EndIf



	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE

			ExitLoop

		case $cbox_all
			;ConsoleWrite("Staus=" & GUICtrlRead($cbox_all)  &@CRLF)
			for $i = 1 to $iniList[0][0]
				GUICtrlSetState($client[$i][1], GUICtrlRead($cbox_all))
			Next
		case $btn_Execute
			GUICtrlSetState($btn_Execute,128)
			for $i = 1 to $iniList[0][0]
				If GUICtrlRead($client[$i][1]) = 1 Then
					$cmdPid[$i] = Run(@ComSpec & " /c " & @AppDataDir & '\AutoIt\PsExec.exe \\' & $iniList[$i][1] & " -u "&$iniAccount[1][0]&" -p "&$iniAccount[1][1]&" -d -i " & GUICtrlRead($txt_SessionId) &" -f -c " & $exeFile & " " & $publicIP & " 80" , "", @SW_HIDE)
					GUICtrlSetData($client[$i][4], "Connecting to client")
;~ 				    Local $t_ExitCode = DllStructCreate("int")
;~ 					Local $avRET = DllCall("kernel32.dll", "int", "GetExitCodeProcess", "ptr", $cmdPid, "ptr", DllStructGetPtr($t_ExitCode))
					ConsoleWrite(@AppDataDir & '\AutoIt\PsExec.exe \\' & $iniList[$i][1] & " -u miti -p 123123 -d -i " & GUICtrlRead($txt_SessionId) &" -f -c " & $exeFile & " " & $publicIP & " 80"  &@CRLF)
				EndIf
			Next
			GUICtrlSetState($btn_Execute,64)


	EndSwitch

WEnd

 TCPCloseSocket($iListenSocket)


Func OnAutoItExit()
    TCPShutdown() ; Close the TCP service.
EndFunc   ;==>OnAutoItExit

Func _GetPublicIP()
	Local Const $GETIP_TIMER = 300000 ; Constant for how many milliseconds between each check. This is 5 minutes.
	Local Static $hTimer = 0 ; Create a static variable to store the timer handle.
	Local Static $sLastIP = 0 ; Create a static variable to store the last IP.

	If TimerDiff($hTimer) < $GETIP_TIMER And Not $sLastIP Then ; If still in the timer and $sLastIP contains a value.
		Return SetExtended(1, $sLastIP) ; Return the last IP instead and set @extended to 1.
	EndIf

	#cs
		Additional list of possible IP disovery sites by z3r0c00l12.
		http://corz.org/ip
		http://icanhazip.com
		http://ip.appspot.com
		http://ip.eprci.net/text
		http://ip.jsontest.com/
		http://services.packetizer.com/ipaddress/?f=text
		http://whatthehellismyip.com/?ipraw
		http://wtfismyip.com/text
		http://www.networksecuritytoolkit.org/nst/tools/ip.php
		http://www.telize.com/ip
		http://www.trackip.net/ip
	#ce
	Local $aGetIPURL[] = ["http://http://www.whatismyip.com.tw/"], _
			$aReturn = 0, _
			$sReturn = ""

	For $i = 0 To UBound($aGetIPURL) - 1
		$sReturn = InetRead($aGetIPURL[$i])
		If @error Or $sReturn == "" Then ContinueLoop
		$aReturn = StringRegExp(BinaryToString($sReturn), "((?:\d{1,3}\.){3}\d{1,3})", $STR_REGEXPARRAYGLOBALMATCH) ; [\d\.]{7,15}
		If @error = 0 Then
			$sReturn = $aReturn[0]
			ExitLoop
		EndIf
		$sReturn = ""
	Next

	$hTimer = TimerInit() ; Create a new timer handle.
	$sLastIP = $sReturn ; Store this IP.
	If $sReturn == "" Then Return SetError(1, 0, -1)
	Return $sReturn
EndFunc


Func IPtoIndex($str, $List)
	if not IsArray($List) Then return -1
	$sSplit = StringSplit($str,".")
	$_str = $sSplit[1] &"-"& $sSplit[2] &"-"&$sSplit[3] &"-"&$sSplit[4]
	for $i = 1 to $List[0][0] 	; search 1-2-3-4
		if StringInStr( $List[$i][1], $_str , 0) Then return $i
	Next
	for $i = 1 to $List[0][0]	; search 1.2.3.4
		if StringInStr( $List[$i][1], $str , 0) Then return $i
	Next
	return 0
EndFunc
