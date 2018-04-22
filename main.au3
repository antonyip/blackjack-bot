#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <ScreenCapture.au3>

AutoItSetOption("MustDeclareVars", 1)
; Litecoin blackjack | Crypto-Games.net - Google Chrome
; go to webpage - https://www.crypto-games.net/blackjack/litecoin

; statemachine stuffs..
Local Const $NEWGAMESTATE = "NEWGAMESTATE"
Local Const $BETTINGSTATE = "BETTINGSTATE"
Local Const $CONFIRMBETTINGSTATE = "CONFIRMBETTINGSTATE"
Local Const $DEALINGSTATE = "DEALINGSTATE"
Local Const $DEALINGSTATE_BJ = "DEALINGSTATE_BJ"
Local Const $INGAMESTATE = "INGAMESTATE"
Local Const $LOOKINGATCARDSSTATE = "LOOKINGATCARDSSTATE"
Local Const $HITSTATE = "HITSTATE"
Local Const $HITSTATE2 = "HITSTATE2"
Local Const $HITSTATE3 = "HITSTATE3"
Local Const $STANDSTATE = "STANDSTATE"
Local Const $GAMEOVERSTATE = "GAMEOVERSTATE"
Local Const $WONSTATE = "WONSTATE"
Local Const $LOSTSTATE = "LOSTSTATE"
Local Const $DRAWSTATE = "DRAWSTATE"
Local Const $SPILTSTATE = "SPILTSTATE"
Local Const $DOUBLESTANDSTATE = "DOUBLESTANDSTATE"
Local Const $DOUBLEHITSTATE = "DOUBLEHITSTATE"
Local Const $ERRORSTATE = "ERRORSTATE"
Local Const $DRAWONESTATE = "DRAWONESTATE"
Local Const $DRAWTWOSTATE = "DRAWTWOSTATE"
Local Const $DRAWTHREESTATE = "DRAWTHREESTATE"
Local Const $SURRENDERSTATE = "SURRENDERSTATE"


; gambling variables
Local $currentState = $NEWGAMESTATE
Local $currentLose = 0
Local $baseBetAmount = 1
Local $betAmount = 1
Local $ControlFolderPath = "C:\Users\AntonWin10\Desktop\Blackjack Player\controlimg"
Local $CardsDrawn = 0

; debug variables
Local $thisErrorState = ""
Local $DebugFolderPath = "C:\Users\AntonWin10\Desktop\Blackjack Player\debug"
Local $HeartBeatCounter = 0

; Local Storage Variables
Local $playerCard1Image
Local $playerCard2Image
Local $playerCard3Image
Local $playerCard4Image
Local $playerCard5Image
Local $dealerCardImage
Local Const $StartOfPlayerCardPosX = 440
Local Const $StartOfPlayerCardPosY = 531
Local Const $StartOfDealerCardPosX = 440
Local Const $StartOfDealerCardPosY = 314
Local Const $BetweenCards = 13
Local Const $CardWidth = 13
Local Const $CardHeight = 13

; Theses are strings
Local $card1Value = ""
Local $card2Value = ""
Local $card3Value = ""
Local $card4Value = ""
Local $card5Value = ""

; this is integer
Local $dealerValue = 0

While(True)
   ; use control pause to exit this loop
   ConsoleWrite("hb:" & Heartbeat() & " " & $currentState & @CRLF)
   If ($currentState == $NEWGAMESTATE) Then
	  ; Game is over, prepare for betting
	  MouseMove(10,10)
	  If ImageCompare(CaptureMacro($NEWGAMESTATE), ControlImage($NEWGAMESTATE)) Then
		 $currentState = $BETTINGSTATE
	  EndIf
   ElseIf ($currentState == $BETTINGSTATE) Then
	  For $counter = 1 To $betAmount Step 1
		 ; Place chips on the table
		 MouseClick("left", 588, 665); 10 dollar chips
		 ;MouseClick("left", 630, 656) ; 100 dollar chips
		 Sleep(150)
	  Next

	  $currentState = $CONFIRMBETTINGSTATE
   ElseIf ($currentState == $CONFIRMBETTINGSTATE) Then
	  ; TODO: check if you are really clicking the bet button...
	  MouseClick("left", 504, 652) ;  click the bet button
	  $currentState = $DEALINGSTATE
	  MouseMove(10,10)
	  Sleep(1800)
   ElseIf ($currentState == $DEALINGSTATE) Then
	  $card1Value = ""
	  $card2Value = ""
	  $card3Value = ""
	  $card4Value = ""
	  $card5Value = ""
	  $dealerValue = 0

	  If ImageCompare(CaptureMacro($DEALINGSTATE), ControlImage($DEALINGSTATE)) Then
		 $currentState = $INGAMESTATE
	  ElseIf ImageCompare(CaptureMacro($DEALINGSTATE_BJ), ControlImage($DEALINGSTATE_BJ)) Then
		 $currentState = $WONSTATE
	  EndIf
   ElseIf ($currentState == $INGAMESTATE) Then

	  $playerCard1Image = CapturePlayerCard(0)
	  $playerCard2Image = CapturePlayerCard(1)
	  $dealerCardImage = Capture($StartOfDealerCardPosX,$StartOfDealerCardPosY,$StartOfDealerCardPosX+$CardWidth,$StartOfDealerCardPosY+$CardHeight)
