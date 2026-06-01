<#
.SYNOPSIS
Tests searching an entire database for a field value.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
}
Describe 'Find-DatabaseValue' -Tag Find-DatabaseValue -Skip:$skip {
	Context 'Searches an entire database for a field value' -Tag FindDatabaseValue,Find,DatabaseValue,Database {
		It "Finds France in [Sales].[SalesTerritory] by country code" -Skip:$(!$env:TestConnectionString) {
			$found = Find-DatabaseValue FR -IncludeSchemata Sales -MaxRows 100 -ConnectionString $env:TestConnectionString
			$found.'#TableName' |Should -BeExactly '[Sales].[SalesTerritory]'
			$found.'#ColumnName' |Should -BeExactly '[CountryRegionCode]'
			$found.CountryRegionCode |Should -BeExactly 'FR'
			$found.Name |Should -BeExactly 'France'
			$found.Group |Should -BeExactly 'Europe'
		}
		It "Finds matching values across several tables" -Skip:$(!$env:TestConnectionString) {
			$found = Find-DatabaseValue 41636 -IncludeColumns %OrderID -ConnectionString $env:TestConnectionString
			$TransactionHistory = $found |Where-Object '#TableName' -eq '[Production].[TransactionHistory]'
			$TransactionHistory.'#TableName' |Should -BeExactly '[Production].[TransactionHistory]'
			$TransactionHistory.'#ColumnName' |Should -BeExactly '[ReferenceOrderID]'
			$TransactionHistory.ReferenceOrderID |Should -BeExactly 41636
			$TransactionHistory.TransactionID |Should -BeExactly 100046
			$TransactionHistory.ProductID |Should -BeExactly 826
			$WorkOrder = $found |Where-Object '#TableName' -eq '[Production].[WorkOrder]'
			$WorkOrder.'#TableName' |Should -BeExactly '[Production].[WorkOrder]'
			$WorkOrder.'#ColumnName' |Should -BeExactly '[WorkOrderID]'
			$WorkOrder.WorkOrderID |Should -BeExactly 41636
			$WorkOrder.ProductID |Should -BeExactly 826
			$WorkOrderRouting = $found |Where-Object '#TableName' -eq '[Production].[WorkOrderRouting]'
			$WorkOrderRouting.'#TableName' |Should -BeExactly '[Production].[WorkOrderRouting]'
			$WorkOrderRouting.'#ColumnName' |Should -BeExactly '[WorkOrderID]'
			$WorkOrderRouting.WorkOrderID |Should -BeExactly 41636
			$WorkOrderRouting.ProductID |Should -BeExactly 826
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
