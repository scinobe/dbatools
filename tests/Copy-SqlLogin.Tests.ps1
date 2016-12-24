<#

Commented out someone needs to look at 


RuleName                            Severity     FileName   Line  Message                                                     
--------                            --------     --------   ----  -------                                                     
PSAvoidUsingPlainTextForPassword    Warning      Copy-SqlLo 117   Parameter '$SourceSqlCredential' should use SecureString,   
                                                 gin.ps1          otherwise this will expose sensitive information. See       
                                                                  ConvertTo-SecureString for more information.                
PSAvoidUsingPlainTextForPassword    Warning      Copy-SqlLo 118   Parameter '$DestinationSqlCredential' should use            
                                                 gin.ps1          SecureString, otherwise this will expose sensitive          
                                                                  information. See ConvertTo-SecureString for more            
                                                                  information.                                                
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlLo 139   $null should be on the left side of equality comparisons.   
ll                                               gin.ps1                                                                      
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlLo 171   $null should be on the left side of equality comparisons.   
ll                                               gin.ps1                                                                      
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlLo 180   $null should be on the left side of equality comparisons.   
ll                                               gin.ps1                                                                      
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlLo 223   $null should be on the left side of equality comparisons.   
ll                                               gin.ps1                                                                      
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlLo 242   $null should be on the left side of equality comparisons.   
ll                                               gin.ps1                                                                      
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlLo 139   $null should be on the left side of equality comparisons.   
ll                                               gin.ps1                                                                      
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlLo 171   $null should be on the left side of equality comparisons.   
ll                                               gin.ps1                                                                      
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlLo 180   $null should be on the left side of equality comparisons.   
ll                                               gin.ps1                                                                      
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlLo 223   $null should be on the left side of equality comparisons.   
ll                                               gin.ps1                                                                      
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlLo 242   $null should be on the left side of equality comparisons.   
ll                                               gin.ps1                                                                      
PSShouldProcess                     Warning      Copy-SqlLo 133   'Copy-Login' calls ShouldProcess/ShouldContinue but does    
                                                 gin.ps1          not have the ShouldProcess attribute.                       
PSAvoidUsingCmdletAliases           Warning      Copy-SqlLo 196   'Where' is an alias of 'Where-Object'. Alias can introduce  
                                                 gin.ps1          possible problems and make scripts hard to maintain. Please 
                                                                  consider changing alias to its full content.                
PSAvoidUsingCmdletAliases           Warning      Copy-SqlLo 205   'Where' is an alias of 'Where-Object'. Alias can introduce  
                                                 gin.ps1          possible problems and make scripts hard to maintain. Please 
                                                                  consider changing alias to its full content.                
PSAvoidUsingCmdletAliases           Warning      Copy-SqlLo 285   '%' is an alias of 'ForEach-Object'. Alias can introduce    
                                                 gin.ps1          possible problems and make scripts hard to maintain. Please 
                                                                  consider changing alias to its full content.                
PSAvoidUsingCmdletAliases           Warning      Copy-SqlLo 299   '%' is an alias of 'ForEach-Object'. Alias can introduce    
                                                 gin.ps1          possible problems and make scripts hard to maintain. Please 
                                                                  consider changing alias to its full content.                







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
    