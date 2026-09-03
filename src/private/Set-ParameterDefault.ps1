<#
.SYNOPSIS
Assigns a value to use for the specified cmdlet parameter to use when one is not specified.

.INPUTS
System.Object containing the default value to assign.

.FUNCTIONALITY
Parameters

.LINK
Stop-ThrowError

.LINK
Get-Command

.LINK
about_Scopes

.EXAMPLE
Set-ParameterDefault epcsv nti $true -Scope Global

Establishes that the -NoTypeInformation param of the Export-Csv cmdlet will be true if not otherwise specified,
globally for the PowerShell session.

.EXAMPLE
Set-ParameterDefault Select-Xml Namespace @{svg = 'http://www.w3.org/2000/svg'}

Uses only the SVG namespace for Select-Xml when none are given explicitly.
#>

[CmdletBinding()] Param(
# The name of a cmdlet, function, script, or alias to assign a default parameter value to.
[Parameter(Position=0,Mandatory=$true)][ValidateNotNullOrEmpty()][Alias('CmdletName')][string] $CommandName,
# The name or alias of the parameter to assign a default value to.
[Parameter(Position=1,Mandatory=$true)][ValidateNotNullOrEmpty()][string] $ParameterName,
# The value to assign as a default.
[Parameter(Position=2,Mandatory=$true,ValueFromPipeline=$true)] $Value,
# The SessionState object to use to access the variables.
[Management.Automation.SessionState] $SessionState = $ExecutionContext.SessionState.Module.GetVariableFromCallersModule('PSCmdlet')?.Value?.SessionState,
# Affects the global parameter defaults.
[switch] $Global
)
Begin
{
	if(!($Global -or $SessionState)) {throw 'Missing a SessionState object.'}
	$cmd = Get-Command $CommandName -ErrorAction Ignore
	if(!$cmd) {Stop-ThrowError "Could not find command '$CommandName'" -Argument CommandName}
	if($cmd.CommandType -eq 'Alias') {$cmd = Get-Command $cmd.ResolvedCommandName}
	if($cmd.CommandType -notin 'Cmdlet','ExternalScript','Function','Script')
	{Stop-ThrowError "Command '$CommandName' ($($cmd.CommandType)) not supported" -Argument CommandName}
	$name =
		try {"$($cmd.Name):$($cmd.ResolveParameter($ParameterName).Name)"}
		catch {Stop-ThrowError "Could not find parameter '$ParameterName' for cmdlet '$CommandName'" -Argument ParameterName}
	if($Global)
	{
		$defaults = Get-Variable PSDefaultParameterValues -Scope Global
		if($null -eq $defaults)
		{
			Set-Variable PSDefaultParameterValues @{} -Scope $Scope
			$defaults = Get-Variable PSDefaultParameterValues -Scope Global
		}
	}
	else
	{
		$defaults = $SessionState.PSVariable.Get('PSDefaultParameterValues')
		if($Global:PSDefaultParameterValues -eq $defaults.Value)
		{
			$SessionState.PSVariable.Set('PSDefaultParameterValues', $Global:PSDefaultParameterValues.Clone())
			$defaults = $SessionState.PSVariable.Get('PSDefaultParameterValues')
		}
		elseif($null -eq $defaults)
		{
			$SessionState.PSVariable.Set('PSDefaultParameterValues', @{})
			$defaults = $SessionState.PSVariable.Get('PSDefaultParameterValues')
		}
	}
}
Process
{
	Write-Verbose "Setting default parameter '$name' to '$Value'"
	$defaults.Value[$name] = $Value
}
