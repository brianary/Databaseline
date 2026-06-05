<#
.SYNOPSIS
Tests generating a Mermaid entity relation diagram for database tables.
#>

if(!(&"$PSScriptRoot/../scripts/Test-RelevantTest.ps1")) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	&"$PSScriptRoot/../scripts/Import-ThisModule.ps1"
	$datadir = Join-Path $PSScriptRoot 'data'
	$mockfile = Join-Path $PSScriptRoot mock ([io.path]::ChangeExtension((Split-Path $PSCommandPath -Leaf), 'cs'))
	$server = if(!!$env:TestConnectionString) {Connect-DbaInstance -SqlInstance $env:TestConnectionString}
}
Describe 'Export-MermaidER' -Tag Export-MermaidER {
	Context 'Generates a Mermaid entity relation diagram for database tables' -Tag ExportMermaidER,Export,MermaidER,Mermaid,Diagram,Database {
		It "From the test database, the table '<Table>' generates the diagram in the '<ResultFile>' data file" -Skip:$(!$env:TestConnectionString) -TestCases @(
			@{ Schema = 'Production'; Table = 'Product'; ResultFile = 'AW.Production.Product.mmd' }
		) {
			Param([string] $Schema, [string] $Table, [string] $ResultFile)
			$result = Join-Path $datadir $ResultFile |Get-Item |Get-Content -Raw
			Get-DbaDbTable -SqlInstance $server -Schema $Schema -Table $Table |Export-MermaidER |Should -BeExactly $result
		}
		It "From the test database, the schema '<Schema>' generates the diagram in the '<ResultFile>' data file" -Skip:$(!$env:TestConnectionString) -TestCases @(
			@{ Schema = 'Purchasing'; ResultFile = 'AW.Purchasing.mmd' }
		) {
			Param([string] $Schema, [string] $ResultFile)
			$result = Join-Path $datadir $ResultFile |Get-Item |Get-Content -Raw
			Get-DbaDbTable -SqlInstance $server -Schema $Schema |Export-MermaidER |Should -BeExactly $result
		}
		It "From the mock Library database, the table '<Table>' generates the diagram in the '<ResultFile>' data file" -Skip:$(!!$env:TestConnectionString) -TestCases @(
			@{ Table = 'Book'; ResultFile = 'Library.dbo.Book.mmd' }
		) {
			Param([string] $Table, [string] $ResultFile)
			try {[void][MockDatabases]} catch {Add-Type -TypeDefinition (Get-Content $mockfile -Raw)}
			$result = Join-Path $datadir $ResultFile |Get-Item |Get-Content -Raw
			([MockDatabases]::Library.Tables[$Table, "dbo"] |Export-MermaidER) -replace '\r' |
				Should -BeExactly ($result -replace '\r')
		}
		It "From the mock Library database generates the diagram in the '<ResultFile>' data file" -Skip:$(!!$env:TestConnectionString) -TestCases @(
			@{ ResultFile = 'Library.mmd' }
		) {
			Param([string] $ResultFile)
			try {[void][MockDatabases]} catch {Add-Type -TypeDefinition (Get-Content $mockfile -Raw)}
			$result = Join-Path $datadir $ResultFile |Get-Item |Get-Content -Raw
			([MockDatabases]::Library.Tables |Export-MermaidER) -replace '\r' |
				Should -BeExactly ($result -replace '\r')
		}
	}
}
AfterAll {
	&"$PSScriptRoot/../scripts/Remove-ThisModule.ps1"
}
