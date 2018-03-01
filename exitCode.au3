#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GUIConstantsEx.au3>

if $CmdLine[0] = 0 then exit 1
$deviceID = $CmdLine[1]




#include <AutoItObject.au3>
#include <WinAPI.au3>

Global Const $TBPF_NOPROGRESS = 0
Global Const $TBPF_INDETERMINATE = 0x1
Global Const $TBPF_NORMAL = 0x2
Global Const $TBPF_ERROR = 0x4
Global Const $TBPF_PAUSED = 0x8

Global $goflag = False

; register to receive the message that our button is ready
GUIRegisterMsg(_WinAPI_RegisterWindowMessage("TaskbarButtonCreated"), "_TaskbarReady")

; register error handler and startup AIO
Global $oError = ObjEvent("AutoIt.Error", "_ErrFunc")
_AutoItObject_StartUp()

; get interfaces
Global $CLSID_TaskBarlist = _AutoItObject_CLSIDFromString("{56FDF344-FD6D-11D0-958A-006097C9A090}")
; ITaskbarList3:  http://msdn.microsoft.com/en-us/library/dd391692(VS.85).aspx
Global $IID_ITaskbarList3 = _AutoItObject_CLSIDFromString("{ea1afb91-9e28-4b86-90e9-9e9f8a5eefaf}")

; create the ITaskbarList3 interface instance
Global $pTB3
_AutoItObject_CoCreateInstance(DllStructGetPtr($CLSID_TaskBarlist), 0, 1, DllStructGetPtr($IID_ITaskbarList3), $pTB3)
If Not $pTB3 Then
    MsgBox(16, "Error", "Failed to create ITaskbarList3 interface, exiting.")
    _AutoItObject_Shutdown()
    Exit
EndIf

; setup AIO wrapper for the interface
Global $tagInterface = _
        "QueryInterface long(ptr;ptr;ptr);" & _
        "AddRef ulong();" & _
        "Release ulong();" & _
        "HrInit long();" & _
        "AddTab long(hwnd);" & _
        "DeleteTab long(hwnd);" & _
        "ActivateTab long(hwnd);" & _
        "SetActiveAlt long(hwnd);" & _
        "MarkFullscreenWindow long(hwnd;int);" & _
        "SetProgressValue long(hwnd;uint64;uint64);" & _
        "SetProgressState long(hwnd;int);" & _
        "RegisterTab long(hwnd;hwnd);" & _
        "UnregisterTab long(hwnd);" & _
        "SetTabOrder long(hwnd;hwnd);" & _
        "SetTabActive long(hwnd;hwnd;dword);" & _
        "ThumbBarAddButtons long(hwnd;uint;ptr);" & _
        "ThumbBarUpdateButtons long(hwnd;uint;ptr);" & _
        "ThumbBarSetImageList long(hwnd;ptr);" & _
        "SetOverlayIcon long(hwnd;ptr;wstr);" & _
        "SetThumbnailTooltip long(hwnd;wstr);" & _
        "SetThumbnailClip long(hwnd;ptr);"
; create the AIO object using the wrapper
Global $oTB3 = _AutoItObject_WrapperCreate($pTB3, $tagInterface)
If Not IsObj($oTB3) Then
    MsgBox(16, "Error", "Something has gone horribly awry...")
    _AutoItObject_Shutdown()
    Exit
EndIf
; call the HrInit method to initialize the ITaskbarList3 interface
$oTB3.HrInit()

Global $gui = Number(GUICreate("Toolbar Progress", 250, 80))
Global $b1 = GUICtrlCreateButton("Start Progress Bar", 10, 10)
GUISetState()

While 1 <> 2
    Switch GUIGetMsg()
        Case $b1
            _GoProgressTest()
        Case -3
            ExitLoop
    EndSwitch
WEnd

$oTB3 = 0
_AutoItObject_Shutdown()

Func _GoProgressTest()
    While Not $goflag
        Sleep(10)
    WEnd
    ConsoleWrite("here we go..." & @CRLF)
    ; go through various states and progress
    $oTB3.SetProgressState($gui, $TBPF_INDETERMINATE)
    Sleep(3000)
    For $i = 0 To 33
        $oTB3.SetProgressValue($gui, $i, 100)
        Sleep(50)
    Next
    $oTB3.SetProgressState($gui, $TBPF_PAUSED)
    For $i = 34 To 66
        $oTB3.SetProgressValue($gui, $i, 100)
        Sleep(50)
    Next
    $oTB3.SetProgressState($gui, $TBPF_ERROR)
    For $i = 67 To 100
        $oTB3.SetProgressValue($gui, $i, 100)
        Sleep(50)
    Next
    $oTB3.SetProgressState($gui, $TBPF_NORMAL)
    Sleep(1500)
    $oTB3.SetProgressState($gui, $TBPF_NOPROGRESS)
EndFunc

Func _TaskbarReady($hWnd, $msg, $wParam, $lParam)
    Switch $hWnd
        Case $gui
            ; the taskbar button is ready
            ConsoleWrite("taskbar button ready" & @CRLF)
            $goflag = True
    EndSwitch
EndFunc

Func _ErrFunc()
    ConsoleWrite("! COM Error !  Number: 0x" & Hex($oError.number, 8) & "   ScriptLine: " & $oError.scriptline & " - " & $oError.windescription & @CRLF)
    Return
EndFunc   ;==>_ErrFunc






#cs
ProgressOn("Progress Bar", "Sample progress bar", "Working...")

 For $i = 0 To 100
 	ProgressSet($i)
 	Sleep(5)
 Next

 ProgressSet(100, "Done!")
 Sleep(750)
 ProgressOff()
#ce