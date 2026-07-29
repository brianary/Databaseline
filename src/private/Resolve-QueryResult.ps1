<#
.SYNOPSIS
Executes SQL that generates SQL strings, and optionally executes the generated SQL.

.PARAMETER Action
Descriptive text for the commands produced, with two format arguments:
0: Verb tense, e.g. 'Renam{0:e;ing;ed}'
1: Command count

.PARAMETER Query
A SQL query that produces a single-column result set, named "command", containing
executable SQL.
#>
[CmdletBinding(SupportsShouldProcess=$true)] Param([string]$Action,[string]$Query)
$count,$i = 0,0
[string[]]$commands = Invoke-DbaQuery -Query $Query -As PSObject |Select-Object -ExpandProperty command
if(!$commands){return}
$max,$act = ($commands.Count/100),($Action -f -1,$commands.Count)
Write-Verbose ($Action -f 1,$commands.Count)
foreach($command in $commands)
{
	Write-Progress $act "Execute command #$i" -CurrentOperation $command -PercentComplete ($i++/$max)
	if(!$Update) {$command}
	elseif($PSCmdlet.ShouldProcess($command,'execute')) {Invoke-DbaQuery -Query $command -As PSObject; $count++}
}
Write-Progress ($action -f 0,$i) -Completed
if($count) {Write-Warning ($Action -f 0,$count)}
