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
[Parameter(Position=1)][Text.Encoding] $Encoding = [Text.Encoding]::UTF8,
# The database to write the details for.
[Parameter(ValueFromPipeline=$true,Mandatory=$true)]
[Microsoft.SqlServer.Management.Smo.Database] $Database
)
Begin
{
	filter Format-TableDetail
	{
		[CmdletBinding()] Param(
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][string] $Schema,
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][string] $Name,
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][double] $RowCountAsDouble,
		[Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][double] $DataSpaceUsed,
		[Parameter(ValueFromPipeline=$true,Mandatory=$true)][Microsoft.SqlServer.Management.Smo.Table] $Table
		)
		return @(
			"$Table"
			$RowCountAsDouble
			1024*$DataSpaceUsed |Format-ByteUnits -Precision 2
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
| Table | Rows | Size |
|-------|-----:|-----:|
$($TableCollection.GetEnumerator() |Show-Progress 'Examining tables' {"$_"} |Format-Table)
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
	Show-Progress 'Add tables to ER diagram' {"$_"} |
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
