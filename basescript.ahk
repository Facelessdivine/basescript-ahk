
; f11::

; while(true){
;     keywait, AppsKey, D
;     keywait, AppsKey, U
;     sleep, 50
;     WinGet, class1, ProcessName, A
;     previousTab := "ahk_exe " class1
; }

; return
; f6::
;     tablesArray := [ "usuario", "cliente", "obra", "concreto", "terraceria", "configuraciones", "pTerraceria", "pconcreto"]
;     keywait, ctrl, D
;     keywait, ctrl, U
;     for index, element in tablesArray {
;         Clipboard:= ""
;         clipboard.= "return knex.schema"
;         clipboard.= ".createTable(id"
;         clipboard.= element
;         clipboard.= "id, function(table) {"
;         clipboard.= "})"
;         sendInput, ^{g}
;         sleep, 20
;         sendInput, 6 {enter}
;         sleep, 20
;         sendInput, ^{v}
;         sendInput, {left 2} {enter}
;         sleep, 300
;         Clipboard:= ""
;         sleep, 200
;         sendInput, ^{f}
;         sleep, 300
;         Clipboard:= "exports.down"
;         sendInput, ^{v}
;         sleep, 200
;         sendInput, {enter}
;         sleep, 50
;         sendInput, {esc}
;         sleep, 350
;         sendInput, {down}
;         sleep, 50
;         Clipboard:= "return knex.schema.dropTableIfExists(id"
;         Clipboard.= element
;         Clipboard.="id);"
;         sleep, 100
;         sendInput, ^{v}
;         sleep, 300
;         sendInput, ^+{e}
;         sleep, 300
;         sendInput, {down}{enter}
;         sleep, 300
;         sendInput, ^+{e}
;         sleep, 600
        
;     }
; return
; f4::
;     tablesArray := [ "usuario", "cliente", "obra", "concreto", "terraceria", "configuraciones", "pTerraceria", "pconcreto"]
;     for index, element in tablesArray {
;         sleep, 1000
;         sendInput, ^{g}
;         sleep, 20
;         sendInput, 7, 15 {enter}
;         sleep, 20
;         sendInput, {ctrl down}{Shift Down}{Right}{shift up}{d}
;         sleep, 20
;         clipboard:= element
;         sleep, 20
;         sendInput, {v}
;         sendInput, {ctrl up}
;         sleep, 100
;         sendInput, {esc}
;         sleep, 200
;         sendInput, ^+{e}
;         sleep, 300
;         sendInput, {down}{enter}
;         sleep, 300
;         sendInput, ^+{e}
;         sleep, 600
;     }
; return
; ; tablesArray := ["idUser", "firstName", "lastName", "cretedDate", "email", "company", "phone", "fullName", "dateBirth", "gender", "usuario"]
; ; for index, element in tablesArray {
; ;     keywait, ctrl, D
; ;     keywait, ctrl, U
; ;     ; sendInput, ^{g}
; ;     ; sleep, 20
; ;     ; sendInput, 7 {enter}
; ;     ; sleep, 20
; ;     ; sendInput, {ctrl down}{Right 3}{Shift Down}{Right}{shift up}{d}
; ;     sleep, 20
; ;     clipboard:= element
; ;     sleep, 20
; ;     sendInput, ^{v}
; ;     msgbox, % tablesArray[index+1]
; ;     ; sendInput, {ctrl up}
; ; }
; f3:: ;GENERACION DE MIGRACIONES Y SEEDS
; tablesArray := [ "usuario", "cliente", "obra", "concreto", "terraceria", "configuraciones", "pTerraceria", "pconcreto"]
; leng := tablesArray.MaxIndex()
; order := "" 
; oldstr := ""
; ; InputBox, scr, script type, type the script 1 = migrations - 2 = seeds, , 300, 250, X, Y, 
; sleep, 1000
; keywait, ctrl, D
; keywait, ctrl, U
; for index, element in tablesArray
; {
;     sleep, 2000
;     order := (index < 10)? " 0"+index : " "+index
;     oldstr .= order
;     oldstr .= "-"
;     oldstr .= element
;     ; if(scr == 1) {
;     ; msgbox, %oldstr%
;     Clipboard := "npx knex migrate:make"+ oldstr
;     Clipboard .= " --migrations-directory knex/migrations"
;     sleep, 500
;     sendInput, ^{v}
;     sleep, 100
;     sendInput, {enter}
;     sleep, 6000
;     ; } else if (scr == 2) {
;     ; oldstr .= "-"
;     Clipboard := "npx knex seed:make"+ oldstr
;     sleep, 500
;     sendInput, ^{v}
;     sleep, 100
;     sendInput, {enter}
;     oldstr := ""
;     msgbox, , , %index% < %leng%, 7
;     sleep, 500
; }
; return
; }else {
;     msgbox, , , Invalid option, 1
;     return
; }

