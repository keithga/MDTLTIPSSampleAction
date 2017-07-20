# MDTLTIPSSampleAction
MDT Litetouch Action Property Page Sample 

![Fancy Example](/Graphics/FancyGraphic.PNG)

## Background

MDT has several pre-defined pages for common task sequence editing tasks. You've seen them in the MDT Litetouch Task Sequence Editor, 
under General, Disks, Images, Settings, and Roles.

They help abstract the ugly command line and scripting code behind the scenes for the user. 

Recently I had an idea for a super-wiz-bang property page type for MDT Litetouch, and asked "are there any MDT LTI samples out there?". 
I knew Config Mgr had a [SDK Sample](http://go.microsoft.com/fwlink/p/?LinkId=248167) and I've been using it for a while now to create SCCM Task Sequence Actions pages.

The answer came back "There _was_ an MDT Litetouch SDK, but not anymore." (Long story for another day)

"Someone should create a sample!" I said!

"Cool Keith, when you figure it out, can you share the results? :)" For those of you who wonder, how does one become a Microsoft MVP? __This__, so here we go.

## The Basics

### C# 

MDT Task Sequence Action Pages are simply C# Windows Form Control Library, with some standard API interfaces so it can be called from the Litetouch Wizard Host. 
The MDT team designed the API to closely resemble the System Center Configuration Manager Action Page API.
- There are entry points for when the control is initialized.
    - Use this opportunity to load the UI elements with the saved data from the PropertyManager (aka TS.xml)
- There are entry points for when the "OK" and "Apply" buttons are pressed.
    - Use this opportunity to save the UI elements with to the PropertyManager

There are several dependent classes required by the sample, they are contained in the 'c:\program files\Microsoft Deployment Toolkit\bin\Microsoft.BDD.Workbench.dll' assembly, 
so you will need add this reference to your project.

Anything else you want to add in the control, can be done if you know the correct C# code to get the job done.

### Registration

Once you have created the DLL Library, we will need to add it so MDT Litetouch console knows about it.

First off, copy the DLL to the 'c:\program files\Microsoft Deployment Toolkit\bin\' folder.

Secondly, we'll need to add an <action> element to the actions.xml file.

```xml
<action>
	<Category>General</Category>
	<Name>Install PowerShellGet Action</Name>
	<Type>BDD_MDTLTIPSSampleControl</Type>
	<Assembly>MDTLTIPSSampleAction</Assembly>
	<Class>MDTLTIPSSampleAction.MDTLTIPSSampleControl</Class>
	<Action>powershell.exe -Command  Install-Package -Force -ForceBootStrap -Name (New-Object -COMObject Microsoft.SMS.TSEnvironment).Value('Package')</Action>
	<Property type="string" name="Package" />
</action>
```

For this sample, I included a PowerShell libary module with two functions, one to register the new control, the other to remove the control. Easy!

### The Sample

The sample in this case is pretty small.

There is one TextBox (as shown above), that prompts the user for the name of a PowerShell Package. 

The package name get's added to the TS.XML, along with the command, in this case it calls PowerShell.exe with the cmdlet Install-Package. We use COM to connect to the SMS environment space to get the package name and go.

You can use the build.ps1 script to compile the sample, and create PowerShell library to install the control within MDT Litetouch.

## Future 

Well I created this sample, because I have some ideas for some MDT LiteTouch (and SCCM) Action controls. 

- Fancy UI for installation of applications through Chocolatey
- Run scripts and modules from PowerShellGallery.com
- Other ideas, let me know (comments or e-mail)


keith
