<#
.SYNOPSIS
Tests returning indexes using a column with the given name.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Find-DbIndexes' -Tag Find-DbIndexes -Skip:$skip {
	Context 'Returns indexes using a column with the given name' -Tag FindDbIndexes,Find,DbIndexes,Database {
		It "Finds the ErrorLog ID" -Skip:$(!$env:TestConnectionString) {
			$index = Find-DbIndexes -ConnectionString $env:TestConnectionString -ColumnName ErrorLogID
			$index.IndexName |Should -BeExactly PK_ErrorLog_ErrorLogID
			$index.TableName |Should -BeExactly ErrorLog
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
