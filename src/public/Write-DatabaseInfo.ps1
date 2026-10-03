<#
.SYNOPSIS
Creates a markdown file containing database details.

.FUNCTIONALITY
Database

.EXAMPLE
Get-DbaDatabase -SqlInstance $db -Database $database |Write-DatabaseInfo

Creates a README.md with information about the database.
#>

[CmdletBinding()] Param(
# The file to write database info to.
[Parameter(Position=0)][string] $Path = 'README.md',
# The file encoding to use.
[Parameter(Position=1)][Text.Encoding] $Encoding = 'utf8',
# The database to write the details for.
[Parameter(ValueFromPipeline=$true,Mandatory=$true)]
[Microsoft.SqlServer.Management.Smo.Database] $Database
)
Begin
{
	filter Format-TableDetail
	{
		[CmdletBinding()] Param(
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][string] $Name,
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][double] $RowCountAsDouble,
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][double] $DataSpaceUsed,
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][int] $DataRetentionPeriod,
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)]
		[Microsoft.SqlServer.Management.Smo.DataRetentionPeriodUnit] $DataRetentionPeriodUnit
		)
		return @(
			$Name
			$RowCountAsDouble
			$DataSpaceUsed |Format-ByteUnits -Precision 2
			$DataRetentionPeriodUnit -eq 'Infinite' ? "$DataRetentionPeriodUnit" :
				"$DataRetentionPeriod $DataRetentionPeriodUnit$('{0:\s;\s;""}' -f ($DataRetentionPeriod-1))"
		)
	}

	filter Format-Table
	{
		[CmdletBinding()] Param(
		[Parameter(ValueFromPipeline=$true,Mandatory=$true)]
		[Microsoft.SqlServer.Management.Smo.Table] $Table
		)
		$Local:OFS = ' | '
		return @"
| $($Table |Format-TableDetail) |
"@
	}

	function Format-TableCollection
	{
		[CmdletBinding()] Param(
		[Parameter(Position=0,Mandatory=$true)]
		[Microsoft.SqlServer.Management.Smo.TableCollection] $TableCollection
		)
		$Local:OFS = [Environment]::NewLine
		return @"
| Table | Rows | Size | Retention |
|-------|-----:|-----:|----------:|
$($TableCollection.GetEnumerator() |Format-Table)
"@
	}

	function Format-Database
	{
		[CmdletBinding()] Param(
		[Parameter(Position=0,Mandatory=$true)]
		[Microsoft.SqlServer.Management.Smo.Database] $Database
		)
		return @"
$($Database.Name)
$(New-Object string '=',$Database.Name.Length)

Last updated $(Get-Date)

``````mermaid
$($Database |
	Get-DbaDbTable |
	Where-Object Name -NotIn dtproperties,__MigrationLog,__SchemaSnapshot |
	Export-MermaidER)
``````

$(Format-TableCollection $Database.Tables)
"@
	}
}
Process
{
	Format-Database $Database |Out-File $Path -Encoding $Encoding
}
