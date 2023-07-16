using namespace System.Management.Automation
using namespace System.Management.Automation.Language
using namespace System.Diagnostics.CodeAnalysis
#requires -version 5
[SuppressMessageAttribute('PSAvoidAssignmentToAutomaticVariable', '', Justification = 'PS7 Polyfill')]
param()

if ($PSEdition -eq 'Desktop' -or $isWindows) {
    $isAdmin = ([System.Security.Principal.WindowsPrincipal]([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

#Force TLS 1.2 for all WinPS 5.1 connections
if ($PSEdition -eq 'Desktop') {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}

if ($PSStyle) {
    #Enable new fancy progress bar for Windows Terminal
    if ($ENV:WT_SESSION) {
        $PSStyle.Progress.UseOSCIndicator = $true
    }
}

#region ModuleImports
#Import-Module Terminal-Icons -ErrorAction SilentlyContinue
#endregion ModuleImports

#region Helpers
function debugOn { $GLOBAL:VerbosePreference = 'Continue'; $GLOBAL:DebugPreference = 'Continue'; $GLOBAL:InformationPreference = 'Continue' }
#endregion

#region oh-my-posh prompt
# Install with 'winget install JanDeDobbeleer.OhMyPosh'
if(-not $isAdmin) {
    try {
        #Join-Path will fix the slash direction if needed. Oh-my-posh is picky about this
        $configPath = Join-Path "$HOME" '.config/oh-my-posh/fflaten.json'
        & oh-my-posh init pwsh --config=$configPath | Invoke-Expression
    } catch [CommandNotFoundException] {
        Write-Verbose 'PROFILE: oh-my-posh not found on this system, skipping prompt'
    }
}
#endregion oh-my-posh prompt