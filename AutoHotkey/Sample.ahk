#n::
{
    if WinExist("ahk_exe vlc.exe")
        WinActivate  ; Activate the window found above
    else
        Run "C:\Program Files\VideoLAN\VLC\vlc.exe"  ; Open a new Notepad window
}

