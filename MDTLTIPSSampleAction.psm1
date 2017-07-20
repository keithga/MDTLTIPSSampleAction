<#
.SYNOPSIS
MDT LTI PowerShell Gallery Control

.DESCRIPTION

Microsoft Deployment Toolkit LiteTouch Task Sequence Action Control for PowerShell Gallery (whew)
Component Installation and UnInstallation

.NOTES
Copyright Keith Garner (KeithGa@DeploymentLive.com), All rights reserved.

.LINK
https://github.com/keithga/MDTLTIPSSampleAction

#>

function Get-MDTDirectory {
    [Microsoft.Win32.RegistryKey]::OpenBaseKey(
            [Microsoft.Win32.RegistryHive]::LocalMachine, 
            [Microsoft.Win32.RegistryView]::Registry64).
        OpenSubKey("Software\Microsoft\Deployment 4").
        GetValue("Install_Dir") |
        Write-Output
}


function Install-LTIPSGallery {

    Write-Verbose "Verify MDT is installed"
    $MDTPath = Get-MDTDirectory
    if ( -not $MDTPath ) { throw "MDT is not installed" }
    if ( -not ( Test-Path $MDTPath\bin\Actions.xml ) ) { throw "MDT actions.xml not found" }

    $Actions = get-content -Path $MDTPath\bin\Actions.xml -Raw
    if ( -not $Actions.Contains('BDD_MDTLTIPSSampleControl') ) {
        Write-Verbose "patch Actions.xml"
        copy-item -Path $MDTPath\bin\Actions.xml -Destination $MDTPath\bin\Actions.bak.xml

        $NewAction = @"
	<action>
		<Category>General</Category>
		<Name>Install PowerShellGet Action</Name>
		<Type>BDD_MDTLTIPSSampleControl</Type>
		<Assembly>MDTLTIPSSampleAction</Assembly>
		<Class>MDTLTIPSSampleAction.MDTLTIPSSampleControl</Class>
		<Action>powershell.exe -Command  Install-Package -Force -ForceBootStrap -Name (New-Object -COMObject Microsoft.SMS.TSEnvironment).Value('Package')</Action>
		<Property type="string" name="Package" />
	</action>
"@

        $Actions.Replace('</actions>', $NewAction + "`r`n" + '</actions>') | Out-File -Encoding ascii -FilePath $MDTPath\bin\Actions.xml
    }

    Write-verbose "Install the control"
    Copy-Item -Force -path $PSScriptRoot\MDTLTIPSSampleAction.dll -Destination $MDTPath\bin
    Copy-Item -Force -path $PSScriptRoot\MDTLTIPSSampleAction.pdb -Destination $MDTPath\bin -ErrorAction SilentlyContinue

    Write-verbose "MDTLTIPSSampleAction Installed"

}

function UnInstall-LTIPSGallery {

    Write-Verbose "Verify MDT is installed"
    $MDTPath = Get-MDTDirectory
    if ( -not $MDTPath ) { throw "MDT is not installed" }
    if ( -not ( Test-Path $MDTPath\bin\Actions.xml ) ) { throw "MDT actions.xml not found" }

    Write-Verbose "remove binaries"
    remove-item $MDTPath\bin\MDTLTIPSSampleAction.dll,$MDTPath\bin\MDTLTIPSSampleAction.pdb -ErrorAction SilentlyContinue

    [xml]$Actions = get-content -Path $MDTPath\bin\Actions.xml -Raw
    $FoundAction = $Actions.actions.action | where-object type -eq 'BDD_MDTLTIPSSampleControl'
    if ( $FoundAction ) {
        Write-Verbose 'remove XML blob'
        $Actions.actions.RemoveChild($FoundAction) | out-null
        $Actions.Save("$MDTPath\bin\Actions.xml")
    }

    Write-verbose "MDTLTIPSSampleAction removed"

}