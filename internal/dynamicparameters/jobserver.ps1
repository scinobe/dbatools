$jobobjects = "ProxyAccounts", "JobSchedule", "SharedSchedules", "AlertSystem", "JobCategories", "OperatorCategories","AlertCategories", "Alerts", "TargetServerGroups", "TargetServers", "Operators", "Jobs", "Mail"

foreach ($name in $jobobjects)
{
	Register-ArgumentCompleter -ParameterName Name -ScriptBlock {
		param (
			$commandName,
			$parameterName,
			$wordToComplete,
			$commandAst,
			$fakeBoundParameter
		)
		
		$server = Get-SmoServerForDynamicParams
		$collection = $server.JobServer.$name.Name
		
		if ($collection)
		{
			foreach ($item in $collection)
			{
				New-CompletionResult -CompletionText $item -ToolTip $item
			}
		}
	}
}