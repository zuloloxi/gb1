; #FUNCTION# ====================================================================================================================
; Name ..........: LocateBarrack
; Description ...:
; Syntax ........: LocateBarrack([$ArmyCamp = False])
; Parameters ....: $ArmyCamp            - [optional] Flag to set if locating army camp and not barrack Default is False.
; Return values .: None
; Author ........: Code Monkey #19
; Modified ......: KnowJack (June 2015) Sardo 2015-08
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func LocateBarrack($ArmyCamp = False)
	Local $choice = getLocaleString("choiceBarrack")
	Local $stext, $MsgBox, $iCount, $iStupid = 0, $iSilly = 0, $sErrorText = "", $sLocMsg = "", $sInfo, $sArmyInfo
	Local $aGetArmySize[3] = ["", "", ""]
	Local $sArmyInfo = ""

	If $ArmyCamp Then $choice = getLocaleString("choiceArmyCamp")
	SetLog(getLocaleString("logLocatingAC") & $choice & getLocaleString("logLocatingAC2"), $COLOR_BLUE)

	If _GetPixelColor($aTopLeftClient[0], $aTopLeftClient[1], True) <> Hex($aTopLeftClient[2], 6) And _GetPixelColor($aTopRightClient[0], $aTopRightClient[1], True) <> Hex($aTopRightClient[2], 6) Then
		Zoomout()
		Collect()
	EndIf

	While 1
		ClickP($aAway,1,0,"#0361")
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Lucida Sans Unicode", 700)
		$stext =  $sErrorText & @CRLF & getLocaleString("msgboxMsg1") & $choice & getLocaleString("msgboxMsg1_2") & @CRLF & @CRLF & _
		getLocaleString("msgboxMsg2")& @CRLF & @CRLF & getLocaleString("msgboxMsg3") & @CRLF
		$MsgBox = _ExtMsgBox(0, getLocaleString("msgboxControlOk"), getLocaleString("msgboxControlLocate") & $choice, $stext, 15, $frmBot)
		If $MsgBox = 1 Then
			WinActivate($HWnD)
			If $ArmyCamp Then
				$ArmyPos[0] = FindPos()[0]
				$ArmyPos[1] = FindPos()[1]
				If _Sleep($iDelayLocateBarrack1) Then Return
				If isInsideDiamond($ArmyPos) = False Then
					$iStupid += 1
					Select
						Case $iStupid = 1
							$sErrorText = $choice & getLocaleString("txtLocationNotValid")&@CRLF
							SetLog(getLocaleString("logStupidCase1"), $COLOR_RED)
							ContinueLoop
						Case $iStupid = 2
							$sErrorText = getLocaleString("txtStupidCase2") & @CRLF
							ContinueLoop
						Case $iStupid = 3
							$sErrorText = getLocaleString("txtStupidCase3") & $ArmyPos[0] & "," & $ArmyPos[1] & getLocaleString("txtStupidCase3_2",1) & @CRLF
							ContinueLoop
						Case $iStupid = 4
							$sErrorText = getLocaleString("txtStupidCase4",1) & @CRLF
							ContinueLoop
						Case $iStupid > 4
							SetLog(getLocaleString("txtOperatorErr") & $choice & getLocaleString("txtOperatorErr2") & "(" & $ArmyPos[0] & "," & $ArmyPos[1] & ")", $COLOR_RED)
							ClickP($aAway,1,0,"#0362")
							Return False
						Case Else
							SetLog(getLocaleString("txtOperatorErr") & $choice & getLocaleString("txtOperatorErr2") & "(" & $ArmyPos[0] & "," & $ArmyPos[1] & ")", $COLOR_RED)
							$ArmyPos[0] = -1
							$ArmyPos[1] = -1
							ClickP($aAway,1,0,"#0363")
							Return False
					EndSelect
				EndIf
				$sArmyInfo = BuildingInfo(242, 520)
				If $sArmyInfo[0] > 1 Or $sArmyInfo[0] = "" Then
					If  StringInStr($sArmyInfo[1], "Army") = 0 Then
						If $sArmyInfo[0] = "" Then
							$sLocMsg = getLocaleString("txtLocMsgNothing")
						Else
							$sLocMsg = $sArmyInfo[1]
						EndIf
						$iSilly += 1
						Select
							Case $iSilly = 1
								$sErrorText = getLocaleString("txtSillyCaseArmyCamp") & $sLocMsg & @CRLF
								ContinueLoop
							Case $iSilly = 2
								$sErrorText = getLocaleString("txtSillyCase2") & $sLocMsg & @CRLF
								ContinueLoop
							Case $iSilly = 3
								$sErrorText = getLocaleString("txtSillyCase3") & $sLocMsg & getLocaleString("txtSillyCase3_2",1) & @CRLF
								ContinueLoop
							Case $iSilly = 4
								$sErrorText = $sLocMsg & " ?!?!?!" & @CRLF & @CRLF & getLocaleString("txtStupidCase4",1) & @CRLF
								ContinueLoop
							Case $iSilly > 4
								SetLog(getLocaleString("txtSillyCase4AC"), $COLOR_RED)
								$ArmyPos[0] = -1
								$ArmyPos[1] = -1
								ClickP($aAway,1,0,"#0364")
								Return False
						EndSelect
					EndIf
				Else
					SetLog(getLocaleString("txtOperatorErr") & $choice & getLocaleString("txtOperatorErr2") & "(" & $ArmyPos[0] & "," & $ArmyPos[1] & ")", $COLOR_RED)
					$ArmyPos[0] = -1
					$ArmyPos[1] = -1
					ClickP($aAway,1,0,"#0365")
					Return False
				EndIf
				SetLog($choice & ": " & "(" & $ArmyPos[0] & "," & $ArmyPos[1] & ")", $COLOR_GREEN)
			Else
				$barrackPos[0] = FindPos()[0]
				$barrackPos[1] = FindPos()[1]
				If isInsideDiamond($barrackPos) = False Then
					$iStupid += 1
					Select
						Case $iStupid = 1
							$sErrorText = $choice & getLocaleString("txtLocationNotValid")&@CRLF
							SetLog(getLocaleString("logStupidCase1"), $COLOR_RED)
							ContinueLoop
						Case $iStupid = 2
							$sErrorText = getLocaleString("txtStupidCase2") & @CRLF
							ContinueLoop
						Case $iStupid = 3
							$sErrorText = getLocaleString("txtStupidCase3") &$barrackPos[0] & "," & $barrackPos[1] & getLocaleString("txtStupidCase3_2",1) & @CRLF
							ContinueLoop
						Case $iStupid = 4
							$sErrorText = getLocaleString("txtStupidCase4",1) & @CRLF
							ContinueLoop
						Case $iStupid > 4
							SetLog(getLocaleString("txtOperatorErr") & $choice & getLocaleString("txtOperatorErr2") & "(" & $barrackPos[0] & "," & $barrackPos[1] & ")", $COLOR_RED)
							ClickP($aAway,1,0,"#0366")
							Return False
						Case Else
							SetLog(getLocaleString("txtOperatorErr") & $choice & getLocaleString("txtOperatorErr2") & "(" & $barrackPos[0] & "," & $barrackPos[1] & ")", $COLOR_RED)
							$barrackPos[0] = -1
							$barrackPos[1] = -1
							ClickP($aAway,1,0,"#0367")
							Return False
					EndSelect
				EndIf
				$sInfo = BuildingInfo(242, 520)
				If $sInfo[0] > 1 Or $sInfo[0] = "" Then
					If  StringInStr($sInfo[1], "Barr") = 0 Then
						If $sInfo[0] = "" Then
							$sLocMsg = getLocaleString("txtLocMsgNothing")
						Else
							$sLocMsg = $sInfo[1]
						EndIf
						$iSilly += 1
						Select
							Case $iSilly = 1
								$sErrorText = getLocaleString("txtSillyCaseBarracks") & $sLocMsg & @CRLF
								ContinueLoop
							Case $iSilly = 2
								$sErrorText = getLocaleString("txtSillyCase2") & $sLocMsg & @CRLF
								ContinueLoop
							Case $iSilly = 3
								$sErrorText = getLocaleString("txtSillyCase3") & $sLocMsg & getLocaleString("txtSillyCase3_2",1) & @CRLF
								ContinueLoop
							Case $iSilly = 4
								$sErrorText = $sLocMsg&" ?!?!?!"&@CRLF&@CRLF&getLocaleString("txtStupidCase4",1) & @CRLF
								ContinueLoop
							Case $iSilly > 4
								SetLog(getLocaleString("txtSillyCase4Barr"), $COLOR_RED)
								$barrackPos[0] = -1
								$barrackPos[1] = -1
								ClickP($aAway,1,0,"#0368")
								Return False
						EndSelect
					EndIf
				Else
					SetLog(getLocaleString("txtOperatorErr") & $choice & getLocaleString("txtOperatorErr2") & "(" & $barrackPos[0] & "," & $barrackPos[1] & ")", $COLOR_RED)
					$barrackPos[0] = -1
					$barrackPos[1] = -1
					ClickP($aAway,1,0,"#0369")
					Return False
				EndIf
				SetLog(getLocaleString("logLocateSuccess") & $choice & ": " & "(" & $barrackPos[0] & "," & $barrackPos[1] & ")", $COLOR_GREEN)
			EndIf
		Else
			SetLog(getLocaleString("logLocateCancelled") & $choice & getLocaleString("logLocateCancelled2"), $COLOR_BLUE)
			ClickP($aAway,1,0,"#0370")
			Return
		EndIf
		ExitLoop
	WEnd
	If $ArmyCamp Then
		$TotalCamp = 0 ; reset total camp number to get it updated
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Lucida Sans Unicode", 500)
		$stext = getLocaleString("msgboxMsgAC")
		$MsgBox = _ExtMsgBox(48, getLocaleString("msgboxMsgACControls"), getLocaleString("msgboxMsgACTitle"), $stext, 15, $frmBot)
		If _Sleep($iDelayLocateBarrack1) Then Return

		ClickP($aAway,1,0,"#0371") ;Click Away
		If _Sleep($iDelayLocateBarrack3) Then Return

		Click($aArmyTrainButton[0], $aArmyTrainButton[1],1,0,"#0372") ;Click Army Camp
		If _Sleep($iDelayLocateBarrack1) Then Return

		$iCount = 0  ; reset loop counter
		$sArmyInfo = getArmyCampCap(212, 144) ; OCR read army trained and total
		If $debugSetlog = 1 Then Setlog("$sArmyInfo = " & $sArmyInfo, $COLOR_PURPLE)
		While $sArmyInfo = ""  ; In case the CC donations recieved msg are blocking, need to keep checking numbers for 10 seconds
			If _Sleep($iDelayLocateBarrack2) Then Return
			$sArmyInfo = getArmyCampCap(212, 144) ; OCR read army trained and total
			If $debugSetlog = 1 Then Setlog(" $sArmyInfo = " & $sArmyInfo, $COLOR_PURPLE)
			$iCount += 1
			If $iCount > 4 Then ExitLoop
		WEnd

		$aGetArmySize = StringSplit($sArmyInfo, "#") ; split the trained troop number from the total troop number
		If $debugSetlog = 1 Then Setlog("$aGetArmySize[0]= " & $aGetArmySize[0] & "$aGetArmySize[1]= " & $aGetArmySize[1] & "$aGetArmySize[2]= " & $aGetArmySize[2], $COLOR_PURPLE)
		If $aGetArmySize[0] > 1 Then ; check if the OCR was valid and returned both values
			$TotalCamp = Number($aGetArmySize[2])
			Setlog("$TotalCamp = " & $TotalCamp, $COLOR_GREEN)
		Else
			Setlog("Army size read error", $COLOR_RED) ; log if there is read error
		EndIf

		If $TotalCamp = 0 Then ; if Total camp size is still not set
			If $ichkTotalCampForced = 0 Then ; check if forced camp size set in expert tab
				$sInputbox = InputBox(getLocaleString("msgboxMsgForceAcTitle"), getLocaleString("msgboxMsgForceAc"), "200", "", Default, Default, Default, Default, 0, $frmbot)
				$TotalCamp = Number($sInputbox)
				Setlog("Army Camp User input = " & $TotalCamp, $COLOR_RED) ; log if there is read error AND we ask the user to tell us.
			Else
				$TotalCamp = Number($iValueTotalCampForced)
			EndIf
		EndIf
	EndIf
	ClickP($aAway, 1, 0, "#0206")

EndFunc   ;==>LocateBarrack
