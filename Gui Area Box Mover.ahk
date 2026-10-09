#SingleInstance Force
SetWorkingDir %A_ScriptDir%
SplitPath, A_ScriptFullPath, name, dir, ext, name_no_ext, drive
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen
global ToolTipToggle := false
global Gui1Made := false
global BorderX := 0
global BorderY := 0
global BorderW := 0
global BorderH := 0
global IniFile := A_ScriptDir . "\" . "Auto Blacksmith Farming" . "IniFile.ini"
if FileExist(IniFile) then
{
	IniRead, 1MenuX, % IniFile, Stored Variables, 1MenuX
	IniRead, 1MenuY, % IniFile, Stored Variables, 1MenuY
	IniRead, 2MenuX, % IniFile, Stored Variables, 2MenuX
	IniRead, 2MenuY, % IniFile, Stored Variables, 2MenuY
}
return
~/::
    Suspend On
    Loop
        if (GetKeyState("Enter", "P") || GetKeyState("Escape", "P") || GetKeyState("LButton", "P"))
            break
    Suspend Off
return
^~/::
    Suspend On
    Loop
        if (GetKeyState("Enter", "P") || GetKeyState("Escape", "P") || GetKeyState("LButton", "P"))
            break
    Suspend Off
return
+~/::
    Suspend On
    Loop
        if (GetKeyState("Enter", "P") || GetKeyState("Escape", "P") || GetKeyState("LButton", "P"))
            break
    Suspend Off
return


$f4::
SetKeyDelay, -1
SetMouseDelay, -1
SetBatchLines, -1

send {=}
return


$f3::
SetKeyDelay, -1
SetMouseDelay, -1
SetBatchLines, -1

CreateGui1()
SetTimer, GetGuiPositions, 1
SetTimer, DisplayGuiPositions, 1
return


