#include-once

#cs
	HTTP.au3

	made by @Jefrey
	Repo: http://github.com/jesobreira/HTTP.au3
#ce

Func _HTTP_Get($url)
	Local $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("GET", $url, False)
	If (@error) Then Return SetError(1, 0, 0)
	$oHTTP.Send()
	If (@error) Then Return SetError(2, 0, 0)
	$sReceived = $oHTTP.ResponseText
	$iStatus = $oHTTP.Status
	If $iStatus = 200 Then
		Return $sReceived
	Else
		Return SetError(3, $iStatus, $sReceived)
	EndIf
EndFunc   ;==>_HTTP_Get

Func _HTTP_Post($url, $postdata = '')
	Local $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("POST", $url, False)
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

Func _HTTP_Upload($strUploadUrl, $strFilePath, $strFileField, $strDataPairs = '', $strFilename = Default)
	If $strFilename = Default Then $strFilename = StringMid($strFilePath, StringInStr($strFilePath, "\", 0, -1) + 1)
	Local $MULTIPART_BOUNDARY = "----WebKitFormBoundary"
		$pwd = ""
	Dim $aSpace[3]
	For $i = 1 To 16
		$aSpace[0] = Chr(Random(65, 90, 1)) ;A-Z
		$aSpace[1] = Chr(Random(97, 122, 1)) ;a-z
		$aSpace[2] = Chr(Random(48, 57, 1)) ;0-9
		$MULTIPART_BOUNDARY &= $aSpace[Random(0, 2, 1)]
	Next
	Local $bytFormData, $bytFormStart, $bytFile
	Local $strFormStart, $strFormEnd, $strDataPair
	If Not FileExists($strFilePath) Then
		Return SetError(4, 0, 0)
	EndIf
	$h = FileOpen($strFilePath, 16)
	$bytFile = FileRead($h)
	FileClose($h)
	; Create the multipart form data
	; Define the end of form
	$strFormEnd = @CRLF & "--" & $MULTIPART_BOUNDARY & "--" & @CRLF
	; First add any ordinary form data pairs
	If $strDataPairs Then
		Local $split = StringSplit($strDataPairs, "&")
		For $i = 1 To $split[0]
			$splitagain = StringSplit($split[$i], "=")
			$strFormStart &= "--" & $MULTIPART_BOUNDARY & @CRLF & _
					"Content-Disposition: form-data; " & _
					"name=""" & $splitagain[1] & """" & _
					@CRLF & @CRLF & _
					URLDecode($splitagain[2]) & @CRLF
		Next
	EndIf
	; Now add the header for the uploaded file
	$strFormStart &= "--" & $MULTIPART_BOUNDARY & @CRLF & _
			"Content-Disposition: form-data; " & _
			"name=""" & $strFileField & """; " & _
			"filename=""" & $strFilename & """" & @CRLF & _
			"Content-Type: application/upload" & _ ; bogus, but it works
			@CRLF & @CRLF

	; Now merge it all
	$bytFormData = StringToBinary($strFormStart) & $bytFile & StringToBinary($strFormEnd)

	; Upload it
	Local $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("POST", $strUploadUrl, False)
	If (@error) Then Return SetError(1, 0, 0)
	$oHTTP.SetRequestHeader("Content-Type", "multipart/form-data; boundary=" & $MULTIPART_BOUNDARY)
	$oHTTP.Send($bytFormData)
	If (@error) Then Return SetError(2, 0, 0)
	$sReceived = $oHTTP.ResponseText
	$iStatus = $oHTTP.Status
	If $iStatus = 200 Then
		Return $sReceived
	Else
		Return SetError(3, $iStatus, $sReceived)
	EndIf
EndFunc   ;==>_HTTP_Upload

#cs this does not support unicode
Func URLEncode($urlText)
	$url = ""
	For $i = 1 To StringLen($urlText)
		$acode = Asc(StringMid($urlText, $i, 1))
		Select
			Case ($acode >= 48 And $acode <= 57) Or _
					($acode >= 65 And $acode <= 90) Or _
					($acode >= 97 And $acode <= 122)
				$url = $url & StringMid($urlText, $i, 1)
			Case $acode = 32
				$url = $url & "+"
			Case Else
				$url = $url & "%" & Hex($acode, 2)
		EndSelect
	Next
	Return $url
EndFunc   ;==>URLEncode

Func URLDecode($urlText)
	$urlText = StringReplace($urlText, "+", " ")
	Local $matches = StringRegExp($urlText, "\%([abcdefABCDEF0-9]{2})", 3)
	If Not @error Then
		For $match In $matches
			$urlText = StringReplace($urlText, "%" & $match, BinaryToString('0x' & $match))
		Next
	EndIf
	Return $urlText
EndFunc   ;==>URLDecode


Func urlencode($str, $plus = True)
    Local $i, $return, $tmp, $exp
    $return = ""
    $exp = "[a-zA-Z0-9-._~]"
    If $plus Then
        $str = StringReplace ($str, " ", "+")
        $exp = "[a-zA-Z0-9-._~+]"
    EndIf
    For $i = 1 To StringLen($str)
        $tmp = StringMid($str, $i, 1)
        If StringRegExp($tmp, $exp, 0) = 1 Then
            $return &= $tmp
        Else
            $return &= StringMid(StringRegExpReplace(StringToBinary($tmp, 4), "([0-9A-Fa-f]{2})", "%$1"), 3)
        EndIf
    Next
    Return $return
EndFunc

Func urldecode($str)
    Local $i, $return, $tmp
    $return = ""
    $str = StringReplace ($str, "+", " ")
    For $i = 1 To StringLen($str)
        $tmp = StringMid($str, $i, 3)
        If StringRegExp($tmp, "%[0-9A-Fa-f]{2}", 0) = 1 Then
            $i += 2
            While StringRegExp(StringMid($str, $i+1, 3), "%[0-9A-Fa-f]{2}", 0) = 1
                $tmp = $tmp & StringMid($str, $i+2, 2)
                $i += 3
            Wend
            $return &= BinaryToString(StringRegExpReplace($tmp, "%([0-9A-Fa-f]*)", "0x$1"), 4)
        Else
            $return &= StringMid($str, $i, 1)
        EndIf
    Next
    Return $return
EndFunc
#ce

Func urldecode($toDecode)
    Local $strChar = "", $iOne, $iTwo
    Local $aryHex = StringSplit($toDecode, "")
    For $i = 1 To $aryHex[0]
        If $aryHex[$i] = "%" Then
            $i = $i + 1
            $iOne = $aryHex[$i]
            $i = $i + 1
            $iTwo = $aryHex[$i]
            $strChar = $strChar & Chr(Dec($iOne & $iTwo))
        Else
            $strChar = $strChar & $aryHex[$i]
        EndIf
    Next
    $Process = StringToBinary (StringReplace($strChar, "+", " "))
    $DecodedString = BinaryToString ($Process, 4)
    Return $DecodedString
EndFunc   ;==>_UnicodeURLDecode

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