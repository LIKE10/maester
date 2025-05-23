# Generated on 04/16/2025 21:38:23 by .\build\orca\Update-OrcaTests.ps1

using module ".\orcaClass.psm1"

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingEmptyCatchBlock', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSPossibleIncorrectComparisonWithNull', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()




class ORCA103 : ORCACheck
{
    <#
    
        CONSTRUCTOR with Check Header Data
    
    #>

    ORCA103()
    {
        $this.Control="ORCA-103"
        $this.Area="Anti-Spam Policies"
        $this.Name="Outbound spam filter policy settings"
        $this.PassText="Outbound spam filter policy settings configured"
        $this.FailRecommendation="Set RecipientLimitExternalPerHour to 500, RecipientLimitInternalPerHour to 1000, and ActionWhenThresholdReached to block."
        $this.Importance="Configure the maximum number of recipients that a user can send to, per hour for internal (RecipientLimitInternalPerHour) and external recipients (RecipientLimitExternalPerHour) and maximum number per day for outbound email. It is common, after an account compromise incident, for an attacker to use the account to generate spam and phish. Configuring the recommended values can reduce the impact, but also allows you to receive notifications when these thresholds have been reached."
        $this.ExpandResults=$True
        $this.CheckType=[CheckType]::ObjectPropertyValue
        $this.ObjectType="Outbound Spam Policy"
        $this.ItemName="Setting"
        $this.DataType="Current Value"
        $this.ChiValue=[ORCACHI]::Low
        $this.Links= @{
                "Microsoft 365 Defender Portal - Anti-spam settings"="https://security.microsoft.com/antispam"
                "Recommended settings for EOP and Microsoft Defender for Office 365 security"="https://aka.ms/orca-atpp-docs-6"
            }
    }

    <#
    
        RESULTS
    
    #>

    GetResults($Config)
    {

        ForEach($Policy in $Config["HostedOutboundSpamFilterPolicy"])
        {

            <#
            
                RecipientLimitExternalPerHour
            
            #>

            $policyname = $Config["PolicyStates"][$Policy.Guid.ToString()].Name
            $RecipientLimitExternalPerHour = $($Policy.RecipientLimitExternalPerHour)
            $RecipientLimitInternalPerHour = $($Policy.RecipientLimitInternalPerHour)
            $RecipientLimitPerDay = $($Policy.RecipientLimitPerDay)
            $ActionWhenThresholdReached = $($Policy.ActionWhenThresholdReached)

            $ConfigObject = [ORCACheckConfig]::new()
            $ConfigObject.Object=$policyname
            $ConfigObject.ConfigItem="RecipientLimitExternalPerHour"
            $ConfigObject.ConfigData=$RecipientLimitExternalPerHour
            $ConfigObject.ConfigDisabled = $Config["PolicyStates"][$Policy.Guid.ToString()].Disabled
            $ConfigObject.ConfigWontApply = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies
            $ConfigObject.ConfigReadonly=$Policy.IsPreset
            $ConfigObject.ConfigPolicyGuid=$Policy.Guid.ToString()

            # Recipient per hour limit for standard is 500
            If($RecipientLimitExternalPerHour -eq 500)
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Pass")
            }
            Else
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")               
            }

            # Recipient per hour limit for strict is 400
            If($RecipientLimitExternalPerHour -eq 400)
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Strict,"Pass")
            }
            Else
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Strict,"Fail")              
            }

            # Add config to check
            $this.AddConfig($ConfigObject)

            <#
            
                RecipientLimitInternalPerHour
            
            #>
            
            $ConfigObject = [ORCACheckConfig]::new()
            $ConfigObject.Object=$policyname
            $ConfigObject.ConfigItem="RecipientLimitInternalPerHour"
            $ConfigObject.ConfigData=$($RecipientLimitInternalPerHour)
            $ConfigObject.ConfigDisabled = $Config["PolicyStates"][$Policy.Guid.ToString()].Disabled
            $ConfigObject.ConfigWontApply = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies
            $ConfigObject.ConfigReadonly=$Policy.IsPreset

            If($RecipientLimitInternalPerHour -eq 1000)
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Pass")
            }
            Else
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")               
            }

            If($RecipientLimitInternalPerHour -eq 800)
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Strict,"Pass")
            }
            Else
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Strict,"Fail")              
            }

            # Add config to check
            $this.AddConfig($ConfigObject)

            <#
            
                RecipientLimitPerDay
            
            #>
            
            $ConfigObject = [ORCACheckConfig]::new()
            $ConfigObject.Object=$policyname
            $ConfigObject.ConfigItem="RecipientLimitPerDay"
            $ConfigObject.ConfigData=$($RecipientLimitPerDay)
            $ConfigObject.ConfigDisabled = $Config["PolicyStates"][$Policy.Guid.ToString()].Disabled
            $ConfigObject.ConfigWontApply = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies
            $ConfigObject.ConfigReadonly=$Policy.IsPreset

            If($RecipientLimitPerDay -eq 1000)
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Pass")
            }
            Else
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")               
            }

            If($RecipientLimitPerDay -eq 800)
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Strict,"Pass")
            }
            Else
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Strict,"Fail")              
            }

            # Add config to check
            $this.AddConfig($ConfigObject)

            $ConfigObject = [ORCACheckConfig]::new()
            $ConfigObject.Object=$policyname
            $ConfigObject.ConfigItem="ActionWhenThresholdReached"
            $ConfigObject.ConfigData=$($ActionWhenThresholdReached)
            $ConfigObject.ConfigDisabled = $Config["PolicyStates"][$Policy.Guid.ToString()].Disabled
            $ConfigObject.ConfigWontApply = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies
            $ConfigObject.ConfigReadonly=$Policy.IsPreset

            If($ActionWhenThresholdReached -like "BlockUser")
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Pass")
            }
            Else
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")               
            }
            
            # Add config to check
            $this.AddConfig($ConfigObject)

        }
    }

}
