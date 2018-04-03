#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <inet.au3>

TCPStartup() ; Start the TCP service.
; Register OnAutoItExit to be called when the script is closed.
OnAutoItExitRegister("OnAutoItExit")

$sIPAddress = "111.248.195.80"
$iPort = 80

for  $i = 1 to 1
$publicIP = _GetIP()
MyTCP_Client($sIPAddress, $iPort, $publicIP & "//Responds//" & $publicIP &" is connected" )
Next



Func MyTCP_Client($sIPAddress, $iPort , $sData)
    ; Assign a Local variable the socket and connect to a listening socket with the IP Address and Port specified.
    Local $iSocket = TCPConnect($sIPAddress, $iPort)
    Local $iError = 0

    ; If an error occurred display the error code and return False.
    If @error Then
        ; The server is probably offline/port is not opened on the server.
        $iError = @error
        MsgBox(BitOR($MB_SYSTEMMODAL, $MB_ICONHAND), "", "Client:" & @CRLF & "Could not connect, Error code: " & $iError)
        Return False
    EndIf

    ; Send the string "tata" to the server.
    TCPSend($iSocket, $sData)

    ; If an error occurred display the error code and return False.
    If @error Then
        $iError = @error
        MsgBox(BitOR($MB_SYSTEMMODAL, $MB_ICONHAND), "", "Client:" & @CRLF & "Could not send the data, Error code: " & $iError)
        Return False
    EndIf

    ; Close the socket.
    TCPCloseSocket($iSocket)
EndFunc   ;==>MyTCP_Client




	Func OnAutoItExit()
    TCPShutdown() ; Close the TCP service.
EndFunc   ;==>OnAutoItExit