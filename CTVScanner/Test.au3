
#include <File.au3>
#include <array.au3>
#include <_Common_Block-UsageLog.au3>
#include <File.au3>


$basePath = "C:\Program Files (x86)\CyberLink"

$a = LoadSkipList($basePath)
_ArrayDisplay($a)



Func LoadSkipList($base , $skipFile = "")
	dim $skipList_tmp[1]
	_FileReadToArray($skipFile<> ""? $skipFile: @ScriptDir & "\CTVScanner_SkipLIst.txt", $skipList_tmp)
	If @error Then
		MsgBox (0,"", "Open skip list (CTVScanner_SkipLIst.txt) failed.")
		If Not $Testing then _ScanFolderUsageLog_Send($strScriptName, $strScriptVersion, $bTestMode, $nScanFolderNum, $nFolderExistCTV, 1)
		exit 1
	EndIf

	Dim $skipList_flag[$skipList_tmp[0]+1] = [$skipList_tmp[0]]


	Local $hasEmptyLine = False
	For $i = 1 to $skipList_tmp[0]
		$skipList_tmp[$i] = StringStripWS($skipList_tmp[$i],1)
		If StringLeft($skipList_tmp[$i],1) = "\" Then $skipList_tmp[$i] = StringTrimLeft($skipList_tmp[$i],1)	; remove header and trailer
		if StringLeft($skipList_tmp[$i],1) = ";" Then															; skip ";"
			$skipList_flag[0] -= 1
			$skipList_tmp[$i] = "xxx"
		EndIf
		If $skipList_tmp[$i] = "" Then																			; only count empty line once
			If $hasEmptyLine Then
				$skipList_flag[0] -= 1
				$skipList_tmp[$i] = "xxx"
			Else
				$hasEmptyLine = True
			EndIf
		EndIf
	Next
	;_ArrayDisplay($skipList_tmp)
	Dim $skipList[$skipList_flag[0]+1] = [$skipList_flag[0]]
	local $index = 1
	For $i = 1 to $skipList_tmp[0]
		;ConsoleWrite($i &@CRLF)
		If $skipList_tmp[$i] <> "xxx" Then
			$skipList[$index] = $skipList_tmp[$i]
			$index += 1
		EndIf
	Next

	for $i=1 to $skipList[0]
		If $skipList[$i] <> "" then
			$skipList[$i] = $base & "\" & $skipList[$i]
		Else
			$skipList[$i] = $base
		EndIf
	Next
	Return $skipList
EndFunc

