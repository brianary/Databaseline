<#
.SYNOPSIS
Finds database constraints that have been incompletely re-enabled.

.FUNCTIONALITY
Database

.LINK
Use-SqlcmdParams

.LINK
https://dbatools.io/

.LINK
https://www.brentozar.com/blitz/foreign-key-trusted/

.EXAMPLE
Repair-DatabaseUntrustedConstraints SqlServerName DatabaseName -Update

WARNING: Checked 2 constraints
#>

[CmdletBinding(SupportsShouldProcess=$true)][OutputType([void])] Param(
# The server to use, by name or constructed via Connect-DbaInstance.
[Parameter(Position=0,Mandatory=$true)][Alias('Parent','ServerInstance')][DbaInstanceParameter] $SqlInstance,
# The the database to connect to on the server.
[Parameter(Position=1,Mandatory=$true)][Alias('Name')][string] $Database,
# Update the database when present, otherwise simply outputs the changes as script.
[switch] $Update
)

Use-DbInstance

function Repair-DefaultName
{
	Resolve-QueryResult -Action 'Check{0:;ing;ed} {1} constraints' -Query @"
select 'if exists (select * from sys.foreign_keys where object_id = object_id('''
	   + quotename(schema_name(schema_id))
	   + '.' + quotename(object_name(object_id))
	   + ''') and is_not_trusted = 1) alter table '
	   + quotename(object_schema_name(parent_object_id))
	   + '.' + quotename(object_name(parent_object_id))
	   + ' with check check constraint ' + quotename(name) + '; -- FK' command
  from sys.foreign_keys
 where is_not_trusted = 1
   and is_not_for_replication = 0
   and is_disabled = 0
 union all
select 'if exists (select * from sys.foreign_keys where object_id = object_id('''
	   + quotename(schema_name(schema_id))
	   + '.' + quotename(object_name(object_id))
	   + ''') and is_not_trusted = 1) alter table '
	   + quotename(object_schema_name(parent_object_id))
	   + '.' + quotename(object_name(parent_object_id))
	   + ' with check check constraint ' + quotename(name) + ';' command
  from sys.check_constraints
 where is_not_trusted = 1
   and is_not_for_replication = 0
   and is_disabled = 0;
"@
}

Repair-DefaultName
