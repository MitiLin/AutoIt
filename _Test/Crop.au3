#include <File.au3>
#include <GDIPlus.au3>
#include <MsgBoxConstants.au3>
Global Const $sInFolder = "In\" ; The folder where all your original .pngs are
Global Const $sOutFolder = "Out\" ; The folder where the new .pngs will be stored

; Generate a list of all the png files in $sInFolder
Global $asList = _FileListToArray($sInFolder, "*.png", 1, False)
If @error Then
Switch @error
Case 1
_ErrMsgExit("Folder not found or invalid, " & $sInFolder, -11)
Case 2
_ErrMsgExit("Invalid _FileListToArray() filter supplied", -12)
Case 3
_ErrMsgExit("Invalid _FileListToArray() Flag", -13)
Case 4
_ErrMsgExit("No files found in " & $sInFolder, -14)
EndSwitch
EndIf

; Crop the images
_GDIPlus_Startup()
; I'm assuming that all the input files are different sizes and that the top left (0, 0)
; needs to be cropped into a 500 x 400 frame (NOTE: if the file is too small (under 500 x 400) then a blank space will occur)
Global $hImage, $hNewImage, $hCtxt, $sErrorList = ""
For $i = 1 To $asList[0] ; Loop through all files
	$hImage = _GDIPlus_ImageLoadFromFile($sInFolder & "" &$asList[$i]) ; Attempt to load file
	If @error Then
		_StringAppend($sErrorList, "Error loading file: """ & $asList[$i] & """ @extended = " & @extended)
		ContinueLoop ; Start the loop again since we can't use this image
	EndIf

	$hNewImage = _GDIPlus_BitmapCreateFromScan0(500, 400) ; Creata a blank 500 x 400 bitmap
	$hCtxt = _GDIPlus_ImageGetGraphicsContext($hNewImage) ; Get the GraphicsContext of an image (so we can write to it)
	; _GDIPlus_GraphicsClear($hCtxt, 0xFF000000) ; Uncomment if you want the background to be a solid colour
	_GDIPlus_GraphicsDrawImageRectRect( _
	$hCtxt, $hImage, _
	0, 0, 500, 400, _ ; Source image ($hImage) (X, Y, Width, Height) (ie. Take data from $hImage at XY 0, 0 with a width of 500 and height of 400)
	0, 0, 500, 400 _ ; Destination image ($hCtxt -> $hNewImage) (ie. Write to $hNewImage at XY 0, 0 with a width of 500 and height of 400)
	) ; Note: Keep the source image and destination image Width / Height the same to prevent resizing

	; At this point $hNewImage contains the new data

	_GDIPlus_GraphicsDispose($hCtxt) ; We no longer need to write to it, so get rid of it
	_GDIPlus_ImageDispose($hImage) ; We no longer need to read from it, so get rid of it
	_GDIPlus_ImageSaveToFile($hNewImage, $sOutFolder & $asList[$i]) ; Write $hNewImage to the folder
	If @error Then
	_StringAppend($sErrorList, "Error saving file: """ & $sOutFolder & $asList[$i] & """ @extended = " & @extended)
	EndIf
	_GDIPlus_ImageDispose($hNewImage) ; Don't need it anymore
Next

If $sErrorList <> "" Then
MsgBox($MB_OK + $MB_ICONWARNING, "Warning", "The following errors have occured:" & @CRLF & @CRLF & $sErrorList)
EndIf

_GDIPlus_Shutdown()


Func _ErrMsgExit($sMsg, $iCode, $iLine = @ScriptLineNumber)
If Not @Compiled Then $sMsg = "An error occured on line " & $iLine & ":" & @CRLF & @CRLF & $sMsg
MsgBox($MB_OK + $MB_ICONERROR, "Critical error", $sMsg)
Exit $iCode
EndFunc ;==>_ErrMsgExit

Func _StringAppend(ByRef $sString, $sAppend, $sDelim = @CRLF)
#cs
If $sString = "" Then
$sString &= $sAppend
Else
$sString &= $sDelim & $sAppend
EndIf
#ce
; Same as above, but with the Ternary operator
$sString &= (($sString = "") ? ("") : ($sDelim)) & $sAppend
Return 1
EndFunc ;==>_StringAppend