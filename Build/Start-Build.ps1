﻿param(
    $Task = 'Default'
)
# Get Powershell Host Version
Write-Host "PowerShell Version:" $PSVersionTable.PSVersion.tostring()

# dependencies
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null

# Install latest
Install-Module -Name PowerShellGet -Force
Import-Module -Name PowerShellGet -Force

# Get PowerShellGet Version
Write-Host "PowerShellGet Version:" $(Get-Module -Name PowerShelGet).Version

if(-not (Get-Module -ListAvailable PSDepend))
{
    & (Resolve-Path "$PSScriptRoot\helpers\Install-PSDepend.ps1")
}
Import-Module PSDepend
$null = Invoke-PSDepend -Path "$PSScriptRoot\build.requirements.psd1" -Install -Import -Force

Set-BuildEnvironment

Invoke-psake $PSScriptRoot\psake.ps1 -taskList $Task -nologo
exit ( [int]( -not $psake.build_success ) )