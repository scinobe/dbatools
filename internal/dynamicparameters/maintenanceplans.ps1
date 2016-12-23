Register-ArgumentCompleter -ParameterName Name -ScriptBlock {
	param (
		$commandName,
		$parameterName,
		$wordToComplete,
		$commandAst,
		$fakeBoundParameter
	)
	
	$server = Get-SmoServerForDynamicParams
	$sql = "SELECT sp.[name] AS MaintenancePlans FROM msdb.dbo.sysmaintplan_plans AS sp"
	$collection = $server.ConnectionContext.ExecuteWithResults($sql).Tables.Rows.MaintenancePlans
	
	if ($collection)
	{
		foreach ($item in $collection)
		{
			New-CompletionResult -CompletionText $item -ToolTip $item
		}
	}
}