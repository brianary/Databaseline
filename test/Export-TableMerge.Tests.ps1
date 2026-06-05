<#
.SYNOPSIS
Tests exporting table data as a T-SQL MERGE statement.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
	$datadir = Join-Path $PSScriptRoot 'data'
	$server = if(!!$env:TestConnectionString) {Connect-DbaInstance -SqlInstance $env:TestConnectionString}
}
Describe 'Export-TableMerge' -Tag Export-TableMerge {
	Context 'Exports table data' -Tag ExportTableMerge,Export,TableMerge,Database {
		It "Exports AdventureWorks HumanResources.Department table data" -Skip:$(!$env:TestConnectionString) -TestCases @(
			@{ Schema = 'HumanResources'; Table = 'Department' }
			@{ Schema = 'Person'; Table = 'PhoneNumberType' }
			@{ Schema = 'Production'; Table = 'ProductModelIllustration' }
		) {
			$result = Join-Path $datadir "${Schema}.${Table}.merge.sql" |Get-Item |Get-Content -Raw
			$result = $result.TrimEnd()
			Get-DbaDbTable -SqlInstance $server -Schema $Schema -Table $Table |
				Export-TableMerge.ps1 |
				Should -BeExactly $result
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