pgdn & Up::
    Run nircmd.exe changebrightness +20
    cbnss:= GetCurrentBrightNess()
    ToolTip, %cbnss%
    SetTimer, RemoveToolTip, 400, 150
    
return

pgdn & Down::
    Run nircmd.exe changebrightness -20
    cbnss:= GetCurrentBrightNess()
    ToolTip, %cbnss%
    SetTimer, RemoveToolTip, 400, 150
    
return

GetCurrentBrightNess()
{
    For property in ComObjGet( "winmgmts:\\.\root\WMI" ).ExecQuery( "SELECT * FROM WmiMonitorBrightness" )
    currentBrightness := property.CurrentBrightness
    
    return currentBrightness
}

RemoveToolTip:
    ToolTip
return
::psh::
    sendInput, passphrase{enter}
return
; Google Search highlighted text
^+!c::
    {
        SendInput, ^c
        Sleep 100
        Run, %clipboard%
    Return
}
^+y::
    {
        SendInput, ^c
        Sleep 100
        Run, https://www.youtube.com/results?search_query=%clipboard%
    Return
}
^+!y::
    {
        SendInput, ^c
        Sleep 100
        ytid:= StrSplit(clipboard, "=")
        id:= ytid[2]
        Run, https://www.y2mate.com/youtube/%id%
    Return
}
^+!z::
    {
        id:= "https://us05web.zoom.us/j/88390008320?pwd=YzNaZXpCWmhXb1Rkb2Y2UmhIVi9oUT09"
        Run, %id%
    Return
}
^+!x::
    {
        id:= "https://itesm.zoom.us/j/5173749162"
        Run, %id%
    Return
}

^+c::
    {
        SendInput, ^c
        Sleep 100
        Run, http://www.google.com/search?q=%clipboard%
    Return
}

:*:git clone::
    {   
        
        url:= clipboard
	  clipboard:=""
        clipwait
        keywait, appsKey, D
        keywait, appsKey, U
        sendInput, git clone %url% -b %clipboard%
        array :=  StrSplit(url, "/")
        fname := array.pop()
        array2 :=  StrSplit(fname, ".")
        fname2 := array2[1]
        Clipboard:= fname2
        keywait, appsKey, D
        keywait, appsKey, U
        sleep, 100
        sendInput, cd %clipboard%  
        sleep, 200
        sendInput, {enter}
        Clipboard:= "npm install"
	  sendInput, %clipboard%{enter}
    }
Return
:*:get clone::
    {   
    sendInput, %Clipboard%{enter}
    array :=  StrSplit(Clipboard, "/")
    fname := array.pop()
    array2 :=  StrSplit(fname, ".")
    fname2 := array2[1]
    Clipboard:= fname2
    keywait, appsKey, D
    keywait, appsKey, U
    sleep, 100
    sendInput, cd %Clipboard% & npm install 
    sleep, 200
    sendInput, {enter} 
    }
Return

#Del::
    FileRecycleEmpty ; win + del
