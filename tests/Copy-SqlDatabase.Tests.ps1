<#

Commented out someone needs to look at 




RuleName                            Severity     FileName   Line  Message                                                     
--------                            --------     --------   ----  -------                                                     
PSUseDeclaredVarsMoreThanAssigments Warning      Copy-SqlDa 866   The variable 'alldbelapsed' is assigned but never used.     
                                                 tabase.ps1                                                                   
PSUseDeclaredVarsMoreThanAssigments Warning      Copy-SqlDa 872   The variable 'dbelapsed' is assigned but never used.        
                                                 tabase.ps1                                                                   
PSAvoidUsingWriteHost               Warning      Copy-SqlDa 571   File 'Copy-SqlDatabase.ps1' uses Write-Host. Avoid using    
                                                 tabase.ps1       Write-Host because it might not work in all hosts, does not 
                                                                  work when there is no host, and (prior to PS 5.0) cannot be 
                                                                  suppressed, captured, or redirected. Instead, use           
                                                                  Write-Output, Write-Verbose, or Write-Information.          
PSUseOutputTypeCorrectly            Information  Copy-SqlDa 1166  The cmdlet 'Copy-SqlDatabase' returns an object of type     
                                                 tabase.ps1       'System.String' but this type is not declared in the        
                                                                  OutputType attribute.                                       
PSUseOutputTypeCorrectly            Information  Copy-SqlDa 635   The cmdlet 'Start-SqlDetachAttach' returns an object of     
                                                 tabase.ps1       type 'System.String' but this type is not declared in the   
                                                                  OutputType attribute.                                       
PSUseOutputTypeCorrectly            Information  Copy-SqlDa 648   The cmdlet 'Start-SqlDetachAttach' returns an object of     
                                                 tabase.ps1       type 'System.String' but this type is not declared in the   
                                                                  OutputType attribute.                                       
PSUseOutputTypeCorrectly            Information  Copy-SqlDa 655   The cmdlet 'Start-SqlDetachAttach' returns an object of     
                                                 tabase.ps1       type 'System.String' but this type is not declared in the   
                                                                  OutputType attribute.                                       
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlDa 377   $null should be on the left side of equality comparisons.   
ll                                               tabase.ps1                                                                   
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlDa 512   $null should be on the left side of equality comparisons.   
ll                                               tabase.ps1                                                                   
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlDa 614   $null should be on the left side of equality comparisons.   
ll                                               tabase.ps1                                                                   
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlDa 940   $null should be on the left side of equality comparisons.   
ll                                               tabase.ps1                                                                   
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlDa 945   $null should be on the left side of equality comparisons.   
ll                                               tabase.ps1                                                                   
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlDa 1048  $null should be on the left side of equality comparisons.   
ll                                               tabase.ps1                                                                   
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlDa 377   $null should be on the left side of equality comparisons.   
ll                                               tabase.ps1                                                                   
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlDa 512   $null should be on the left side of equality comparisons.   
ll                                               tabase.ps1                                                                   
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlDa 614   $null should be on the left side of equality comparisons.   
ll                                               tabase.ps1                                                                   
PSAvoidUsingCmdletAliases           Warning      Copy-SqlDa 561   'where' is an alias of 'Where-Object'. Alias can introduce  
                                                 tabase.ps1       possible problems and make scripts hard to maintain. Please 
                                                                  consider changing alias to its full content.                
PSAvoidUsingEmptyCatchBlock         Warning      Copy-SqlDa 237   Empty catch block is used. Please use Write-Error or throw  
                                                 tabase.ps1       statements in catch blocks.                                 






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

    Describe 'Script Analyzer Tests'  -Tag @('ScriptAnalyzer'){
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

    Describe "$Name Tests" -Tag ('Command'){
        InModuleScope 'dbatools' {
            Context " There should be some functional tests here" {
                It "Does a thing" {
                    $ActualValue | Should Be $ExpectedValue
                }
		    }# Context
        }#modulescope
    }#describe
    #>
    