#include <HTTP.au3>


$_beta = "https://live-demo-api.cyberlink.com/"
$_production = "https://webinars-api.cyberlink.com/"
Global $_webinarAPI = $_beta



;ConsoleWrite(GrantToken("BI2AYWBI5SXNK3T4ZXXH","VvFDnav2BDyTzXnekedSUM9fu3jKpYbSt2tdtnYy","clmd003+10@gmail.com"))
;ConsoleWrite(GrantToken("BI2AYWBI5SXNK3T4ZXXH","VvFDnav2BDyTzXnekedSUM9fu3jKpYbSt2tdtnYy","cl.mitil.test@gmail.com"))
;7d975b2b-ec66-464e-9f39-3387ab5fb70e
;ConsoleWrite(JoinWebinar("505150205042099637","mywatermark","myname"))

;ConsoleWrite(urlencode("123"))


Func SetSever($string)
	If ($string = "Beta") Then
		$_webinarAPI = "https://live-demo-api.cyberlink.com/"
	Else
		$_webinarAPI = "https://webinars-api.cyberlink.com/"
	EndIf
EndFunc


Func GrantToken($_appKey, $_appSecret, $_email)
	;$_email = StringReplace($_email,"+","%2B")	; handle + case
	ConsoleWrite("appKey=" & $_appKey & " appSecret=" & $_appSecret & " email=" & urlencode($_email) &@CRLF)
	Return _HTTP_Post($_webinarAPI & "api/app/sessions/get.action","appKey=" & $_appKey & "&appSecret=" & $_appSecret & "&email=" & urlencode($_email))
EndFunc

Func ScheduleWebinar($_token, $_title, $_description, $_startDate, $_endDate, $_privacy, $_timeZone, $_watermarkEnabled , $_watermark)
	If $_watermarkEnabled = "false" Then
		$_watermark = ""
	Else
		$_watermark = "&watermark=" &  urlencode($_watermark)
	EndIf
	ConsoleWrite("token=" & $_token & "title=" & urlencode($_title) & "&description=" & urlencode($_description) & _
	"&startDate=" & urlencode($_startDate) & "&endDate=" & urlencode($_endDate) & "&privacy=" & $_privacy & _
	"&timeZone=" & $_timeZone & "&watermarkEnabled=" & $_watermarkEnabled & $_watermark &@CRLF)
	Return _HTTP_Post($_webinarAPI & "api/app/lives/schedule.action", "token=" & $_token & "&title=" & urlencode($_title) & "&description=" & urlencode($_description) & _
	"&startDate=" & urlencode($_startDate) & "&endDate=" & urlencode($_endDate) & "&privacy=" & $_privacy & _
	"&timeZone=" & $_timeZone & "&watermarkEnabled=" & $_watermarkEnabled & $_watermark)
EndFunc

Func StartWebinar($_token, $_liveId)
	Return _HTTP_Post($_webinarAPI & "api/app/lives/start.action","token=" & $_token & "&liveId=" & $_liveId )
EndFunc


Func JoinWebinar($_token, $_liveId, $_watermark, $_displayName)
	ConsoleWrite("liveId=" & $_liveId & @CRLF& "APIwatermark=" & $_watermark &@CRLF& "APIdisplayName=" & $_displayName&@CRLF)
	ConsoleWrite("liveId=" & $_liveId & @CRLF& "APIwatermark=" & urlencode($_watermark) &@CRLF& "APIdisplayName=" & urlencode($_displayName)&@CRLF)
	Return _HTTP_Post($_webinarAPI & "api/app/lives/join.action","token=" & $_token & "&liveId=" & $_liveId & "&watermark=" & urlencode($_watermark) & "&displayName=" & urlencode($_displayName))
EndFunc

Func QueryWebinar($_token,$_liveId)
	Return _HTTP_Post($_webinarAPI & "api/app/lives/query.action","token=" & $_token & "&liveId=" & $_liveId )
EndFunc