Return
^+!NumLock::
    run, C:\Users\facel\OneDrive\Desktop\scripts\minecraft-ahk\Minecraft.ahk
    ExitApp, 0
return
::inpy::
    sleep, 100
    sendInput, {tab 2}
    sleep, 50
    sendInput, {enter}
    sleep, 200
    sendInput, {tab 10}
    sleep, 50
    sendInput, 1118150082
    sendInput, {tab}
    sendInput, ee538c60
    sleep, 100
    sendInput, {enter}
    keywait, ctrl, D
    keywait, ctrl, U
    sendInput, {alt down}{d}{alt up}
    sleep, 50
    sendInput, https://proyecta.utch.edu.mx/salumno/informacion
    sendInput, {enter}
return

;:*:/::
;sendInput, \
;return

; ^space::
; sendInput, {w up}
; sendInput, {Lcontrol down}
; sendInput, {s down}
; sendInput, {Lbutton up}
;return
; space::
; ; while(true){
; ;     ImageSearch, x, y, 683, 384, 1366, 768, C:\Users\raulh\Pictures\salcana3.png
; ;     ImageSearch, x3, y3, 683, 384, 1366, 768, C:\Users\raulh\Pictures\salcana2.png
; ;     ImageSearch, x2, y2, 683, 384, 1366, 768, C:\Users\raulh\Pictures\salcana.png
; ;     ImageSearch, x4, y4, 683, 384, 1366, 768, C:\Users\raulh\Pictures\salcana4.png
; ;     ImageSearch, x5, y5, 683, 384, 1366, 768, C:\Users\raulh\Pictures\salcana5.png
; ;     ImageSearch, x6, y6, 683, 384, 1366, 768, C:\Users\raulh\Pictures\salcana6.png
; ; if(x>0 or x2>0 or x3>0 or x4>0 or x5>0 or x6>0){
;     sendInput, {Rbutton}
;     sleep, 500
;     sendInput, {Rbutton}
; ; }
; ;                      sleep, 10
; ; }
; return
; fishingFarm(){
;         BlockInput, on
;         send, {t}
;         sleep, 100
;         sendInput, /execute in overworld run tp facelessdivine -252 138 13 90 19
;         sleep, 40
;         send, {Enter}
;         sleep, 1000
;         send, {8}
;         sleep, 500
;         loop, 777{
;             click, Right
;             sleep, 2000
;         }
;         sleep, 100
;         Return
;     }

:*:psql1::
    sendInput, psql -U postgres
    sendInput, {enter}
    sleep, 10
    sendInput, Password44
    sendInput, {enter}
return

; ^+!p::
; MsgBox, 4, Proyecta, >>>, 
;     IfMsgBox, Yes
;     {
; run, https://proyecta.utch.edu.mx/
; sleep, 1800
;     }
; found := false
; while(!found){
; ImageSearch, x, y, 0, 0, 1366, 768, C:\Users\raulh\Pictures\pyiniciarsesion.png
; if(x > 0){
;     found:=true
;     MouseGetPos, Xa, Ya
;     x+=15
;     y+=15
;     mousemove, x, y, 0
;     click
;     sleep, 50
;     sendInput, {tab 10}
;     sleep, 4
;     sendInput, 1118150082
;     sendInput, {tab}
;     sendInput, ee538c60
;     sendInput, {tab}
;     sendInput, {enter}
;     ; msgbox, hola
;     sleep, 500
;     mousemove, Xa, Ya, 1
;     sleep, 2200
;     MsgBox, 4, Proyecta, >>>, 
;     IfMsgBox, Yes
;     {
;         send, !{d}
;         sleep, 50
;         sendInput, https://proyecta.utch.edu.mx/SAlumno/informacion
;         send, {enter}
;     }

; }
; ;regresar a la posicion original del mouse
; sleep, 10000
; }
; return
; ^+!v::
; MsgBox, 3, Virtual, Yes/ open virtual no/ open ti.virtual cancel/ start finding, 
;     IfMsgBox, Yes
;     {
; run, https://virtual.utch.edu.mx/
; sleep, 1800
;     }
;     else IfMsgBox, No
;     {
; run, https://ti.utch.edu.mx/
; sleep, 1800
;     }
; found := false
; while(!found){
; ImageSearch, x, y, 0, 0, 1366, 768, C:\Users\raulh\Pictures\ingresarvt.png
; if(x > 0){
;     found:=true
;     MouseGetPos, Xa, Ya
;     x+=15
;     y+=15
;     sleep, 500
;     sendInput, {tab 3}
;     ; sendInput, 1118150082
;     ; sendInput, {tab}
;     sendInput, ee538c60
;     sendInput, {tab}
;     sendInput, {enter}
;     ; msgbox, hola
;     sleep, 500
;     mousemove, Xa, Ya, 1
;     sleep, 2200

; }
; ;regresar a la posicion original del mouse
; sleep, 10000
; }
return

