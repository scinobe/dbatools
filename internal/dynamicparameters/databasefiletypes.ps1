Register-ArgumentCompleter -ParameterName FileTypes -ScriptBlock {
	param (
		$commandName,
		$parameterName,
		$wordToComplete,
		$commandAst,
		$fakeBoundParameter
	)
	
	$server = Get-SmoServerForDynamicParams
	
	if ($server.versionMajor -eq 8)
	{
		$sql = "select distinct CASE WHEN groupid = 1 THEN 'ROWS' WHEN groupid = 0 THEN 'LOG' END as filetype from sysaltfiles"
	}
	else
	{
		$sql = "SELECT distinct CASE type_desc WHEN 'ROWS' then 'DATA' ELSE type_desc END AS FileType FROM sys.master_files mf INNER JOIN sys.databases db ON db.database_id = mf.database_id"
	}
	
	$dbfiletable = $server.ConnectionContext.ExecuteWithResults($sql)
	$filetypes = ($dbfiletable.Tables[0].Rows).FileType
	
	if ($server.versionMajor -eq 8)
	{
		$filetypes += "FULLTEXT"
	}
	
	if ($filetypes)
	{
		foreach ($item in $filetypes)
		{
			New-CompletionResult -CompletionText $item -ToolTip $item
		}
	}
}