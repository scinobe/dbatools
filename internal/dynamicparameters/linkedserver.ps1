Register-ArgumentCompleter -ParameterName LinkedServers -ScriptBlock {
	param (
		$commandName,
		$parameterName,
		$wordToComplete,
		$commandAst,
		$fakeBoundParameter
	)
	
	$server = Get-SmoServerForDynamicParams
	$collection = $server.LinkedServers | Where-Object { $_.Name -ne "repl_distributor"} | Select -exp Name
	
	if ($collection)
	{
		foreach ($item in $collection)
		{
			New-CompletionResult -CompletionText $item -ToolTip $item
		}
	}
}