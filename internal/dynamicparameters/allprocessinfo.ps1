$processinfo = "Logins", "Spids", "Exclude", "Hosts", "Programs", "Databases"

foreach ($name in $processinfo)
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
		$processes = $server.EnumProcesses()
		$propertyname = $name.TrimEnd("s")
		
		switch ($propertyname)
		{
			"Exclude" { $items = $processes.Spid }
			"Spid" { $items = $processes.Spid }
			
			Default
			{
				$collection = $processes.$propertyname | Where-Object { $_.Length -gt 1 } | Sort-Object | Get-Unique
			}
		}
		
		if ($collection)
		{
			foreach ($item in $collection)
			{
				New-CompletionResult -CompletionText $item -ToolTip $item
			}
		}
	}
}