#include <MsgBoxConstants.au3>

;~ Example()

;~ Func Example()
;~     ; Read the current script file into an array using the filepath.
;~     Local $aArray = FileReadToArray(@ScriptDir & "\data_2.csv")
;~     If @error Then
;~         MsgBox($MB_SYSTEMMODAL, "", "There was an error reading the file. @error: " & @error) ; An error occurred reading the current script file.
;~     Else
;~         For $i = 0 To 10; UBound($aArray) - 1 ; Loop through the array.
;~             MsgBox($MB_SYSTEMMODAL, "", $aArray[$i]) ; Display the contents of the array.
;~         Next
;~     EndIf
;~ EndFunc   ;==>Example



Local $aArray = FileReadToArray(@ScriptDir & "\data_2.csv")
$tar = FileOpen (@ScriptDir & "\data_2_.csv" , 10)

$lastLine = ","
For $i = 0 To UBound($aArray) - 1
	if groupName($lastLine) <> groupName($aArray[$i]) Then FileWriteLine($tar,"group,"& groupName($lastLine))
	$lastLine = $aArray[$i]
	FileWriteLine($tar,$aArray[$i])
Next




Func groupName($a)
	$position = StringInStr($a,",",0,-1)

	Return Stringleft($a,$position-1)
EndFunc
