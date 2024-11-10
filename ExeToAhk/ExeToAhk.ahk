filePath := FileSelect(3, , "Open a compiled script", "Compiled Scripts (*.exe)")
If !FileExist(filePath)
    ExitApp
fileContents := FileRead(filePath)
found := RegExMatch(fileContents, "s)<COMPILER: v\d+\.\d+\.\d+.\d+>\n(.*)", &extractedScript)
if found {
    ; TODO: make always strip ending
    script := RegExReplace(extractedScript[1], "s)(.*?)(PAD|PA|P)?$", "$1")
    savedFilePath := FileSelect("S", "ExtractedScript.ahk")
    FileAppend(script, savedFilePath)
    res := MsgBox("Would you like to view the script?", "Success!", "Iconi Y/N")
    If (res = "Yes")
        Run("notepad " savedFilePath)
} else {
    MsgBox("Failed to extract script`nIt's possible this archive has been compressed or encrypted`nOr isn't even AutoHotkey", "Failed", "Icon!")
}