;~ 	  DebugImage($playerCard1Image, "card1.png")
;~ 	  DebugImage($playerCard2Image, "card2.png")
;~ 	  DebugImage($dealerCardImage, "dcard.png")
	  $card1Value = GetValueOfCard($playerCard1Image, "cleanp1.png")
	  $card2Value = GetValueOfCard($playerCard2Image, "cleanp2.png")
	  $dealerValue = GetValueOfCard($dealerCardImage, "cleand1.png")

	  ; TODO some error checking here..

	  $currentState = CompareCards($card1Value, $card2Value, $dealerValue)

	  ; Assert(false,"pause")
	  ; $currentState = $ERRORSTATE
   ElseIf ($currentState == $HITSTATE) Then
	  MouseMove(10,10)
	  If ImageCompare(CaptureMacro($HITSTATE), ControlImage($HITSTATE)) Then
		 $currentState = $DRAWONESTATE
		 MouseClick("left",451,653);  click the hit button
		 Sleep(1000)
	  EndIf
   ElseIf ($currentState == $HITSTATE2) Then
	  MouseMove(10,10)
	  If ImageCompare(CaptureMacro($HITSTATE), ControlImage($HITSTATE)) Then
		 $currentState = $DRAWTWOSTATE
		 MouseClick("left",451,653);  click the hit button
		 Sleep(1000)
	  EndIf
   ElseIf ($currentState == $HITSTATE3) Then
	  MouseMove(10,10)
	  If ImageCompare(CaptureMacro($HITSTATE), ControlImage($HITSTATE)) Then
		 $currentState = $DRAWTHREESTATE
		 MouseClick("left",451,653);  click the hit button
		 Sleep(1000)
	  EndIf
   ElseIf ($currentState == $DRAWONESTATE) Then
	  $playerCard3Image = CapturePlayerCard(2)
	  $card3Value = GetValueOfCard($playerCard3Image, "cleanp3.png")
	  Local $cardsValue = CalculateCardsValue3($card1Value, $card2Value, $card3Value)
	  $currentState = WhatToDoNormal($cardsValue, $dealerValue)
	  ConsoleWrite("Draw1Action: " & $currentState  & " p: " & $cardsValue & " d: " & $dealerValue & @CRLF)
	  if $currentState == $HITSTATE Then
		 $currentState = $HITSTATE2
	  EndIf
   ElseIf ($currentState == $DRAWTWOSTATE) Then
	  $playerCard4Image = CapturePlayerCard(3)
	  $card4Value = GetValueOfCard($playerCard4Image, "cleanp4.png")
	  Local $cardsValue = CalculateCardsValue4($card1Value, $card2Value, $card3Value, $card4Value)
	  $currentState = WhatToDoNormal($cardsValue, $dealerValue)
	  ConsoleWrite("Draw2Action: " & $currentState  & " p: " & $cardsValue & " d: " & $dealerValue & @CRLF)
	  if $currentState == $HITSTATE Then ; TODO: handle more cards
		 $currentState = $HITSTATE3
	  EndIf
   ElseIf ($currentState == $DRAWTHREESTATE) Then
	  $playerCard5Image = CapturePlayerCard(4)
	  $card5Value = GetValueOfCard($playerCard5Image, "cleanp5.png")
	  Local $cardsValue = CalculateCardsValue5($card1Value, $card2Value, $card3Value, $card4Value, $card5Value)
	  $currentState = WhatToDoNormal($cardsValue, $dealerValue)
	  ConsoleWrite("Draw3Action: " & $currentState  & " p: " & $cardsValue & " d: " & $dealerValue & @CRLF)
	  if $currentState == $HITSTATE Then ; TODO: handle more cards
		 $currentState = $ERRORSTATE
	  EndIf
   ElseIf ($currentState == $STANDSTATE) Then
	  MouseMove(10,10)
	  If ImageCompare(CaptureMacro($STANDSTATE), ControlImage($STANDSTATE)) Then
		 MouseClick("left",505,659);  click the hit button
		 $currentState = $GAMEOVERSTATE
	  EndIf
   ElseIf ($currentState == $GAMEOVERSTATE) Then
	  If ImageCompare(CaptureMacro($LOSTSTATE), ControlImage($LOSTSTATE)) Then
		 $currentState = $LOSTSTATE
	  ElseIf ImageCompare(CaptureMacro($WONSTATE), ControlImage($WONSTATE)) Then
		 $currentState = $WONSTATE
	  ElseIf ImageCompare(CaptureMacro($DRAWSTATE), ControlImage($DRAWSTATE)) Then
		 $currentState = $DRAWSTATE
	  EndIf
   ElseIf ($currentState == $LOSTSTATE) Then
	  ;$betAmount = $betAmount * 2
	  MouseClick("left", 448, 658) ;  click the clear button
	  $currentState = $NEWGAMESTATE
   ElseIf ($currentState == $WONSTATE) Then
	  $betAmount = $baseBetAmount
	  MouseClick("left", 448, 658) ;  click the clear button
	  $currentState = $NEWGAMESTATE
   ElseIf ($currentState == $DRAWSTATE) Then
	  MouseClick("left", 506, 663) ;  click the clear button
	  $currentState = $DEALINGSTATE
   ElseIf ($currentState == $SURRENDERSTATE) Then
	  If ImageCompare(CaptureMacro($SURRENDERSTATE), ControlImage($SURRENDERSTATE)) Then
		 MouseClick("left", 401, 647) ;  click the surrender button
		 $currentState = $LOSTSTATE
	  EndIf
   ElseIf ($currentState == $DOUBLESTANDSTATE) Then
	  If ImageCompare(CaptureMacro($DOUBLESTANDSTATE), ControlImage($DOUBLESTANDSTATE)) Then
		 MouseClick("left", 348, 646) ;  click the surrender button
		 $currentState = $GAMEOVERSTATE
	  EndIf
   ElseIf ($currentState == $DOUBLEHITSTATE) Then
	  If ImageCompare(CaptureMacro($DOUBLEHITSTATE), ControlImage($DOUBLEHITSTATE)) Then
		 MouseClick("left", 348, 646) ;  click the surrender button
		 $currentState = $GAMEOVERSTATE
	  EndIf
   ElseIf ($currentState == $SPILTSTATE) Then
	  ExitLoop
   ElseIf ($currentState == $ERRORSTATE) Then
	  MouseMove(10,10)
	  $currentState = $ERRORSTATE
	  ExitLoop
   EndIf