DisplayGuiPositions:
global ToolTipOn
if (ToolTipToggle) then
{
	SetTimer, DisplayGuiPositions, Off
	return
}
ToolTip, % "TOP LEFT CORNER: " BorderX "`, " BorderY "`n" "BOTTOM RIGHT CORNER: " (BorderX + BorderW) "`, " (BorderY + BorderH) "`n" "WIDTH: " BorderW "`n" "HEIGHT: " BorderH "`n" "PRESS J TO HIDE TOOLTIP" "`n" "PRESS K TO SET AREA", % BorderX + (BorderW // 2), % BorderY + (BorderH // 2)
return


~$J::
SetKeyDelay, -1
SetMouseDelay, -1
SetBatchLines, -1

ToolTip
ToolTipToggle := true
return


~$K::
SetKeyDelay, -1
SetMouseDelay, -1
SetBatchLines, -1

if (Gui1Made && BorderX && BorderY && BorderW && BorderH) then
{
	IniRead, 1MenuX, % IniFile, Stored Variables, 1MenuX
	IniRead, 1MenuY, % IniFile, Stored Variables, 1MenuY
	IniRead, 2MenuX, % IniFile, Stored Variables, 2MenuX
	IniRead, 2MenuY, % IniFile, Stored Variables, 2MenuY
	
	if (1MenuX != "ERROR" && 1MenuX != "") then
	{
		return
	}

	IniWrite, % BorderX + 3, % IniFile, Stored Variables, 1MenuX
	IniWrite, % BorderY + 3, % IniFile, Stored Variables, 1MenuY
	IniWrite, % (BorderX + BorderW) - 3, % IniFile, Stored Variables, 2MenuX
	IniWrite, % (BorderY + BorderH) - 3, % IniFile, Stored Variables, 2MenuY
	Msgbox, Set Menu Cords
	return
}
return


GetGuiPositions:
global BorderX, BorderY, BorderW, BorderH
WinGetPos, GuiX, GuiY, GuiW, GuiH, %name_no_ext%
BorderX := GuiX
BorderY := GuiY + 35
BorderW := GuiW - 16
BorderH := GuiH - 39
return


GuiSize:
    if (A_EventInfo = 1) ; minimized
        return

    w := A_GuiWidth
    h := A_GuiHeight

    thickness := 3

    GuiControl, Move, border1, % "w" w " h" thickness
    GuiControl, Move, border2, % "h" h
    GuiControl, Move, border3, % "y" h-thickness " w" w " h" thickness
    GuiControl, Move, border4, % "x" w-thickness " h" h
return


CreateGui1() {
	global GuiX, GuiY, GuiW, GuiH
	global Gui1Made
    Gui, 1:New
    Gui, 1:Color, E4F0F6

    ;Draw_Outline(1, 0, 0, 250, 250, "White", 3)

	Gui, 1:+AlwaysOnTop +ToolWindow +Resize ; -Caption
    Gui, 1:+LastFound
	hwnd := WinExist()

    OnMessage(0x201, "MoveWindow")

    WinSet, TransColor, E4F0F6 200
    Gui, 1:Show, % "X" (A_ScreenWidth // 2) - (A_ScreenWidth // 15) " Y" (A_ScreenHeight // 2) - (A_ScreenHeight // 10) " W" 250 " H" 250, %name_no_ext%
	WinGetPos, GuiX, GuiY, GuiW, GuiH, %name_no_ext%
	Draw_Outline(1, 0, 0, GuiW - 16, GuiH - 39, "White", 3)
	Gui, 1:Show, % "X" (A_ScreenWidth // 2) - (A_ScreenWidth // 15) " Y" (A_ScreenHeight // 2) - (A_ScreenHeight // 10) " W" 250 " H" 250, %name_no_ext%
	Gui1Made := true
}


Draw_Outline(Gui_Name,x,y,w,h,Color:="Black",thickness:=1){
	global border1, border2, border3, border4
	x2:=X+W-thickness
	Gui,% Gui_Name ":Add",Progress,% "vborder1" " x" X " y" Y " w" W " h" thickness " Background" Color 
	Gui,% Gui_Name ":Add",Progress,% "vborder2" " x" X " y" Y " w" thickness " h" H " Background" Color 
	Gui,% Gui_Name ":Add",Progress,% "vborder3" " x" X " y" Y+H-thickness " w" W " h" thickness " Background" Color 
	Gui,% Gui_Name ":Add",Progress,% "vborder4" " x" X+W-thickness " y" Y " w" thickness " h" H " Background" Color 	
}
Draw_Line(Gui_Name,x,y,w,h,color){
	Gui,% Gui_Name ":Add",Progress,% "x" X " y" Y " w" W " h" H " Background" Color 
}


MoveWindow(wParam, lParam, msg, hwnd) {
	global GuiX, GuiY, GuiW, GuiH
    static lastHwnd

    ; make sure we only react to our GUI
    if (hwnd != WinExist("A"))
        return

    PostMessage, 0xA1, 2,,, A  ; drag active window
	WinGetPos, GuiX, GuiY, GuiW, GuiH, %name_no_ext%
}


SystemTime()
{
    freq := 0, tick := 0
    If (!freq)
        DllCall("QueryPerformanceFrequency", "Int64*", freq)
    DllCall("QueryPerformanceCounter", "Int64*", tick)
    Return tick / freq * 1000
}


HyperSleep(value)
{
	global Sleeps
	Sleeps += value
    s_begin_time := SystemTime()
    freq := 0, t_current := 0
    DllCall("QueryPerformanceFrequency", "Int64*", freq)
    s_end_time := (s_begin_time + value) * freq / 1000 
    While, (t_current < s_end_time)
    {
        If (s_end_time - t_current) > 20000
        {
            DllCall("Winmm.dll\timeBeginPeriod", UInt, 1)
            DllCall("Sleep", "UInt", 1)
            DllCall("Winmm.dll\timeEndPeriod", UInt, 1)
            DllCall("QueryPerformanceCounter", "Int64*", t_current)
        }
        Else
            DllCall("QueryPerformanceCounter", "Int64*", t_current)
    }
}


$f7::
Reload
return


RemoveTT:
ToolTip
return