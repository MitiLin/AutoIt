#include <MsgBoxConstants.au3>
#include <array.au3>
;~ $str = "[187, 148, 670, 824]"
;~ $aArray = StringRegExp('<test>a</test> <test>b</test> <test>c</Test>', '(?i)<test>(.*?)</test>', 2)
;~ _ArrayDisplay($aArray)


Local $aArray = StringRegExp('[485, 300, 1111, 568]', '(?:\d)+(?!\d)', $STR_REGEXPARRAYGLOBALMATCH)
_ArrayDisplay($aArray)