Register-ArgumentCompleter -ParameterName CollectionSets -ScriptBlock {
	param (
		$commandName,
		$parameterName,
		$wordToComplete,
		$commandAst,
		$fakeBoundParameter
	)
	
	$server = Get-SmoServerForDynamicParams
	$sqlconn = $server.ConnectionContext.SqlConnectionObject
	$storeconn = New-Object Microsoft.SqlServer.Management.Sdk.Sfc.SqlStoreConnection $sqlconn
	$store = New-Object Microsoft.SqlServer.Management.Collector.CollectorConfigStore $storeconn
	
	$collection = ($store.CollectionSets | Where-Object { $_.isSystem -eq $false }).Name
	
	if ($collection)
	{
		foreach ($item in $collection)
		{
			New-CompletionResult -CompletionText $item -ToolTip $item
		}
	}
}