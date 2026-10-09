#IfWinActive ahk_exe RobloxPlayerBeta.exe
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen
global IniFile := A_ScriptDir . "\" . "Auto Blacksmith Farming" . "IniFile.ini"
if FileExist(IniFile) then
{
	IniRead, 1MenuX, % IniFile, Stored Variables, 1MenuX
	IniRead, 1MenuY, % IniFile, Stored Variables, 1MenuY
	IniRead, 2MenuX, % IniFile, Stored Variables, 2MenuX
	IniRead, 2MenuY, % IniFile, Stored Variables, 2MenuY
}
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

ReadIniFile()

MacroStatus := ""
RandomStatus := ""
PlayCords := [66, 851]
PickaxeKey := "1"
HelmetKey := "3"
SilverguardKey := "6"
GelidusKey := "8"
GrindstoneKey := "0"
GateKey := "-"
HasPickaxe := false
FFCheckDuration := 3 ; (Seconds)
HasForceField := false
ForceFieldDetections := []
SteppedOut := false
ManaCharged := false
CanGate := false
FacingS3Ores := false
Ore := 1
2PS := [3, 4, 5, 13, 14, 16, 17, 19, 20, 23]
3PS := [1, 2, 6, 12, 15, 18, 21, 22]
6PS := [7, 8, 9, 10, 11]
ShoreOres := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
ForestP1Ores := [12, 13, 14, 15, 16]
ForestP2Ores := [17, 18, 19]
ForestP3Ores := [20, 21, 22, 23]

