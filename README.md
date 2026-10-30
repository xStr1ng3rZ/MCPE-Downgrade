# MCPE-Downgrade
Script for downgrading Minecraft UWP versions (fixes Xbox Authentication issues).
> **Note:** Open Command Prompt (`cmd`) as Administrator and install `aria2` first by running:
> ```cmd
> winget install aria2.aria2
> 
> ```
> 
> 
### How to Run It
Make sure you have the script file downloaded in your Downloads folder and run the following command in PowerShell as Administrator:
```powershell
powershell -ExecutionPolicy Bypass -File "%USERPROFILE%\Downloads\downgrade-1.16-1.18-1.21.114.ps1"
```
###  What if the installation fails and you need to restore your worlds manually?
If the script gets interrupted or the Minecraft installation fails and your worlds are not restored automatically, you can easily recover them using Command Prompt (`cmd`) with the following command:
```cmd
powershell -Command "Add-AppxPackage -Path '%USERPROFILE%\Downloads\Microsoft.Services.Store.Engagement_*.appx'"
```
*(Make sure to completely close Minecraft before running the restoration command).*
