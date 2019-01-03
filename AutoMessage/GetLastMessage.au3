#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <PythonOpenCVTM.au3>
#include <array.au3>

;ConsoleWrite("return = " &GetLastMessage("C:\Users\Miti\AppData\Local\Temp\temp.png") &@CRLF)

Func GetLastMessage($png)
	$source = $png
	$imgTL = @LocalAppDataDir&"\AutoMessage\_TopLeft_receive.png" ; old path = @ScriptDir & "\_TopLeft_receive.png"
	;$imgTR = @ScriptDir & "\_TopRight.png"
	;$imgBL = @ScriptDir & "\_BotLeft.png"
	$imgBR = @LocalAppDataDir&"\AutoMessage\_BotRight_receive.png" ; old path = @ScriptDir & "\_BotRight_receive.png"
	$tempPNG = @TempDir & "\LastMSG.png"

	$TL_List = _openCVTM($source,$imgTL,0.96,True)
	$BR_List = _openCVTM($source,$imgBR,0.96,True)
	;_ArrayDisplay($TL_List)
	;_ArrayDisplay($BR_List)
	$PosLastMSG = _GetLastReveiveMsgPos($TL_List,$BR_List)
	_getMsgSnapshot($source,$posLastMSG,$tempPNG)
	$Msg = _OCRMsg($tempPNG)
	;FileDelete($tempPNG)
	Return $Msg
EndFunc



Func _OCRMsg($_png)

	RunWait(@ComSpec & " /c " & "tesseract " & $_png & " " & "temp -c tosp_min_sane_kn_sp=3 -l normal --psm 7" , @ScriptDir , @SW_HIDE )
	;ConsoleWrite("cmd = " &"tesseract " & $_png & " " & "temp -c tosp_min_sane_kn_sp=3 -l normal --psm 7" &@CRLF )
	$_str = FileReadLine(@ScriptDir & "\temp.txt")
	FileDelete(@ScriptDir & "\temp.txt")
	;ConsoleWrite("Txt = " & $_str &@CRLF)
	return	$_str
EndFunc


Func _getMsgSnapshot($_s , $_pos, $tempFile)
    Local $hBitmap, $hClone, $hImage, $iX, $iY

    ; Initialize GDI+ library
    _GDIPlus_Startup()

    ; Capture 32 bit bitmap
    $hImage = _GDIPlus_ImageLoadFromFile($_s)

    ; Create 24 bit bitmap clone
    $iX = _GDIPlus_ImageGetWidth($hImage)
    $iY = _GDIPlus_ImageGetHeight($hImage)
    $hClone = _GDIPlus_BitmapCloneArea($hImage, $_pos[0], $_pos[1], $_pos[2], $_pos[3], $GDIP_PXF16RGB555 )
	$sCLSID = _GDIPlus_EncodersGetCLSID("PNG")

    ; Save bitmap to file
    _GDIPlus_ImageSaveToFileEx($hClone, $tempFile , $sCLSID)

    ; Clean up resources
    _GDIPlus_ImageDispose($hClone)
    _GDIPlus_ImageDispose($hImage)

    ; Shut down GDI+ library
    _GDIPlus_Shutdown()
	;ConsoleWrite("Msg PNG = "  & $tempFile &@CRLF)
EndFunc


Func _GetLastReveiveMsgPos($_TL_List,$_BR_List)
	local $Return[] = [0,0,0,0,0,0]
	If Not IsArray($_BR_List) Then Return -1
	$Return[0] = 78
	$Return[1] = $_TL_List[UBound($_TL_List)-1][1] + 8
	$Return[2] = $_BR_List[UBound($_BR_List)-1][0] - $_TL_List[UBound($_TL_List)-1][0] - 15
	$Return[3] = 20
	$Return[4] = $Return[0] + $Return[2]
	$Return[5] = $Return[1] + $Return[3]
	;_ArrayDisplay($Return)
	Return $Return
EndFunc



Func _GetLastSendMsgPos($_TR_List,$_BL_List)
	local $Return[] = [0,0,0,0,0,0]
	If Not IsArray($_BL_List) Then Return -1
	$Return[0] = $_BL_List[UBound($_BL_List)-1][0] + 10
	$Return[1] = $_TR_List[UBound($_TR_List)-1][1] + 10
	$Return[2] = $_TR_List[UBound($_TR_List)-1][0] - $_BL_List[UBound($_BL_List)-1][0] - 4
	$Return[3] = $_BL_List[UBound($_BL_List)-1][1] - $_TR_List[UBound($_TR_List)-1][1] + 8
	$Return[4] = $Return[0] + $Return[2]
	$Return[5] = $Return[1] + $Return[3]

	Return $Return
EndFunc

Func _GetTempMsgPos($__TL,$__BR)
	If Not (IsArray($__TL) And IsArray($__BR)) Then Return 0
	$__numberTL = UBound($__TL)
	$__numberBR = UBound($__BR)
	If $__numberBR = 0 Then return 0
	local $__return[ $__numberTL + $__numberBR ][4]	; [index][pos]
	For $i = 0 to $__numberTL-1
		$__return[$i][0] = $__TL[0]
		$__return[$i][1] =$__TL[1]
		$__return[$i][2] =$__TL[2]
		$__return[$i][3] =$__TL[3]
	Next
	For $j = 0 to $__numberBR -1

	Next
	Return $__return
EndFunc


