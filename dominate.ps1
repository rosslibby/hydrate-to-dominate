[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

Add-Type -AssemblyName System.Windows.Forms

params($sleep = 1790)
$WShell = New-Object -com "Wscript.Shell"
$ud = 1
$title = 'Name'
$msg = "What's your name?"

$name = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)

Clear-Host
Echo "Reminding $name to stay hydrated."

$index = 0
while ($true)
{
  $WShell.sendKeys("{SCROLLLOCK}")
  Start-Sleep -Milliseconds 200
  $WShell.sendKeys("{SCROLLLOCK}")

  $wshell = New-Object -ComObject Wscript.Shell
  $Output = $wshell.Popup("Remember to drink at least 8 ounces of water!")
  Sleep 1
  $wshell.SendKeys('~')
  
  $p = [System.Windows.Forms.Cursor]::Position
  $x = $p.X + $ud
  $y = $p.Y + $ud
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
  $ud *= -1

  Start-Sleep -Seconds $sleep
}
