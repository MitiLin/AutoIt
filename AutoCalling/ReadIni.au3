#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here


Func readMeetingINI($file)
	$SectionNames = IniReadSectionNames(@ScriptDir & "\" & $file)
	Dim $CallData[$SectionNames[0]+1][4] = [[0]]
	For $i = 1 to $SectionNames[0]
		$SectionNameTemp = $SectionNames[$i]
		If StringRegExp($SectionNameTemp,"Meeting-(\d*)") Then
			$CallData[0][0] += 1
			$CallData[$CallData[0][0]][0] = $SectionNameTemp
			$CallData[$CallData[0][0]][1] = IniRead($file,$SectionNameTemp,"StartHour",0)
			$CallData[$CallData[0][0]][2] = IniRead($file,$SectionNameTemp,"StartMin",0)
			$CallData[$CallData[0][0]][3] = IniRead($file,$SectionNameTemp,"Callee","DefaultUser")
		EndIf
	Next
	Dim $returnArray[$CallData[0][0]+1][4] = [[$CallData[0][0]]]
	for $i =  1 to $CallData[0][0]
		$returnArray[$i][0] = $CallData[$i][0]
		$returnArray[$i][1] = $CallData[$i][1]
		$returnArray[$i][2] = $CallData[$i][2]
		$returnArray[$i][3] = $CallData[$i][3]
	Next
	Return $returnArray
EndFunc
Func readReceiveIni($file)
	$SectionNames = IniReadSectionNames(@ScriptDir & "\" & $file)
	Dim $ReceiveData[$SectionNames[0]+1][5] = [[0]]
	For $i = 1 to $SectionNames[0]
		$SectionNameTemp = $SectionNames[$i]
		If StringRegExp($SectionNameTemp,"Receive-(\d*)") Then
			$ReceiveData[0][0] += 1
			$ReceiveData[$ReceiveData[0][0]][0] = $SectionNameTemp
			$ReceiveData[$ReceiveData[0][0]][1] = IniRead($file,$SectionNameTemp,"StartHour",0)
			$ReceiveData[$ReceiveData[0][0]][2] = IniRead($file,$SectionNameTemp,"StartMin",0)
			$ReceiveData[$ReceiveData[0][0]][3] = IniRead($file,$SectionNameTemp,"EndHour",0)
			$ReceiveData[$ReceiveData[0][0]][4] = IniRead($file,$SectionNameTemp,"EndMin",0)
		EndIf
	Next
	Dim $returnArray[$ReceiveData[0][0]+1][5] = [[$ReceiveData[0][0]]]
	for $i =  1 to $ReceiveData[0][0]
		$returnArray[$i][0] = $ReceiveData[$i][0]
		$returnArray[$i][1] = $ReceiveData[$i][1]
		$returnArray[$i][2] = $ReceiveData[$i][2]
		$returnArray[$i][3] = $ReceiveData[$i][3]
		$returnArray[$i][4] = $ReceiveData[$i][4]
	Next
	Return $returnArray
EndFunc