WEnd

; starts from 0 like a programmer
Func CapturePlayerCard($index)
   Local $spaceBetweenCards = $index * $BetweenCards
   return Capture(   $StartOfPlayerCardPosX + $spaceBetweenCards,   $StartOfPlayerCardPosY,   ($StartOfPlayerCardPosX + $spaceBetweenCards) + $CardWidth,   $StartOfPlayerCardPosY + $CardHeight)
EndFunc

; Main function ends - only helper functions left below --------
; Configurable Stuffs per PC ------------- Start --------------
Func CaptureMacro($enumState)
   If ($enumState == $NEWGAMESTATE) Then
	  return Capture(181,277,649,714)
   ElseIf ($enumState == $DEALINGSTATE) Then
	  return Capture(322,601,370,686)
   ElseIf ($enumState == $DEALINGSTATE_BJ) Then
	  return Capture(430,565,537,581)
   ElseIf ($enumState == $HITSTATE) Then
	  return Capture(437,640,472,693)
   ElseIf ($enumState == $STANDSTATE) Then
	  return Capture(491,637,514,671)
   ElseIf ($enumState == $WONSTATE) Then
	  return Capture(409,477,430,491)
   ElseIf ($enumState == $LOSTSTATE) Then
	  return Capture(436,475,471,491)
   ElseIf ($enumState == $DRAWSTATE) Then
	  return Capture(436,475,471,491)
   ElseIf ($enumState == $SURRENDERSTATE) Then
	  return Capture(385,633,413,667)
   ElseIf ($enumState == $DOUBLEHITSTATE) Then
	  return Capture(309,601,357,681)
   ElseIf ($enumState == $DOUBLESTANDSTATE) Then
	  return Capture(309,601,357,681)
   Else
	  Assert(false, "Invalid Capture Macro Function")
   EndIf
   return DebugImage(Capture())
