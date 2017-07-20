<#
.SYNOPSIS
MDT LTI PowerShell Gallery Control

.DESCRIPTION

Microsoft Deployment Toolkit LiteTouch Task Sequence Action Control for PowerShell Gallery (whew)
Component Installation and UnInstallation

.NOTES
Copyright Keith Garner (KeithGa@DeploymentLive.com), All rights reserved.

.LINK
https://github.com/keithga/DeployShared

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
    if ( -not $Actions.Contains('BDD_MDTLTIPSGalleryControl') ) {
        Write-Verbose "patch Actions.xml"
        copy-item -Path $MDTPath\bin\Actions.xml -Destination $MDTPath\bin\Actions.bak.xml

        $NewAction = @"
	<action>
		<Category>General</Category>
		<Name>Run PowerShellGallery Action</Name>
		<Type>BDD_MDTLTIPSGalleryControl</Type>
		<Assembly>MDTLTIPSGalleryAction</Assembly>
		<Class>MDTLTIPSGalleryAction.MDTLTIPSGalleryControl</Class>
		<Action>powershell.exe -Command  Invoke-Expression (New-Object -COMObject Microsoft.SMS.TSEnvironment).Value('PSCommand')</Action>
		<Property type="string" name="PSCommand" />
		<Property type="string" name="Package" />
		<Property type="string" name="PackageType" />
		<Property type="string" name="PackageName" />
		<Property type="string" name="PackageCommand" />
		<Property type="string" name="SuccessCodes" default="0 3010" />
	</action>
"@

        $Actions.Replace('</actions>', $NewAction + "`r`n" + '</actions>') | Out-File -Encoding ascii -FilePath $MDTPath\bin\Actions.xml
    }

    Write-verbose "Install the control"
    Copy-Item -Force -path $PSScriptRoot\MDTLTIPSGalleryAction.dll -Destination $MDTPath\bin
    Copy-Item -Force -path $PSScriptRoot\MDTLTIPSGalleryAction.pdb -Destination $MDTPath\bin -ErrorAction SilentlyContinue

    Write-verbose "MDTLTIPSGalleryAction Installed"

}

function UnInstall-LTIPSGallery {

    Write-Verbose "Verify MDT is installed"
    $MDTPath = Get-MDTDirectory
    if ( -not $MDTPath ) { throw "MDT is not installed" }
    if ( -not ( Test-Path $MDTPath\bin\Actions.xml ) ) { throw "MDT actions.xml not found" }

    Write-Verbose "remove binaries"
    remove-item $MDTPath\bin\MDTLTIPSGalleryAction.dll,$MDTPath\bin\MDTLTIPSGalleryAction.pdb -ErrorAction SilentlyContinue

    [xml]$Actions = get-content -Path $MDTPath\bin\Actions.xml -Raw
    $FoundAction = $Actions.actions.action | where-object type -eq 'BDD_MDTLTIPSGalleryControl'
    if ( $FoundAction ) {
        Write-Verbose 'remove XML blob'
        $Actions.actions.RemoveChild($FoundAction) | out-null
        $Actions.Save("$MDTPath\bin\Actions.xml")
    }

    Write-verbose "MDTLTIPSGalleryAction removed"

}