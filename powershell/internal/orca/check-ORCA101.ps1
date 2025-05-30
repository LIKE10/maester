# Generated on 04/16/2025 21:38:23 by .\build\orca\Update-OrcaTests.ps1

using module ".\orcaClass.psm1"

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingEmptyCatchBlock', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSPossibleIncorrectComparisonWithNull', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()




class ORCA101 : ORCACheck
{
    <#
    
        CONSTRUCTOR with Check Header Data
    
    #>

    ORCA101()
    {
        $this.Control="ORCA-101"
        $this.Area="Anti-Spam Policies"
        $this.Name="Mark Bulk as Spam"
        $this.PassText="Bulk is marked as spam"
        $this.FailRecommendation="Set the anti-spam policy to mark bulk mail as spam"
        $this.Importance="The differentiation between bulk and spam can sometimes be subjective. The bulk complaint level is based on the number of complaints from the sender. Marking bulk as spam can decrease the amount of perceived spam received. This setting is only available in PowerShell."
        $this.ExpandResults=$True
        $this.ItemName="Anti-Spam Policy"
        $this.DataType="Mark as Spam Bulk Mail Setting (MarkAsSpamBulkMail)"
        $this.ChiValue = [ORCACHI]::Low
        $this.Links= @{
            "Set-HostedContentFilterPolicy"="https://aka.ms/orca-antispam-docs-9"
            "Recommended settings for EOP and Microsoft Defender for Office 365 security"="https://aka.ms/orca-atpp-docs-6"
        }
    }

    <#
    
        RESULTS
    
    #>

    GetResults($Config)
    {
        #$CountOfPolicies = ($Config["HostedContentFilterPolicy"]).Count
        $CountOfPolicies = ($global:HostedContentPolicyStatus| Where-Object {$_.IsEnabled -eq $True}).Count
        ForEach($Policy in $Config["HostedContentFilterPolicy"])
        {

            $MarkAsSpamBulkMail = $($Policy.MarkAsSpamBulkMail)

            # Check objects
            $ConfigObject = [ORCACheckConfig]::new()
            $ConfigObject.ConfigItem=$Config["PolicyStates"][$Policy.Guid.ToString()].Name
            $ConfigObject.ConfigData=$MarkAsSpamBulkMail
            $ConfigObject.ConfigDisabled = $Config["PolicyStates"][$Policy.Guid.ToString()].Disabled
            $ConfigObject.ConfigWontApply = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies
            $ConfigObject.ConfigReadonly=$Policy.IsPreset
            $ConfigObject.ConfigPolicyGuid=$Policy.Guid.ToString()

            If($MarkAsSpamBulkMail -eq "On")
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,[ORCAResult]::Pass)
            }
            Else 
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,[ORCAResult]::Fail)               
            }

            # Add config to check
            $this.AddConfig($ConfigObject)

        }    

    }

}