:*:ps44::
    sendInput, Password44
    sendInput, {enter}
return
:*:status::
    sendInput, git status
    sendInput, {enter}
return

; :*:asd::
; sleep, 1000
; GetKeyState, lstate, LControl
; ;msgbox, %state%
; if (lstate = "D"){
; MouseGetPos, X, Y
; InputBox, num, numero de items, Please enter a number., , 200, 150
; sendInput, {lbutton}
; mousemove, 921, 308, 0
; sendInput, {Rbutton down}
; loop, %num%
; {
; mousemove, 921, 308, 3
; sendInput, {Rbutton down}
; mousemove, 914, 271, 3
; sendInput, {Rbutton up}
; }
; mousemove, 987, 292, 0
; sendInput, {shift down}
; click
; sendInput, {shift up}
; }
; mousemove, X, Y, 0
; return

; ^+!Lbutton::
;     sendInput, ^e
;     sendInput, {delete}
;     MouseGetPos, X, Y
;     MouseMove, 326, 83, 0
;     Click
;     MouseMove, X, Y, 0
    
;     ; Input my radius
;     InputBox, Radius, Radius, Input Radius
;     ; Draw my circle
;     sleep, 100
;     BlockInput, ON
;     Radius= 50
;     MouseGetPos, StartX, StartY
;     MouseMove, 0, %Radius%, 0, R
;     MouseClick, Left, , , , 0, D
;     Loop 64
;     {
;         xVar := Radius*Sin(A_Index/10)
;         yVar := Radius*Cos(A_Index/10)
;         DrawX := StartX+xVar
;         DrawY := StartY+yVar
;         MouseMove, %DrawX%, %DrawY%, 0
;         MouseMove, %DrawX%, %DrawY%, 0
;     }
;     MouseClick, Left, , , , 0, U
;     ; r is radius of circle, nLaps is number of laps to turn, can be -1 for keep on going until lbutton is released.
;     ; Set direction via, dir. dir:=1 is clockwise, dir:=-1 is counter-clockwise
;     sleep, 100
;     BlockInput, ON
;     r:=100, speed:=0, nLaps:=1, dir:=-1
;     cont:= 0
;     pi:=3.1416, n:=2*r*pi
;     points := []
;     t:=0
;     SetMouseDelay, -1
;     CoordMode, Mouse, Screen
;     MouseGetPos, OX, OY
;     MouseMove, OX+r*cos(t:=((A_Index)/n)), OY+dir*r*sin(t), speed
;     MouseClick, Left, , , , 0, D
;     while ((t<=2*pi*nLaps)) {
;         cont++
;         MouseMove, OX+r*cos(t:=((A_Index-1)/n)), OY+dir*r*sin(t), speed
;     }
;     MouseClick, Left, , , , 0, U
;     sendInput, {Control Up}
;     BlockInput, OFF
;     MsgBox, %cont%
; Return

