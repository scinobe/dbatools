Register-ArgumentCompleter -ParameterName Name -ScriptBlock {
	param (
		$commandName,
		$parameterName,
		$wordToComplete,
		$commandAst,
		$fakeBoundParameter
	)
	
	$server = Get-SmoServerForDynamicParams
	
	$server.Configuration.ShowAdvancedOptions.ConfigValue = $true
	$null = $server.ConnectionContext.ExecuteNonQuery("RECONFIGURE WITH OVERRIDE")
	$collection = $server.Configuration.PsObject.Properties.Name | Where-Object { $_ -notin "Parent", "Properties" }
	$server.Configuration.ShowAdvancedOptions.ConfigValue = $false
	$null = $server.ConnectionContext.ExecuteNonQuery("RECONFIGURE WITH OVERRIDE")
	
	if ($collection)
	{
		foreach ($item in $collection)
		{
			New-CompletionResult -CompletionText $item -ToolTip $item
		}
	}
}