EndFunc

Func ControlImage($enumState)
   Local $FolderPath = $ControlFolderPath

   If ($enumState == $NEWGAMESTATE) Then
	  Return LoadImgFromFile($FolderPath & "\NEWGAMESTATE.png")
   ElseIf ($enumState == $DEALINGSTATE) Then
	  Return LoadImgFromFile($FolderPath & "\DEALINGSTATE.png")
   ElseIf ($enumState == $DEALINGSTATE_BJ) Then
	  Return LoadImgFromFile($FolderPath & "\DEALINGSTATE_BJ.png")
   ElseIf ($enumState == $HITSTATE) Then
	  Return LoadImgFromFile($FolderPath & "\HITSTATE.png")
   ElseIf ($enumState == $STANDSTATE) Then
	  Return LoadImgFromFile($FolderPath & "\STANDSTATE.png")
   ElseIf ($enumState == $WONSTATE) Then
	  Return LoadImgFromFile($FolderPath & "\WONSTATE.png")
   ElseIf ($enumState == $LOSTSTATE) Then
	  Return LoadImgFromFile($FolderPath & "\LOSTSTATE.png")
   ElseIf ($enumState == $DRAWSTATE) Then
	  Return LoadImgFromFile($FolderPath & "\DRAWSTATE.png")
   ElseIf ($enumState == $SURRENDERSTATE) Then
	  Return LoadImgFromFile($FolderPath & "\SURRENDERSTATE.png")
   ElseIf ($enumState == $DOUBLEHITSTATE) Then
	  Return LoadImgFromFile($FolderPath & "\DOUBLEHITSTATE.png")
   ElseIf ($enumState == $DOUBLESTANDSTATE) Then
	  Return LoadImgFromFile($FolderPath & "\DOUBLESTANDSTATE.png")
   Else
	  Assert(false, "Invalid Control Image")
   EndIf

   Return LoadImgFromFile($FolderPath & "\dummy.png")
EndFunc
; Configurable Stuffs per PC ------------- End --------------

; All Other functions
Func WhatToDoFirst($player, $dealer)
   If $player == 10 Then
	  If $dealer == 10 Then
		 Return $HITSTATE
	  EndIf

	  If $dealer == 1 Then
		 Return $HITSTATE
	  EndIf
	  Return $DOUBLEHITSTATE
   EndIf

   If $player == 11 Then
	  Return $DOUBLEHITSTATE
   EndIf

   If $player == 15 Then
	  If $dealer == 10 Then
		 Return $SURRENDERSTATE
	  EndIf
	  If $dealer == 1 Then
		 Return $SURRENDERSTATE
	  EndIf
   EndIf

   If $player == 16 Then
	  If $dealer == 9 Then
		 Return $SURRENDERSTATE
	  EndIf
	  If $dealer == 10 Then
		 Return $SURRENDERSTATE
	  EndIf
	  If $dealer == 1 Then
		 Return $SURRENDERSTATE
	  EndIf
   EndIf

   If $player == 17 Then
	  If $dealer == 1 Then
		 Return $SURRENDERSTATE
	  EndIf
   EndIf

   Return WhatToDoNormal($player, $dealer)
EndFunc

Func WhatToDoNormal($player, $dealer)
   If $player < 12 Then
	  Return $HITSTATE
   EndIf

   IF $player == 12 Then
	  IF $dealer == 2 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 3 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 4 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 5 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 6 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 7 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 8 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 9 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 10 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 1 Then
		 Return $HITSTATE
	  EndIf
   EndIf

   IF $player == 13 Then
	  IF $dealer == 2 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 3 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 4 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 5 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 6 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 7 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 8 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 9 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 10 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 1 Then
		 Return $HITSTATE
	  EndIf
   EndIf

   IF $player == 14 Then
	  IF $dealer == 2 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 3 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 4 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 5 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 6 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 7 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 8 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 9 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 10 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 1 Then
		 Return $HITSTATE
	  EndIf
   EndIf

   IF $player == 15 Then
	  IF $dealer == 2 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 3 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 4 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 5 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 6 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 7 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 8 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 9 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 10 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 1 Then
		 Return $HITSTATE
	  EndIf
   EndIf

   IF $player == 16 Then
	  IF $dealer == 2 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 3 Then
		 Return $STANDSTATE
	  EndIf
	   IF $dealer == 4 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 5 Then
		 Return $STANDSTATE
	  EndIf
	   IF $dealer == 6 Then
		 Return $STANDSTATE
	  EndIf
	  IF $dealer == 7 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 8 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 9 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 10 Then
		 Return $HITSTATE
	  EndIf
	  IF $dealer == 1 Then
		 Return $HITSTATE
	  EndIf
   EndIf

   If $player == 17 Then
	  Return $STANDSTATE
   EndIf
   If $player == 18 Then
	  Return $STANDSTATE
   EndIf
   If $player == 19 Then
	  Return $STANDSTATE
   EndIf
   If $player == 20 Then
	  Return $STANDSTATE
   EndIf

   If $player > 20 Then
	  Return $GAMEOVERSTATE
   EndIf

   Assert(false, "Unprogrammed State")
   Return $ERRORSTATE
