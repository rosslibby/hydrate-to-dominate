[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')

function Reminder {
  [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
  [Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
  [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

  $Logo = "$PSScriptRoot\images\logo.png";
  $Title = "Hydration Alert";
  $Message = "It's time to hydrate. Try to drink at least 8oz of water!";
  $Hashtag = "#HydrateToDominate";
  $APP_ID = "d87ceb61-e553-4319-b4c0-65ae005141eb";
  $imageTemplate = @"
  <toast>
    <visual>
      <binding template="ToastImageAndText04">
        <image id="1" src="$($Logo)" alt="Hydration logo"/>
        <text id="1">$($Title)</text>
        <text id="2">$($Message)</text>
        <text id="3">$($Hashtag)</text>
      </binding>
    </visual>
  </toast>
"@

  $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
  $xml.LoadXml($imageTemplate)
  $toast = New-Object Windows.UI.Notifications.ToastNotification $xml
  [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($APP_ID).Show($toast)
}

$sleep = 1790
$WShell = New-Object -com "Wscript.Shell"
$ud = 1

Clear-Host

while ($true)
{
  $WShell.sendKeys("{SCROLLLOCK}")
  Start-Sleep -Milliseconds 200
  $WShell.sendKeys("{SCROLLLOCK}")

  # notify
  Reminder
  # end notify

  $p = [System.Windows.Forms.Cursor]::Position
  $x = $p.X + $ud
  $y = $p.Y + $ud
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
  $ud *= -1

  Start-Sleep -Seconds $sleep
}
