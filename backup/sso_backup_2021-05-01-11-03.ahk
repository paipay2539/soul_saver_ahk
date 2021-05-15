#Persistent
CoordMode, ToolTip, screen
AnyKeyPress = 0
CountDownTime = 0

Return
;~Space::
~space::
    PixelGetColor, color1, 800, 1000
    PixelGetColor, color2, 840, 1000
    PixelGetColor, color3, 880, 1000
    If Active:=!Active
	{
        Sleep, 100
		SetTimer PreCheck, 100
        ;SetTimer NoMainTask, Off
	}
    Else
	{
        SetTimer PreCheck, Off
        ;SetTimer NoMainTask, 1000

	}
Return


PreCheck:
    IfWinNotActive, SoulSaverOnline
    {
        Return  
    }   
    gosub CheckAnyKeyPress
    If( AnyKeyPress = 0 )
    {
        gosub rightHold
    }
Return

rightHold:
    PixelGetColor, color, 178, 11
    If ( color != 0x0000FF )
    {
        SendInput, {5 down}
        Sleep, 10
        SendInput, {5 up}
        Sleep, 10
    }
    PixelGetColor, color, 178, 26
    If ( color != 0xFFBD08 )
    {
        SendInput, {6 down}
        Sleep, 10
        SendInput, {6 up}
        Sleep, 10
    }
    PixelGetColor, color, 800, 1000
    If ( color = color1 )
    {
        SendInput, {1 down}
        Sleep, 10
        SendInput, {1 up}
        Sleep, 10
    }
    PixelGetColor, color, 840, 1000
    If ( color = color2 )
    {
        SendInput, {2 down}
        Sleep, 10
        SendInput, {2 up}
        Sleep, 10
    }
    PixelGetColor, color, 880, 1000
    If ( color = color3 )
    {
        SendInput, {3 down}
        Sleep, 10
        SendInput, {3 up}
        Sleep, 10
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
    
    ;ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, C:\Users\KPY35\Desktop\PYE\soul_saver_ahk\chara.png
    ;MouseGetPos, MouseX, MouseY
    ;PixelGetColor, color, %MouseX%, %MouseY%
    ;ToolTip, Screen :`t`tx %color% %MouseX% %MouseY%, 340, 5
    ;clipboard := "color:" color ", x:" MouseX ",y:" MouseY

Return

Esc::
    ExitApp
Return

CheckAnyKeyPress:
    GetKeyState, KeyPressUp,      up
    GetKeyState, KeyPressDown,    down
    GetKeyState, KeyPressRight,   right
    GetKeyState, KeyPressLeft,    left
    GetKeyState, KeyPress1,       space
    GetKeyState, KeyPress2,       control
    If (   KeyPressUp      = "D"
        Or KeyPressDown    = "D"
        Or KeyPressRight   = "D"
        Or KeyPressLeft    = "D"
        Or KeyPress1       = "D"
        Or KeyPress2       = "D" )
    {
        AnyKeyPress := 1
        CountDownTime := 0
    }
    Else
    {
        If ( CountDownTime > 0 )
        {
            AnyKeyPress := 0
        }
        Else
        {
            AnyKeyPress := 1
            CountDownTime++
        }
    }
Return



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
