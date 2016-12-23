foreach ($name in "Policies", "Conditions")
{
	Register-ArgumentCompleter -ParameterName $name -ScriptBlock {
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
		# DMF is the Declarative Management Framework, Policy Based Management's old name
		$store = New-Object Microsoft.SqlServer.Management.DMF.PolicyStore $sqlStoreConnection
		$collection = $store.$name.Name
		
		if ($collection)
		{
			foreach ($item in $collection)
			{
				New-CompletionResult -CompletionText $item -ToolTip $item
			}
		}
	}
}