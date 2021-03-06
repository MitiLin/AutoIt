#include-once
#cs ----------------------------------------------------------------------------
	Author:         BB_19
	Material Themes for MetroGUI UDF
#ce ----------------------------------------------------------------------------

;#Set Default Theme
Global $GUIThemeColor = "0x191919" ; GUI Background Color
Global $FontThemeColor = "0xFFFFFF" ; Font Color
Global $GUIBorderColor = "0x303030" ; GUI Border Color
Global $ButtonBKColor = "0x40798D" ; Metro Button BacKground Color
Global $ButtonTextColor = "0xFFFFFF" ; Metro Button Text Color
Global $GUI_Theme_Name = "DarkBlue"
Global $ControlThickStyle = False ; Enables thick "Close/Maximize/Minimiz" button style.
Global $CB_Radio_Color = "0xFFFFFF" ;Checkbox and Radio Color (Box/Circle)
Global $CB_Radio_Hover_Color = "0xD8D8D8"; Checkbox and Radio Hover Color (Box/Circle)
Global $CB_Radio_CheckMark_Color = "0x1B1B1B"; Checkbox and Radio checkmark color
;22264b <<< nice color

Func _SetTheme($ThemeSelect = "DarkTeal")
	Switch ($ThemeSelect)
		Case "DarkGreen"
			$GUIThemeColor = "0x212121"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0x0F595E"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "DarkGray"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "LightTeal"
			$GUIThemeColor = "0xcccccc"
			$FontThemeColor = "0x1B1B1B"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0x009688"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "LightTeal"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xF7F7F7"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "DarkTeal"
			$GUIThemeColor = "0x212121"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0x00897b"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "DarkTeal"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "DarkMidnight"
			$GUIThemeColor = "0x1F253D"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x242B47"
			$ButtonBKColor = "0x3C4D66"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "DarkMidnightV2"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "DarkBlue"
			$GUIThemeColor = "0x212121"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x303030"
			$ButtonBKColor = "0x40798D"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "DarkBlue"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "LightBlue"
			$GUIThemeColor = "0xcccccc"
			$FontThemeColor = "0x1B1B1B"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0x0d47a1"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "LightBlue"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xF7F7F7"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "DarkBlueV2"
			$GUIThemeColor = "0x282828"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0x0d47a1"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "DarkBlue"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "LightCyan"
			$GUIThemeColor = "0xD7D7D7"
			$FontThemeColor = "0x1B1B1B"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0x00838f"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "LightCyan"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xF7F7F7"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "DarkCyan"
			$GUIThemeColor = "0x212121"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0x00838f"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "DarkCyan"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "LightGray"
			$GUIThemeColor = "0xcccccc"
			$FontThemeColor = "0x1B1B1B"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0x3F5863"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "LightGray"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xF7F7F7"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "LightGreen"
			$GUIThemeColor = "0xD7D7D7"
			$FontThemeColor = "0x212121"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0x2E7D32"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "LightGreen"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xF7F7F7"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "DarkGreen"
			$GUIThemeColor = "0x212121"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0x179141"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "DarkGreen"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "LightRed"
			$GUIThemeColor = "0xD7D7D7"
			$FontThemeColor = "0x212121"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0xc62828"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "LightRed"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xF7F7F7"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "DarkGray"
			$GUIThemeColor = "0x455A64"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x4F6772"
			$ButtonBKColor = "0x607D8B"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "DarkGray"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "DarkAmber"
			$GUIThemeColor = "0x212121"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0xffa000"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "DarkAmber"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "LightOrange"
			$GUIThemeColor = "0xD7D7D7"
			$FontThemeColor = "0x212121"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0xd84315"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "LightOrange"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xF7F7F7"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "DarkOrange"
			$GUIThemeColor = "0x212121"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0xf4511e"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "DarkOrange"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "LightPurple"
			$GUIThemeColor = "0xD7D7D7"
			$FontThemeColor = "0x212121"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0x512DA8"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "LightPurple"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xF7F7F7"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "DarkPurple"
			$GUIThemeColor = "0x212121"
			$FontThemeColor = "0xFFFFFF"
			$GUIBorderColor = "0x2D2D2D"
			$ButtonBKColor = "0x512DA8"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "DarkPurple"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xD8D8D8"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"
		Case "LightPink"
			$GUIThemeColor = "0xD7D7D7"
			$FontThemeColor = "0x212121"
			$GUIBorderColor = "0xD8D8D8"
			$ButtonBKColor = "0xE91E63"
			$ButtonTextColor = "0xFFFFFF"
			$GUI_Theme_Name = "LightPink"
			$ControlThickStyle = False
			$CB_Radio_Color = "0xFFFFFF"
			$CB_Radio_Hover_Color = "0xF7F7F7"
			$CB_Radio_CheckMark_Color = "0x1B1B1B"


	EndSwitch
EndFunc   ;==>_SetTheme
