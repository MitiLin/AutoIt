#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here


#include <File.au3>
#include <array.au3>

Global $fileList = _FileListToArray(@ScriptDir , "*.PNG", 1, False)
Global $fileList1 = _FileListToArray("Android\" , "*.PNG", 1, True)
Global $fileList2 = _FileListToArrayRec(".\","??-??-??-??-??.PNG", $FLTAR_FILES ,$FLTAR_RECUR )
_ArrayConcatenate($fileList,$fileList1)
_ArrayDisplay($fileList2)