; :*:111equipo::
;     sendInput, Rosa Alejandra Legarda Bencomo, Efra{alt down}{Numpad1}{Numpad6}{Numpad1}{alt up}n Fernando Bejarano Puentes, Ra{alt down}{Numpad1}{Numpad6}{Numpad3}{alt up}l Herrera Mac{alt down}{Numpad1}{Numpad6}{Numpad1}{alt up}as
; return
; :*:111team::
;     sendInput, 1119150016, 1118150082, 1118150112
; return

;     if winexist("ahk_exe brave.exe"){
;         winactivate
;     }
; }
; 5::
; while(True){
;         click, Right
;         ; sleep, 650
;         ; click, left
;         sleep, 250
;         ; CheckConnection()
;     }
; Return

; f7::
    
;     send, {f5}
;     sleep, 3000
;     imssencuesta()
;     f:=False
;     i=317
;     while (!f) {
;         ImageSearch, x, y, 0, 0, 1366, 768, C:\Users\raulh\Pictures\errornssa.png
;         ImageSearch, x2, y2, 0, 0, 1366, 768, C:\Users\raulh\Pictures\errortryagainnssa.png
;         if(x > 0 or x2 > 0) {
;             i++
;             msgbox, 0, Puto error, intentos sin exito -> %i%, 5
;             mousemove, 678, 630, 0
;             sleep, 10
;             Click
;             sleep, 2000
;             send, {f5}
;             sleep, 3000
;             imssencuesta()
;         }
;         sleep, 5
;     }
; Return
;hotkey to activate OCR

;     cant = 0
;     c = 0
;     InputBox, cant, Introduccion de datos, , , 200, 200, X, Y, , 10, 
;     sleep, 40
;     MouseMove, 80, 300, 0
;     sleep, 400
;     while(c < cant){
;         MouseMove, 80, 300, 0
;         sleep, 250
;         found := False
;         found2 := False
;         f:= False
;         fp:= False
;         fp2:= False
;         mouseclick, WheelDown, , , 5, 0, D, R
;         sleep, 100
;         while(!found){
;             ImageSearch, x, y, 0, 0, 1366, 768, C:\Users\raulh\Pictures\descargarepisodio.png
;             if(x)
;             {
;                 found := True
;             }
;             sleep, 100
;         }

;         x+=20
;         y+=20
;         mousemove, %x%, %y%, 0
;         click, left
;         while(!found2){
;             ImageSearch, x2, y2, 0, 0, 1366, 768, C:\Users\raulh\Pictures\descargarbutton2.png
;             if(x2){
;                 found2 := True
;             }
;             sleep, 100
;         }
;         x2+=10
;         y2+=10
;         mousemove, %x2%, %y2%, 0
;         click, left
;         while(!fp){
;             ImageSearch, x5, y5, 0, 0, 1366, 768, C:\Users\raulh\Pictures\descargarmega.png
;             if(x5){
;                 fp := True
;             }
;             sleep, 100
;         }
;         send, ^{e}
;         sleep, 200
;         send, ^{c}
;         sleep, 300
;         while(!fp2){
;             if winactive("ahk_exe MegaDownloader V 1.9.exe"){
;                 fp2 := True
;             }
;             else{
;                 if WinExist("ahk_exe MegaDownloader V 1.9.exe"){
;                 WinActivate
;                 }
;                 fp2 := True
;             }
;             sleep, 100
;         }
;         sleep, 200
;         mousemove, 88, 223
;         click, left
;         sleep, 500
;         If WinExist("ahk_exe opera.exe"){
;             WinActivate
;         }
;         sleep, 300
;         send, ^{w}
;         sleep, 100
;         while(!f){
;             ImageSearch, x3, y3, 0, 0, 1366, 768, C:\Users\raulh\Pictures\siguienteepisodio.png
;             ImageSearch, x4, y4, 0, 0, 1366, 768, C:\Users\raulh\Pictures\siguienteepisodio2.png
;             if(x3){
;                 mousemove, %x3%, %y3%, 0
;             }
;             else if(x4){
;                 mousemove, %x4%, %y4%, 0

;             }
;             if(x3 or x4){
;                 f := True
;                 click, left
;             }
;             sleep, 100
;         }
;         c++
;         sleep, 700
;     }
;     MsgBox, 0, END, Fin del script, 3
; Return

