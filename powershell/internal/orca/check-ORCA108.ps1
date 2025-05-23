# Generated on 04/16/2025 21:38:23 by .\build\orca\Update-OrcaTests.ps1

using module ".\orcaClass.psm1"

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingEmptyCatchBlock', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSPossibleIncorrectComparisonWithNull', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()




class ORCA108 : ORCACheck
{
    <#
    
        CONSTRUCTOR with Check Header Data
    
    #>

    ORCA108()
    {
        $this.Control="108"
        $this.Area="DKIM"
        $this.Name="Signing Configuration"
        $this.PassText="DKIM signing is set up for all your custom domains"
        $this.FailRecommendation="Set up DKIM signing to sign your emails"
        $this.Importance="DKIM signing can help protect the authenticity of your messages in transit and can assist with deliverability of your email messages."
        $this.ExpandResults=$True
        $this.ItemName="Domain"
        $this.DataType="Signing Setting"
        $this.ChiValue=[ORCACHI]::Low
        $this.Links= @{
            "Microsoft 365 Defender Portal - DKIM"="https://security.microsoft.com/authentication?viewid=DKIM"
            "Use DKIM to validate outbound email sent from your custom domain in Office 365"="https://aka.ms/orca-dkim-docs-1"
        }
    }

    <#
    
        RESULTS
    
    #>

    GetResults($Config)
    {
        # Check pre-requisites for DNS resolution
        If(!(Get-Command "Resolve-DnsName" -ErrorAction:SilentlyContinue))
        {
            # No Resolve-DnsName command
            ForEach($AcceptedDomain in $Config["AcceptedDomains"])
            {
                $ConfigObject = [ORCACheckConfig]::new()
                $ConfigObject.Object = $($AcceptedDomain.Name)
                $ConfigObject.SetResult([ORCAConfigLevel]::All,[ORCAResult]::Informational)
                $ConfigObject.ConfigItem = "Pre-requisites not installed"
                $ConfigObject.ConfigData = "Resolve-DnsName is not found on ORCA computer. Required for DNS checks."
                $this.AddConfig($ConfigObject)
            }

            $this.CheckFailed = $true
            $this.CheckFailureReason = "Resolve-DnsName is not found on ORCA computer and is required for DNS checks."
        }
        else 
        {
            # Check DKIM is enabled
        
            ForEach($AcceptedDomain in $Config["AcceptedDomains"]) 
            {
                $HasMailbox = $false
                
                try
                {
                    
                    If($AcceptedDomain.Name -notlike "*.onmicrosoft.com") 
                { 
                    $mailbox = Resolve-DnsName -Name $($AcceptedDomain.Name) -Type MX -ErrorAction:Stop
                    if($null -ne $mailbox -and $mailbox.Count -gt 0)
                        {
                            $HasMailbox = $true
                        }
                    }
                }
                Catch{}
                If($HasMailbox) 
                {
        
                    # Check objects
                    $ConfigObject = [ORCACheckConfig]::new()
                    $ConfigObject.ConfigItem=$($AcceptedDomain.Name)

                    # Get matching DKIM signing configuration
                    $DkimSigningConfig = $Config["DkimSigningConfig"] | Where-Object {$_.Name -eq $AcceptedDomain.Name}
        
                    If($DkimSigningConfig)
                    {
                        $ConfigObject.ConfigData=$($DkimSigningConfig.Enabled)

                        if($DkimSigningConfig.Enabled -eq $true)
                        {
                            $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Pass")
                        }
                        Else 
                        {
                            $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")
                        }
                    }
                    Else
                    {
                        $ConfigObject.ConfigData="No Configuration"
                        $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")
                    }

                    # Add config to check
                    $this.AddConfig($ConfigObject)
        
                }
        
            }         
        }

  

    }

}

