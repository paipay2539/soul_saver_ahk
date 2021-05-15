#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1

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
targetColor := 0xF3D0CC ;0x5A84C5
foundMonster := 0
activeL := 1
activeR := 1
walkStatus := "left"

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
		SetTimer mainloopTask, 100, -2
        SetTimer restoreTask, 100, -1
	}
    Else
	{
        SetTimer mainloop, Off
        SetTimer mainloopTask, Off
        SetTimer restoreTask, Off

	}
Return

mainloopTask:
    IfWinNotActive, SoulSaverOnline
    {
        Return  
    }  
    
    gosub timeCapture
    ToolTip, Debugger foundMonster: %foundMonster% skillAct %skillAct%, 340, 5, 2
    
    If targetColorAct
    {
        SetTimer mainloop, 100, -3
        SetTimer mainloopTask, 500, -2
        gosub imageProcessing
    }
    Else
    {
        skillAct := 1
        gosub mainloop
    }

Return

imageProcessingMap:
    delta := 10
    PixelSearch, currentPointX, currentPointY, 1500, 100, 1830, 350, 0x00E6FF,, Fast
    dx := currentPointX - setpointX
    dy := currentPointY - setpointY
    
    If ( dx > delta ) or ( dx < -delta )
    {
        If ( dx > delta )
        {
            walkStatus := "left"
            ;SoundBeep, 5000, 200  
            activeL := 1.5
            activeR := 1  
        }
        If ( dx < -delta )
        {
            walkStatus := "right"
            ;SoundBeep, 500, 200
            activeL := 1
            activeR := 1.5
        }
    }
    Else
    {
        If ( dy > delta ) or ( dy < -delta )
        {
            If ( dy > delta )
            {
                walkStatus := "jump"
            }
            If ( dy < -delta )
            {
                walkStatus := "down"
            }
        }
        Else
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
    }
Return

imageProcessing:
    gosub imageProcessingMap
    gosub imageProcessingHero
    ToolTip, %prevHeroX% , A_ScreenWidth * 0.3, 100, 18 
    ToolTip, %prevMonsterX% , A_ScreenWidth * 0.7, 100, 19
    ;if (prevHeroX < (A_ScreenWidth * 0.3)) 
    ;{
    ;    walkStatus := "right"
    ;    ;SoundBeep, 500, 200
    ;    activeL := 1
    ;    activeR := 1.5
    ;}
    ;if (prevHeroX > (A_ScreenWidth * 0.7))
    ;{
    ;    walkStatus := "left"
    ;    ;SoundBeep, 5000, 200  
    ;    activeL := 1.5
    ;    activeR := 1        
    ;}

    gosub imageProcessingMonster
    if (foundMonster > 1)
    {
        SendInput, {left up}
        SendInput, {right up}
        if (prevMonsterX > prevHeroX)
        {
            gosub goTurnRight
        }
        else
        {
            gosub goTurnLeft
        }
        ;gosub mainloop
        skillAct := 1
    }
    else
    {   
        gosub walkExecute
        skillAct := 0
    }
    
Return

walkExecute:
    if (walkStatus = "left") 
    {
        ;SendInput, {left down}
        ;SendInput, {right up}    
        ;gosub goLeft
    }
    if (walkStatus = "right") 
    {   
        ;SendInput, {right down}
        ;SendInput, {left up}
        ;gosub goRight
    }
    if (walkStatus = "jump")
    {
        ;SendInput, {left up}
        ;SendInput, {right up}
        SendInput, {control down}
        pressKeyFunction("up", 100)
        SendInput, {control up}
    }
    if (walkStatus = "down")
    {
        ;SendInput, {left up}
        ;SendInput, {right up}
        gosub goDown
    }    
    
    pressKeyFunction("control")
Return

imageProcessingMonster: 


    frameMonster00xOffset := - 300
    frameMonster11xOffset := + 300
    frameMonster00x := prevHeroX + frameMonster00xOffset*activeL
    frameMonster11x := prevHeroX + frameMonster11xOffset*activeR
    frameMonster00y := prevHeroY - 50 - 150 
    frameMonster11y := prevHeroY + 50
    ;targetColor := 0x5A84C5
 
    PixelSearch, monsterX, monsterY, frameMonster00x, frameMonster00y, frameMonster11x, frameMonster11y, targetColor,, Fast
    ToolTip, frameMonster00 , frameMonster00x, frameMonster00y, 5 
    ToolTip, frameMonster11 , frameMonster11x, frameMonster11y, 6
    ToolTip, frameMonster01 , frameMonster00x, frameMonster11y, 7 
    ToolTip, frameMonster10 , frameMonster11x, frameMonster00y, 8
    If ErrorLevel
    {
        if foundMonster > 1
        {
             foundMonster--
        }
    }
    Else
    {
        if foundMonster < 6
        {
             foundMonster++
        }
        prevMonsterX := monsterX
        prevMonsterY := monsterY
    }  
    ToolTip, Monster, prevMonsterX, prevMonsterY - 100, 9
    
Return    

imageProcessingHero:
    frameHero00x := A_ScreenWidth * 0.05
    frameHero11x := A_ScreenWidth * 0.95
    frameHero00y := A_ScreenHeight * 0.35
    frameHero11y := A_ScreenHeight * 0.90 + 10
    colorHero := 0x9CC5FF
    colorHero2nd := 0x7B73DE
    
    PixelSearch, HeroX, HeroY, frameHero00x, frameHero00y, frameHero11x, frameHero11y, colorHero,, Fast
    ToolTip, frameHero00 , frameHero00x, frameHero00y, 10 
    ToolTip, frameHero11 , frameHero11x, frameHero11y, 11
    ToolTip, frameHero01 , frameHero00x, frameHero11y, 12 
    ToolTip, frameHero10 , frameHero11x, frameHero00y, 13
    If ErrorLevel
    {
        PixelSearch, HeroX, HeroY, frameHero00x, frameHero00y, frameHero11x, frameHero11y, colorHero2nd,, Fast
        If ErrorLevel
        {
        }
        Else
        {
            prevHeroX := HeroX
            prevHeroY := HeroY
        }        
    }
    Else
    {
        prevHeroX := HeroX
        prevHeroY := HeroY
    }
    ToolTip, Hero ,prevHeroX, prevHeroY - 100, 14
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
    global anyKeyPress, skillAct
    If( anyKeyPress = 0 and skillAct = 1 )
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
    clipboard := color
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

timeCapture:
    millis := (a_hour*3600 + a_min*60 + a_sec)*1000 + a_msec
    timerDiff := millis - timerOld
    timerOld := millis
    ToolTip, Timer %timerDiff%, 340, 35
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
