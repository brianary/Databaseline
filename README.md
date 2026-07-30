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

- [Export-MermaidER](https://github.com/brianary/Databaseline/wiki/Export-MermaidER): Generates a Mermaid entity relation diagram for database tables.
- [Export-TableMerge](https://github.com/brianary/Databaseline/wiki/Export-TableMerge): Exports table data as a T-SQL MERGE statement.
- [Find-DatabaseValue](https://github.com/brianary/Databaseline/wiki/Find-DatabaseValue): Searches an entire database for a field value.
- [Find-DbColumn](https://github.com/brianary/Databaseline/wiki/Find-DbColumn): Searches for database columns.
- [Find-DbIndexes](https://github.com/brianary/Databaseline/wiki/Find-DbIndexes): Returns indexes using a column with the given name.
- [Measure-DbColumn](https://github.com/brianary/Databaseline/wiki/Measure-DbColumn): Provides statistics about SQL Server column data.
- [Measure-DbColumnValues](https://github.com/brianary/Databaseline/wiki/Measure-DbColumnValues): Provides sorted counts of SQL Server column values.
- [Measure-DbTable](https://github.com/brianary/Databaseline/wiki/Measure-DbTable): Provides frequency details about SQL Server table data.
- [New-DbProviderObject](https://github.com/brianary/Databaseline/wiki/New-DbProviderObject): Create a common database object.
- [Repair-DatabaseConstraintNames](https://github.com/brianary/Databaseline/wiki/Repair-DatabaseConstraintNames): Finds database constraints with system-generated names and gives them deterministic names.
- [Repair-DatabaseUntrustedConstraints](https://github.com/brianary/Databaseline/wiki/Repair-DatabaseUntrustedConstraints): Finds database constraints that have been incompletely re-enabled.
- [Send-SqlReport](https://github.com/brianary/Databaseline/wiki/Send-SqlReport): Execute a SQL statement and email the results.
- [Test-ConnectionString](https://github.com/brianary/Databaseline/wiki/Test-ConnectionString): Test a given connection string and provide details about the connection.
- [Use-DbInstance](https://github.com/brianary/Databaseline/wiki/Use-DbInstance): Sets a default dbatools connection, using a caller script's parameter values when available.
