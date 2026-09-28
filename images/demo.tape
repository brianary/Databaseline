# VHS https://github.com/charmbracelet/vhs
Output demo.gif
Hide
Set Shell pwsh
Type "Import-Module ../.publish/Databaseline.psd1 ; Import-Module dbatools"
Enter
Type "Clear-Host"
Enter
Show
Type "Test-ConnectionString 'Server=localhost;Database=AdventureWorks2025;Trust Server Certificate=true' -Details"
Enter
Sleep 4s
Type "$db = Connect-DbaInstance -SqlInstance localhost -ApplicationIntent ReadOnly -EncryptConnection:$false"
Enter
Sleep 3s
Type "Use-DbInstance -SqlInstance $db -Database AdventureWorks2025 -As PSObject"
Enter
Sleep 2s
Type "Invoke-DbaQuery -Query 'select @@servername as ServerName;'"
Enter
Sleep 3s
Type "Find-DbIndexes -SqlInstance $db -Database AdventureWorks2025 -ColumnName ErrorLogID"
Enter
Sleep 9s
