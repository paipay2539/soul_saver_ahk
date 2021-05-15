#Persistent
CoordMode, ToolTip, screen
anyKeyPress = 0
countDownTime = 0
OnExit, ExitSub

setPointArrayX := []
setPointArrayY := []
arrayCount = 0
setPointCount = 0

Return






;color:0x52423A, x:+3,y:+32 offset

~space::
    PixelGetColor, color1, 800, 1000
    PixelGetColor, color2, 840, 1000
    PixelGetColor, color3, 880, 1000
    If active:=!active
	{
        Sleep, 100
		SetTimer ISR, 100
        ;SetTimer NoMainTask, Off
	}
    Else
	{
        SetTimer ISR, Off
        ;SetTimer NoMainTask, 1000

	}
Return

ISR:
    IfWinNotActive, SoulSaverOnline
    {
        Return  
    }   
    gosub checkAnyKeyPress
    If( anyKeyPress = 0 )
    {
        gosub mainloop
    }
Return

mainloop:
    PixelGetColor, color, 178, 11
    If ( color != 0x0000FF )
    {
        pressKeyFunction(5)
    }
    PixelGetColor, color, 178, 26
    If ( color != 0xFFBD08 )
    {
        pressKeyFunction(6)
    }
    PixelGetColor, color, 800, 1000
    If ( color = color1 )
    {
        pressKeyFunction(1)
    }
    PixelGetColor, color, 840, 1000
    If ( color = color2 )
    {
        pressKeyFunction(2)
    }
    PixelGetColor, color, 880, 1000
    If ( color = color3 )
    {
        pressKeyFunction(3)
    }
    PixelGetColor, color, 313, 540
    If ( color = 0x736b63 )
    {
        Click, 313, 540
        Sleep, 500
        Click, 313, 540
        Sleep, 100
        Click, 500, 540
    }
    PixelSearch, buffX, buffY, 1630, 967, 1910, 990, 0x061533,, Fast  
    If ErrorLevel
    {
        pressKeyFunction("v")
    }
    ;ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, C:\Users\KPY35\Desktop\PYE\soul_saver_ahk\chara.png
    ;MouseGetPos, MouseX, MouseY
    ;PixelGetColor, color, %MouseX%, %MouseY%
    ;ToolTip, Screen :`t`tx %color% %MouseX% %MouseY%, 340, 5
    ;clipboard := "color:" color ", x:" MouseX ",y:" MouseY

Return

checkAnyKeyPress:
    GetKeyState, keyPressUp,      up
    GetKeyState, keyPressDown,    down
    GetKeyState, keyPressRight,   right
    GetKeyState, keyPressLeft,    left
    GetKeyState, keyPress1,       space
    GetKeyState, keyPress2,       control
    If (   keyPressUp      = "D"
        Or keyPressDown    = "D"
        Or keyPressRight   = "D"
        Or keyPressLeft    = "D"
        Or keyPress1       = "D"
        Or keyPress2       = "D" )
    {
        anyKeyPress := 1
        countDownTime := 0
    }
    Else
    {
        If ( countDownTime > 0 )
        {
            anyKeyPress := 0
        }
        Else
        {
            anyKeyPress := 1
            countDownTime++
        }
    }
Return

; #########################################################################################################
; #########################################################################################################
; #########################################################################################################
    
^a::
    If autoRouteAct:=!autoRouteAct
	{
        SetTimer autoRoute, 5000
        SetTimer autoLR, 1000
	}
    Else
	{
        SetTimer autoRoute, Off
        SetTimer autoLR, Off
	}
Return

autoLR:
    If autoLRAct:=!autoLRAct
	{
        gosub goTurnLeft
    }
    Else
    {
        gosub goTurnRight
    }
Return

^q::
    
    PixelSearch, setPointX, setPointY, 1500, 100, 1830, 350, 0x00E6FF,, Fast  
    MouseMove, setPointX, setPointY
    setPointArrayX[arrayCount] := setPointX
    setPointArrayY[arrayCount] := setPointY
    arrayCount++
    
Return   

^w:: 
    MouseMove, setPointArrayX[0], setPointArrayY[0]
    MouseMove, setPointArrayX[1], setPointArrayY[1]
    MouseMove, setPointArrayX[2], setPointArrayY[2]
Return
    
autoRoute:

    If ( arrivedX = 1 and arrivedY = 1)
    {
        setPointCount++
        If ( setPointCount = arrayCount )
        {
            setPointCount := 0
        }
        
        setpointX := setPointArrayX[setPointCount]
        setpointY := setPointArrayY[setPointCount]
        arrivedX := 0
        arrivedY := 0
    }

    PixelSearch, currentPointX, currentPointY, 1500, 100, 1830, 350, 0x00E6FF,, Fast
    
    dx := currentPointX - setpointX
    If ( dx > 20 ) or ( dx < -20 )
    {
        If ( dx > 20 )
        {
            gosub goLeft
        }
        If ( dx < -20 )
        {
            gosub goRight
        }
    }
    Else
    {
        arrivedX := 1
    }
    
    dy := currentPointY - setpointY
    If ( dy > 20 ) or ( dy < -20 )
    {
        If ( dy > 20 )
        {
            gosub goUp
        }
        If ( dy < -20 )
        {
            gosub goDown
        }
    }
    Else
    {
        arrivedY := 1
    }

