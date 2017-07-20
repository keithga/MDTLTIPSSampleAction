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
    param ( 
        $Name = 'MDTLTIPSSampleAction'
    )

    Write-Verbose "Verify MDT is installed"
    $MDTPath = Get-MDTDirectory
    if ( -not $MDTPath ) { throw "MDT is not installed" }
    if ( -not ( Test-Path $MDTPath\bin\Actions.xml ) ) { throw "MDT actions.xml not found" }

    if ( -not ( Test-Path "$MDTPath\bin\Actions.$($Name).xml" ) ) {
        Write-verbose "Create the XML file $MDTPath\bin\Actions.$($Name).xml"
        @"
<actions>
	<action>
		<Category>General</Category>
		<Name>Install PowerShellGet Action</Name>
		<Type>BDD_MDTLTIPSSampleControl</Type>
		<Assembly>$Name</Assembly>
		<Class>$($Name).MDTLTIPSSampleControl</Class>
		<Action>powershell.exe -Command  Install-Package -Force -ForceBootStrap -Name '%Package%'</Action>
		<Property type="string" name="Package" />
	</action>
</actions>
"@ | out-file -Encoding ascii -FilePath "$MDTPath\bin\Actions.$($Name).xml"
    }

    Write-verbose "Install the control"
    Copy-Item -Force -path $PSScriptRoot\$($Name).dll -Destination $MDTPath\bin
    Copy-Item -Force -path $PSScriptRoot\$($Name).pdb -Destination $MDTPath\bin -ErrorAction SilentlyContinue

    Write-verbose "$Name Installed"

}

function UnInstall-LTIPSGallery {
    param ( 
        $Name = 'MDTLTIPSSampleAction'
    )

    Write-Verbose "Verify MDT is installed"
    $MDTPath = Get-MDTDirectory
    if ( -not $MDTPath ) { throw "MDT is not installed" }
    if ( -not ( Test-Path $MDTPath\bin\Actions.xml ) ) { throw "MDT actions.xml not found" }

    Write-Verbose "remove $Name files"
    remove-item "$MDTPath\bin\$($Name).dll","$MDTPath\bin\$($Name).pdb","$MDTPath\bin\Actions.$($Name).xml" -ErrorAction SilentlyContinue

    Write-verbose "$Name removed"

}