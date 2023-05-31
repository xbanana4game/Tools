AppsKey::DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
/*
AppsKey
Browser_Home
Browser_Back
Browser_Search
Media_Next
Media_Prev
Media_Play_Pause
*/

#n::
{
    if WinExist("ahk_exe vlc.exe")
        WinActivate  ; Activate the window found above
    else
        Run "C:\Program Files\VideoLAN\VLC\vlc.exe"  ; Open a new Notepad window
}

