$server = Get-SmoServerForDynamicParams
Get-GenericArgumentCompleter -Name Databases -Collection $server.databases.name