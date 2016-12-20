foreach ($name in "JobCategories", "OperatorCategories", "AlertCategories")
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
		$collection = ($server.JobServer.$name | Where-Object { $_.ID -ge 100 }).Name
		
		if ($collection)
		{
			foreach ($item in $collection)
			{
				New-CompletionResult -CompletionText $item -ToolTip $item
			}
		}
	}
}