Register-ArgumentCompleter -ParameterName Shapshots -ScriptBlock {
	param (
		$commandName,
		$parameterName,
		$wordToComplete,
		$commandAst,
		$fakeBoundParameter
	)
	
	$server = Get-SmoServerForDynamicParams
	$collection = $server.Databases | Where-Object { $_.IsDatabaseSnapshot -eq $true | Select -Exp Name
	#$databaselist += $database.DatabaseSnapshotBaseName
		
	
	if ($collection)
	{
		foreach ($item in $collection)
		{
			New-CompletionResult -CompletionText $item -ToolTip $item
		}
	}
}