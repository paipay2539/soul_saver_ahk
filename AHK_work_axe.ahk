#Persistent
#MaxThreadsPerHotkey 3
CoordMode, ToolTip, screen
anyKeyPress = 0
countDownTime = 0
OnExit, ExitSub

setPointArrayX := []
setPointArrayY := []
arrayCount = 0
setPointCount = 0

targetColorAct = 0
targetColor := 0x215A7B

gosub Testsub
Return

;color:0x52423A, x:+3,y:+32 offset


p::
    MouseGetPos, MouseX, MouseY
    PixelGetColor, targetColor, MouseX, MouseY
Return
^p::
    targetColorAct := 1
Return

~space::
    PixelGetColor, color1, 800, 1000
    PixelGetColor, color2, 840, 1000
    PixelGetColor, color3, 880, 1000
    PixelGetColor, color4, 920, 1000
    PixelGetColor, colorv, 920, 1040
    PixelGetColor, colorb, 960, 1040
    color4 := 0x3AE684
    If active:=!active
	{
        Sleep, 100
		SetTimer mainloopTask, 100 , -2
        SetTimer restoreTask, 100, -1
	}
    Else
	{
        SetTimer mainloopTask, Off
        SetTimer restoreTask, Off

	}
Return

mainloopTask:
    IfWinNotActive, SoulSaverOnline
    {
        Return  
    }  

    If targetColorAct
    {
        
    
        PixelSearch, HeroX, HeroY, A_ScreenWidth * 0.1, A_ScreenHeight * 0.35, A_ScreenWidth * 0.9, A_ScreenHeight * 0.90,  0xF3A935,, Fast
        ToolTip, 11 , A_ScreenWidth * 0.1, A_ScreenHeight * 0.35, 10 
        ToolTip, 22 , A_ScreenWidth * 0.9, A_ScreenHeight * 0.90, 11
        If ErrorLevel
        {
    
        }
        Else
        {
            ;if ( (800+1300)/2 - Px > 50 )
            ;{
            ;    gosub goTurnRight
            ;}
            ;if ( -((800+1300)/2 - Px) > 50 )
            ;{
            ;    gosub goTurnLeft
            ;}
            prevHeroX := HeroX
            prevHeroY := HeroY
        }
        ToolTip, Hero ,prevHeroX, prevHeroY , 5
        PixelSearch, Px, Py,  prevHeroX - 250, prevHeroY - 130 , prevHeroX + 250, prevHeroY - 30,  targetColor,, Fast
        ToolTip, 1 , prevHeroX - 250, prevHeroY - 130 , 3 
        ToolTip, 2 , prevHeroX + 250, prevHeroY - 30 , 4 
        If ErrorLevel
        {
            sleep, 100
        }
        Else
        {
            ToolTip, Monster ,Px, Py , 2 
            
            if ( prevHeroX - Px < 0 )
            {
                gosub goTurnRight
            }
            else
            {
                gosub goTurnLeft
            }
            gosub mainloop
        }  
        
        
        
    }
    Else
    {
        gosub mainloop
    }

Return

mainloop:
    checkCooldown( 1, color1, 800, 1000)
    checkCooldown( 2, color2, 840, 1000)
    checkCooldown( 3, color3, 880, 1000)
    checkCooldown( 4, color4, 920, 1000)
    PixelGetColor, mainloopColor, 313, 540
    If ( mainloopColor = 0x736b63 )
    {
        Click, 313, 540
        Sleep, 500
        Click, 313, 540
        Sleep, 100
        Click, 500, 540
    }
        
    PixelSearch, buffX, buffY, 1630, 975, 1910, 975, 0x062B0B,, Fast  
    If ErrorLevel
    {
        checkCooldown("v", colorv, 920, 1040)
    }
    PixelSearch, buffX, buffY, 1630, 975, 1910, 975, 0x352F0E,, Fast  
    If ErrorLevel
    {
        checkCooldown("b", colorb, 960, 1040)
    }
    
    ;ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, C:\Users\KPY35\Desktop\PYE\soul_saver_ahk\chara.png
    ;MouseGetPos, MouseX, MouseY
    ;PixelGetColor, color, %MouseX%, %MouseY%
    ;ToolTip, Screen :`t`tx %color% %MouseX% %MouseY%, 340, 5
    ;clipboard := "color:" color ", x:" MouseX ",y:" MouseY

Return

restoreTask:
    IfWinNotActive, SoulSaverOnline
    {
        Return  
    }   
    PixelGetColor, restoreColor, 170, 11
    If ( restoreColor != 0x0000FF )
    {
        pressKeyFunction(5)
    }
    PixelGetColor, restoreColor, 170, 26
    If ( restoreColor != 0xFFBD08 )
    {
        pressKeyFunction(6)
    }
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
        SetTimer autoRouteTask, 2000, -3
        ;SetTimer autoLRTask, 2000, -3
	}
    Else
	{
        SetTimer autoRouteTask, Off
        SetTimer autoLRTask, Off
	}
Return

autoLRTask:
    IfWinNotActive, SoulSaverOnline
    {
        Return  
    }   
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
    