EndFunc

Func WhatToDoAce($player, $dealer)
   Local $othercard = $player - 1

   If $othercard == 1 Then
	  Return $SPILTSTATE
   EndIf

   If $othercard == 2 Then
	  If $dealer == 5 Then
		 Return $DOUBLEHITSTATE
	  EndIf
	  If $dealer == 6 Then
		 Return $DOUBLEHITSTATE
	  EndIf

	  Return $HITSTATE
   EndIf

   If $othercard == 3 Then
	  If $dealer == 5 Then
		 Return $DOUBLEHITSTATE
	  EndIf
	  If $dealer == 6 Then
		 Return $DOUBLEHITSTATE
	  EndIf
	  Return $HITSTATE
   EndIf

   If $othercard == 4 Then
	  If $dealer == 4 Then
		 Return $DOUBLEHITSTATE
	  EndIf
	  If $dealer == 5 Then
		 Return $DOUBLEHITSTATE
	  EndIf
	  If $dealer == 6 Then
		 Return $DOUBLEHITSTATE
	  EndIf
	  Return $HITSTATE
   EndIf

   If $othercard == 5 Then
	  If $dealer == 4 Then
		 Return $DOUBLEHITSTATE
	  EndIf
	  If $dealer == 5 Then
		 Return $DOUBLEHITSTATE
	  EndIf
	  If $dealer == 6 Then
		 Return $DOUBLEHITSTATE
	  EndIf
	  Return $HITSTATE
   EndIf

   If $othercard == 6 Then
	  If $dealer == 3 Then
		 Return $DOUBLEHITSTATE
	  EndIf
	  	  If $dealer == 4 Then
		 Return $DOUBLEHITSTATE
	  EndIf
	  	  If $dealer == 5 Then
		 Return $DOUBLEHITSTATE
	  EndIf
	  	  If $dealer == 6 Then
		 Return $DOUBLEHITSTATE
	  EndIf
	  Return $HITSTATE
   EndIf

   If $othercard == 7 Then
	  If $dealer == 7 Then
		 Return $STANDSTATE
	  EndIf
	  If $dealer == 8 Then
		 Return $STANDSTATE
	  EndIf
	  If $dealer == 9 Then
		 Return $HITSTATE
	  EndIf
	  If $dealer == 10 Then
		 Return $HITSTATE
	  EndIf
	  If $dealer == 1 Then
		 Return $HITSTATE
	  EndIf
	  Return $DOUBLEHITSTATE
   EndIf

   If $othercard == 8 Then
	  If $dealer == 6 Then
		 Return $DOUBLEHITSTATE
	  EndIf
	  Return $STANDSTATE
   EndIf

   If $othercard == 9 Then
	  Return $STANDSTATE
   EndIf
EndFunc

Func CompareCards($card1, $card2, $dealercard)
   Local $haveAce = False
   Local $spiltable = False

   If ($card1 == "A") Then
	  $haveAce = true
   EndIf
   If ($card2 == "A") Then
	  $haveAce = true
   EndIf

   Local $card1IntValue = ValueOfCard($card1)
   Local $card2IntValue = ValueOfCard($card2)
   ; handled differently
   $dealerValue = ValueOfCard($dealercard)

   If ($card1IntValue == $card2IntValue) Then
	  If NOT ($card1IntValue == 10) Then
		 $spiltable = true
	  EndIf
   EndIf

   ; normal blackjack rules
   If Not $spiltable Then
	  If Not $haveAce Then
		 ConsoleWrite("cardvalue: " & $card1IntValue + $card2IntValue & " dealer: " & $dealerValue & @CRLF)
		 Return WhatToDoFirst($card1IntValue + $card2IntValue, $dealerValue)
	  EndIf
   EndIf

   If $haveAce Then
	  Return WhatToDoAce($card1IntValue + $card2IntValue, $dealerValue)
   EndIf

   If $spiltable Then
	  ; dont' need to handle double aces here..
	  ; TODO: Spilt Logic
	  Return WhatToDoFirst($card1IntValue + $card2IntValue, $dealerValue)
	  ; Return $SPILTSTATE
	  EndIf

   Return $ERRORSTATE
