#NoEnv
#KeyHistory 0
#SingleInstance force
SendMode Input
#WinActivateForce
SetBatchLines -1
#IfWinActive ahk_exe GenshinImpact.exe
#MaxThreadsPerHotkey 1

SearchImage(imageFile) {
    CoordMode, Screen

    ImageSearch, foundX, foundY, FX, FY, ScreenWidth, ScreenHeight, *32 %imageFile%
    
    if (ErrorLevel = 0) {
        check := 1
        return check, foundX, foundY
    } else {
        check := 0
    }
}

ClickImage(imageFile) {
    i := 0
    while 1 {
        tempImageFile := imageFile . i . ".png"

        SearchImage(tempImageFile)

        if (FileExist(tempImageFile)) {
            if (check) {
                Click, %foundX%, %foundY%
                Sleep 100
                break
            } else {
                i += 1
            }
        } else {
            Click
            Sleep 100
            break
        }
        Sleep 100
    }
}

global foundX := 0
global foundY := 0
global FX
global FY
global default_i
global check := 0
global ScreenWidth
global ScreenHeight

; =========================
; These are the search coordinates. With the default value, the search will start from 0x0 to ScreenWidthxScreenHeight (find the entire screen). These values can be adjusted for better performance.
SysGet, ScreenWidth, 78 ; Search to X
SysGet, ScreenHeight, 79 ; Search to Y
FX := 0 ; Search from X
FY := 0 ; Search from Y
; =========================

; =========================
/*
Let's say that when talking to an NPC and having 4 dialogue options,
"0.png" will be the snapshot to search for and select the first dialogue choice,
"1.png" will be the snapshot to search for and select the second dialogue option,
"2.png" will be the screenshot to search for and select the third dialogue option,
"3.png" will be the screenshot to search for and select the fourth dialogue option,
and so on.
The first dialogue selection will be the last selection (the one closest to the text box).
The variable `default_i` is a variable to determine which dialogue option should be selected first. If that option is not available, the next options will be found. For example, `default_i := 1` will always look for the second dialogue choice first.
To learn how to generate image data, please visit `https://www.autohotkey.com/docs/v2/lib/ImageSearch.htm#Remarks`
*/
default_i := 0
; =========================

f8::
    Suspend -1
    return
    
`::
    i := default_i
    while 1 {
        if GetKeyState("TAB") & 1 {
            break
        }
        try {
            Sleep 1000
            SearchImage(".\data\chat\" . i . ".png")
            if (check) {
                Sleep 3000
                Click, %foundX%, %foundY%
            } else {
                i := i + 1
            }
        } catch {
            i := default_i
            Send {space}
        }
    }
    return

backspace::
    ClickImage(".\data\cancel\")
    return
enter::
    ClickImage(".\data\confirm\")
    return

; There may be some NPCs whose interactive dialogue options are out of order compared to the order in ahk. This depends on the image data you create. Below is just sample code.
; Currently testing navigating between dialogue options using the arrow keys

+1:: ; Shift + 1
    SearchImage(".\data\chat\0.png")
    Click, %foundX%, %foundY%
    return

+2:: ; Shift + 2
    SearchImage(".\data\chat\1.png")
    Click, %foundX%, %foundY%
    return

+3:: ; Shift + 3
    SearchImage(".\data\chat\2.png")
    Click, %foundX%, %foundY%
    return

+4:: ; Shift + 4
    SearchImage(".\data\chat\3.png")
    Click, %foundX%, %foundY%
    return