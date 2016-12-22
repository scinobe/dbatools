Function Parse-CmsGroup($CmsGrp, $base = '')
{
	$results = @()
	foreach($el in $CmsGrp) {
		if($base -eq ''){
			$partial = $el.name
		} else {
			$partial = "$base\$($el.name)"
		}
		$results += $partial
		foreach($group in $el.ServerGroups) {
			$results += Parse-CmsGroup $group $partial
		}
	}
	return $results
}
	
Register-ArgumentCompleter -ParameterName Group -ScriptBlock {
	param (
		$commandName,
		$parameterName,
		$wordToComplete,
		$commandAst,
		$fakeBoundParameter
	)
	
	# unfortunately the logic is quite cumbersome because group names accept also the '\'
	# character, that is also the de-facto standard to give a hierarchy.
	# e.g.
	#
	# cms
	# +--foo
	#    +--bar\baz
	#    +--foo
	#       +--registered server
	# The only short-circuit would be something like:
	# cms
	# +--foo
	# |  +--bar
	# +--foo\bar
	
	$server = Get-SmoServerForDynamicParams
	$sqlconnection = $server.ConnectionContext.SqlConnectionObject
	
	try { $cmstore = New-Object Microsoft.SqlServer.Management.RegisteredServers.RegisteredServersStore($sqlconnection) }
	catch { return }
	
	$collection = Parse-CmsGroup $cmstore.DatabaseEngineServerGroup.ServerGroups
	
	if ($collection)
	{
		foreach ($item in $collection)
		{
			New-CompletionResult -CompletionText $item -ToolTip $item
		}
	}
}

Register-ArgumentCompleter -ParameterName SqlCmsGroups -ScriptBlock {
	param (
		$commandName,
		$parameterName,
		$wordToComplete,
		$commandAst,
		$fakeBoundParameter
	)
	
	# unfortunately the logic is quite cumbersome because group names accept also the '\'
	# character, that is also the de-facto standard to give a hierarchy.
	# e.g.
	#
	# cms
	# +--foo
	#    +--bar\baz
	#    +--foo
	#       +--registered server
	# The only short-circuit would be something like:
	# cms
	# +--foo
	# |  +--bar
	# +--foo\bar
	
	$server = Get-SmoServerForDynamicParams
	$sqlconnection = $server.ConnectionContext.SqlConnectionObject
	
	try { $cmstore = New-Object Microsoft.SqlServer.Management.RegisteredServers.RegisteredServersStore($sqlconnection) }
	catch { return }
	
	$collection = Parse-CmsGroup $cmstore.DatabaseEngineServerGroup.ServerGroups
	
	if ($collection)
	{
		foreach ($item in $collection)
		{
			New-CompletionResult -CompletionText $item -ToolTip $item
		}
	}
}