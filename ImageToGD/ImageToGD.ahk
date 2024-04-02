/* Image to GD

Converts Geometry Data to spwn code, which then allows you to use it in Geometry Dash

Shapes (type conversion) - See README for supported shapes:
1 -> 211 (Rectangle)
2 -> 211 (Rotated Rectangle)
4 -> 693 (Triangle)
8 -> 1764 (Ellipses)
16 -> 1764 (Rotated Ellipses)
32 -> 1764 (Circle)
64 -> 1753 (Line)
128 -> (Quadratic Beziers)
256 -> (multiple?) 468 (Polyline)
*/

try FileDelete("BuildImage.spwn")

if WinExist("Geometry Dash")
    MsgBox("It appears Geometry Dash is running, I highly recommend to close it before continuing, as keeping it running may prevent spwn from writing to the save file.", "Geometry Dash is running", "Icon!")

fileName := FileSelect(3,,, "Geometry Data (*.json; *.svg)")
if (fileName = "")
    ExitApp
objFile := FileRead(fileName)
RegexMatch(fileName, "\.(.*)$", &fileExt)

Script := "extract $; extract obj_props`n"
if (fileExt[1] = "json") {
    Loop Parse objFile, "`n" {
        found := RegexMatch(A_LoopField, '\{"type":(\d+), "data":\[(\d+),(\d+),(\d+),?(\d+)?\],"color":\[(\d+),(\d+),(\d+),128\],.*\},?', &GDObj)
        if (!found)
            Continue
        if (GDObj[1] = 1) { ; Rectangle
            Script .= "add(obj {OBJ_ID: 1927, X: " GDObj[2] ", Y: " GDObj[3] ", 128: " GDObj[4] / 8 ", 129: " GDObj[5] / 8 ", HVS: `"" RGBToHSV(GDObj[6], GDObj[7], GDObj[8]) "`", HVS_ENABLED: true, Z_ORDER: " A_Index ",})`n"
        } else if (GDObj[1] = 8) { ; Ellipses
            Script .= "add(obj {OBJ_ID: 1764, X: " GDObj[2] ", Y: " GDObj[3] ", 128: " GDObj[4] / 4 ", 129: " GDObj[5] / 4 ", HVS: `"" RGBToHSV(GDObj[6], GDObj[7], GDObj[8]) "`", HVS_ENABLED: true, Z_ORDER: " A_Index ",})`n"
        } else if (GDObj[1] = 32) { ; Circle
            Script .= "add(obj {OBJ_ID: 1764, X: " GDObj[2] ", Y: "  GDObj[3] ", SCALING: " GDObj[4] / 4 ", HVS: `"" RGBToHSV(GDObj[6], GDObj[7], GDObj[8]) "`", HVS_ENABLED: true, Z_ORDER: " A_Index ",})`n"
        } else {
            Script .= "print(`"Unsupported Object: " GDObj[1] "`")"
        }
    }
} else if (fileExt[1] = "svg") {
    Loop Parse objFile, "`n" {
        if RegexMatch(A_LoopField, '<(\?xml|\/?svg)') { ; xml and svg tag
            Continue
        } else if RegexMatch(A_LoopField, '<circle cx="(\d+)" cy="(\d+)" r="(\d+)".*?fill="rgb\((\d+),(\d+),(\d+)\).*>', &GDObj) {
            Script .= "add(obj {OBJ_ID: 1764, X: " GDObj[1] ", Y: "  GDObj[2] ", SCALING: " GDObj[3] / 4 ", HVS: `"" RGBToHSV(GDObj[4], GDObj[5], GDObj[6]) "`", HVS_ENABLED: true, Z_ORDER: " A_Index ",})`n"
        } else if RegexMatch(A_LoopField, '<line x1="(\d+)" y1="(\d+)" x2="(\d+)" y2="(\d+).*?stroke="rgb\((\d+),(\d+),(\d+).*>', &GDObj) {
            Script .= "add(obj {OBJ_ID: 1753, X: " (GDObj[1] + GDObj[3]) / 2 ", Y: " (GDObj[2] + GDObj[4]) / 2 ", 128: " Sqrt((GDObj[3] - GDObj[1]) ** 2 + (GDObj[4] - GDObj[2]) ** 2) / 30 ", ROTATION: " Degrees(GDObj[4] - GDObj[2], GDObj[3] - GDObj[1]) ", HVS: `"" RGBToHSV(GDObj[5], GDObj[6], GDObj[7]) "`", HVS_ENABLED: true, Z_ORDER: " A_Index ",})`n"
        } else if RegexMatch(A_LoopField, '^<ellipse cx="(\d+)" cy="(\d+)" rx="(\d+)" ry="(\d+).*?fill="rgb\((\d+),(\d+),(\d+)\).*>', &GDObj) {
            Script .= "add(obj {OBJ_ID: 1764, X: " GDObj[1] ", Y: " GDObj[2] ", 128: " GDObj[3] / 4 ", 129: " GDObj[4] / 4 ", HVS: `"" RGBToHSV(GDObj[5], GDObj[6], GDObj[7]) "`", HVS_ENABLED: true, Z_ORDER: " A_Index ",})`n"
        } else if RegexMatch(A_LoopField, '<g transform="translate\((\d+) (\d+)\) rotate\((\d+)\) scale\((\d+) (\d+)\)"><ellipse.*?fill="rgb\((\d+),(\d+),(\d+).*>', &GDObj) {
            Script .= "add(obj {OBJ_ID: 1764, X: " GDObj[1] ", Y: " GDObj[2] ", ROTATION: " 0-(GDObj[3]) ", 128: " GDObj[4] / 4 ", 129: " GDObj[5] / 4 ", HVS: `"" RGBToHSV(GDObj[6], GDObj[7], GDObj[8]) "`", HVS_ENABLED: true, Z_ORDER: " A_Index ",})`n"
        } else {
            RegexMatch(A_LoopField, '<(.*?) ', &Shape)
            Script .= "print(`"Unsupported Object: " Shape[1] "`")`n"
        }
    }
}
FileAppend(Script, "BuildImage.spwn")
MsgRes := MsgBox("Complete! Now run 'spwn build `"" A_ScriptDir "\BuildImage.spwn`" in command prompt`n`nWould you like me to do it for you?", "Conversion Success!", 4)
if (MsgRes = "Yes")
    Run("cmd /K spwn build `"" A_ScriptDir "\BuildImage.spwn`"")
Return


RGBToHSV(r, g, b) {
    RGBMax := Max(r, g, b)
    RGBMin := Min(r, g, b)
    if (RGBMax - RGBMin = 0) {
        h := "0a"
    } else if (RGBMax = r) {
        h := 60 * ((g - b) / (RGBMax - RGBMin)) + 360 "a"
    } else if (RGBMax = g) {
        h := 60 * ((b - r) / (RGBMax - RGBMin)) + 120 "a"
    } else {
        h := 60 * ((r - g) / (RGBMax - RGBMin)) + 240 "a"
    }
    if (RGBMax != 0) {
        s := (RGBMax - RGBMin) / RGBMax "a"
    } else {
        s := "0a"
    }
    v := RGBMax / 255 "a1a1"
    return h s v
}

Degrees(y, x) {
    return -((DllCall("msvcrt\atan2", "Double", y, "Double", x, "CDECL Double") * 180) / (ATan(1) * 4))
}