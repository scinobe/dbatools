<#

Commented out someone needs to look at 





RuleName                            Severity     FileName   Line  Message                                                     
--------                            --------     --------   ----  -------                                                     
PSShouldProcess                     Warning      Set-DbaPow 71    'Set-DbaPowerPlan' calls ShouldProcess/ShouldContinue but   
                                                 erPlan.ps1       does not have the ShouldProcess attribute.                  
PSUseShouldProcessForStateChangingF Warning      Set-DbaPow 71    Function ?Set-DbaPowerPlan? has verb that could change      
unctions                                         erPlan.ps1       system state. Therefore, the function has to support        
                                                                  'ShouldProcess'.                                            
PSAvoidUsingWMICmdlet               Warning      Set-DbaPow 89    File 'Set-DbaPowerPlan.ps1' uses WMI cmdlet. For PowerShell 
                                                 erPlan.ps1       3.0 and above, use CIM cmdlet which perform the same tasks  
                                                                  as the WMI cmdlets. The CIM cmdlets comply with             
                                                                  WS-Management (WSMan) standards and with the Common         
                                                                  Information Model (CIM) standard, which enables the cmdlets 
                                                                  to use the same techniques to manage Windows computers and  
                                                                  those running other operating systems.                      
PSAvoidUsingWMICmdlet               Warning      Set-DbaPow 118   File 'Set-DbaPowerPlan.ps1' uses WMI cmdlet. For PowerShell 
                                                 erPlan.ps1       3.0 and above, use CIM cmdlet which perform the same tasks  
                                                                  as the WMI cmdlets. The CIM cmdlets comply with             
                                                                  WS-Management (WSMan) standards and with the Common         
                                                                  Information Model (CIM) standard, which enables the cmdlets 
                                                                  to use the same techniques to manage Windows computers and  
                                                                  those running other operating systems.                      
PSUseOutputTypeCorrectly            Information  Set-DbaPow 191   The cmdlet 'Set-DbaPowerPlan' returns an object of type     
                                                 erPlan.ps1       'System.Collections.ArrayList' but this type is not         
                                                                  declared in the OutputType attribute.                       
PSPossibleIncorrectComparisonWithNu Warning      Set-DbaPow 98    $null should be on the left side of equality comparisons.   
ll                                               erPlan.ps1                                                                   
PSPossibleIncorrectComparisonWithNu Warning      Set-DbaPow 98    $null should be on the left side of equality comparisons.   
ll                                               erPlan.ps1                                                                   







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
Get-ChildItem "$Modulebase\internal\" |ForEach-Object {. $_.fullname}

    Describe "$Name Tests" -Tag @('Command'){
        InModuleScope 'dbatools' {
            Context " There should be some functional tests here" {
                It "Does a thing" {
                    $ActualValue | Should Be $ExpectedValue
                }
		    }# Context
        }#modulescope
    }#describe
    #>
    