<#
.SYNOPSIS
Tests searching for database columns.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Find-DbColumn' -Tag Find-DbColumn {
	Context 'Searches for database columns' -Tag FindDbColumn,Find,DbColumn,Database {
		It "Finds price columns in the test database" -Skip:$(!$env:TestConnectionString) {
			Find-DbColumn -ConnectionString $env:TestConnectionString -IncludeColumns %price% |
				Select-Object -ExpandProperty ColumnName |
				Should -BeLike '*Price*'
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
