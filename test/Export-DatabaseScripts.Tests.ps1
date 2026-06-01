<#
.SYNOPSIS
Tests exporting MS SQL database objects from the given server and database as files, into a consistent folder structure.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
	Mock Export-DbaScript {}
	$mockfile = Join-Path $PSScriptRoot mock ([io.path]::ChangeExtension((Split-Path $PSCommandPath -Leaf), 'cs'))
	try {[void][MockObject]}
	catch {Add-Type -TypeDefinition (Get-Content $mockfile -Raw)}
}
Describe 'Export-DatabaseScripts' -Tag Export-DatabaseScripts -Skip:$skip {
	Context 'Exports MS SQL database objects from the given server and database as files, into a consistent folder structure' `
		-Tag ExportDatabaseScripts,Export,DatabaseScripts,Database,SQL {
		It "Export scripts" {
			New-Object Database |Export-DatabaseScripts
			Assert-MockCalled -CommandName Export-DbaScript -Times 3
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
