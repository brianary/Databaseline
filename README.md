Databaseline
============

<!-- To publish to PowerShell Gallery, commit an update to the .psd1 file -->
<img src="images/Databaseline.svg" alt="Databaseline icon" align="right" height="200" width="200" />

[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/Databaseline)](https://www.powershellgallery.com/packages/Databaseline/)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/Databaseline)](https://www.powershellgallery.com/packages/Databaseline/)
[![Actions Status](https://github.com/brianary/Databaseline/actions/workflows/continuous.yml/badge.svg)](https://github.com/brianary/Databaseline/actions/workflows/continuous.yml)
[![Mastodon: @dataelemental@mastodon.social](https://badgen.net/badge/@dataelemental/@mastodon.social/blue?icon=mastodon)](https://mastodon.social/@dataelemental "DataElemental Mastodon profile")

Enhancements for working with SQL Server databases.

<img src="images/demo.gif" alt="a demonstration of the module commands" height="300" width="600" />

- [Export-DatabaseScripts](./src/public/Export-DatabaseScripts.ps1): <!-- ERROR: Unable to find type [Database]. -->
- [Export-MermaidER](./src/public/Export-MermaidER.ps1): <!-- ERROR: Unable to find type [Table]. -->
- [Export-TableMerge](./src/public/Export-TableMerge.ps1): <!-- ERROR: Unable to find type [Table]. -->
- [Find-DatabaseValue](./src/public/Find-DatabaseValue.ps1): <!-- ERROR: Unable to find type [Microsoft.SqlServer.Management.Smo.Database]. -->
- [Find-DbColumn](./src/public/Find-DbColumn.ps1): <!-- ERROR: Unable to find type [Microsoft.SqlServer.Management.Smo.Database]. -->
- [Find-DbIndexes](./src/public/Find-DbIndexes.ps1): <!-- ERROR: Unable to find type [Microsoft.SqlServer.Management.Smo.Database]. -->
- [Measure-DbColumn](./src/public/Measure-DbColumn.ps1): <!-- ERROR: Unable to find type [Microsoft.SqlServer.Management.Smo.Column]. -->
- [Measure-DbColumnValues](./src/public/Measure-DbColumnValues.ps1): <!-- ERROR: Unable to find type [Microsoft.SqlServer.Management.Smo.Column]. -->
- [Measure-DbTable](./src/public/Measure-DbTable.ps1): <!-- ERROR: Unable to find type [Microsoft.SqlServer.Management.Smo.Table]. -->
- [New-DbProviderObject](https://github.com/brianary/Databaseline/wiki/New-DbProviderObject): Create a common database object.
- [Repair-DatabaseConstraintNames](./src/public/Repair-DatabaseConstraintNames.ps1): <!-- ERROR: Unable to find type [Microsoft.SqlServer.Management.Smo.Database]. -->
- [Repair-DatabaseUntrustedConstraints](./src/public/Repair-DatabaseUntrustedConstraints.ps1): <!-- ERROR: Unable to find type [Microsoft.SqlServer.Management.Smo.Database]. -->
- [Send-SqlReport](./src/public/Send-SqlReport.ps1): <!-- ERROR: Unable to find type [Microsoft.SqlServer.Management.Smo.Database]. -->
- [Test-ConnectionString](https://github.com/brianary/Databaseline/wiki/Test-ConnectionString): Test a given connection string and provide details about the connection.
- [Use-DbInstance](./src/public/Use-DbInstance.ps1): <!-- ERROR: Unable to find type [DbaInstanceParameter]. -->
- [Use-SqlcmdParams](https://github.com/brianary/Databaseline/wiki/Use-SqlcmdParams): Use the calling script parameters to set Invoke-Sqlcmd defaults.
