Register-ArgumentCompleter -ParameterName Assemblies -ScriptBlock {
	param (
		$commandName,
		$parameterName,
		$wordToComplete,
		$commandAst,
		$fakeBoundParameter
	)
	
	$server = Get-SmoServerForDynamicParams
	
	$collection = @()
	
	foreach ($database in $server.Databases)
	{
		try
		{
			# a bug here requires a try/catch
			$userAssemblies = $($database.assemblies | Where-Object { $_.isSystemObject -eq $false })
			foreach ($assembly in $userAssemblies)
			{
				$collection += "$($database.name).$($assembly.name)"
			}
		}
		catch { }
	}
	
	if ($collection)
	{
		foreach ($item in $collection)
		{
			New-CompletionResult -CompletionText $item -ToolTip $item
		}
	}
}