Func Base64Decode($s)
    Local $key = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=', _
    $t = '', $p = -8, $a = 0, $c, $d, $len = StringLen($s)
    For $i = 1 to $len
        $c = StringInStr($key, StringMid($s,$i,1), 1) - 1
        If $c < 0 Then ContinueLoop
        $a = BitOR(BitShift($a, -6), BitAND($c, 63))
        $p = $p + 6
        If $p >= 0 Then
            $d = BitAND(BitShift($a, $p), 255)
            If $c <> 64 Then $t = $t & Chr($d)
            $a = BitAND($a, 63)
            $p = $p - 8
        EndIf
    Next
    Return $t
EndFunc


ConsoleWrite (Base64Decode("b5Laakb3sbdua1Aa6]acb0a5d8bcd0b9qb8a3a9dab5b4b3sbdua1C"))