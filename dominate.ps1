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

  # notify
  New-BurntToastNotification -Text "Hydration Alert", "It's time to hydrate. Try to drink at least 8 ounces of water! #HydrateToDominate" -AppLogo C:\hydrate\logo.png

  Show-Notification

  # end notify

  $p = [System.Windows.Forms.Cursor]::Position
  $x = $p.X + $ud
  $y = $p.Y + $ud
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
  $ud *= -1

  Start-Sleep -Seconds $sleep
}

function Show-Notification {
  [cmdletbinding()]

  $ToastTitle = "Hydration Alert"
  $ToastText = "It's time to hydrate. Try to drink at least 8 ounces of water! #HydrateToDominate"

  [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
  $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastImageAndText01)

  $RawXml = [xml] $Template.GetXml()
  var images = $RawXml.getElementsByTagName("image");
  images[0].setAttribute("src", "logo.png");
  ($RawXml.toast.visual.binding.text|where {$_.id -eq "1"}).AppendChild($RawXml.CreateTextNode($ToastTitle)) > $null
  ($RawXml.toast.visual.binding.text|where {$_.id -eq "2"}).AppendChild($RawXml.CreateTextNode($ToastText)) > $null

  $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
  $SerializedXml.LoadXml($RawXml.OuterXml)

  $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)
  $Toast.Tag = "PowerShell"
  $Toast.Group = "PowerShell"
  $Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)

  $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("PowerShell")
  $Notifier.Show($Toast);
}
