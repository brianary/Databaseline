<#
.SYNOPSIS
Finds database constraints with system-generated names and gives them deterministic names.

.FUNCTIONALITY
Database

.LINK
Use-SqlcmdParams

.LINK
https://dbatools.io/

.LINK
https://www.databasejournal.com/features/mssql/article.php/1570801/Beware-of-the-System-Generated-Constraint-Name.htm

.EXAMPLE
Repair-DatabaseConstraintNames SqlServerName DatabaseName -Update

WARNING: Renamed 10 defaults
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
	Resolve-QueryResult -Action 'Renam{0:e;ing;ed} {1} defaults' -Query @"
select 'if object_id(''' + quotename(schema_name(schema_id)) +'.'+ quotename(name)
	   +''') is not null exec sp_rename '''+quotename(schema_name(schema_id))+'.'+quotename(name)
	   +''', ''DF_'+object_name(parent_object_id)+'_'+col_name(parent_object_id,parent_column_id)
	   +''', ''OBJECT'';' [command]
  from sys.default_constraints
 where name like 'DF._._%' escape '.'
   and name <> 'DF_'+object_name(parent_object_id)+'_'+col_name(parent_object_id,parent_column_id)
   and objectproperty(parent_object_id,'IsUserTable') = 1 -- excludes 'sys' schema, &c
   and objectproperty(parent_object_id,'IsMsShipped') = 0 -- excludes dtproperties, &c
   and parent_object_id not in (select major_id from sys.extended_properties
	   where class = 1 and minor_id = 0 and name = 'microsoft_database_tools_support'); -- excludes sysdiagrams, &c
"@
}

function Repair-PrimaryKeyName
{
	Resolve-QueryResult -Action 'Renam{0:e;ing;ed} {1} primary keys' -Query @"
select 'if object_id(''' + quotename(schema_name(schema_id)) +'.'+ quotename(name)
	   +''') is not null exec sp_rename '''+quotename(schema_name(schema_id))+'.'+quotename(name)
	   +''', '''+'PK_'+object_name(parent_object_id)+''', ''OBJECT'';' command
  from sys.key_constraints
 where name like 'PK._._%' escape '.'
   and name <> 'PK_'+object_name(parent_object_id)
   and objectproperty(parent_object_id,'IsUserTable') = 1 -- excludes 'sys' schema, &c
   and objectproperty(parent_object_id,'IsMsShipped') = 0 -- excludes dtproperties, &c
   and parent_object_id not in (select major_id from sys.extended_properties
	   where class = 1 and minor_id = 0 and name = 'microsoft_database_tools_support'); -- excludes sysdiagrams, &c
"@
}

function Repair-ForeignKeyName
{ #TODO: Mitigate possible deterministic naming collisions.
	Resolve-QueryResult -Action 'Renam{0:e;ing;ed} {1} foreign keys' -Query @"
select 'if object_id(''' + quotename(schema_name(schema_id)) +'.'+ quotename(name)
	   +''') is not null exec sp_rename '''+quotename(schema_name(schema_id))+'.'+quotename(name)
	   +''', '''+'FK_'+object_name(parent_object_id)+'_'+object_name(referenced_object_id)+''', ''OBJECT'';' command
  from sys.foreign_keys
 where name like 'FK._._%' escape '.'
   and name <> 'FK_'+object_name(parent_object_id)
   and objectproperty(parent_object_id,'IsUserTable') = 1 -- excludes 'sys' schema, &c
   and objectproperty(parent_object_id,'IsMsShipped') = 0 -- excludes dtproperties, &c
   and parent_object_id not in (select major_id from sys.extended_properties
	   where class = 1 and minor_id = 0 and name = 'microsoft_database_tools_support'); -- excludes sysdiagrams, &c
"@
}

Repair-DefaultName
Repair-PrimaryKeyName
Repair-ForeignKeyName