EndFunc

Func Assert($condition, $msg)
   If ($condition == False) Then
	  $thisErrorState = $msg
	  ConsoleWrite($msg);
	  Sleep(1000000)
   EndIf
EndFunc

Func CalculateCardsValue2($card1string, $card2string)
   Local $val1 = ValueOfCard($card1string)
   Local $val2 = ValueOfCard($card2string)
   Local $retVal = $val1 + $val2

   If ( $retVal < 12 ) Then
	  If ($val1 == 1 or $val2 == 1) Then
		 $retVal += 10
	  EndIf
   EndIf

   return $retVal
EndFunc

Func CalculateCardsValue3($card1string, $card2string, $card3string)
   Local $val1 = ValueOfCard($card1string)
   Local $val2 = ValueOfCard($card2string)
   Local $val3 = ValueOfCard($card3string)
   Local $retVal = $val1 + $val2 + $val3

   If ( $retVal < 12 ) Then
	  If ($val1 == 1 or $val2 == 1 or $val3 == 1) Then
		 $retVal += 10
	  EndIf
   EndIf

   return $retVal
EndFunc

Func CalculateCardsValue4($card1string, $card2string, $card3string, $card4string)
   Local $val1 = ValueOfCard($card1string)
   Local $val2 = ValueOfCard($card2string)
   Local $val3 = ValueOfCard($card3string)
   Local $val4 = ValueOfCard($card4string)
   Local $retVal = $val1 + $val2  + $val3 + $val4

   If ( $retVal < 12 ) Then
	  If ($val1 == 1 or $val2 == 1 or $val3 == 1 or $val4 == 1) Then
		 $retVal += 10
	  EndIf
   EndIf

   return $retVal
EndFunc

Func CalculateCardsValue5($card1string, $card2string, $card3string, $card4string, $card5string)
   Local $val1 = ValueOfCard($card1string)
   Local $val2 = ValueOfCard($card2string)
   Local $val3 = ValueOfCard($card3string)
   Local $val4 = ValueOfCard($card4string)
   Local $val5 = ValueOfCard($card5string)
   Local $retVal = $val1 + $val2  + $val3 + $val4 + $val5

   If ( $retVal < 12 ) Then
	  If ($val1 == 1 or $val2 == 1 or $val3 == 1 or $val4 == 1 or $val5 == 1) Then
		 $retVal += 10
	  EndIf
   EndIf

   return $retVal
EndFunc

Func ValueOfCard($stringCard)
   If $stringCard == "2" Then
	  Return 2
	  EndIf
   If $stringCard == "3" Then
	  Return 3
	  EndIf
   If $stringCard == "4" Then
	  Return 4
	  EndIf
   If $stringCard == "5" Then
	  Return 5
	  EndIf
   If $stringCard == "6" Then
	  Return 6
	  EndIf
   If $stringCard == "7" Then
	  Return 7
	  EndIf
   If $stringCard == "8" Then
	  Return 8
	  EndIf
   If $stringCard == "9" Then
	  Return 9
	  EndIf
   If $stringCard == "T" Then
	  Return 10
	  EndIf
   If $stringCard == "J" Then
	  Return 10
	  EndIf
   If $stringCard == "Q" Then
	  Return 10
	  EndIf
   If $stringCard == "K" Then
	  Return 10
	  EndIf
   If $stringCard == "A" Then
	  Return 1
	  EndIf

   Assert(false, "Should never happen: "  & $stringCard)
EndFunc

Func Heartbeat()
   Sleep(1000)
   $HeartBeatCounter += 1
   Return $HeartBeatCounter
EndFunc

Func Capture($left = 0, $top = 0, $right = -1, $bottom = -1)
   ;https://www.autoitscript.com/autoit3/docs/libfunctions/_ScreenCapture_Capture.htm
   ;Local $hBmp = _ScreenCapture_Capture("", 0,0,@DesktopWidth, @DesktopHeight)
   _GDIPlus_Startup()
   Local $hBmp = _ScreenCapture_Capture("", $left, $top, $right, $bottom)
   ; TODO: Clear this memory - https://www.autoitscript.com/autoit3/docs/libfunctions/_GDIPlus_Startup.htm
   Local $tmp = _GDIPlus_BitmapCreateFromHBITMAP($hBmp)
   Assert(@error, "Errors on ScreenCapture")
   _WinAPI_DeleteObject($hBmp)
   Return $tmp;