autoRouteTask:
    IfWinNotActive, SoulSaverOnline
    {
        Return  
    }   
    delta := 10
    If ( arrivedX = 1 and arrivedY = 1)
    {
        setPointCount++
        If ( setPointCount = arrayCount )
        {
            sleep, 10000
            setPointCount := 0
        }
        setpointX := setPointArrayX[setPointCount]
        setpointY := setPointArrayY[setPointCount]
        arrivedX := 0
        arrivedY := 0
    }

    PixelSearch, currentPointX, currentPointY, 1500, 100, 1830, 350, 0x00E6FF,, Fast
    
    dx := currentPointX - setpointX
    If ( dx > delta ) or ( dx < -delta )
    {
        If ( dx > delta )
        {
            gosub goLeft
            gosub goTurnRight
        }
        If ( dx < -delta )
        {
            gosub goRight
            gosub goTurnLeft
        }
    }
    Else
    {
        arrivedX := 1
    }
    
    dy := currentPointY - setpointY
    If ( dy > delta ) or ( dy < -delta )
    {
        If ( dy > delta )
        {
            gosub goUp
        }
        If ( dy < -delta )
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
    
    
    ;ImageSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, *Trans0x4A5A9C *10 C:\Users\KPY35\Desktop\PYE\soul_saver_ahk\name.png 
    
    
    PixelSearch, Px, Py, Px - deltaX, Py - deltaY + offsetY, Px + deltaX, Py + deltaY + offsetY, 0xF3A935,, Fast
    if ErrorLevel
    {
        ;PixelSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, 0xF3A935,, Fast
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
    ToolTip, 1,Px - deltaX, Py - deltaY + offsetY, 1 
    ToolTip, 2,Px + deltaX, Py - deltaY + offsetY, 2
    ToolTip, 3,Px - deltaX, Py + deltaY + offsetY, 3
    ToolTip, 4,Px + deltaX, Py + deltaY + offsetY, 4
    ToolTip, 5,Px , Py - deltaY + offsetY, 5 
    ToolTip, 6,Px , Py + deltaY + offsetY, 6  
    ToolTip, 7,Px - deltaX, Py + offsetY, 7
    ToolTip, 8,Px + deltaX, Py + offsetY, 8
    ToolTip, 9,Px , Py + offsetY, 9
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

LButton::left
RButton::right
XButton1::gosub goDown
XButton2::up

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

pressKeyFunction(buttonTarget, holdTime:=100, cooldownTime:=10)
{
    SendInput, {%buttonTarget% down}
    Sleep, %holdTime%
    SendInput, {%buttonTarget% up}
    Sleep, %cooldownTime%
    return
}

checkCooldown( targetKey, checkColor, checkPointX, checkPointY)
{
    gosub checkAnyKeyPress
    global anyKeyPress
    If( anyKeyPress = 0 )
    {
        PixelGetColor, color, checkPointX, checkPointY
        If ( color = checkColor )
        {
            retryCounter := 0
            Loop
            {
                pressKeyFunction(targetKey)
                ;sleep, 10
                retryCounter++
                pressKeyFunction("control")
                PixelGetColor, color, checkPointX, checkPointY
                if Not (color = checkColor) or (retryCounter > 10)
                    break
            }
        }   
    }
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


Testsub:
    ;SetTimer TestsubTask, 1000, 0
    global prevMonsterX, prevMonsterY
    prevMonsterX := 0
    prevMonsterY := 0
    prevHeroX := 0
    prevHeroY := 0
    prevRatio := 0.5
Return

TestsubTask:


    IfWinNotActive, SoulSaverOnline
    {
        Return  
    }   
    PixelSearch, MonsterX, MonsterY, 0, A_ScreenHeight *2/3, A_ScreenWidth, A_ScreenHeight, 0x6B5A5A,, Fast
    if ErrorLevel
    {
        MonsterX := prevMonsterX
        MonsterY := prevMonsterY
    }
    else
    {
        MonsterX := MonsterX*(1-prevRatio) + prevMonsterX*(prevRatio)
        MonsterY := MonsterY*(1-prevRatio) + prevMonsterY*(prevRatio)
    }
    
    ToolTip, Monster ,MonsterX, MonsterY , 1 
    prevMonsterX := MonsterX
    prevMonsterY := MonsterY
    
    PixelSearch, HeroX, HeroY, 0, A_ScreenHeight *2/3, A_ScreenWidth, A_ScreenHeight, 0x299CDE,, Fast
    if ErrorLevel
    {
        HeroX := prevHeroX
        HeroY := prevHeroY
    }
    else
    {
        HeroX := HeroX*(1-prevRatio) + prevHeroX*(prevRatio)
        HeroY := HeroY*(1-prevRatio) + prevHeroY*(prevRatio)
    }
    
    ToolTip, Hero ,HeroX, HeroY , 2 
    prevHeroX := HeroX
    prevHeroY := HeroY
Return


^u::
    MouseGetPos, MouseX, MouseY
    SoundBeep, 1000, 200
    
    PixelGetColor, color, MouseX, MouseY
    acc_text := acc_text "color:" color ", x:" MouseX ",y:" MouseY "`n"
    clipboard := acc_text
    SoundBeep, 1000, 200
Return 

^f::
    MouseGetPos, MouseX, MouseY
    PixelGetColor, color, 1900, 975
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
=::
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
