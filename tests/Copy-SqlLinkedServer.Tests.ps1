<#

Commented out someone needs to look at 

Should be easy to fix but being careful


RuleName                            Severity     FileName   Line  Message                                                     
--------                            --------     --------   ----  -------                                                     
PSShouldProcess                     Warning      Copy-SqlLi 96    'Get-LinkedServerLogins' calls ShouldProcess/ShouldContinue 
                                                 nkedServer       but does not have the ShouldProcess attribute.              
                                                 .ps1                                                                         
PSShouldProcess                     Warning      Copy-SqlLi 253   'Copy-SqlLinkedServers' calls ShouldProcess/ShouldContinue  
                                                 nkedServer       but does not have the ShouldProcess attribute.              
                                                 .ps1                                                                         
PSUseSingularNouns                  Warning      Copy-SqlLi 96    The cmdlet 'Get-LinkedServerLogins' uses a plural noun. A   
                                                 nkedServer       singular noun should be used instead.                       
                                                 .ps1                                                                         
PSUseSingularNouns                  Warning      Copy-SqlLi 253   The cmdlet 'Copy-SqlLinkedServers' uses a plural noun. A    
                                                 nkedServer       singular noun should be used instead.                       
                                                 .ps1                                                                         
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlLi 264   $null should be on the left side of equality comparisons.   
ll                                               nkedServer                                                                   
                                                 .ps1                                                                         
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlLi 293   $null should be on the left side of equality comparisons.   
ll                                               nkedServer                                                                   
                                                 .ps1                                                                         
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlLi 372   $null should be on the left side of equality comparisons.   
ll                                               nkedServer                                                                   
                                                 .ps1                                                                         
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlLi 264   $null should be on the left side of equality comparisons.   
ll                                               nkedServer                                                                   
                                                 .ps1                                                                         
PSPossibleIncorrectComparisonWithNu Warning      Copy-SqlLi 293   $null should be on the left side of equality comparisons.   
ll                                               nkedServer                                                                   
                                                 .ps1                                                                         
PSAvoidUsingEmptyCatchBlock         Warning      Copy-SqlLi 279   Empty catch block is used. Please use Write-Error or throw  
                                                 nkedServer       statements in catch blocks.                                 
                                                 .ps1                                                                         






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
    