#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <File.au3>
#include <GDIPlus.au3>
#include <MsgBoxConstants.au3>

;local $IE_Edge[] =  [843,225,1078,290,196,786,432,850]	; 4:3
local $IE_Edge[] = [749,215,1169,294,104,786,523,854]		; 16:9

; for 4:3 IE/Edge
local $BrowserData[][] = [ _
	["Chrome",105,257,521,326], _
	["FireFox",1382,255,1799,325], _
	["IE",$IE_Edge[0],$IE_Edge[1],$IE_Edge[2],$IE_Edge[3]], _
	["Edge",$IE_Edge[4],$IE_Edge[5],$IE_Edge[6],$IE_Edge[7]], _
	["U",643,772,953,823], _
	["Original",1949,401,3830,710], _
	["Android",9,440,1068,612] _		; Android screen is cropped independently
	]


Global $fileList = _FileListToArrayRec(".\","??-??-??-??-??.PNG", $FLTAR_FILES ,$FLTAR_RECUR )

DirCreate("pic")
_GDIPlus_Startup()
Global $hImage, $hNewImage[7], $hCtxt[7], $sErrorList = ""


for $j = 0 to UBound($BrowserData) -1
	$hNewImage[$j] = _GDIPlus_BitmapCreateFromScan0($BrowserData[$j][3] - $BrowserData[$j][1], $BrowserData[$j][4] - $BrowserData[$j][2])
	$hCtxt[$j] = _GDIPlus_ImageGetGraphicsContext($hNewImage[$j])
Next



for $i = 1 to $fileList[0]
	$hImage = _GDIPlus_ImageLoadFromFile($fileList[$i])
	If @error Then
		ConsoleWrite("Error loading file"&@CRLF)
		_StringAppend($sErrorList, "Error loading file: """ & $fileList[$i] & """ @extended = " & @extended)
		;ContinueLoop ; Start the loop again since we can't use this image
	EndIf

	If StringLeft($fileList[$i],7) = "Android" Then
		$fileList[$i] = StringTrimLeft($fileList[$i],8)
		$BrowserStart = 6
		$BrowserEnd = 6
	Else
		$BrowserStart = 0
		$BrowserEnd = 5
	EndIf

	for $j = $BrowserStart to $BrowserEnd
		_GDIPlus_GraphicsDrawImageRectRect( _
		$hCtxt[$j], $hImage, _
		$BrowserData[$j][1], $BrowserData[$j][2], $BrowserData[$j][3] - $BrowserData[$j][1], $BrowserData[$j][4] - $BrowserData[$j][2], _ ; Source image ($hImage) (X, Y, Width, Height) (ie. Take data from $hImage at XY 0, 0 with a width of 500 and height of 400)
		0, 0, $BrowserData[$j][3] - $BrowserData[$j][1], $BrowserData[$j][4] - $BrowserData[$j][2] _ ; Destination image ($hCtxt -> $hNewImage) (ie. Write to $hNewImage at XY 0, 0 with a width of 500 and height of 400)
		)

		_GDIPlus_ImageSaveToFile($hNewImage[$j], "pic\" & $BrowserData[$j][0] & "_" & $fileList[$i]) ; Write $hNewImage to the folder
		If @error Then
			_StringAppend($sErrorList, "Error saving file: """ & $fileList[$i] & """ @extended = " & @extended)
		EndIf
	Next

	_GDIPlus_ImageDispose($hImage) ; We no longer need to read from it, so get rid of it
Next

for $j = 0 to UBound($BrowserData) -1
	_GDIPlus_GraphicsDispose($hCtxt[$j]) ; We no longer need to write to it, so get rid of it
	_GDIPlus_ImageDispose($hNewImage[$j]) ; Don't need it anymore
	OCRtoFile($BrowserData[$j][0])
Next

_GDIPlus_Shutdown()




Func OCRtoFile($title, $folderName = "pic")
	$fileList = _FileListToArray($folderName , $title & "_*.PNG", 1, False)

	;apply zero data if files are less than 24
	$fileNumber = 24

	for $i = 1 to $fileNumber
		$result =  0 & @TAB & 0 & @TAB & 0 & @TAB & 0	; for the date that number > fileList[0]
		$date = 0 & @TAB & 0 & @TAB & 0 & @TAB & 0 & @TAB & 0
		if $i <= $fileList[0] Then
			RunWait(@ComSpec & " /c " & "tesseract " & $folderName &"\" & $fileList[$i] & " " & $title & "_temp -l WORK" , "" , @SW_HIDE )
			$result = StringStripWS (FileRead( $title & "_temp.txt" ),3) ; remove front / back white space
			FileDelete( $title &"_temp.txt")
			$date = stringleft($fileList[$i],StringInStr( $fileList[$i],".",0,-1)-1) ; file name only
			$date = StringTrimLeft($date,StringInStr( $date,"_"))
			$date = StringReplace($date,"-",@tab)

			$result = StringReplace($result,":",@tab)
			$result = StringReplace($result,".",@tab)
		EndIf
		FileWrite($title &".txt" , $date & @tab & $result &@CRLF)
		FileWrite("RawData.txt",$date & @tab & $result &@CRLF)
	Next
EndFunc

Func _StringAppend(ByRef $sString, $sAppend, $sDelim = @CRLF)
; Same as above, but with the Ternary operator
$sString &= (($sString = "") ? ("") : ($sDelim)) & $sAppend
Return 1
EndFunc ;==>_StringAppend