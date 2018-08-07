#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

$_webinarAPI = "https://howsmyssl.com/a/check"
$apiKey_b = "BI2AYWBI5SXNK3T4ZXXH"
$apiSecret_b = "VvFDnav2BDyTzXnekedSUM9fu3jKpYbSt2tdtnYy"
Func _HTTP_Post($url, $postdata = '')
	Local $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("GET", $url, False)
	If (@error) Then Return SetError(1, 0, 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	$oHTTP.Send($postdata)
	If (@error) Then Return SetError(2, 0, 0)
	$sReceived = $oHTTP.ResponseText
	$iStatus = $oHTTP.Status
	If $iStatus = 200 Then
		Return $sReceived
	Else
		Return SetError(3, $iStatus, $sReceived)
	EndIf
EndFunc   ;==>_HTTP_Post

Func GrantToken($_appKey, $_appSecret, $_email)
	;$_email = StringReplace($_email,"+","%2B")	; handle + case
	ConsoleWrite("appKey=" & $_appKey & " appSecret=" & $_appSecret & " email=" & urlencode($_email) &@CRLF)
	Return _HTTP_Post($_webinarAPI & "api/app/sessions/get.action","appKey=" & $_appKey & "&appSecret=" & $_appSecret & "&email=" & urlencode($_email))
EndFunc
Func urlencode($UnicodeURL)
    $UnicodeBinary = StringToBinary ($UnicodeURL, 4)
    $UnicodeBinary2 = StringReplace($UnicodeBinary, '0x', '', 1)
    $UnicodeBinaryLength = StringLen($UnicodeBinary2)
    Local $EncodedString
    For $i = 1 To $UnicodeBinaryLength Step 2
        $UnicodeBinaryChar = StringMid($UnicodeBinary2, $i, 2)
        If StringInStr("$-_.!*'(),;/?@=&abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890", BinaryToString ('0x' & $UnicodeBinaryChar, 4)) Then
            $EncodedString &= BinaryToString ('0x' & $UnicodeBinaryChar)
        Else
            $EncodedString &= '%' & $UnicodeBinaryChar
        EndIf
    Next
    Return $EncodedString
EndFunc   ;==>_UnicodeURLEncode


Global $oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

Func MyErrFunc()
Local $HexNumber
Local $strMsg

$HexNumber = Hex($oMyError.Number, 8)
$strMsg = "Error Number: " & $HexNumber & @CRLF
$strMsg &= "WinDescription: " & $oMyError.WinDescription & @CRLF
$strMsg &= "Script Line: " & $oMyError.ScriptLine & @CRLF
MsgBox(0, "ERROR", $strMsg)
SetError(1)
Endfunc


;$returnGrantToken = GrantToken($apiKey_b, $apiSecret_b, "cl.mitil.test@gmail.com")
MsgBox(0,"",_HTTP_Post($_webinarAPI))
