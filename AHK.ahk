#Requires AutoHotkey v2.0
#SingleInstance Force

; Initialize toggle variables for quotes
global doubleQuoteToggle := false
global singleQuoteToggle := false

; Function to check if the preceding character is a space or at the beginning of a sentence
IsOpeningQuote() {
    lastChar := GetCharBeforeCaret()
    return (lastChar == " " or lastChar == "`n" or lastChar == "`r" or lastChar == "" or lastChar == "." or lastChar == "!" or lastChar == "?")
}

; Function to get the character before the caret
GetCharBeforeCaret() {
    ClipboardOld := ClipboardAll()
    A_Clipboard := ""
    Send("^+{Left}^c{Right}")
    if !ClipWait(0.2)
        return ""
    char := A_Clipboard
    A_Clipboard := ClipboardOld
    return char
}

; Remap double quote key
$"::
{
    global doubleQuoteToggle
    Sleep(50)  ; Small delay for reliability
    if (IsOpeningQuote() or !doubleQuoteToggle) {
        Send("{U+201C}")  ; Left double quotation mark
        doubleQuoteToggle := true
    } else {
        Send("{U+201D}")  ; Right double quotation mark
        doubleQuoteToggle := false
    }
    LogDebugInfo("Double Quote", GetCharBeforeCaret())
}

; Remap single quote key
$'::
{
    global singleQuoteToggle
    Sleep(50)  ; Small delay for reliability
    if (IsOpeningQuote() or !singleQuoteToggle) {
        Send("{U+2018}")  ; Left single quotation mark
        singleQuoteToggle := true
    } else {
        Send("{U+2019}")  ; Right single quotation mark
        singleQuoteToggle := false
    }
    LogDebugInfo("Single Quote", GetCharBeforeCaret())
}

; Function to log debug information
LogDebugInfo(quoteType, precedingChar) {
    global doubleQuoteToggle, singleQuoteToggle
    FileAppend(
        "Time: " . A_Now . "`n" .
        "Quote Type: " . quoteType . "`n" .
        "Preceding Character: '" . precedingChar . "' (ASCII: " . Ord(precedingChar) . ")`n" .
        "Double Quote Toggle: " . doubleQuoteToggle . "`n" .
        "Single Quote Toggle: " . singleQuoteToggle . "`n`n",
        "quote_log.txt"
    )
}

; Hotkey for debugging (Ctrl+Shift+D)
^+d::
{
    global doubleQuoteToggle, singleQuoteToggle
    precedingChar := GetCharBeforeCaret()
    MsgBox(
        "Debug Info:`n" .
        "Preceding Character: '" . precedingChar . "' (ASCII: " . Ord(precedingChar) . ")`n" .
        "Double Quote Toggle: " . doubleQuoteToggle . "`n" .
        "Single Quote Toggle: " . singleQuoteToggle
    )
}

; Error handling
LogError(exception, mode) {
    FileAppend(
        "Time: " . A_Now . "`n" .
        "Error: " . exception.Message . "`n" .
        "File: " . exception.File . "`n" .
        "Line: " . exception.Line . "`n" .
        "What: " . exception.What . "`n" .
        "Extra: " . exception.Extra . "`n`n",
        "error_log.txt"
    )
}

OnError(LogError)