EndFunc

Func LoadImgFromFile($filename)
   _GDIPlus_Startup()
   ; TODO: Clear this memory - https://www.autoitscript.com/autoit3/docs/libfunctions/_GDIPlus_Startup.htm
   Return _GDIPlus_BitmapCreateFromFile($filename) ;TODO: Clear this memory

EndFunc


Func DebugImage($gdiBmp, $filename = "currentImg.png")
   Local $retVal = _GDIPlus_ImageSaveToFile ( $gdiBmp, $DebugFolderPath & "\" & $filename )
   Assert($retVal == True, "Errors on Debug Image : ReturnValue")
   Assert(@error, "Errors on Debug Image : Error")
EndFunc

Func ExtractXorValColorWeighted($xorVal)

   ; i just want to compare the most significant 4
   Local $colora = BitShift(BitAND($xorVal, 0xF0000000), 24)
   Local $colorr = BitShift(BitAND($xorVal, 0x00F00000), 16)
   Local $colorg = BitShift(BitAND($xorVal, 0x0000F000), 8)
   Local $colorb = BitShift(BitAND($xorVal, 0x000000F0), 0)

   Local $retVal = 0;
   For $bitPos = 0 To 7 ; autoit is inclusive (this is like c++ for (int i = 0; i < 32; ++i) )
	  If BitAND($colora , BitShift(1, -$bitPos)) > 0 Then
		 $retVal += $bitPos
	  EndIf
	  If BitAND($colorr , BitShift(1, -$bitPos)) > 0 Then
		 $retVal += $bitPos
	  EndIf
	  If BitAND($colorg , BitShift(1, -$bitPos)) > 0 Then
		 $retVal += $bitPos
	  EndIf
	  If BitAND($colorb , BitShift(1, -$bitPos)) > 0 Then
		 $retVal += $bitPos
	  EndIf
   Next
   return $retVal;
EndFunc

Func ImageCompare($gdi_lhs, $gdi_rhs)
   _GDIPlus_Startup()
   Local $lhs = _GDIPlus_ImageResize($gdi_lhs, 256, 256);
   Assert(@error, "error happened during resize lhs");
   Local $rhs = _GDIPlus_ImageResize($gdi_rhs, 256, 256);
   Assert(@error, "error happened during resize rhs");

   Local $equalCounters = 0;
    For $iY = 0 To 255 Step 1 ; autoit is inclusive (this is like c++ for (int i = 0; i < 256; ++i) )
        For $iX = 0 To 255 Step 1
            Local $lhsc = _GDIPlus_BitmapGetPixel($lhs, $iX, $iY) ;get current pixel color
			Local $rhsc = _GDIPlus_BitmapGetPixel($rhs, $iX, $iY) ;get current pixel color
			Local $xorval = BitXOR($lhsc, $rhsc);

			If $lhsc == $rhsc Then
			   $equalCounters += 1
			ElseIf ExtractXorValColorWeighted($xorval) < 6 Then ; if xor compare has less then 1 numbers different (most sig)
			   $equalCounters += 1
			EndIf
        Next
	 Next

   If ($equalCounters > 250*250 ) Then
	  return True
   Else
	  ;ConsoleWrite("not equal: " & $equalCounters & @CRLF)
	  DebugImage($gdi_lhs, "invalid.png")
   EndIf

   return False

EndFunc

Func ImageCompareNoResize($gdi_lhs, $gdi_rhs, $size)
   _GDIPlus_Startup()
   Local $equalCounters = 0;
    For $iY = 0 To $size - 1 Step 1 ; autoit is inclusive (this is like c++ for (int i = 0; i < 256; ++i) )
        For $iX = 0 To $size - 1 Step 1
            Local $lhsc = _GDIPlus_BitmapGetPixel($gdi_lhs, $iX, $iY) ;get current pixel color
			Local $rhsc = _GDIPlus_BitmapGetPixel($gdi_rhs, $iX, $iY) ;get current pixel color
			Local $xorval = BitXOR($lhsc, $rhsc);

			If $lhsc == $rhsc Then
			   $equalCounters += 1
			ElseIf ExtractXorValColorWeighted($xorval) < 6 Then ; if xor compare has less then 1 numbers different (most sig)
			   $equalCounters += 1
			EndIf
        Next
	 Next

   If ($equalCounters == $size*$size ) Then
	  return True
   EndIf
    ;ConsoleWrite($equalCounters & @CRLF)
   return False
EndFunc

Func CardImageCompare($gdi_lhs, $filename)
   Local $gdi_rhs = LoadImgFromFile($filename)
   ; ConsoleWrite("compare: " & $filename)
   return ImageCompareNoResize($gdi_lhs, $gdi_rhs, 14)
EndFunc

Func CardVerificationCheck($gdi_img)
   ; just check the first row should be all white after clean up
	  For $iY = 0 To $CardHeight Step 1
		 Local $color = _GDIPlus_BitmapGetPixel($gdi_img, 0, $iY)
		 If Not $color == 0xFFFFFFFF Then
			return False
		 EndIf
	  Next
   Return True
EndFunc

Func CardCleanVerification($gdi_img, $imgName)
   ; Make the first last and 2nd last columns all black
	  For $iY = 0 To $CardHeight Step 1
		 _GDIPlus_BitmapSetPixel($gdi_img, 0, $iY,0x00000000)
		 _GDIPlus_BitmapSetPixel($gdi_img, $CardWidth, $iY,0x00000000)
		 _GDIPlus_BitmapSetPixel($gdi_img, $CardWidth-1, $iY,0x00000000)
	  Next

	  DebugImage($gdi_img, $imgName)

   Return True
EndFunc

Func CleanupCardNoise($gdi_img)
   ; autoit is inclusive (this is like c++ for (int i = 0; i < $CardHeight; ++i) )
   For $iY = 0 To $CardHeight Step 1
      For $iX = 0 To $CardWidth Step 1
		 Local $color = _GDIPlus_BitmapGetPixel($gdi_img, $iX, $iY) ;get current pixel color
		 Local $colora = BitShift(BitAND($color, 0xFF000000), 24)
		 Local $colorr = BitShift(BitAND($color, 0x00FF0000), 16)
		 Local $colorg = BitShift(BitAND($color, 0x0000FF00), 8)
		 Local $colorb = BitShift(BitAND($color, 0x000000FF), 0)
		 If $colorr > ($colorb + $colorg) Then
			; its a red pixel - make it white
			_GDIPlus_BitmapSetPixel($gdi_img,$iX, $iY, 0xFFFFFFFF)
		 ElseIf $colorr < 4 And $colorg < 4 And $colorb < 4 Then
			; its a white pixel - make it white
			_GDIPlus_BitmapSetPixel($gdi_img,$iX, $iY, 0xFFFFFFFF)
		 Else
			; it a black pixel - make it black
			_GDIPlus_BitmapSetPixel($gdi_img,$iX, $iY, 0xFF000000)
		 EndIf
	  Next
   Next

EndFunc

Func GetValueOfCard($gdi_img, $imgName)
   CleanupCardNoise($gdi_img)
   Assert(CardVerificationCheck($gdi_img),"Seems like you didn't capture a card...")
   CardCleanVerification($gdi_img, $imgName)

   If CardImageCompare($gdi_img, $ControlFolderPath & "\card_2.png") Then
	  Return "2"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_22.png") Then
	  Return "2"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_23.png") Then
	  Return "2"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_3.png") Then
	  Return "3"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_32.png") Then
	  Return "3"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_4.png") Then
	  Return "4"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_42.png") Then
	  Return "4"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_5.png") Then
	  Return "5"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_52.png") Then
	  Return "5"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_6.png") Then
	  Return "6"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_62.png") Then
	  Return "6"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_7.png") Then
	  Return "7"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_72.png") Then
	  Return "7"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_8.png") Then
	  Return "8"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_82.png") Then
	  Return "8"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_9.png") Then
	  Return "9"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_92.png") Then
	  Return "9"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_T.png") Then
	  Return "T"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_T2.png") Then
	  Return "T"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_J.png") Then
	  Return "J"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_J2.png") Then
	  Return "J"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_Q.png") Then
	  Return "Q"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_Q2.png") Then
	  Return "Q"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_K.png") Then
	  Return "K"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_K2.png") Then
	  Return "K"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_A.png") Then
	  Return "A"
   ElseIf CardImageCompare($gdi_img, $ControlFolderPath & "\card_A2.png") Then
	  Return "A"
   Else
	  DebugImage($gdi_img, "newcard.png")
	  ConsoleWrite("New Card Detected!")
	  Assert(false, "stop the program and copy the card.")
   EndIf

   return 0;
EndFunc