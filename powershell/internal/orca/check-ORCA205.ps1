# Generated on 04/16/2025 21:38:23 by .\build\orca\Update-OrcaTests.ps1

using module ".\orcaClass.psm1"

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingEmptyCatchBlock', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSPossibleIncorrectComparisonWithNull', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()


<#

205 Checks to determine if Common attachment type filter is enbaled in EOP Anti-malware policy.

#>



class ORCA205 : ORCACheck
{
    <#
    
        CONSTRUCTOR with Check Header Data
    
    #>

    ORCA205()
    {
        $this.Control=205
        $this.Area="Malware Filter Policy"
        $this.Name="Common Attachment Type Filter"
        $this.PassText="Common attachment type filter is enabled"
        $this.FailRecommendation="Enable common attachment type filter"
        $this.Importance="The common attachment type filter can block file types that commonly contain malware, including in internal emails."
        $this.ExpandResults=$True
        $this.CheckType=[CheckType]::ObjectPropertyValue
        $this.ObjectType="Policy"
        $this.ItemName="Setting"
        $this.DataType="Missing Default File Type"
        $this.ChiValue=[ORCACHI]::Low
        $this.Links= @{
            "Microsoft 365 Defender Portal - Anti-malware"="https://security.microsoft.com/antimalwarev2"
            "Configure anti-malware policies"="https://aka.ms/orca-mfp-docs-1"
            "Recommended settings for EOP and Microsoft Defender for Office 365"="https://aka.ms/orca-atpp-docs-6"
        }
    }

    <#
    
        RESULTS
    
    #>

    GetResults($Config)
    {

        $DefaultFileFormats = @("ace","ani", "apk", "app","appx", "arj", "bat", "cab", "cmd", "com", "deb", "dex", "dll", "docm", "elf", "exe", "hta", "img", "iso", "jar", "jnlp", "kext", "lha", "lib", "library", "lnk", "lzh", "macho", "msc", "msi", "msix", "msp", "mst", "pif", "ppa", "ppam", "reg", "rev", "scf", "scr", "sct", "sys", "uif", "vb", "vbe", "vbs", "vxd", "wsc", "wsf", "wsh", "xll", "xz", "z")
      
        ForEach($Policy in $Config["MalwareFilterPolicy"])
        {
            $IsPolicyDisabled = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies
            $EnableFileFilter = $($Policy.EnableFileFilter)
            $policyname = $Config["PolicyStates"][$Policy.Guid.ToString()].Name

            # Fail if EnableFileFilter is not set to true or FileTypes is empty in the policy

            If($EnableFileFilter -eq $false) 
            {
                $ConfigObject = [ORCACheckConfig]::new()
                $ConfigObject.Object=$policyname
                $ConfigObject.ConfigItem="FileFilter"
                $ConfigObject.ConfigDisabled = $Config["PolicyStates"][$Policy.Guid.ToString()].Disabled
                $ConfigObject.ConfigWontApply = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies
                $ConfigObject.ConfigReadonly = $Policy.IsPreset
                $ConfigObject.ConfigPolicyGuid=$Policy.Guid.ToString()
                $ConfigObject.ConfigData=$("EnableFileFilter Disabled")
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")
                $this.AddConfig($ConfigObject)
            }
            Else
            {
                # Enabled, check file types

                $MissingFiles = @();

                # Validate each file format
                foreach($DefaultFileFormat in $DefaultFileFormats)
                {
                    if($Policy.FileTypes -notcontains $DefaultFileFormat)
                    {
                        $MissingFiles += $DefaultFileFormat
                    }
                }

                if($MissingFiles.Count -eq 0)
                {
                    $ConfigObject = [ORCACheckConfig]::new()
                    $ConfigObject.Object=$policyname
                    $ConfigObject.ConfigItem="FileFilter"
                    $ConfigObject.ConfigDisabled = $Config["PolicyStates"][$Policy.Guid.ToString()].Disabled
                    $ConfigObject.ConfigWontApply = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies
                    $ConfigObject.ConfigReadonly = $Policy.IsPreset
                    $ConfigObject.ConfigPolicyGuid=$Policy.Guid.ToString()
                    $ConfigObject.ConfigData=$("Enabled with all default file types")
                    $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Pass")
                    $this.AddConfig($ConfigObject)
                } else {
                    $ConfigObject = [ORCACheckConfig]::new()
                    $ConfigObject.Object=$policyname
                    $ConfigObject.ConfigItem="FileFilter"
                    $ConfigObject.ConfigDisabled = $Config["PolicyStates"][$Policy.Guid.ToString()].Disabled
                    $ConfigObject.ConfigWontApply = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies
                    $ConfigObject.ConfigReadonly = $Policy.IsPreset
                    $ConfigObject.ConfigPolicyGuid=$Policy.Guid.ToString()
                    $ConfigObject.ConfigData=$($MissingFiles -join ",")
                    $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")
                    $this.AddConfig($ConfigObject)
                }
                
            }

            
        }
        
    }

}
