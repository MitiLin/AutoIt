#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
Func _urlencode($str, $plus = True)
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


Func urlencode($UnicodeURL)
    $UnicodeBinary = StringToBinary ($UnicodeURL, 4)
    $UnicodeBinary2 = StringReplace($UnicodeBinary, '0x', '', 1)
    $UnicodeBinaryLength = StringLen($UnicodeBinary2)
    Local $EncodedString
    For $i = 1 To $UnicodeBinaryLength Step 2
        $UnicodeBinaryChar = StringMid($UnicodeBinary2, $i, 2)
        If StringInStr("$-_.+!*'(),;/?:@=&abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890", BinaryToString ('0x' & $UnicodeBinaryChar, 4)) Then
            $EncodedString &= BinaryToString ('0x' & $UnicodeBinaryChar)
        Else
            $EncodedString &= '%' & $UnicodeBinaryChar
        EndIf
    Next
    Return $EncodedString
EndFunc   ;==>_UnicodeURLEncode

ConsoleWrite("_url="& _urlencode("🌸")&@CRLF)
ConsoleWrite("url=" & urlencode("🌸")&@CRLF)