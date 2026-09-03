<#
.SYNOPSIS
Sets a default dbatools connection, using a caller script's parameter values when available.

.FUNCTIONALITY
Database

.EXAMPLE
Use-DbInstance -SqlInstance '(localdb)\ProjectsV13' -Database AdventureWorks2016

Sets a default connection to use for queries.
#>

[CmdletBinding()] Param(
# The server to use, by name or constructed via Connect-DbaInstance.
[Parameter(Position=0)][Alias('Parent','ServerInstance')][DbaInstanceParameter] $SqlInstance =
	$ExecutionContext.SessionState.Module.GetVariableFromCallersModule('PSCmdlet')?.Value?.SessionState?.PSVariable?.Get('SqlInstance'),
# The the database to connect to on the server.
[Parameter(Position=1)][Alias('Name')][string] $Database =
	$ExecutionContext.SessionState.Module.GetVariableFromCallersModule('PSCmdlet')?.Value?.SessionState?.PSVariable?.Get('Database'),
# Sets a default output type for Invoke-DbaQuery.
[ValidateSet('DataSet','DataTable','DataRow','PSObject','PSObjectArray','SingleValue')][string] $As
)
[Management.Automation.SessionState] $sessionState =
	$ExecutionContext.SessionState.Module.GetVariableFromCallersModule('PSCmdlet')?.Value?.SessionState
$scope = $sessionState ? @{ SessionState = $sessionState } : @{ Global = $true }
if($SqlInstance) {Set-ParameterDefault Invoke-DbaQuery SqlInstance $SqlInstance @scope}
if($Database) {Set-ParameterDefault Invoke-DbaQuery Database $Database @scope}
if($As) {Set-ParameterDefault Invoke-DbaQuery As $As @scope}
