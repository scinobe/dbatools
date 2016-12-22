$objects = "ConfigurationValues", "Profiles", "Accounts", "MailServers"

foreach ($name in $objects)
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
		
		if ($name -eq "MailServers") 
		{ 
			$collection = $server.Mail.Accounts.$name.Name 
		}
		else 
		{ 
			$collection = $server.Mail.$name.Name 
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