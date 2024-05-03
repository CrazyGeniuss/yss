# Invoke-WebRequest 
$deskpath = "$env:tmp\any.exe"
$deskUrl = "https://download.anydesk.com/AnyDesk.exe"
Write-Output "downloading"
(New-Object System.Net.WebClient).DownloadFile($deskUrl,$deskpath)
Write-Output "installing"
Start-Process -FilePath $deskpath -ArgumentList '--install  "C:\Program Files (x86)\AnyDesk"' -Wait
Start-Sleep -Seconds 5
Stop-Process -Name "anydesk" -Force
$AnyDeskService = Get-WmiObject -Query "SELECT * FROM Win32_Service WHERE Name LIKE 'AnyDesk%'"
$BinPath = $AnyDeskService.PathName
$BinPath = $BinPath -replace ' --service',''
# Start-Process -FilePath $BinPath 
# Start-Sleep -Seconds 60
write-output "Setting Password"
$logfile = "$env:tmp\sa.log"
Start-Process -FilePath "cmd.exe" -ArgumentList '/c echo "1328459-qW!" | "%programfiles(x86)%"\AnyDesk\AnyDesk.exe --set-password _full_access' -Wait -RedirectStandardOutput $logfile
Write-Output "set password Result $(Get-Content -Path $logfile)"

Write-Output "Getting ID"

# "--get-id" only works from a script, see (https://support.anydesk.com/knowledge/command-line-interface-for-windows#client-commands)
$IdFile = "$env:TEMP\anydesk.id"
$Result = Start-Process -FilePath $BinPath -ArgumentList '--get-id' -Wait -RedirectStandardOutput $IdFile
Write-Output "ID: $Result"
Write-Host "AnyDesk ID for $($env:COMPUTERNAME) is $(Get-Content -Path $IdFile)"

Remove-Item -Path $IdFile -Force