MacroStatusToolTip("Pressing Play...")
HyperSleep(250)
MouseMove, % PlayCords[1], % PlayCords[2]
HyperSleep(250)
send {click}
HyperSleep(50)
MacroStatusToolTip("Spawning in...")
HyperSleep(400)
MacroStatusToolTip("Spawning in...`nChecking for Pickaxe...")
PickaxeTime := A_TickCount
while (!HasPickaxe)
{
	if (A_TickCount - PickaxeTime > 3000) then
	{
		ImageSearch, MenuX, MenuY, % 1MenuX, % 1MenuY, % 2MenuX, % 2MenuY, *20 %A_ScriptDir%\MenuButton.png
		if (ErrorLevel = 0) then
		{
			HyperSleep(25)
			MouseMove, % MenuX, % MenuY
			HyperSleep(25)
			send {click}
			Loop, 2
			{
				HyperSleep(500)
				ImageSearch, MenuX, MenuY, % 1MenuX, % 1MenuY, % 2MenuX, % 2MenuY, *20 %A_ScriptDir%\MenuButton.png
				if (ErrorLevel = 1) then
				{
					break
				}
			}
		}
		MacroStatusToolTip("Couldn't find pickaxe.`nIn Menu.")
		return
	}
	ImageSearch, FoundX, FoundY, 0, 0, % A_ScreenWidth, % A_ScreenHeight, *30 %A_ScriptDir%\Pickaxe.png
	if (ErrorLevel = 0) then
	{
		HasPickaxe := true
	}
	HyperSleep(100)
}
MacroStatusToolTip("Checking for force field...")
FFCheckTime := A_TickCount
while (!HasForceField)
{
	if (A_TickCount - FFCheckTime > (FFCheckDuration * 1000)) then
	{
		break
	}
	PixelSearch, Px, Py, 0, 0, % A_ScreenWidth, % A_ScreenHeight, 0xBA8A1A, 10, Fast
	if (ErrorLevel = 0) then
	{
		HasForceField := true
	}
	HyperSleep(100)
}
if (HasForceField) then
{
	MacroStatusToolTip("Has force field.")
}
else
{
	MacroStatusToolTip("Out of force field.")
}
HyperSleep(400)
MacroStatusToolTip("Resetting camera angle...")
HyperSleep(25)
ResetCameraAngles()
HyperSleep(25)
if (HasForceField) then
{
	MacroStatusToolTip("Stepping out of ff...")
	HyperSleep(250)
	send {space down}
	send {w down}
	HyperSleep(50)
	send {w up}
	HyperSleep(50)
	send {w down}
	while (!SteppedOut)
	{
		if (ForceFieldDetections.Count() >= 3) then
		{
			SteppedOut := true
		}
		PixelSearch, Px, Py, 0, 0, % A_ScreenWidth, % A_ScreenHeight, 0xBA8A1A, 10, Fast
		if (ErrorLevel = 1) then
		{
			ForceFieldDetections.Push(A_Index)
		}
		if (ForceFieldDetections.Count() >= 3) then
		{
			SteppedOut := true
		}
		HyperSleep(100)
	}
	send {w up}
	send {space up}
}
HyperSleep(250)
MacroStatusToolTip("Gating Shore 3...")
HyperSleep(250)
GateFunction("shore 3")
HyperSleep(750)
MacroStatusToolTip("Gated Shore 3.")
HyperSleep(400)
MacroStatusToolTip("Trying to face towards shore 3 ores...")
FaceS3Time := A_TickCount
while (!FacingS3Ores)
{
	if (A_TickCount - FaceS3Time >= 3 * 1000) then
	{
		MacroStatusToolTip("Couldn't face shore ores...`nGating shore 3 and Menuing...")
		GateFunction("shore 4")
		HyperSleep(250)
		ImageSearch, MenuX, MenuY, % 1MenuX, % 1MenuY, % 2MenuX, % 2MenuY, *20 %A_ScriptDir%\MenuButton.png
		if (ErrorLevel = 0) then
		{
			HyperSleep(25)
			MouseMove, % MenuX, % MenuY
			HyperSleep(25)
			send {click}
			Loop, 2
			{
				HyperSleep(500)
				ImageSearch, MenuX, MenuY, % 1MenuX, % 1MenuY, % 2MenuX, % 2MenuY, *20 %A_ScriptDir%\MenuButton.png
				if (ErrorLevel = 1) then
				{
					break
				}
			}
		}
		MacroStatusToolTip("Couldn't face shore 3 ores...`nIn Menu.")
		break
	}
	PixelSearch, Px, Py, % (A_ScreenWidth // 1.28), % (A_ScreenHeight // 3.03), % A_ScreenWidth, % (A_ScreenHeight // 1.35), 0x00FFFF, 10, Fast
	if (ErrorLevel = 1) then
	{
		send {,}
	}
	else
	if (ErrorLevel = 0) then
	{
		send {,}
		HyperSleep(100)
		PixelSearch, Px, Py, % (A_ScreenWidth // 1.28), % (A_ScreenHeight // 3.03), % A_ScreenWidth, % (A_ScreenHeight // 1.35), 0x00FFFF, 10, Fast
		if (ErrorLevel = 1) then
		{
			send {.}
		}
		FacingS3Ores := true
	}
	HyperSleep(250)
}
if (!FaceS3Time) then
{
	MacroStatusToolTip("Macro Stopped.`nCouldn't face shore ores.`nIn Menu.")
	return
}
MacroStatusToolTip("Facing shore 3 ores.")
HyperSleep(400)
MacroStatusToolTip("Putting on Helmet and Silverguard...")
HyperSleep(250)
send % HelmetKey
HyperSleep(25)
send {click}
HyperSleep(25)
send % SilverguardKey
HyperSleep(25)
send {click}
HyperSleep(250)
MacroStatusToolTip("Starting auto shore ores mine...")
HyperSleep(250)
Loop, % ShoreOres.Count()
{
	GoToOres(Ore)
	ClickOre(Ore)
	Ore++
}
MacroStatusToolTip("Finished auto shore ores mine.")
HyperSleep(250)
MacroStatusToolTip("Gating Forest 3...")
HyperSleep(250)
GateFunction("forest 3")
HyperSleep(750)
MacroStatusToolTip("Gated Forest 3.")
HyperSleep(250)

return


$f2::
SetKeyDelay, -1
SetMouseDelay, -1
SetBatchLines, -1

GoToOres(20)
HyperSleep(1000)
GoToOres(21)
HyperSleep(1000)
GoToOres(22)
return


$f1::
MouseGetPos, MouseX, MouseY
PixelGetColor, color, %MouseX%, %MouseY%
MsgBox The color at the current cursor position is %color%.
return


ClickOre(Ore) {
	global 2PS, 3PS, 6PS
	for index, value in 2PS
	{
		if (value == Ore) then
		{
			PickaxeLoop(2)
		}
	}
	for index, value in 3PS
	{
		if (value == Ore) then
		{
			PickaxeLoop(3)
		}
	}
	for index, value in 6PS
	{
		if (value == Ore) then
		{
			PickaxeLoop(6)
		}
	}
}


PickaxeLoop(Clicks) {
	Loop, % Clicks
	{
		send 1
		HyperSleep(25)
		send {click}
		HyperSleep(250)
		send 1
		HyperSleep(675 - 250)
	}
}


GoToOres(OreNumber) {
	; SHORE 3 PART 1: 1-6
	; SHORE 3 PART 2: 7-11
	; FOREST 3 PART 1: 12-16
	; FOREST 3 PART 2: 17- 19
	; FOREST 3 PART 3: 20-23
	if (OreNumber == 0) then
	{
		OreNumber := 1
	}
	if (OreNumber == 1) then
	{
		send {shift}
		MacroStatusToolTip("Going to ore " OreNumber "...")
		RunFunction(3600)
		HyperSleep(25)
		Loop, 2
		{
			send {,}
		}
		HyperSleep(25)
		RunFunction(2500)
		HyperSleep(25)
		send {a down}
		HyperSleep(100)
		send {a up}
		MacroStatusToolTip("At ore " OreNumber ".")
	}
	else
	if (OreNumber == 2) then
	{
		MacroStatusToolTip("Going to ore " OreNumber "...")
		Loop, 2
		{
			send {.}
		}
		HyperSleep(25)
		RunFunction(1275)
		HyperSleep(75)
		send {w down}
		HyperSleep(500)
		send {w up}
		HyperSleep(25)
		send {a down}
		HyperSleep(500)
		send {a up}
		HyperSleep(25)
		send {d down}
		HyperSleep(1000)
		send {d up}
		MacroStatusToolTip("At ore " OreNumber ".")
	}
	else
	if (OreNumber == 3) then
	{
		MacroStatusToolTip("Going to ore " OreNumber "...")
		send {w down}
		HyperSleep(250)
		send {w up}
		HyperSleep(25)
		send {d down}
		HyperSleep(1000)
		send {d up}
		HyperSleep(25)
		RunFunction(2250)
		HyperSleep(25)
		send {a down}
		HyperSleep(1100)
		send {a up}
		MacroStatusToolTip("At ore " OreNumber ".")
	}
	else
	if (OreNumber == 4) then
	{
		MacroStatusToolTip("Going to ore " OreNumber "...")
		send {w down}
		HyperSleep(250)
		send {w up}
		HyperSleep(25)
		send {d down}
		HyperSleep(1000)
		send {d up}
		HyperSleep(25)
		Loop, 4
		{
			send {.}
		}
		HyperSleep(25)
		RunFunction(2500)
		HyperSleep(25)
		send {a down}
		HyperSleep(2500)
		send {a up}
		MacroStatusToolTip("At ore " OreNumber ".")
	}
	else
	if (OreNumber == 5) then
	{
		MacroStatusToolTip("Going to ore " OreNumber "...")
		send {a down}
		HyperSleep(1250)
		send {a up}
		HyperSleep(25)
		Loop, 4
		{
			send {,}
		}
		HyperSleep(25)
		send {w down}
		HyperSleep(1400)
		send {w up}
		HyperSleep(25)
		send {d down}
		HyperSleep(1000)
		send {d up}
		MacroStatusToolTip("At ore " OreNumber ".")
	}
	else
	if (OreNumber == 6) then
	{
		MacroStatusToolTip("Going to ore " OreNumber "...")
		RunFunction(1250)
		MacroStatusToolTip("At ore " OreNumber ".")
	}
	else
	if (OreNumber == 7) then
	{
		MacroStatusToolTip("Going to ore " OreNumber "...")
		send {a down}
		HyperSleep(1600)
		send {a up}
		HyperSleep(25)
		RunFunction(2000)
		HyperSleep(25)
		send {a down}
		HyperSleep(2350)
		send {a up}
		HyperSleep(25)
		send {space down}
		send {a down}
		HyperSleep(400)
		send {space up}
		send {a up}
		HyperSleep(500)
		MacroStatusToolTip("At ore " OreNumber ".")
	}
	else
	if (OreNumber == 8) then
	{
		MacroStatusToolTip("Going to ore " OreNumber "...")
		send {a down}
		HyperSleep(2500)
		send {a up}
		HyperSleep(25)
		send {w down}
		HyperSleep(500)
		send {w up}
		MacroStatusToolTip("At ore " OreNumber ".")
	}
	else
	if (OreNumber == 9) then
	{
		MacroStatusToolTip("Going to ore " OreNumber "...")
		send {a down}
		HyperSleep(1750)
		send {a up}
		HyperSleep(25)
		RunFunction(1750)
		HyperSleep(25)
		send {d down}
		HyperSleep(400)
		send {d up}
		HyperSleep(25)
		send {s down}
		HyperSleep(250)
		send {s up}
		MacroStatusToolTip("At ore " OreNumber ".")
	}
	else
	if (OreNumber == 10) then
	{
		MacroStatusToolTip("Going to ore " OreNumber "...")
		send {d down}
		HyperSleep(2900)
		send {d up}
		MacroStatusToolTip("At ore " OreNumber ".")
	}
	else
	if (OreNumber == 11) then
	{
		MacroStatusToolTip("Going to ore " OreNumber "...")
		send {d down}
		HyperSleep(1750)
		send {d up}
		HyperSleep(25)
		Loop, 4
		{
			send {,}
		}
		HyperSleep(25)
		RunFunction(1250)
		HyperSleep(25)
		send {d down}
		HyperSleep(325)
		send {d up}
		MacroStatusToolTip("At ore " OreNumber ".")
	}
	else
	if (OreNumber == 12) then
	{
		Loop, 4
		{
			send {.}
		}
		HyperSleep(25)
		send {a down}
		HyperSleep(650)
		send {a up}
		HyperSleep(25)
		RunFunction(1250)
		HyperSleep(25)
		send {d down}
		HyperSleep(350)
		send {d up}
	}
	else
	if (OreNumber == 13) then
	{
		send {a down}
		HyperSleep(325)
		send {a up}
		HyperSleep(25)
		send {w down}
		HyperSleep(200)
		send {w up}
	}
	else
	if (OreNumber == 14) then
	{
		send {space down}
		send {a down}
		HyperSleep(400)
		send {a up}
		send {space up}
		HyperSleep(25)
		send {w down}
		HyperSleep(750)
		send {w up}
		HyperSleep(25)
		send {g down}
		HyperSleep(25)
		send {a down}
		HyperSleep(600)
		send {a up}
		HyperSleep(25)
		send {d down}
		send {w down}
		HyperSleep(300)
		send {g up}
		HyperSleep(25)
		send {w up}
		send {d up}
		HyperSleep(25)
		Loop, 7
		{
			send {space down}
			HyperSleep(100)
			send {space up}
			HyperSleep(100)
		}
		send {d down}
		send {w down}
		HyperSleep(1000)
		send {d up}
		send {w up}
		HyperSleep(250)
		RunFunction(2400, "a")
		HyperSleep(25)
		Loop, 4
		{
			send {.}
		}
		HyperSleep(25)
		RunFunction(750)
	}
	else
	if (OreNumber == 15) then
	{
		RunFunction(2300, "d")
		HyperSleep(100)
		send {w down}
		HyperSleep(300)
		send {w up}
	}
	else
	if (OreNumber == 16) then
	{
		send {s down}
		HyperSleep(400)
		send {s up}
		HyperSleep(25)
		send {d down}
		HyperSleep(450)
		send {d up}
	}
	else
	if (OreNumber == 17) then
	{
		RunFunction(2600, "a")
		HyperSleep(25)
		send {s down}
		HyperSleep(500)
		send {s up}
		HyperSleep(25)
		send {space down}
		HyperSleep(25)
		RunFunction(5900, "a")
		HyperSleep(25)
		send {space up}
		HyperSleep(250)
		send {s down}
		HyperSleep(1750)
		send {s up}
	}
	else
	if (OreNumber == 18) then
	{
		send {d down}
		HyperSleep(600)
		send {d up}
		HyperSleep(25)
		Loop, 3
		{
			send {.}
		}
		HyperSleep(25)
		send {w down}
		send {g down}
		HyperSleep(500)
		send {g up}
		HyperSleep(25)
		send {space down}
		HyperSleep(100)
		send {space up}
		HyperSleep(100)
		send {space down}
		HyperSleep(1000)
		send {space up}
		send {w up}
		HyperSleep(25)
		send {.}
		HyperSleep(1000)
		RunFunction(2000)
		HyperSleep(25)
		send {w down}
		send {a down}
		HyperSleep(500)
		send {w up}
		send {a up}
		HyperSleep(25)
		send {g down}
		HyperSleep(500)
		send {g up}
		HyperSleep(25)
		send {space down}
		HyperSleep(100)
		send {space up}
		HyperSleep(100)
		send {space down}
		HyperSleep(2000)
		send {space up}
		HyperSleep(750)
		RunFunction(1400, "d")
	}
	else
	if (OreNumber == 19) then
	{
		send {a down}
		HyperSleep(500)
		send {a up}
		HyperSleep(25)
		send {w down}
		HyperSleep(500)
		send {w up}
		HyperSleep(25)
		send {d down}
		HyperSleep(250)
		send {d up}
	}
	else
	if (OreNumber == 20) then
	{
		Loop, 4
		{
			send {.}
		}
		HyperSleep(25)
		RunFunction(1425)
		HyperSleep(25)
		send {w down}
		HyperSleep(25)
		send {q}
		HyperSleep(25)
		send {w up}
		HyperSleep(25)
		send {space down}
		HyperSleep(250)
		send {space up}
		HyperSleep(500)
		send {a down}
		HyperSleep(400)
		send {a up}
		HyperSleep(25)
		send {s down}
		HyperSleep(1250)
		send {s up}
		HyperSleep(25)
		send {w down}
		HyperSleep(425)
		send {w up}
		HyperSleep(250)
		RunFunction(2300, "d")
		HyperSleep(25)
		Loop, 4
		{
			send {.}
		}
		HyperSleep(25)
		send {g down}
		HyperSleep(1000)
		send {g up}
		HyperSleep(25)
		send {w down}
		HyperSleep(400)
		Loop, 20
		{
			send {space down}
			HyperSleep(50)
			send {space up}
			HyperSleep(50)
		}
		send {space down}
		HyperSleep(100)
		send {space up}
		send {w up}
		HyperSleep(500)
		send {s down}
		HyperSleep(500)
		send {s up}
		HyperSleep(250)
		RunFunction(1500)
		HyperSleep(25)
		send {d down}
		HyperSleep(750)
		send {d up}
		HyperSleep(25)
		RunFunction(125)
		HyperSleep(25)
		send {a down}
		HyperSleep(250)
		send {a up}
	}
	else
	if (OreNumber == 21) then
	{
		send {w down}
		HyperSleep(100)
		send {w up}
		HyperSleep(25)
	}
	else
	if (OreNumber == 22) then
	{
		send {a down}
		HyperSleep(225)
		send {a up}
		HyperSleep(25)
		RunFunction(425)
		HyperSleep(25)
		send {d down}
		HyperSleep(200)
		send {d up}
	}
	else
	if (OreNumber == 23) then
	{
		send {a down}
		HyperSleep(225)
		send {a up}
	}
}


RunFunction(Duration, Direction := "") {
	send {w down}
	HyperSleep(75)
	send {w up}
	HyperSleep(75)
	send {w down}
	if (Direction != "") then
	{
		send {s down}
		send {%Direction% down}
	}
	HyperSleep(Duration)
	send {w up}
	if (Direction != "") then
	{
		send {s up}
		send {%Direction% up}
	}
}


GateFunction(GateLocation) {
	SetKeyDelay, -1
	SetMouseDelay, -1
	SetBatchLines, -1
	global CanGate, ManaCharged, GatePercentageColor1, GatePercentageColor2
	global GateKey, PickaxeKey
	
	CanGate := false
	ManaCharged := false
	Loop
	{
		if (GatePercentageColor1 != "" && GatePercentageColor2 != "") then
		{
			break
		}
		if (GatePercentageColor1 == "") then
		{
			PixelGetColor, GatePercentageColor1, 35, 565
		}
		if (GatePercentageColor2 == "") then
		{
			PixelGetColor, GatePercentageColor2, 35, % 565 + 30
		}
		if (GatePercentageColor1 != "" && GatePercentageColor2 != "") then
		{
			break
		}
		HyperSleep(100)
	}
	send % PickaxeKey GateKey
	send {g down}
	GateTime := A_TickCount
	while (!CanGate)
	{
		if (A_TickCount - GateTime >= 3000) then
		{
			ImageSearch, MenuX, MenuY, % 1MenuX, % 1MenuY, % 2MenuX, % 2MenuY, *20 %A_ScriptDir%\MenuButton.png
			if (ErrorLevel = 0) then
			{
				HyperSleep(25)
				MouseMove, % MenuX, % MenuY
				HyperSleep(25)
				send {click}
				Loop, 2
				{
					HyperSleep(500)
					ImageSearch, MenuX, MenuY, % 1MenuX, % 1MenuY, % 2MenuX, % 2MenuY, *20 %A_ScriptDir%\MenuButton.png
					if (ErrorLevel = 1) then
					{
						break
					}
				}
			}
			break
		}
		if (!ManaCharged)
		{
			PixelSearch, Px, Py, 35, 565, 35, 565, % GatePercentageColor1, 10, Fast
			if (ErrorLevel = 1) then
			{
				ManaCharged := true
			}
		}
		else
		{
			PixelSearch, Px, Py, 35, % 565 + 30, 35, % 565 + 30, % GatePercentageColor2, 10, Fast
			if (ErrorLevel = 0) then
			{
				CanGate := true
			}
		}
		HyperSleep(25)
	}
	send {g up}
	HyperSleep(25)
	send {clickright}
	HyperSleep(250)
	Temp_CB := clipboardall
	clipboard := GateLocation
	send /
	HyperSleep(250)
	send ^v
	HyperSleep(100)
	send {enter}
	clipboard := Temp_CB
}


ResetCameraAngles() {
	Loop, 12
	{
		send {PgUp}
		HyperSleep(25)
	}
	HyperSleep(75)
	Loop, 3
	{
		send {PgDn}
		HyperSleep(25)
	}
	HyperSleep(75)
	Loop, 12
	{
		send i
		HyperSleep(25)
	}
	HyperSleep(75)
	Loop, 5
	{
		send o
		HyperSleep(25)
	}
}


ResetVariables() {
	global MacroStatus, RandomStatus
	global HasPickaxe, HasForceField
	global ForceFieldDetections, SteppedOut
	global ManaCharged, CanGate
	global FacingS3Ores
	
	MacroStatus := ""
	RandomStatus := ""
	HasPickaxe := false
	HasForceField := false
	ForceFieldDetections := []
	SteppedOut := false
	ManaCharged := false
	CanGate := false
	FacingS3Ores := false
}


ReadIniFile() {
	global IniFile := A_ScriptDir . "\" . "Auto Blacksmith Farming" . "IniFile.ini"
	if FileExist(IniFile) then
	{
		IniRead, 1MenuX, % IniFile, Stored Variables, 1MenuX
		IniRead, 1MenuY, % IniFile, Stored Variables, 1MenuY
		IniRead, 2MenuX, % IniFile, Stored Variables, 2MenuX
		IniRead, 2MenuY, % IniFile, Stored Variables, 2MenuY
	}
}


MacroStatusToolTip(MSText) {
	global MacroStatus, RandomStatus
	Text := ""
	Text .= "Macro Status:`n"
	Text .= MSText
	if (RandomStatus != "") then
	{
		Text .= "`nRandom Status:"
	}
	Text .= "`n" RandomStatus
	MacroStatus := MSText
	ToolTip, % Text, % (A_ScreenWidth // 2) + (A_ScreenWidth // 10), % (A_ScreenHeight // 2)
	return Text
}


RandomStatusToolTip(RSText) {
	global MacroStatus, RandomStatus
	Text := ""
	Text .= "Macro Status:`n" . MacroStatus . "`n"
	Text .= "Random Status:`n"
	Text .= RSText
	RandomStatus := RSText
	ToolTip, % Text, % (A_ScreenWidth // 2) + (A_ScreenWidth // 10), % (A_ScreenHeight // 2)
	return Text
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


*$f7::
Reload
return


RemoveTT:
ToolTip
return