Return

; #########################################################################################################
; #########################################################################################################
; #########################################################################################################
/*
q::
autoControl:
    offsetY := -100
    deltaX := 600
    deltaY := 100
    
    PixelSearch, Px, Py, Px - deltaX, Py - deltaY + offsetY, Px + deltaX, Py + deltaY + offsetY, 0xF3A935,, Fast
    if ErrorLevel
    {
        PixelSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, 0xF3A935,, Fast
        SoundBeep, 1000, 200
    }
    

    Px := 922
    Py := 967
    
    PixelSearch, monsterX, monsterY, Px - deltaX, Py - deltaY + offsetY, Px + deltaX, Py + deltaY + offsetY, 0x2D2DEE,, Fast
    if ErrorLevel
    {
        SoundBeep, 2000, 200
        return
    }
    
    if(monsterX - Px > 0)
    {
        gosub goTurnRight
    }
    else
    {
        gosub goTurnLeft
    }

    MouseMove, monsterX, monsterY
debugFrame:  
    MouseMove, Px - deltaX, Py - deltaY + offsetY
    sleep, 1000
    MouseMove, Px + deltaX, Py + deltaY + offsetY 
Return
*/
; #########################################################################################################
; #########################################################################################################
; #########################################################################################################

F2::
 enableLeftPad := !enableLeftPad
return
#if enableLeftPad = 1
!a::gosub goLeft 
!d::gosub goRight 
!w::gosub goUp 
!s::gosub goDown 
!q::gosub goTurnLeft
!e::gosub goTurnRight
a::left
d::right
w::gosub goUp 
s::gosub goDown
#if

goTurnLeft:
    pressKeyFunction("left")
Return

goTurnRight:
    pressKeyFunction("right")
Return

goLeft:
    pressKeyFunction("left", 500)
Return

goRight:
    pressKeyFunction("right", 500)
Return

goUp:
    pressKeyFunction("up", 100, 50)
    pressKeyFunction("up", 100)
Return

goDown:
    SendInput, {control down}
    pressKeyFunction("down", 100)
    SendInput, {control up}
Return

pressKeyFunction(buttonTarget, holdTime:=10, cooldownTime:=10)
{
    SendInput, {%buttonTarget% down}
    Sleep, %holdTime%
    SendInput, {%buttonTarget% up}
    Sleep, %cooldownTime%
    return
}

MsgBoxArray(myArray)
{
    Concat := ""
    For Each, Element In myArray
    {
        If (Concat <> "") ; Concat is not empty, so add a line feed
            Concat .= "`n"
        Concat .= Element
    }
    MsgBox, %Concat%
    return
}

; #########################################################################################################
; #########################################################################################################
; #########################################################################################################


;w::
;ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, C:\Users\KPY35\Desktop\PYE\soul_saver_ahk\button.png
;if (ErrorLevel = 2)
;    MsgBox Could not conduct the search.
;else if (ErrorLevel = 1)
;    MsgBox Icon could not be found on the screen.
;else
;    MsgBox The icon was found at %FoundX%x%FoundY%.
;Return

;F1::MouseGetPos, , , win_id, control, 
;F2::Msgbox, control %control%`r`nwin_id %win_id%
;
;1::ControlSend , %Control%, {1}, ahk_id %win_id%
;2::ControlSend , %Control%, {2}, ahk_id %win_id%
;3::ControlSend , %Control%, {3}, ahk_id %win_id%
;4::
;ControlSend , %Control%, {5 down}, ahk_id %win_id%
;Sleep, 100
;ControlSend , %Control%, {5 up}, ahk_id %win_id%
;Sleep, 10
;
;Space::
;ControlClick, x1 y1, ahk_id %win_id% 
;ControlSend , %Control%, {Space}, ahk_id %win_id%
;Return



^f::
    MouseGetPos, MouseX, MouseY
    PixelGetColor, color, 1897, 977
    acc_text := acc_text "color:" color ", x:" MouseX ",y:" MouseY "`n"
    clipboard := acc_text
    SoundBeep, 1000, 200
Return 

^g::
    MouseGetPos, MouseX, MouseY
    PixelGetColor, color, %MouseX%, %MouseY%
    PixelSearch, Px, Py, MouseX - 100, MouseY - 100, MouseX + 100, MouseY + 100, 0x0000C6,, Fast
    MouseMove, Px, Py
Return   

^h::
    PixelSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, color,, Fast
    MouseMove, Px, Py
Return

~-::
    Reload
Return
~=::
    ExitApp
Return

ExitSub:
    clipboard :=
    Loop, 0xFF
    {
        Key := Format("VK{:02X}",A_Index)
        IF GetKeyState(Key)
            Send, {%Key% Up}
    }
ExitApp
