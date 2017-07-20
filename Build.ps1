<#

.SYNOPSIS
MDT LTI PowerShell Gallery Control

.DESCRIPTION

script to build the powershell installation script package for the sample. 

.NOTES
Copyright Keith Garner (KeithGa@DeploymentLive.com), All rights reserved.

.LINK
https://github.com/keithga/MDTLTIPSSampleAction


#>

[cmdletbinding()]
param( 
    [string] $BuildType = 'Release',
    [switch] $register
)

#region Compile DLL

Write-Verbose "Compile dll"

$MSBuildPath = get-childitem "${env:ProgramFiles(x86)}\Microsoft Visual Studio\*\*\MSBuild\*\Bin\msbuild.exe" | 
    Select-Object -First 1 -ExpandProperty FullName

if ( -not $MSBuildPath ) { throw "Missing MSBuild" }
Write-Verbose "Found MSBuild $MSBuildPath"

& $msbuildpath $PSScriptRoot\MDTLTIPSSampleAction.sln   /nologo /t:Rebuild /p:Configuration=$BuildType /p:PostBuildEvent=

#endregion 

#region Create Libarary Folder

write-verbose "Create the libaray folder $PSScriptRoot\MDTLTIPSSampleAction"
New-Item -ItemType Directory -path $PSScriptRoot\MDTLTIPSSampleAction -ErrorAction SilentlyContinue | Out-Null

copy-item $PSscriptRoot\bin\$BuildType\MDTLTIPSSampleAction.dll -Destination $PSScriptRoot\MDTLTIPSSampleAction -Force
if ( $BuildType -eq 'Debug' ) {
    copy-item $PSscriptRoot\bin\$BuildType\MDTLTIPSSampleAction.pdb -Destination $PSScriptRoot\MDTLTIPSSampleAction -Force
}
copy-item $PSscriptRoot\MDTLTIPSSampleAction.psm1 -Destination $PSScriptRoot\MDTLTIPSSampleAction -Force

#endregion

#region Create Module Manifest

$ModuleCommon = @{
    Author = "Keith Garner (KeithGa@DeploymentLive.com)"
    CompanyName  = "DeploymentLive.com"
    Copyright = "Copyright Keith Garner (KeithGa@DeploymentLive.com), all Rights Reserved."
    ModuleVersion = (get-date -Format "1.1.yyMM.ddhh")
    Tags = 'MDT'
    Description = "PowerShell Gallery add on for Microsoft Deployment Toolkit (MDT)"
    GUID = [guid]::NewGuid().ToString()
    # NestedModules = @( 'MDTLTIPSSampleAction.dll' )
    # RequiredAssemblies = @( 'C:\Program Files\Microsoft Deployment Toolkit\Bin\Microsoft.BDD.Workbench.dll' )
    CmdletsToExport = @( 'Install-LTIPSGallery', 'UnInstall-LTIPSGallery' )
    ModuleToProcess = 'MDTLTIPSSampleAction.psm1'
}

write-verbose "Create the manifest"
New-ModuleManifest @ModuleCommon -path $PSScriptRoot\MDTLTIPSSampleAction\MDTLTIPSSampleAction.psd1

#endregion

#region Register

if ( $register ) {

    Import-Module -Name $PSScriptRoot\MDTLTIPSSampleAction -Force -Scope Local
    MDTLTIPSSampleAction\Install-LTIPSGallery

}

#endregion
