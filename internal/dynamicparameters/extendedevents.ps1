Register-ArgumentCompleter -ParameterName Sessions -ScriptBlock {
	param (
		$commandName,
		$parameterName,
		$wordToComplete,
		$commandAst,
		$fakeBoundParameter
	)
	
	$server = Get-SmoServerForDynamicParams
	$sqlconn = $server.ConnectionContext.SqlConnectionObject
	$sqlStoreConnection = New-Object Microsoft.SqlServer.Management.Sdk.Sfc.SqlStoreConnection $sqlconn
	
	$store = New-Object  Microsoft.SqlServer.Management.XEvent.XEStore $sqlStoreConnection
	$collection = $store.Sessions.Name
	
	if ($collection)
	{
		foreach ($item in $collection)
		{
			New-CompletionResult -CompletionText $item -ToolTip $item
		}
	}
}