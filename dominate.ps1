Install-Module -Name BurntToast

[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

Add-Type -AssemblyName System.Windows.Forms
Add-Type -Name ConsoleUtils -Namespace WPIA -MemberDefinition @'
  [DllImport("Kernal32.dll")]
  public static extern IntPtr GetConsoleWindow();
  [DllImport("user32.dll")]
  public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'@

$hWnd = [WPIA.ConsoleUtils]::GetConsoleWindow()
[WPIA.ConsoleUtils]::ShowWindow($hWnd, 0)

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
  New-BurntToastNotification -Text "Hydration Alert", "It's time to hydrate. Try to drink at least 8 ounces of water! #HydrateToDominate" -AppLogo C:\hydrate\logo.png
  $p = [System.Windows.Forms.Cursor]::Position
  $x = $p.X + $ud
  $y = $p.Y + $ud
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
  $ud *= -1

  Start-Sleep -Seconds $sleep
}
