# CapsLock -> Ctrl

1. Install PowerToys

```powershell
choco install powertoys
```

2. Add key mapping in Keyboard Manager
3. Enable 'Always run as administor' to be able to remap on programmes opened as an administrator

# Three finger mouse drag

1. Install Autohotkey

```powershell
choco install autohotkey
```

2.  Create a new Autohotkey file by

- Right mouse click -> New -> Autohotkey script
- Name the file with `.ahk` extension
- Open as notepad

3. Paste this snippet at the bottom

```ahk
#SingleInstance force

drag_enabled := 0

+^#F22::
if(drag_enabled)
{
  Click up
    drag_enabled := 0
}
else
{
drag_enabled := 1
                Click down
}
return

LButton::
if(drag_enabled)
{
  Click up
    drag_enabled := 0
}
else
{
  Click down
    KeyWait, LButton
    Click up
}
return
```

4. Open the .ahk file by clicking right and "Open with..." -> "Autohotkey"
