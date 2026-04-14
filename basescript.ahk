#Requires AutoHotkey v2.0
Persistent
; Ensure single instance of the script
#SingleInstance Force
global textBuffer := ""
executing := false
AZ_PASSWORD := "Alphabeta432"
global executingShutdown := false
global aborted := False
SetTimer idleMouse, 777
; SetTimer refreshWalmartPage, 20000
idleMouse() {
    if (A_TimeIdleMouse > 150000) {
        screenWidth := A_ScreenWidth
        screenHeight := A_ScreenHeight
        centerX := screenWidth // 2
        centerY := screenHeight // 2
        MouseMove centerX, centerY, 0
    }
}
sendDownKeys(count := 30, delayMs := 50) {
    loop count {
        Send("{Down}")
        Sleep delayMs
    }
}
; ^+!l::
; {
;     while (true) {
;         refreshWalmartPage()
;         sleep 20000
;     }
; }
; refreshWalmartPage() {
;     A_Clipboard := ""
;     showChromeBrowser()
;     sendInput "^{R}"
;     sleep 10000
;     mousemove 1372, 509, 0
;     click
;     sleep 100
;     sendInput "^{a}"
;     sleep 1000
;     sendInput "^{c}"
;     ClipWait  ; Espera hasta que el portapapeles tenga contenido
;     FileOpen("C:\Users\rherrera\Desktop\Code\Python\walmartTracking\new.txt", "w", "CP1252").Write(A_Clipboard)
;     mousemove 1372, 600, 0
; }
astProjectCreationDropdown() {
    MyGui := Gui()

    MyGui.Add("Text", , "Fill the fields to create an AST Project")
    MyGui.Add("Text", , "projectName")
    MyGui.Add("Edit", "vprojectName w150",)
    MyGui.Add("Text", , "projectSubtitle")
    MyGui.Add("Edit", "vprojectSubtitle w150",)
    MyGui.Add("Text", , "manufacturerID")
    MyGui.Add("Edit", "vmanufacturerID w150",)
    MyGui.Add("Text", , "createdBy")
    MyGui.Add("Edit", "vcreatedBy w150",)
    MyGui.Add("Text", , "assignee")
    MyGui.Add("Edit", "vassignee w150",)
    MyGui.Add("Text", , "qcAssignee")
    MyGui.Add("Edit", "vqcAssignee w150",)
    MyGui.Add("Text", , "vehicles")
    MyGui.Add("Edit", "vvehicles w150",)
    MyGui.Add("Text", , "specifications")
    MyGui.Add("Edit", "vspecifications w150",)

    MyGui.Add("Button", "Default", "OK").OnEvent("Click", OK_Click)

    MyGui.Show("x" . A_ScreenWidth // 2 . " y" . A_ScreenHeight // 2)
    OK_Click(*) {
        saved := MyGui.Submit()
        MyGui.Hide()
        createASTProjectRequest(saved.projectName, saved.projectSubtitle, saved.manufacturerID, saved.createdBy, saved.assignee,
            saved.qcAssignee, saved.vehicles, saved.specifications)

    }
}

createASTProjectRequest(projectName, projectSubtitle, manufacturerID, createdBy, assignee, qcAssignee, vehiclesInput,
    specificationsInput) {
    url := "http://vmq-alfrescona-02.alldata.com:8448/authored-specs/projects"

    ; Helper to convert comma-separated string to JSON array
    ToJsonArray(str, isString := true) {
        arr := StrSplit(str, ",")
        result := ""
        for i, item in arr {
            item := Trim(item)
            if (isString)
                result .= '"' item '"'
            else
                result .= item
            if (i < arr.Length)
                result .= ", "
        }
        return result
    }

    vehicles := ToJsonArray(vehiclesInput, true)
    specifications := ToJsonArray(specificationsInput, false)

    json := '{'
        . '"title": "' projectName '", '
        . '"subtitle": "' projectSubtitle '", '
        . '"notes": "NOTES", '
        . '"manufacturerId": "' manufacturerID '", '
        . '"createdBy": "' createdBy '", '
        . '"assignee": "' assignee '", '
        . '"qcAssignee": "' qcAssignee '", '
        . '"priority": "LOW", '
        . '"status": "IN_PROGRESS", '
        . '"languages": ["en_US"], '
        . '"markets": ["US"], '
        . '"vehicles": [' vehicles '], '
        . '"specifications": [' specifications ']'
        . '}'

    FileAppend("Sending JSON:`n" json "`n`n", A_Temp "\ahk_http_debug.txt", "UTF-8")

    http := ComObject("WinHttp.WinHttpRequest.5.1")
    http.Open("POST", url, false)
    http.SetRequestHeader("Content-Type", "application/json")
    http.SetRequestHeader("Accept", "application/json")
    http.SetRequestHeader("Authorization", "Bearer " . getASTToken())
    A_Clipboard := json
    http.Send(json)

    status := http.Status
    headers := http.GetAllResponseHeaders()
    response := http.ResponseText

    MsgBox response
}

::astpj::
{
    astProjectCreationDropdown()

}
getASTToken() {
    url := "http://vmq-alfrescona-02.alldata.com:8448/authored-specs/auth/login"
    json := '{"username":"autest1","password":"5YABiULM"}'

    ; Depuración
    FileAppend("Sending JSON:`n" json "`n`n", A_Temp "\ahk_http_debug.txt", "UTF-8")

    http := ComObject("WinHttp.WinHttpRequest.5.1")
    http.Open("POST", url, false)
    http.SetRequestHeader("Content-Type", "application/json")
    http.SetRequestHeader("Accept", "application/json")
    http.Send(json)

    status := http.Status
    headers := http.GetAllResponseHeaders()
    response := http.ResponseText

    ; Extraer access_token con una expresión regular
    token := ""
    key := '"access_token":"'
    start := InStr(response, key)
    if (start) {
        start += StrLen(key)
        end := InStr(response, '"', false, start)
        token := SubStr(response, start, end - start)
    }
    return token
}
^+!a::
{

    A_Clipboard := getASTToken()
}
^+!p::
{
    url := "https://vmq-alfrescona-02.alldata.com:8445/pet/authenticate"
    json := '{"username":"autest2","password":"6hMEXwaF"}'

    ; Depuración
    FileAppend("Sending JSON:`n" json "`n`n", A_Temp "\ahk_http_debug.txt", "UTF-8")

    http := ComObject("WinHttp.WinHttpRequest.5.1")
    http.Open("POST", url, false)
    http.SetRequestHeader("Content-Type", "application/json")
    http.SetRequestHeader("Accept", "application/json")
    http.Send(json)

    status := http.Status
    headers := http.GetAllResponseHeaders()
    response := http.ResponseText

    ; Extraer access_token con una expresión regular
    token := ""
    key := '"access_token":"'
    start := InStr(response, key)
    if (start) {
        start += StrLen(key)
        end := InStr(response, '"', false, start)
        token := SubStr(response, start, end - start)
    }

    A_Clipboard := token
}
getASTURL(environment, parameters) {
    baseURL := ""
    if (environment == "QA") {
        baseURL := "http://vmq-alfrescona-02.alldata.com/ast-ui/"
    }
    if (environment == "DATAVAL") {
        baseURL := "http://vmq-alfrescona-01.alldata.com/ast-ui/"
    }
    if (environment == "PRODUCTION") {
        baseURL := "http://alfresco-02.alldata.com/ast-ui/"
    }
    return baseURL . parameters
}
getVMURL(environment) {
    if (environment == "QA") {
        return "http://vmq-alfrescona-02.alldata.com/"
    }
}
getPETURL(environment) {
    if (environment == "QA") {
        return "https://vmq-alfrescona-02.alldata.com:8445/ui/#/dashboard"
    }
}
openIncognito(environment, app, parameters) {
    showChromeBrowser()
    sendInput "^+{n}"
    sleep 500
    sendInput "!{d}"
    sleep 10
    clip := A_Clipboard
    if (app == "AST") {
        A_Clipboard := getASTURL(environment, parameters)
    }
    if (app == "VM") {
        A_Clipboard := getVMURL(environment)
    }
    if (app == "PET") {
        A_Clipboard := getPETURL(environment)
    }
    sendInput "^{v}"
    sleep 100
    A_Clipboard := clip
    sleep 10
    sendInput "{Enter}"
    sleep 4000
    PID := WinActive("Site is not secure - Google Chrome")
    if PID {
        WinActivate(PID)
        sleep 200
        sendInput "{tab 3}"
        sleep 200
        SendInput "{Enter}"
        sleep 2500
    }
    sleep 80
    if (app == "VM") {
        sendInput "{tab 2}"
    }
    if (app == "PET") {
        sendInput "{tab}"
    }
    sendInput "{tab}"
    sleep 80
    sendInput "autest1"
    sleep 80
    sendInput "{tab}"
    sleep 80
    sendInput "5YABiULM"
    sleep 80
    sendInput "{enter}"
}
showChromeBrowser() {
    chrome := "ahk_exe chrome.exe"
    chrome_path := "C:\Program Files\Google\Chrome\Application\chrome.exe"
    if WinExist(chrome) {
        if (!WinActive(chrome)) {
            WinActivate
        }
    } else {
        run(chrome_path)
    }
}
::astui::
{
    openDropdownInput("Select the environment url", ["QA", "DATAVAL", "PRODUCTION"], "AST", "QA")
}
::vmui::
{
    openDropdownInput("Select the environment url", ["QA", "DATAVAL", "PRODUCTION"], "VM", "QA")
}
::petui::
{
    openDropdownInput("Select the environment url", ["QA", "DATAVAL", "PRODUCTION"], "PET", "QA")
}
::venv::
{
    sendInput "venv\Scripts\activate.bat{enter}"
}
^+Rbutton::
{
    sleep 500
    MouseMove 1879, 112, 0
    click
    Sleep 1000
    MouseMove 447, 308, 0
    click

}

; NumpadDot:: {
;     dotCount := 0
;     sleep 300
;     if (GetKeyState("NumpadDot", "P")) {
;         while GetKeyState("NumpadDot", "P") {
;             dotCount++
;             SendInput "."
;             ToolTip("Dots typed: " dotCount)
;             Sleep 300
;         }
;         sleep 2000
;         ToolTip("")
;     }
;     else {
;         dots := InputBox("", "How many dots?", "").value
;         loop dots {
;             sendInput "."
;         }
;     }
; }

; {
;     sendInput "){home}await{space}{end}"
; }

^+Space::
{
    runTeams()

}
runTeams() {
    teams := "ahk_exe ms-teams.exe"
    whatsapp := "ahk_exe ApplicationFrameHost.exe"
    if WinExist(teams) {
        if (!WinActive(teams)) {
            WinMinimize("ahk_exe olk.exe")
            WinActivate(teams)
        }
        else {
            WinMinimize(teams)
            WinMinimize("ahk_exe olk.exe")
            if WinExist(whatsapp) {
                if (!WinActive(whatsapp)) {
                    WinActivate
                }
                else {
                    WinMinimize(whatsapp)
                    if (!WinActive(teams)) {
                        WinMinimize("ahk_exe olk.exe")
                        WinActivate(teams)
                    }
                }
            }
        }
    }

    sendInput "{ctrl up}{shift up}{space up}"
    sendInput "{ctrl up}{shift up}{Lbutton up}"
}
runWhatsapp() {

}
; Hotkey "$numpad0", CaptureKeystroke
; Hotkey "$numpad1", CaptureKeystroke
; Hotkey "$numpad2", CaptureKeystroke
; Hotkey "$numpad3", CaptureKeystroke
; Hotkey "$numpad4", CaptureKeystroke
; Hotkey "$numpad5", CaptureKeystroke
; Hotkey "$numpad6", CaptureKeystroke
; Hotkey "$numpad7", CaptureKeystroke
; Hotkey "$numpad8", CaptureKeystroke
; Hotkey "$numpad9", CaptureKeystroke
; Hotkey "$Space", CaptureSpace
; Hotkey "$Backspace", CaptureBackspace

DeviceChange(wParam, lParam, msg, hwnd) {
    if (executingShutdown) {
        return
    }
    global executingShutdown := True
    Hotkey "$Space", CaptureSpace2
    timeout := 10
    while (timeout > 0) {
        Tooltip "Turning off the Pc, press space to cancel. Time left : " . timeout . " Seconds"
        sleep 1000
        timeout--
    }
    Tooltip
    if (!aborted) {
        shutdown 1
    }

    CaptureSpace2(ThisHotkey) {
        global aborted := True
        Tooltip
        Tooltip "Shutdown aborted successfully"
        sleep 5000
        Tooltip
        reload
    }
}

HandleResponse(http) {
    if (http.readyState == 4) {
        if (http.status == 200) {
            MsgBox "Success: " http.responseText
        } else {
            MsgBox "Error: " http.status " - " http.responseText
        }
    }
    return ""
}

; CaptureKeystroke(ThisHotkey) {
;     hotkeyText := SubStr(SubStr(ThisHotkey, 2), -1)
;     sendInput(hotkeyText)
;     global textBuffer
;     ; Append the last character, which is the number from the hotkey
;     textBuffer .= hotkeyText
;     ; ToolTip(textBuffer)
;     ; CheckBuffer()
; }
; CaptureSpace(ThisHotkey) {
;     sendInput "{Space}"
;     global textBuffer .= " "
;     CheckBuffer()
; }
; CaptureBackspace(ThisHotkey) {
;     sendInput "{Backspace}"
;     global textBuffer := SubStr(textBuffer, 1, -1)
; }
; checkBuffer() {
;     result := CheckForFourDigits(textBuffer)
;     url := "https://jira.alldata.com/browse/ST-"
;     if (result != "-1") {
;         url .= result
;         res := MsgBox("Would you like to open the story ST-" . textBuffer . "? (press Yes or No)", , "YesNo")
;         if res = "Yes"
;             run(url)
;     }
;     global textBuffer := ""
; }

; CheckForFourDigits(text) {
;     pattern := "^\d{5}.$"

;     if (RegExMatch(text, pattern, &match) > 0) {
;         return SubStr(text, 1, -1)
;     } else {
;         return -1
;     }
; }

Lwin & rbutton::
{
    sendInput "{Ctrl down}{Lwin down}{right}{Ctrl up}{Lwin up}"
    Sleep 100
    return
}

Lwin & lbutton::
{
    sendInput "{Ctrl down}{Lwin down}{left}{Ctrl up}{Lwin up}"
    Sleep 100
    return
}

:*:qsolr::
{

    field := StrSplit(InputBox("()", "Enter the field in solr", "").value, "_")
    range1 := InputBox("()", "Enter the min range", "").value
    range2 := InputBox("()", "Enter max range", "").value
    q := InputBox("()", "Enter the fild name to search", "").value
    field1 := field[1] . "_" . field[2] . "_"
    query := q . ":"
    queryBody := ""
    while (range1 <= range2) {
        queryBody := queryBody . field1 . range1
        if (range1 != range2) {
            queryBody .= " OR "
        }
        range1 := range1 + 1
    }
    query .= queryBody
    msgbox(query . "\n HAS BEEN COPIED TO THE CLIPBOARD")

    A_Clipboard := query
}

loopMethod() {
    SetTimer lockScreenFlase, 5000
}

movemouse() {
    if (A_TimeIdleMouse > 150000) {
        x := SysGet(78)
        y := SysGet(79)
        BlockInput(false)
        MouseMove x / 2, y / 2, 0
    }
}
lockScreenFlase() {
    ToolTip("The computer has been locked")
    movemouse()

    BlockInput(true)
}
#+l::
{
    loopMethod()
}
; ^+!Rbutton::
; {
;     clip := ""
;     A_Clipboard := ""
;     ; sendInput "{ctrl up}{Rbutton up}"
;     ; sleep 500

;     mousemove 2188, 631, 0
;     SendInput "{LButton 3}"
;     sendInput "{RButton}"
;     sleep 100
;     SendInput "{down}{Enter}"
;     sleep 100
;     clip := SubStr(A_Clipboard, 1, -2)
;     msg1 := "con leche y azúcar por favor"
;     msg2 := "té y café"
;     msg3 := "café y té"
;     msg4 := "con azúcar por favor"
;     msg5 := "café con leche por favor"
;     msg6 := "té por favor"
;     msg7 := "si o no"
;     msg8 := "leche por favor"
;     msg9 := "agua por favor"
;     msg10 := "por favor"
;     msg11 := "café o té"
;     msg12 := "con azúcar por favor"
;     msg13 := "café por favor"
;     msg14 := "no gracias"
;     msg15 := "café con leche"
;     msg16 := "si gracias"
;     msg17 := "leche o agua"
;     msg18 := "café y té por favor"
;     msg19 := "con leche por favor"
;     msg20 := "agua"
;     msg21 := "café"
;     msg22 := "Hola"
;     msg23 := "no gracias"
;     msg24 := "té o café"
;     msg25 := "si"
;     msg26 := "adiós"
;     msg27 := "con leche"
;     msg28 := "No"
;     msg29 := "si por favor"
;     msg30 := "gracias adiós"
;     msg31 := "de nada"
;     msg32 := "té"
;     msg33 := "leche y azúcar"

;     switch clip {
;         case "Tea and coffee.":
;             writeWord(msg2)
;         case "With milk and sugar, please.":
;             writeWord(msg1)
;         case "Coffee and tea.":
;             writeWord(msg3)
;         case "With sugar, please.":
;             writeWord(msg4)
;         case "Coffee with milk, please.":
;             writeWord(msg5)
;         case "Tea, please.":
;             writeWord(msg6)
;         case "Yes or no?":
;             writeWord(msg7)
;         case "Milk, please.":
;             writeWord(msg8)
;         case "Water, please.":
;             writeWord(msg9)
;         case "Please.":
;             writeWord(msg10)
;         case "Coffee or tea?":
;             writeWord(msg11)
;         case "Coffee, please.":
;             writeWord(msg13)
;         case "No, thank you.":
;             writeWord(msg14)
;         case "Coffee with milk.":
;             writeWord(msg15)
;         case "Yes, thank you.":
;             writeWord(msg16)
;         case "Milk or water?":
;             writeWord(msg17)
;         case "Coffee and tea, please.":
;             writeWord(msg18)
;         case "With milk, please.":
;             writeWord(msg19)
;         case "Water.":
;             writeWord(msg20)
;         case "Coffee.":
;             writeWord(msg21)
;         case "Hello.":
;             writeWord(msg22)
;         case "No, thank you.":
;             writeWord(msg23)
;         case "Tea or coffee?":
;             writeWord(msg24)
;         case "Yes.":
;             writeWord(msg25)
;         case "Goodbye!":
;             writeWord(msg26)
;         case "With milk.":
;             writeWord(msg27)
;         case "With milk?":
;             writeWord(msg27)
;         case "No.":
;             writeWord(msg28)
;         case "Yes, please.":
;             writeWord(msg29)
;         case "Thank you, goodbye.":
;             writeWord(msg30)
;         case "You're welcome!":
;             writeWord(msg31)
;         case "You're welcome.":
;             writeWord(msg31)
;         case "Tea?":
;             writeWord(msg32)
;         case "Milk and sugar.":
;             writeWord(msg33)
;         default:
;             clip := ""
;             A_Clipboard := ""
;             return
;     }
;     clip := ""
;     A_Clipboard := ""
;     clickandreturn()
;     return
; }
; ^Lbutton::
; {
;     clickandreturn()
;     return
; }
clickandreturn() {
    MouseGetPos &sx, &sy
    mousemove 2094, 1324, 0
    SendInput "{Lbutton 2}"
    mousemove sx, sy, 0
}
writeWord(word) {
    loop parse, word, " " {
        loop parse, A_LoopField {
            send A_LoopField
            sleep 40
        }
    }
    sendInput "{Lbutton}"
}

^+!c::
{
    run A_Clipboard
}

^+Xbutton1::
{
    WinMaximize "A"
}

::jenk ::
{
    run "https://jenkins.alldata.com/user/rmherrer/my-views/view/all"
}
moveWindowToRightDisplay() {
    sendInput " {Rwin down}+{left}{Rwin up}"
    WinMaximize "A"
}
moveWindowToLeftDisplay() {
    sendInput "#+{Right}"
    ; WinMaximize "A"
}
^Xbutton1::
{
    moveWindowToLeftDisplay()
}
^Xbutton2::
{
    moveWindowToRightDisplay()
}
moveMouseToScreenCenter() {
    x := (A_ScreenWidth // 2) - 450
    y := (A_ScreenHeight // 2) + 105
    mouseMove x, y, 0
    return
}
waitCtrlAndReturn() {
    KeyWait "CTRL, U"
    moveMouseToScreenCenter()
}
clickInSaveChanges() {
    mouseMove 1050, 285, 0
    sendInput " {Lbutton}"
}

GetScreenSize() {
    ; This is a placeholder. You need to replace it with actual code to get the screen dimensions.
    ; For example, in some environments, you might use a system call or a library function.
    return { Width: 1920, Height: 1080
    } ; Example screen size, replace with dynamic values
}

openDropdownInput(message, options, function, defaultOption) {
    MyGui := Gui()
    MyGui.Add("Text", , message)
    MyGui.Add("DDL", "vChoice w150", options)
    MyGui.Choice := "QA"

    if (function == "AST") {
        MyGui.Add("Text", , "Select Type:")
        Choice2DDL := MyGui.Add("DDL", "vChoice2 w150", ["Project", "Catalog"])
        Choice2DDL.OnEvent("Change", UpdateSubOptions)

        MyGui.Choice2 := "Catalog"

        MyGui.Add("DDL", "vChoice3 w150 Hidden", ["specifications", "specification-groups", "specification-types",
            "users", "database-view", "content-packages"])
    }

    MyGui.Add("Button", "Default", "OK").OnEvent("Click", OK_Click)
    MouseGetPos &xpos, &ypos
    MyGui.Show("x" . xpos . " y" . ypos)

    UpdateSubOptions(GuiCtrlObj, Info) {
        Gui := GuiCtrlObj.Gui
        Gui.Submit(false)  ; Update variables without closing the GUI
        selected := Gui["Choice2"].Text  ; Get the selected text from the second dropdown

        if (selected == "Catalog") {
            Gui["Choice3"].Visible := true
        } else {
            Gui["Choice3"].Visible := false
        }
    }

    OK_Click(*) {
        saved := MyGui.Submit()
        MyGui.Hide()
        opt := ""
        if (saved.Choice2 == "Catalog") {
            opt := saved.Choice3
        }
        else {
            if (saved.Choice2 == "Project") {
                opt := "project/571/specifications"
            }
            opt := saved.Choice2
        }
        openIncognito(saved.Choice, function, opt)
    }
}

:*:solrs::
{
    MyGui := Gui()
    MyGui.add("Text", , "Select a Solr to navigate to it")
    MyGui.ADD("DDL", "h50 w100 vSolrChoice", ["Staging", "Production", "Ontology"])
    MyGui.vSolrChoice := "Staging"
    MyGui.Add("Button", "Default", "OK").OnEvent("Click", OK_Click)
    MouseGetPos &xpos, &ypos
    ; Show the GUI window in the current mouse position
    MyGui.Show("x" . xpos . " y" . ypos)
    OK_Click(*) {
        saved := MyGui.Submit()
        MyGui.Hide()
        openSolr(saved.SolrChoice)
    }
}

openSolr(SolrChoice) {
    switch SolrChoice {
        case "Staging":
            solar := "http://bmq-nadata-01.alldata.com:8985/solr/#/QA-Vehicles-Staging-NA/query"
        case "Production":
            solar := "http://bmq-nadata-01.alldata.com:8985/solr/#/QA-Vehicles-Production-NA/query"
        case "Ontology":
            solar := "http://bmq-nadata-01.alldata.com:8995/solr/#/ALLDATA-Unified-Ontology/query"
        Default:
            solar := "http://bmq-nadata-01.alldata.com:8995/solr/#/ALLDATA-Unified-Ontology/query"

    }
    run(solar)
    return
}
:*:pjast::
{
    pj := InputBox("", "Enter the project id", "").value
    URL := "http://vmq-alfrescona-02.alldata.com/ast-ui/project/" . pj . "/specifications"
    run URL

}
:*:comit::
{
    sendInput "cls `;` git status{space}{enter}"
    KeyWait "CTRL", "D"
    KeyWait "CTRL", "U"
    sendInput " git commit -m `""
    KeyWait "CTRL", "D"
    KeyWait "CTRL", "U"
    sendInput "`" {enter}"
    KeyWait "CTRL", "D"
    KeyWait "CTRL", "U"
    sendInput "git push"
    Sleep 100
    sendInput "{enter}"
    KeyWait "CTRL", "D"
    KeyWait "CTRL", "U"
    sendInput "git checkout main"
    Sleep 100
    sendInput "{enter}"
    KeyWait "CTRL", "D"
    KeyWait "CTRL", "U"
    sendInput "git merge ManageVehiclesSmoke"
    Sleep 100
    sendInput "{enter}"
    KeyWait "CTRL", "D"
    KeyWait "CTRL", "U"
    sendInput "git push"
    Sleep 100
    sendInput "{enter}"
    KeyWait "CTRL", "D"
    KeyWait "CTRL", "U"
    sendInput "git checkout ManageVehiclesSmoke"
    Sleep 100
    sendInput "{enter}"
}
createMake(regions) {
    randomNumber := Random(100000)
    makeName := "new_make_" . randomNumber
    mousemove 652, 339, 0
    sendInput "{Lbutton}"
    sleep 200
    mousemove 1754, 271, 0
    sendInput "{Lbutton}"
    sleep 10
    sendInput makeName
    sendInput "{tab 2}{space}{tab 2}"
    loop regions {
        sendInput "{enter}{tab}"
    }
    mousemove 1852, 634, 0
    sendInput "{Lbutton}"
    mousemove 652, 339 + 50, 0
}

createModel(regions) {
    randomNumber := Random(100000)
    modelName := "new_model_" . randomNumber
    mousemove 1247, 347, 0
    sendInput "{Lbutton}"
    sleep 200
    mousemove 1738, 280, 0
    sendInput "{Lbutton}"
    sleep 10
    sendInput modelName
    sendInput "{tab 3}{space}{tab 2}"
    loop regions {
        sendInput "{enter}{tab}"
    }
    mousemove 1854, 633, 0
    sendInput "{Lbutton}"
    mousemove 852, 339 + 50, 0
}
:*:nmodel::
{
    if (WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe firefox.exe")) {
        setRegion(3)
    }
    return
}
:*:nmake::
{
    if (WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe firefox.exe")) {
        setRegion(2)
    }
    return
}
:*:nman::
{
    if (WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe firefox.exe")) {
        setRegion(1)
    }
    return
}
:*:nengine::
{
    if (WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe firefox.exe")) {
        setRegionAndFuelType()
    }
    return
}
setRegionAndFuelType() {
    MyGui := Gui()
    MyGui.add("Text", , "Select the fuel type for the engine")
    MyGui.add("DDL", "h50 w100 Choose1 vFuelTypeChoice", ["Gasoline", "Electric"
    ])
    MyGui.add("DDL", "h50 w100 Choose1 vRegionsChoice", [3, 2, 1
    ])
    MyGui.add("Button", "Default", "OK").OnEvent("Click", OK_Click)
    MyGui.Show()
    OK_Click(*) {
        saved := MyGui.Submit()
        MyGui.Hide()
        sleep 200
        createEngine(saved.FuelTypeChoice, saved.RegionsChoice)
    }
}

setRegion(element) {
    MyGui := Gui()
    MyGui.add("Text", , "Select regions for the element")
    MyGui.add("DDL", "h50 w100 Choose1 vRegionsChoice", [3, 2, 1
    ])
    MyGui.add("Button", "Default", "OK").OnEvent("Click", OK_Click)
    MyGui.Show()
    OK_Click(*) {
        saved := MyGui.Submit()
        MyGui.Hide()
        sleep 150
        switch element {
            case 1:
                createManufacturer(saved.RegionsChoice)
            case 2:
                createMake(saved.RegionsChoice)
            case 3:
                createModel(saved.RegionsChoice)
        }
    }
}
fillGasolineEngine(engineName) {
    sendInput "{enter}"
    sleep 50
    sendInput "{Shift down}{tab}{Shift up}{enter}"
    sleep 300
    sendInput "{tab}"
    randomBlockType := Random(1, 5)
    loop randomBlockType {
        sendInput "{down}"
        sleep 10
    }
    sleep 10
    sendInput "{tab 2}"
    randomCilinders := Random(100, 10000)
    sendInput randomCilinders
    sendInput "{tab}"
    sendInput "4.0"
    sleep 50
    sendInput "{tab}"
    randomHeadType := Random(1, 5)
    loop randomHeadType {
        sendInput "{down}"
        sleep 10
    }
    sleep 60
    sendInput "{tab 2}"
    sendInput "123"
    sleep 30
    sendInput "{tab}"
    sendInput "123"
    sleep 30
    sendInput "{tab}"
    sleep 30
    sendInput "Engine BIN"
    sleep 30
    sendInput "{tab}"
    sendInput "Engine Description"
    sleep 50
    sendInput "{tab}"
    sleep 10
    sendInput "{space}"
    sleep 50
    sendInput "{tab 4}{enter}"
    sleep 50
    sendInput "{Shift down}{tab}{Shift up}"
    sleep 50
    sendInput "{enter}"
    sleep 350
    sendInput "{tab}"
    sendInput "Engine Designation"
    sleep 50
    sendInput "{tab}"
    sendInput engineName
    sleep 150
    sendInput "{tab 2}{Space}{tab 2}"
}
fillElectricEngine(engineName) {
    sendInput "{tab 2}{enter}"
    sleep 50
    sendInput "{Shift down}{tab 3}{Shift up}"
    sleep 50
    sendInput "{enter}"
    sleep 300
    sendInput "{tab}"
    sendInput "Engine BIN"
    sleep 50
    sendInput "{tab}"
    sendInput "Engine Description"
    sleep 50
    sendInput "{tab}"
    sendInput "Engine Designation"
    sleep 50
    sendInput "{tab}"
    sendInput engineName
    sleep 150
    sendInput "{tab 2}{Space}{tab 2}"
}
createEngine(fuelType, regions) {
    gasoline := true
    if (fuelType == "Electric") {
        gasoline := false
    }
    randomNumber := Random(100000)
    engineName := "new_engine_" . randomNumber
    mousemove 1834, 345, 0
    sendInput "{Lbutton}"
    sleep 350
    mousemove 1688, 226, 0
    sendInput "{Lbutton}"
    sleep 10
    sendInput "{tab}{space}{tab 4}"
    sleep 400
    if (gasoline) {
        fillGasolineEngine(engineName)
    } else {
        fillElectricEngine(engineName)
    }
    sleep 50
    loop regions {
        sendInput "{enter}{tab}"
    }
    sleep 100
    sendInput "{Shift down}{tab}{Shift up}"
    sleep 100
    loop regions {
        sendInput "{Shift down}{tab}{Shift up}"
    }
    sleep 100
    sendInput "{enter}"
    sleep 300
    mousemove 1856, 982, 0
    sendInput "{Lbutton}"
    sleep 300
    mousemove 1813, 289, 0
}

createManufacturer(regions) {
    randomNumber := Random(100000)
    manufacturerName := "new_manufacturer_" . randomNumber
    manufacturerCode := "mft_" . randomNumber
    mousemove 353, 345, 0
    sendInput "{Lbutton}"
    sleep 300
    mousemove 1727, 302, 0
    sendInput "{Lbutton}"
    sleep 10
    sendInput manufacturerName
    sendInput "{tab}"
    sendInput manufacturerCode
    sendInput "{tab 2}{space}{tab 2}"
    loop regions {
        if (A_Index == 1) {
            sendInput "{tab}"
        } else {
            sendInput "{enter}{tab}"
        }
    }
    mousemove 1857, 667, 0
    sleep 200
    sendInput "{Lbutton}"
    mousemove 552, 339 + 50, 0
}

pgup::
{
    sendInput "{Media_Play_Pause}"
    return
}

pgdn::
{
    sendInput "{Media_Next}"
    return
}
; end::
; {
;     sendInput "{Media_Prev}"
;     return
; }
^9::
{
    ;Put the window coordinates to the bottom right corner
    ; get the ammount of records
    URL := "https://www.cccsecureshare.com/login/dashboard/application/1061/customers?page=1&desc=true&inactive=true"
    run URL
    sleep 5000
    mousemove 1344, 440, 0
    sendInput "{Lbutton}"
    sleep 2500
    sendInput "{tab 4}{enter}"
    sleep 4500
    mousemove 1775, 885, 0
    sendInput "{Lbutton 2}"
    sendInput "^{c}"
    sleep 300
    ammount_of_records := Integer(A_Clipboard * 1)
    ammount_of_pages := Floor(ammount_of_records / 10) + 1
    ; ammount_of_pages := 1
    sleep 300
    result := Array()
    date := Array()
    cccid := Array()
    shop_name := Array()
    address := Array()
    location := Array()
    phone := Array()
    contact := Array()
    email := Array()
    while (ammount_of_pages > 0) {
        ammount_of_pages--
        x := 2000
        y := 482
        mousemove x, y, 0
        sendInput "{Lbutton 3}"
        sleep 500
        sendInput "^{c}"
        sleep 500
        size := 0
        loop parse, A_Clipboard, "`n" {
            if (A_Index > 2 && A_Index < 13) ;will add other domains once working
            {
                loop parse, A_LoopField, "	" {
                    switch A_Index {
                        case 1:
                            cccid.Push(A_LoopField)
                        case 2:
                            shop_name.Push(A_LoopField)
                            size++
                        case 4:
                            formattedDate := StrSplit(A_LoopField, " ")
                            date.Push(formattedDate[1])
                    }
                }
            }
        }
        shop_name_x := 520
        shop_name_y := 400
        y_axis_difference := 49
        loop size {
            mousemove shop_name_x, shop_name_y, 0
            sendInput "{Lbutton}"
            sleep 1200
            mousemove 1195, 738, 0
            sendInput "{Lbutton down}"
            sleep 100
            mousemove 635, 328, 0
            sendInput "{Lbutton up}"
            sleep 10
            sendInput "^{c}"
            sleep 400
            card := Array()
            loop parse, A_Clipboard, "`n" {

                if (StrLen(A_LoopField) > 1 && A_Index > 1) {
                    if (A_LoopField != "View shop profile on Carwise.com") {
                        card.Push(A_LoopField)
                    }
                }
            }
            address_flag := false
            phone_flag := false
            location_flag := false
            contact_flag := false
            email_flag := false
            for i, v in card {
                ; MsgBox v
                found := false
                if RegExMatch(v, "\d+") {
                    if (InStr(v, "(") && !phone_flag) {
                        ; MsgBox "Phone if " . card[i]
                        phone.Push(v)

                        phone_flag := true
                        found := true
                    } else if (!address_flag) {
                        ; MsgBox "address if" . card[i]
                        address.Push(v)
                        address_flag := true
                        found := true
                    }
                } else {
                    if (i == 1) {
                        address_flag := true
                        address.Push(v)
                        found := true
                    }
                }
                if (InStr(v, ",") && !location_flag && !RegExMatch(v, "\d+")) {
                    val := StrUpper(v)
                    location.Push(val)
                    found := true
                    location_flag := true
                } else if (InStr(v, "@") && !email_flag && contact_flag) {
                    val := StrLower(v)
                    email.Push(val)
                    found := true
                    email_flag := true
                } else if (!found) {
                    contact_flag := true
                    val := StrTitle(v)
                    contact.Push(val)
                }
                if (i == card.Length) {
                    if (!phone_flag) {
                        phone.Push("")
                    }
                    if (!contact_flag) {
                        contact.Push("")
                    }
                    if (!address_flag) {
                        address.Push("")
                    }
                    if (!location_flag) {
                        location.Push("")
                    }
                    if (!email_flag) {
                        email.Push("")
                    }
                }
            }
            sleep 50
            sendInput "{esc 2}"
            sleep 500
            shop_name_y := shop_name_y + y_axis_difference
        }
        ; next page
        if (ammount_of_pages > 0) {
            mousemove 1857, 884, 0
            sendInput "{Lbutton}"
            sleep 3500
        }
    }
    ; the following loop deletes the line break at the end
    for i, v in email {
        address[i] := SubStr(address[i], 1, StrLen(address[i]) - 1)
        location[i] := SubStr(location[i], 1, StrLen(location[i]) - 1)
        phone[i] := SubStr(phone[i], 1, StrLen(phone[i]) - 1)
        contact[i] := SubStr(contact[i], 1, StrLen(contact[i]) - 1)
        email[i] := SubStr(email[i], 1, StrLen(email[i]) - 1)
    }

    for i, v in shop_name {
        value_res := date[i] . "`t" . cccid[i] . "`t" . shop_name[i] . "`t" . address[i] . "`t" . location[i] . "`t" .
            phone[i] . "`t" . contact[i] . "`t" . email[i]
        result.Push(value_res)
    }
    file_result := ""
    for i, v in result {
        file_result .= v . "`n"
    }

    currentDateTime := StrReplace(FormatTime(, "LongDate") . "-" . StrReplace(FormatTime("T12", "Time"), ":", "-"),
    ",", "-")
    DirCreate(A_ScriptDir . "\results\")
    sleep 200
    path := A_ScriptDir . "\results\" . currentDateTime . ".txt"
    FileAppend file_result, path
    option := MsgBox("Would you like to open the result txt file?", , "YesNo")
    if option == "Yes"
        run path
    return
}

getPingIDPassword() {
    pingid := "ahk_exe PingID.exe"

    if WinWait(pingid, , 6) {
        WinActivate
        Sleep 500
    }
    sendInput "{tab}{tab}"
    Sleep 1000
    send "130789"
    sendInput "{Enter}"
    Sleep 1000
    sendInput "{tab}"
    Sleep 500
    sendInput "{Enter}"
    Sleep 500
    sendInput "{Enter}"
    Sleep 100
    sendInput "{Enter}"
    ; MsgBox A_Clipboard
}
killVPNProgrammsIfExists() {
    pingid := "ahk_exe PingID.exe"
    vpnid := "ahk_exe vpnui.exe"
    if (WinExist(pingid)) {
        WinKill
    }
    if (WinExist(vpnid)) {
        WinKill
    }
}
connectVPN() {
    runVPNPrograms()
    vpnid := "ahk_exe vpnui.exe"
    if WinWait(vpnid, , 5) {
        WinActivate
        sleep 500
    }

    if (WinActive(vpnid)) {
        sendInput AZ_PASSWORD
        Sleep 500
        sendInput "{Enter}"
    }
    getPingIDPassword()
    pastePING()
    killVPNProgrammsIfExists()
}
pastePING() {
    vpnid := "ahk_exe vpnui.exe"
    if (WinExist(vpnid)) {
        WinActivate
        Sleep 200
        sendInput "^{v}"
        Sleep 300
        sendInput "{enter}"
    }
}
runVPNPrograms() {
    run "C:\Program Files (x86)\Ping Identity\PingID\PingID.exe"
    run "C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpnui.exe"
}
^+0::
{
    connectVPN()
}

^+!d::  ; This is the hotkey Ctrl+Shift+Alt+d
{
    Folder := "C:\Users\rherrera\Downloads"
    File := GetLastFolder(Folder)
    if (File != "") {
        result := MsgBox("Would you like to open the file " . File . " ?", "Question", 4)
        if (result == "Yes") {
            Run(Folder "\" File)  ; Corrected line with parentheses
        }
    }
}

GetLastFolder(Folder) {
    Time_Orig := 0
    LastFile := ""
    loop files, Folder "\*", "F" {
        Time := FileGetTime(A_LoopFileFullPath, "C")  ; Corrected usage
        if (Time && (Time > Time_Orig))  ; Ensure Time is not empty and is greater
        {
            Time_Orig := Time
            LastFile := A_LoopFileName
        }
    }
    return LastFile
}

^+y:: ;select a query and run this macro to search in youtube. Opens browser if is closed
{
    sendInput "^c"
    Sleep 100
    run "https://www.youtube.com/results?search_query=" . (A_Clipboard)
    return
}
^+!y:: ;Copy a youtube path and run this hotkey
{
    sendInput " ^c"
    Sleep 100
    ytid := StrSplit(A_Clipboard, "=")
    id := ytid[2]
    yid := StrSplit(id, "&")
    id := yid[1]
    run "https://www.y2mate.com/youtube/%id%"
    return
}

^+c:: ;select a google search and run this macro to search in
{
    sendInput " ^c"
    Sleep 100
    run "http://www.google.com/search?q=" . (A_Clipboard)
    return
}

; :*:git clone:: ;copy a github url, go to your terminal and type git clone, then press ctrl when the repo is fully downloaded, then press contol again to get into the folder with the repo name

;     {
;         url:= A_Clipboard
;         sendInput " git clone " . (A_Clipboard) . " {enter}"
;         ; KeyWait "ctrl, D"
;         ; KeyWait "ctrl, U"
;         ; array := StrSplit(url, "/")
;         ; fname := array.pop()
;         ; array2 := StrSplit(fname, ".")
;         ; fname2 := array2[1]
;         ; Clipboard:= fname2
;         ; KeyWait "ctrl, D"
;         ; KeyWait "ctrl, U"
;         ; sendInput " cd %clipboard% {enter}"
;         ; Sleep  800
;         ; sendInput " code . {enter}"
;     }

#Del::
{
    FileRecycleEmpty ; win + del
}

:*:alldp::
{
    sendInput "G"
    sendInput "{# down}"
    sendInput "{# up}"
    sendInput "pass24"
    sendInput "{! down}"
    sendInput "{! up}"
    sendInput "7"
}

:*:ps44::
{
    sendInput "Password44"
    sendInput "{enter}"
}

:*:ps33::
{
    sendInput "Password33"
    sendInput "{enter}"
}

:*:ps11::
{
    sendInput "Password333qwer"
    sendInput "{enter}"
}

:*:ps22::
{
    sendInput "Password22"
    sendInput "{enter}"
}

^AppsKey::
{
    if (getCurrentDesktopIndex() == 1) {
        activateTeams()
    } else if (getCurrentDesktopIndex() == 0) {
        ideapath := "C:\Users\rherrera\AppData\Local\JetBrains\IntelliJ IDEA Community Edition 2023.1.1\bin\idea64.exe"
        idea := "ahk_exe idea64.exe"
        class1 := ""
        if WinExist(idea) {
            if (!WinActive(idea)) {
                WinActivate
            }
        } else {
            run(ideapath)
        }
    }
}
getCurrentDesktopIndex() {
    ; cur:= RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\2\VirtualDesktops", "IsCurrentVDRemote")
    ; all:= RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops", "VirtualDesktopIDs")
    ; ix := floor(InStr(all,cur) / strlen(cur))
    return 0
}

^Rshift::
{
    showChromeBrowser()
}

^#up::
^#WheelUp::
{  ; Ctrl + Rueda Arriba para aumentar el volumen
    SoundSetVolume "+6"
}

^#Down::
^#WheelDown::
{
    SoundSetVolume "-6"
    return
}

;duplicate a tab in chrome
^l::
{
    if winactive("ahk_exe chrome.exe") {
        sendInput " {alt down}{d}{alt up}"
        Sleep 50
        sendInput " {ctrl down}{c}{ctrl up}"
        Sleep 50
        run "%clipboard%"
    }
}

:*:rh111::
{
    sendInput " RH111815008206{#}"
}

:*:rhm::
{
    sendInput " Ra{alt down}{Numpad1}{Numpad6}{Numpad3}{alt up}l Herrera Mac{alt down}{Numpad1}{Numpad6}{Numpad1}{alt up}as"
}

:*:rh@::
{
    SendInput "raul.herrera@autozone.com"
}
:*:fd@::
{
    SendInput "facelessdivine@gmail.com"
}
:*:fdg@::
{
    SendInput "facelessdivinegod@gmail.com"
}
:*:111@::
{
    SendInput "1118150082@utch.edu.mx"
}
:*:hemr::
{
    SendInput "HEMR000915HCHRCLA7"
}
:*:numss::
{
    SendInput "63160076053"
}
:*:autest1::
{
    SendInput "autest1"
    ; SendInput "{tab}"
    A_Clipboard := "5YABiULM"
}
:*:autest2::
{
    SendInput "autest2"
    ; SendInput "{tab}"
    A_Clipboard := "6hMEXwaF"
}
:*:autest3::
{
    SendInput "autest3"
    ; SendInput "{tab}"
    A_Clipboard := "HN4WuSJB"
}
:*:autest4::
{
    SendInput "autest4"
    ; SendInput "{tab}"
    A_Clipboard := "JpEqPfk7"
}

Mbutton::
{
    MouseGetPos , , &id, &control
    if id {
        if (winactive("ahk_exe chrome.exe")) {
            sendInput "^{w}"
        } else {
            WinMinimize { Hwnd: id
            } ; Minimize the window under the mouse
        }
    }

}
^Mbutton::
{
    if (winactive("ahk_exe chrome.exe")) {
        sendInput "^{w}"
    } else {
        sendInput "!{F4}"
    }
}

; :*:datetime...::
; {
;     FormatTime TimeString, T12, Time
;     FormatTime mesCompleto, , MMMM
;     FormatTime dia2, , dd
;     FormatTime ano, , yyyy
;     sendInput "%mesCompleto%-%dia2%-%ano% %TimeString%"

;     }

; :*:time...::
; {
;     FormatTime TimeString, T12, Time
;     sendInput " %TimeString%"
;     }

; :*:date...::
; {

;     }

:*:10010::100101011010110password10010
:*:1001p::
{
    sendInput " 100101011010110Password10010"
}

:*:1001d::
{
    sendInput " 100101011010110Password10010@@"
}

:*:dzpc::
{
    SendInput "DZ-ITDEV4585"
}
:*:dzig::
{
    SendInput "11179553"
}
:*:dzip::
{
    sendInput "11179553"
    sendInput " {tab}"
    sendInput "Password333qwer"
    sendInput " {enter}"
}

:*:crunchypss::
{
    sendInput " cuentaparacrunchyroll1309@gmail.com"
    sendInput " {tab}"
    sendInput " soloparacrunchy"
    sendInput " {enter}"
}

:*:1001m::100101011010110Password100101011010110

^+!r::
{
    BlockInput("Off")
    BlockInput("MouseMoveOff")
    reload
}

activateTeams() {
    if WinExist("ahk_exe ahk_exe ms-teams.exe") {
        WinActivate
    } else {
        run("C:\Users\rherrera\AppData\Local\Microsoft\WindowsApps\ms-teams.exe")
    }
}

; ^!t::  ; Ctrl+Alt+T para abrir la lista de tareas
; Gui "New"
; Gui "Add, Text,, Nueva Tarea:"
; Gui "Add, Edit, vNewTask"
; Gui "Add, Button, gAddTask, Agregar Tarea"
; Gui "Add, ListBox, vTaskList w300 h200"
; Gui "Add, Button, gRemoveTask, Eliminar Tarea Seleccionada"
; Gui "Show,, Lista de Tareas"
; return

; AddTask:
; Gui "Submit, NoHide  ; Recoge la entrada sin cerrar la GUI"
; GuiControlGet, vNewTask,, NewTask  ; Obtiene el valor del control vNewTask
; if (vNewTask != "") {
;     ; Obtener la lista actual de tareas de la ListBox
;     GuiControlGet, CurrentList,, vTaskList
;     ; Agregar la nueva tarea al final de la ListBox
;     GuiControl,, TaskList, %CurrentList% `n %vNewTask%
;     ; Limpiar el campo de entrada
;     GuiControl,, vNewTask,
; }
; return

; RemoveTask:
;     GuiControlGet, SelectedItem, , TaskList  ; Obtiene el ítem seleccionado de la ListBox
;     if (SelectedItem != "") {
;         GuiControlGet, vTaskList,, TaskList  ; Obtiene la lista actual de la ListBox
;         NewList := ""  ; Inicializa la nueva lista
;         loop Parse, TaskList, `n  ; Parsea cada tarea
;         {
;             if (A_LoopField != SelectedItem)  ; Si la tarea no es la seleccionada, añádela a NewList
;             {
;                 NewList .= A_LoopField "`n"
;             }
;         }
;         ; Actualiza la ListBox con la nueva lista
;         GuiControl,, vTaskList, %NewList%
; }
; return
; Use strings "+1" or "-1"

; Use strings "+1" or "-1"
#!up::
#!WheelUp::
{
    BrightnessOSDM "+9" ; Cursor Position
    return
}
#!down::
#!WheelDown::
{
    BrightnessOSDM "-9" ; Cursor Position
    return
}

; ^Up::                 BrightnessOSDW "+1"  ; Current Active Window
; ^Down::               BrightnessOSDW "-1"  ; Current Active Window

BrightnessOSDW(b) { ; Use current active window
    hMon := DllCall("MonitorFromWindow", "ptr", WinExist("A"), "uint", 0, "ptr")
    return BrightnessOSD(hMon, b)
}

BrightnessOSDM(b) { ; Use cursor position
    DllCall("GetCursorPos", "uint64*", &point := 0)
    hMon := DllCall("MonitorFromPoint", "uint64", point, "uint", 0x2, "ptr")
    return BrightnessOSD(hMon, b)
}

BrightnessOSD(hMon, b) { ; https://www.reddit.com/r/AutoHotkey/comments/uvykvk/comment/i9orgso/

    MIEX := Buffer(40 + 64)
    NumPut("uint", MIEX.size, MIEX)

    if DllCall("GetMonitorInfo", "ptr", hMon, "ptr", MIEX)
        MonName := StrGet(MIEX.ptr + 40, 32)

    ; https://stackoverflow.com/a/42351543
    ; https://social.msdn.microsoft.com/Forums/windows/en-US/d940a189-58e8-48e5-a3f0-0ca0f66f1cb1/howto-get-handle-of-a-display-device-from-displaydevicedevicename?forum=vcgeneral

    ; struct DISPLAY_DEVICEW - https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-display_devicew
    ddAdapter := Buffer(840, 0)
    NumPut("uint", ddAdapter.size, ddAdapter)

    while DllCall("EnumDisplayDevicesW", "ptr", 0, "uint", A_Index - 1, "ptr", ddAdapter, "uint", 0) {

        ; Useful DISPLAY_DEVICE.StateFlags:
        ;   #define DISPLAY_DEVICE_ATTACHED_TO_DESKTOP 0x00000001
        ;   #define DISPLAY_DEVICE_PRIMARY_DEVICE      0x00000004
        ;   #define DISPLAY_DEVICE_MIRRORING_DRIVER    0x00000008

        StateFlags := NumGet(ddAdapter, 324, "uint")

        if ((StateFlags & 0x9) == 0x1) {

            DeviceName := StrGet(ddAdapter.ptr + 4, 32 + 2, "UTF-16")
            DeviceString := StrGet(ddAdapter.ptr + 68, 128 + 2, "UTF-16")

            ddMonitor := Buffer(840, 0)
            NumPut("uint", ddMonitor.size, ddMonitor)

            if (DeviceName != MonName)
                continue

            while DllCall("EnumDisplayDevicesW", "str", DeviceName, "uint", A_Index - 1, "ptr", ddMonitor, "uint", 1) { ; EDD_GET_DEVICE_INTERFACE_NAME

                ; Child Device state
                ; #define DISPLAY_DEVICE_ACTIVE              0x00000001
                ; #define DISPLAY_DEVICE_ATTACHED            0x00000002

                StateFlags := NumGet(ddMonitor, 324, "uint")

                if (StateFlags & 0x1) {

                    ;DeviceName := StrGet(ddMonitor.ptr + 4, 32+2, "UTF-16")
                    ;DeviceString := StrGet(ddMonitor.ptr + 68, 128+2, "UTF-16")
                    DeviceID := StrGet(ddMonitor.ptr + 328, 128 + 2, "UTF-16")

                    SupportedBrightness := Buffer(256, 0)
                    Brightness := Buffer(3, 0)

                    hLCD := DllCall("CreateFile"
                        , "str", DeviceID ; !!!!!!!!!
                        , "uint", 0x80000000 | 0x40000000 ;Read | Write
                        , "uint", 0x1 | 0x2  ; File Read | File Write
                        , "ptr", 0
                        , "uint", 0x3  ; open any existing file
                        , "uint", 0
                        , "ptr", 0
                        , "ptr")

                    DevVideo := 0x00000023, BuffMethod := 0, Fileacces := 0
                    NumPut("UChar", 0x03, Brightness, 0)   ; 0x01 = Set AC, 0x02 = Set DC, 0x03 = Set both
                    NumPut("UChar", 0x00, Brightness, 1)      ; The AC brightness level
                    NumPut("UChar", 0x00, Brightness, 2)      ; The DC brightness level

                    DllCall("DeviceIoControl"
                        , "ptr", hLCD
                        , "uint", (DevVideo << 16 | 0x126 << 2 | BuffMethod << 14 | Fileacces) ; IOCTL_VIDEO_QUERY_DISPLAY_BRIGHTNESS
                        , "ptr", 0
                        , "uint", 0
                        , "ptr", Brightness
                        , "uint", 3
                        , "uint*", &BrightnessSize := 0
                        , "ptr", 0)

                    DllCall("DeviceIoControl"
                        , "ptr", hLCD
                        , "uint", (DevVideo << 16 | 0x125 << 2 | BuffMethod << 14 | Fileacces) ; IOCTL_VIDEO_QUERY_SUPPORTED_BRIGHTNESS
                        , "ptr", 0
                        , "uint", 0
                        , "ptr", SupportedBrightness
                        , "uint", 256
                        , "uint*", &SupportedBrightnessSize := 0
                        , "ptr", 0)

                    ACBrightness := NumGet(Brightness, 1, "UChar")
                    ACIndex := 0
                    DCBrightness := NumGet(Brightness, 2, "UChar")
                    DCIndex := 0
                    BufferSize := SupportedBrightnessSize
                    MaxIndex := SupportedBrightnessSize - 1

                    loop BufferSize {
                        ThisIndex := A_Index - 1
                        ThisBrightness := NumGet(SupportedBrightness, ThisIndex, "UChar")
                        if (ACBrightness = ThisBrightness)
                            ACIndex := ThisIndex
                        if (DCBrightness = ThisBrightness)
                            DCIndex := ThisIndex
                    }

                    if (DCIndex >= ACIndex)
                        BrightnessIndex := DCIndex
                    else
                        BrightnessIndex := ACIndex

                    BrightnessIndex += b
                    BrightnessIndex := Min(MaxIndex, BrightnessIndex)
                    BrightnessIndex := Max(0, BrightnessIndex)

                    NewBrightness := NumGet(SupportedBrightness, BrightnessIndex, "UChar")
                    NumPut("UChar", 0x03, Brightness, 0)   ; 0x01 = Set AC, 0x02 = Set DC, 0x03 = Set both
                    NumPut("UChar", NewBrightness, Brightness, 1)      ; The AC brightness level
                    NumPut("UChar", NewBrightness, Brightness, 2)      ; The DC brightness level

                    ; will set A_LastError to ERROR_INVALID_HANDLE (0x6) if not a built in LCD.
                    check := DllCall("DeviceIoControl"
                        , "ptr", hLCD
                        , "uint", (DevVideo << 16 | 0x127 << 2 | BuffMethod << 14 | Fileacces) ; IOCTL_VIDEO_SET_DISPLAY_BRIGHTNESS
                        , "ptr", Brightness
                        , "uint", 3
                        , "ptr", 0
                        , "uint", 0
                        , "ptr", 0
                        , "ptr", 0)

                    DllCall("CloseHandle", "ptr", hLCD)

                    if not check {

                        static stored := Map()

                        DllCall("dxva2\GetNumberOfPhysicalMonitorsFromHMONITOR"
                            , "ptr", hMon
                            , "uint*", &PhysMons := 0)
                        DllCall("dxva2\GetPhysicalMonitorsFromHMONITOR"
                            , "ptr", hMon
                            , "uint", PhysMons
                            , "ptr", PHYS_MONITORS := Buffer((A_PtrSize + 256) * PhysMons, 0))
                        hPhysMon := NumGet(PHYS_MONITORS, 0, "ptr")
                        start := A_TickCount
                        ; Occasionaly fails to communicate with the monitor, setting current brightness to zero.
                        ; fails if not external

                        if !stored.has(MonName) {
                            ; fixes a bug where the call randomly fails :(
                            while !DllCall("dxva2\GetVCPFeatureAndVCPFeatureReply"
                                , "Ptr", hPhysMon
                                , "uchar", 0x10
                                , "ptr", 0
                                , "uint*", &BrightnessCur := 0
                                , "uint*", &BrightnessMax := 0)
                                b := Max(0, Min(BrightnessMax, BrightnessCur + b))
                            stored[MonName] := [0, b, BrightnessMax
                            ]
                        } else {
                            BrightnessMax := stored[MonName][3]
                            BrightnessCur := stored[MonName][2]
                            b := stored[MonName][2] := Max(0, Min(BrightnessMax, BrightnessCur + b))
                        }

                        ; lmao you need to create a named function, and use named_func.bind or else SetTimer will just reset the timer!
                        set_brightness(b, bref, xd2) {
                            if (b == %bref%)
                                DllCall("dxva2\SetVCPFeature", "Ptr", hPhysMon, "uchar", 0x10, "UInt", b)
                            DllCall("dxva2\DestroyPhysicalMonitors", "uint", PhysMons, "ptr", xd2)
                        }

                        ; Sending a reference to b in case it changes is pretty important, as it allows updating the timer's function queue
                        ; by discarding the unnecessary changes. For example, when going from 30 → 50, it's not necessary to set 31, 32, 33,
                        ; if the current value of b is already at 50. Instead it may set 31, return, and see a new value of 50, skip 32-49 and set 50.
                        SetTimer set_brightness.bind(b, &b, PHYS_MONITORS), -1

                    }

                    ; Cause you used createfile
                    else {

                        /*
                              ; Show the Brightness OSD
                              static WM_SHELLHOOK := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK", "UInt")
                              static hwnd := 0
                              if !hwnd
                                 try if shellProvider := ComObject("{C2F03A33-21F5-47FA-B4BB-156362A2F239}", "{00000000-0000-0000-C000-000000000046}")
                                    try if flyoutDisp := ComObjQuery(shellProvider, "{41f9d2fb-7834-4ab6-8b1b-73e74064b465}", "{41f9d2fb-7834-4ab6-8b1b-73e74064b465}")
                                       if !ComCall(3, flyoutDisp, "int", 0, "uint", 0)
                                          hwnd := DllCall("FindWindow", "Str", "NativeHWNDHost", "Str", "", "Ptr")
                              DllCall("PostMessage", "ptr", hwnd, "uint", WM_SHELLHOOK, "uptr", 0x37, "ptr", 0)
                        */
                    }

                }
            }

        }
    }

}