^r::reload
; ^+!a::
;     MsgBox, 0, Script Teams, Se ha iniciado servicio de búsqueda de reunión en Microsoft Teams, 3
;     key:=""
;     InputBox, secs, Cantidad de segundos, , , 200, 150, X, Y, , , 30
;     InputBox, keycode, tecla (1./space 2./esc 3./None), , , 200, 150, X, Y, , , 3
;     if(keycode==1) {
;         key:="Space"
;     } else if (keycode==2) {
;         key:="Esc"
;     }
;     Else{
;         key:=""
;     }
;     secs*=1000
;     sleep, 200
;     a:= False
;     b:= False
;     while (!a) {
;         WinGet, class1, ProcessName, A
;         class1 := "ahk_exe " class1
;         if WinExist("ahk_exe Teams.exe") {
;             WinActivate
;         }
;         sleep, 250
;         click, left, 1316, 497
;         ImageSearch, x, y, 0, 0, 1366, 768, C:\Users\raulh\Pictures\unirse.png
;         if(x > 0) {
;             a:=True
;             x+=15
;             y+=15
;             Mousemove, x, y
;             Click, Left
;             while (!b) {
;                 ImageSearch, x2, y2, 0, 0, 1366, 768, C:\Users\raulh\Pictures\unirteahora.png
;                 if(x2 > 0) {
;                     b:= True
;                     x2+=15
;                     y2+=15
;                     Mousemove, x2, y2
;                     Click, Left
;                 }
;                 sleep, 100
;             }
            
;         } else {
            
;             sleep, 1500
;             if WinExist(class1) {
;                 WinActivate
;                 send, {%key%}
;             }
;             sleep, %secs%
;             send, {%key%}
;         }
;     }
;     ; MsgBox, 0, Found, Se ha encontrado el botón de la reunión, 3
; Return
^+!9::
    MsgBox, 0, búsqueda persistente Microsoft Teams, Enabled, 2
    sleep, 400
    while (true) {
        ImageSearch, x, y, 0, 0, 1366, 768, C:\Users\raulh\Pictures\unirse.png
        if(x > 0) {
            a:=True
            x+=15
            y+=15
            Mousemove, x, y
            Click, Left
            while (!b) {
                ImageSearch, x2, y2, 0, 0, 1366, 768, C:\Users\raulh\Pictures\unirteahora.png
                if(x2 > 0) {
                    b:= True
                    x2+=15
                    y2+=15
                    Mousemove, x2, y2
                    Click, Left
                }
                sleep, 100
            }
            
        }
    }
Return
^+1::
    sleep, 1000
    while (true) {
        SendInput, {Lbutton}
    }
Return
activateTeams()
{
    if WinExist("ahk_exe Teams.exe") {
        WinActivate
    } else {
        run, C:\Users\raulh\AppData\Local\Microsoft\Teams\Update.exe --processStart "Teams.exe"
    }
}

;f1::

Return

; f3::
; send, {esc}
; sleep, 500
; InputBox, minutos, Tiempo en minutos del click, Prompt, , 200, 300, X, Y, Locale, , 
; sleep, 200
; send, {esc}

; while(true){
;     click, left
;     sleep, %minutos%
;      ImageSearch, x, y, 0, 0, 1366, 768, C:\Users\raulh\Pictures\connectionlost.png
;         if(x > 0){
;             click, left, 695, 429
;             sleep, 2000
;             click, left, 436, 203
;             sleep, 10000
;             x=0
;             y=0
;         }
; }
; Return
