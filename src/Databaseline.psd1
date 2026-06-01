# see https://docs.microsoft.com/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest
# and https://docs.microsoft.com/powershell/module/microsoft.powershell.core/new-modulemanifest
@{
RootModule = 'Databaseline.psm1'
ModuleVersion = '0.0.0.0' # placeholder to be overridden
CompatiblePSEditions = @('Core')
GUID = 'aadd2ea7-c7ac-4a12-90b7-10d46714931a'
Author = 'Brian Lalonde'
CompanyName = 'Unknown'
Copyright = 'Copyright © 2026 Brian Lalonde'
Description = 'Enhancements for working with SQL Server databases.'
PowerShellVersion = '7.0'
RequiredModules = @('dbatools')
FunctionsToExport = @('*') # '*'
CmdletsToExport = @() # '*'
VariablesToExport = @() # '*'
# AliasesToExport = @()
FileList = @('Databaseline.psd1','Databaseline.psm1')
PrivateData = @{
	PSData = @{
		Tags = @('Database','SQL','TSQL','SQLServer','Diagram','Analysis')
		LicenseUri = 'https://github.com/brianary/Databaseline/blob/master/LICENSE'
		ProjectUri = 'https://github.com/brianary/Databaseline/'
		IconUri = 'http://webcoder.info/images/Databaseline.svg'
		# ReleaseNotes = ''
		# PS7: A list of external modules that this module is dependent upon.
		# ExternalModuleDependencies = ,'Microsoft.PowerShell.Utility'
	}
}
}
