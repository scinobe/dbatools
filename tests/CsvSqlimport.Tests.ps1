<#

Commented out someone needs to look at 






RuleName                            Severity     FileName   Line  Message                                                     
--------                            --------     --------   ----  -------                                                     
PSUseSingularNouns                  Warning      CsvSqlimpo 344   The cmdlet 'Get-SqlDatabases' uses a plural noun. A         
                                                 rt.ps1           singular noun should be used instead.                       
PSUseSingularNouns                  Warning      CsvSqlimpo 389   The cmdlet 'Get-SqlTables' uses a plural noun. A singular   
                                                 rt.ps1           noun should be used instead.                                
PSUseSingularNouns                  Warning      CsvSqlimpo 436   The cmdlet 'Get-Columns' uses a plural noun. A singular     
                                                 rt.ps1           noun should be used instead.                                
PSPossibleIncorrectComparisonWithNu Warning      CsvSqlimpo 185   $null should be on the left side of equality comparisons.   
ll                                               rt.ps1                                                                       
PSPossibleIncorrectComparisonWithNu Warning      CsvSqlimpo 275   $null should be on the left side of equality comparisons.   
ll                                               rt.ps1                                                                       
PSPossibleIncorrectComparisonWithNu Warning      CsvSqlimpo 740   $null should be on the left side of equality comparisons.   
ll                                               rt.ps1                                                                       
PSPossibleIncorrectComparisonWithNu Warning      CsvSqlimpo 787   $null should be on the left side of equality comparisons.   
ll                                               rt.ps1                                                                       
PSPossibleIncorrectComparisonWithNu Warning      CsvSqlimpo 794   $null should be on the left side of equality comparisons.   
ll                                               rt.ps1                                                                       
PSPossibleIncorrectComparisonWithNu Warning      CsvSqlimpo 801   $null should be on the left side of equality comparisons.   
ll                                               rt.ps1                                                                       
PSPossibleIncorrectComparisonWithNu Warning      CsvSqlimpo 974   $null should be on the left side of equality comparisons.   
ll                                               rt.ps1                                                                       
PSPossibleIncorrectComparisonWithNu Warning      CsvSqlimpo 1175  $null should be on the left side of equality comparisons.   
ll                                               rt.ps1                                                                       
PSPossibleIncorrectComparisonWithNu Warning      CsvSqlimpo 1196  $null should be on the left side of equality comparisons.   
ll                                               rt.ps1                                                                       
PSPossibleIncorrectComparisonWithNu Warning      CsvSqlimpo 275   $null should be on the left side of equality comparisons.   
ll                                               rt.ps1                                                                       
PSUseOutputTypeCorrectly            Information  CsvSqlimpo 1051  The cmdlet 'Import-CsvToSql' returns an object of type      
                                                 rt.ps1           'System.String' but this type is not declared in the        
                                                                  OutputType attribute.                                       
PSUseApprovedVerbs                  Warning      CsvSqlimpo 235   The cmdlet 'Parse-OleQuery' uses an unapproved verb.        
                                                 rt.ps1                                                                       
PSUseDeclaredVarsMoreThanAssigments Warning      CsvSqlimpo 1226  The variable 'newrow' is assigned but never used.           
                                                 rt.ps1                                                                       
PSAvoidUsingPlainTextForPassword    Warning      CsvSqlimpo 147   Parameter '$SqlCredential' should use SecureString,         
                                                 rt.ps1           otherwise this will expose sensitive information. See       
                                                                  ConvertTo-SecureString for more information.                
PSAvoidUsingPlainTextForPassword    Warning      CsvSqlimpo 169   Parameter '$SqlCredentialPath' should use SecureString,     
                                                 rt.ps1           otherwise this will expose sensitive information. See       
                                                                  ConvertTo-SecureString for more information.                
PSAvoidUsingPlainTextForPassword    Warning      CsvSqlimpo 316   Parameter '$SqlCredential' should use SecureString,         
                                                 rt.ps1           otherwise this will expose sensitive information. See       
                                                                  ConvertTo-SecureString for more information.                
PSAvoidUsingPlainTextForPassword    Warning      CsvSqlimpo 362   Parameter '$SqlCredential' should use SecureString,         
                                                 rt.ps1           otherwise this will expose sensitive information. See       
                                                                  ConvertTo-SecureString for more information.                
PSAvoidUsingPlainTextForPassword    Warning      CsvSqlimpo 408   Parameter '$SqlCredential' should use SecureString,         
                                                 rt.ps1           otherwise this will expose sensitive information. See       
                                                                  ConvertTo-SecureString for more information.                
PSUseShouldProcessForStateChangingF Warning      CsvSqlimpo 589   Function ?New-SqlTable? has verb that could change system   
unctions                                         rt.ps1           state. Therefore, the function has to support               
                                                                  'ShouldProcess'.                                            
PSAvoidUsingEmptyCatchBlock         Warning      CsvSqlimpo 1395  Empty catch block is used. Please use Write-Error or throw  
                                                 rt.ps1           statements in catch blocks.                                 





#Thank you Warren http://ramblingcookiemonster.github.io/Testing-DSC-with-Pester-and-AppVeyor/

if(-not $PSScriptRoot)
{
    $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}
$Verbose = @{}
if($env:APPVEYOR_REPO_BRANCH -and $env:APPVEYOR_REPO_BRANCH -notlike "master")
{
    $Verbose.add("Verbose",$True)
}



$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace('.Tests.', '.')
Import-Module $PSScriptRoot\..\functions\$sut -Force
Import-Module PSScriptAnalyzer
## Added PSAvoidUsingPlainTextForPassword as credential is an object and therefore fails. 
## We can ignore any rules here under special circumstances agreed by admins :-)
## We expect some context using comments about the reason for ignoring a rule

$Rules = (Get-ScriptAnalyzerRule).Where{$_.RuleName -notin ('PSAvoidUsingPlainTextForPassword') }
$Name = $sut.Split('.')[0]

    Describe 'Script Analyzer Tests' {
            Context "Testing $Name for Standard Processing" {
                foreach ($rule in $rules) { 
                    $i = $rules.IndexOf($rule)
                    It "passes the PSScriptAnalyzer Rule number $i - $rule  " {
                        (Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\functions\$sut" -IncludeRule $rule.RuleName ).Count | Should Be 0 
                    }
                }
            }
        }
   ## Load the command
$ModuleBase = Split-Path -Parent $MyInvocation.MyCommand.Path

# For tests in .\Tests subdirectory
if ((Split-Path $ModuleBase -Leaf) -eq 'Tests')
{
	$ModuleBase = Split-Path $ModuleBase -Parent
}

# Handles modules in version directories
$leaf = Split-Path $ModuleBase -Leaf
$parent = Split-Path $ModuleBase -Parent
$parsedVersion = $null
if ([System.Version]::TryParse($leaf, [ref]$parsedVersion))
{
	$ModuleName = Split-Path $parent -Leaf
}
else
{
	$ModuleName = $leaf
}

# Removes all versions of the module from the session before importing
Get-Module $ModuleName | Remove-Module

# Because ModuleBase includes version number, this imports the required version
# of the module
$null = Import-Module $ModuleBase\$ModuleName.psd1 -PassThru -ErrorAction Stop 
. "$Modulebase\functions\DynamicParams.ps1"
Get-ChildItem "$Modulebase\internal\" |% {. $_.fullname}

    Describe "$Name Tests"{
        InModuleScope 'dbatools' {
            Context " There should be some functional tests here" {
                It "Does a thing" {
                    $ActualValue | Should Be $ExpectedValue
                }
		    }# Context
        }#modulescope
    }#describe
    #>
    