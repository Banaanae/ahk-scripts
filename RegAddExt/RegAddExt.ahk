#Requires AutoHotkey v2

regGui := Gui(, "RegAddExt")
regGui.Add("Text", "x10 y10 w90 h20", "v1 extentions")
regGui.Add("Text", "x100 y10 w90 h20", "v2 extentions")
ah1 := regGui.Add("CheckBox", "x10 y35 w90 h20 checked", ".ah1")
ahk1 := regGui.Add("CheckBox", "x10 y60 w90 h20 checked", ".ahk1")
ah2 := regGui.Add("CheckBox", "x100 y35 w90 h20 checked", ".ah2")
ahk2 := regGui.Add("CheckBox", "x100 y60 w90 h20 checked", ".ahk2")
regGui.Add("Button", "x10 y85 w205 h20", "Add selected").OnEvent("Click", AddExt)
regGui.Add("Button", "x225 y85 w205 h20", "Remove selected").OnEvent("Click", RemExt)
regGui.Add("Text", "x230 y10 w200 h20", "Custom extensions (new line for each)")
editExtList := regGui.Add("Edit", "x230 y35 w200 h45")
regGui.Show()
Return

AddExt(*) {
    extList := EditToArray()
    script := "#Requires AutoHotkey v2`n"
    if (ah1.Value)
        script .= "RegWrite(`"AutoHotkeyScript`", `"REG_SZ`", `"HKCR\.ah1`")`n"
    if (ahk1.Value)
        script .= "RegWrite(`"AutoHotkeyScript`", `"REG_SZ`", `"HKCR\.ahk1`")`n"
    if (ah2.Value)
        script .= "RegWrite(`"AutoHotkeyScript`", `"REG_SZ`", `"HKCR\.ah2`")`n"
    if (ahk2.Value)
        script .= "RegWrite(`"AutoHotkeyScript`", `"REG_SZ`", `"HKCR\.ahk2`")`n"
    for i, key in extList
        script .= "RegWrite(`"AutoHotkeyScript`", `"REG_SZ`", `"HKCR\`" " key ")`n"
    FileAppend(script, "addexttoreg.ahk")
    RunWait('*RunAs "' A_ScriptDir '\addexttoreg.ahk"')
    FileDelete("addexttoreg.ahk")
}

RemExt(*) {
    extList := EditToArray()
    script := "#Requires AutoHotkey v2`n"
    if (ah1.Value)
        script .= "try RegDeleteKey(`"HKCR\.ah1`")`n" ; "try" is to supress warnings if key doesn't exist
    if (ahk1.Value)
        script .= "try RegDeleteKey(`"HKCR\.ahk1`")`n"
    if (ah2.Value)
        script .= "try RegDeleteKey(`"HKCR\.ah2`")`n"
    if (ahk2.Value)
        script .= "try RegDeleteKey(`"HKCR\.ahk2`")`n"
    for i, key in extList
        script .= "try RegDeleteKey(`"HKCR\`"" key ")`n"
    FileAppend(script, "addexttoreg.ahk")
    RunWait('*RunAs "' A_ScriptDir '\addexttoreg.ahk"')
    FileDelete("addexttoreg.ahk")
}

EditToArray() {
    extArray := []
    Loop Parse, editExtList.Value, "`n" {
        extArray.Push(RegexReplace(A_LoopField, "m)^([^.].*)", ".$1")) ; Add dot (how registry keys are formatted)
    }
    return extArray
}