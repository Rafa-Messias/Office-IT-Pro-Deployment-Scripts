﻿Function Run-365OfficeUpdateSetup {
Param
    (
        [Parameter()]
	    [string]$FolderName = "Packages",

	    [Parameter()]
	    [String]$FolderPath = "D:\",
        
        [Parameter()]
	    [String]$SavePath = "D:\Packages\en-us",

        [Parameter()]
	    [String]$UNCSourcePath = "\\SCCM-CM\Packages\en-us",

        [Parameter()]
	    [String]$SiteServer = "SCCM-CM",

        [Parameter()]
	    [String]$Description = "Deploys office 365 latest updates",

        [Parameter()]
	    [String]$DistributionPoint = "SCCM-CM.CONTOSO.COM",

        [Parameter()]
	    [String]$Branch = "FRCB1602",

        [Parameter()]
	    [String]$Bitness = "64",

        [Parameter()]
	    [String]$DeploymentName = "O365 Clients - English",

        [Parameter()]
	    [String]$SiteCode = "S01",

        [Parameter()]
	    [String]$CollectionName = "Office 2016 Clients"

        
    )


# Create a shared folder and set the permission




 #Create the device collection
 Create-DeviceCollection -CollectionName $CollectionName -SiteCode $SiteCode
 


 #Deploy package
 Deploy-SoftwareUpdates -Branch $Branch -CollectionName $CollectionName -Bitness $Bitness
 


 #Check Status
 Check-DeploymentStatus -Branch $Branch -Bitness $Bitness


 }

Function CreateFolder{
<# 
.SYNOPSIS 
    Creates a folder and sets permission
.DESCRIPTION 
    Creates a folder, sets proper permissions, and shares the folder
.PARAMETER FolderName
    Specify the name of the folder to be created
.PARAMETER FolderPath
    Specify the path that the folder will be created in
.EXAMPLE 
    CreateFolder -FolderName Downloaded-Files -FolderPath \\Server1\Updates
    Will create a folder named "Downloaded-Files" in the directory "\\Server1\Updates" with proper permissions and sharing
#> 
Param
    (
        [Parameter()]
	    [string]$FolderName = "Packages",

	    [Parameter()]
	    [String]$FolderPath = "D:\"
    )
    $ShareName = "Packages"

}


Function Download-SoftwareUpdateFiles{
<# 
.SYNOPSIS 
    Downloads files for Software Update
.DESCRIPTION 
    Downloads files for Software Update
.PARAMETER Branch
    Specify the name of the Office 365 branch update to be download, ie "FRCB1601"
.PARAMETER SiteCode
    Specify the 3 character server code that the collection is being added to
.PARAMETER Path
    Specify the path for the files to be downloaded to
.Parameter DeploymentPackageName
    Specify the name of the deployment package the update files will be added to
.EXAMPLE 
    Download-SoftwareUpdateFiles -Branch -SiteCode S01 -Path \\Server1\Updates\en-us
    Downloads files for the Office 365 update "FRCB1601" on the Server "S01" to the path \\Server1\Updates\en-us
#> 
Param
    (
        [Parameter()]
	    [string]$Branch,

	    [Parameter()]
	    [String]$Path = $NULL,

	    [Parameter()]
	    [String]$Bitness,
        
        [Parameter()]
	    [String]$SiteCode = 'S01',

        [Parameter()]
	    [String]$SiteServer,

        [Parameter()]
        [String]$DeploymentPackageName
    )
$hash = @{
        $PSD = Get-PSDrive -PSProvider CMSite
        CD "$($PSD):"


        $bitness = $Bitness

        $officeupdatename = $sun.LocalizedDisplayName

    $UpdateContentIDs += [UInt32]$ContentIDManger
    $UpdateContentSourcePaths += [String]$Path.Replace('/','\').Replace('D:\','\\'+$SiteServer+'\')

    

    
    Add-Content -SiteCode $SiteCode -SiteServer $SiteServer -ContentIDs $UpdateContentIDs -ContentSourcePath $UpdateContentSourcePaths -DeploymentPackageName $DeploymentPackageName
}



 Function Setup-NewSoftwareUpdateDeploymentPackage {
 <# 
.SYNOPSIS 
    Create a Deployment Package in Configuration Manager 2012. 
.DESCRIPTION 
    Use this script if you need to create a Deployment Package in Configuration Manager 2012.  
.PARAMETER SiteServer 
    Primary Site server name with SMS Provider installed 
.PARAMETER Name 
    Name of the Deployment Package 
.PARAMETER Description 
    Description of the Deployment Package 
.PARAMETER SourcePath 
    UNC path to the source location where downloaded patches will be stored 
.EXAMPLE 
    .\New-CMDeploymentPackage.ps1 -SiteServer CM01 -Name "Critical and Security Patches" -SourcePath "\\CAS01\Source$\SUM\ADRs\CS" -Description "Contains Critical and Security patches" 
    Create a Deployment Package called 'Critical and Security Patches', specifying a source path and description on a Primary Site server called 'CM01': 
#> 
[CmdletBinding(SupportsShouldProcess=$true)] 
param( 
    [parameter(Mandatory=$true,HelpMessage="Site server where the SMS Provider is installed")]     
    [string]$SiteServer, 
    [parameter(Mandatory=$true,HelpMessage="Name of the Deployment Package")] 
    [string]$Name, 
    [parameter(Mandatory=$false,HelpMessage="Description of the Deployment Package")] 
    [string]$Description, 
    [parameter(Mandatory=$true,HelpMessage="UNC path to the source location where downloaded patches will be stored")] 
    [string]$SourcePath ,
    [parameter(HelpMessage="Where the distribution point is")] 
    [string]$DistributionPoint
) 
Begin { 
    # Determine SiteCode from WMI 
    try { 
        Write-Verbose "Determining SiteCode for Site Server: '$($SiteServer)'" 
        $SiteCodeObjects = Get-WmiObject -Namespace "root\SMS" -Class SMS_ProviderLocation -ComputerName $SiteServer -ErrorAction Stop 
        foreach ($SiteCodeObject in $SiteCodeObjects) { 
            if ($SiteCodeObject.ProviderForLocalSite -eq $true) { 
                $SiteCode = $SiteCodeObject.SiteCode 
                Write-Debug "SiteCode: $($SiteCode)" 
            } 
        } 
    } 
    catch [Exception] { 
        Throw "Unable to determine SiteCode" 
    } 
} 
Process { 
    function Get-DuplicateInfo { 
        $IsDuplicatePkg = $false 
        $EnumDeploymentPackages = Get-CimInstance -CimSession $CimSession -Namespace "root\SMS\site_$($SiteCode)" -ClassName SMS_SoftwareUpdatesPackage -ErrorAction SilentlyContinue -Verbose:$false 
        foreach ($Pkgs in $EnumDeploymentPackages) { 
            if ($Pkgs.PkgSourcePath -like "$($SourcePath)") { 
                $IsDuplicatePkg = $true 
            } 
        } 
        return $IsDuplicatePkg 
    } 
    function Remove-CimSessions { 
        foreach ($Session in $(Get-CimSession -ComputerName $SiteServer -ErrorAction SilentlyContinue -Verbose:$false)) { 
            if ($Session.TestConnection()) { 
                Write-Verbose -Message "Closing CimSession against '$($Session.ComputerName)'" 
                Remove-CimSession -CimSession $Session -ErrorAction SilentlyContinue -Verbose:$false 
            } 
        } 
    } 
    try { 
        Write-Verbose -Message "Establishing a Cim session against '$($SiteServer)'" 
        $CimSession = New-CimSession -ComputerName $SiteServer -Verbose:$false 
        # Check if there's an existing Deployment Package with the same name 
        if ((Get-CimInstance -CimSession $CimSession -Namespace "root\SMS\site_$($SiteCode)" -ClassName SMS_SoftwareUpdatesPackage -Filter "Name like '$($Name)'" -ErrorAction SilentlyContinue -Verbose:$false | Measure-Object).Count -eq 0) { 
            # Check if there's an existing Deployment Package with the same source path 
            if ((Get-DuplicateInfo) -eq $false) { 
                $CimProperties = @{ 
                    "Name" = "$($Name)" 
                    "PkgSourceFlag" = [UInt32]2 
                    "PkgSourcePath" = "$($SourcePath)" 
                    "SourceVersion" = [UInt32]2
                } 
                if ($PSBoundParameters["Description"]) { 
                    $CimProperties.Add("Description",$Description) 
                } 
                $CMDeploymentPackage = New-CimInstance -CimSession $CimSession -Namespace "root\SMS\site_$($SiteCode)" -ClassName SMS_SoftwareUpdatesPackage -Property $CimProperties -Verbose:$false -ErrorAction Stop
                $PSObject = [PSCustomObject]@{ 
                    "Name" = $CMDeploymentPackage.Name 
                    "Description" = $CMDeploymentPackage.Description 
                    "PackageID" = $CMDeploymentPackage.PackageID 
                    "PkgSourcePath" = $CMDeploymentPackage.PkgSourcePath 
                    "SourceVersion" = $CMDeploymentPackage.SourceVersion
                    #"DistributionPoint" = $CMDeploymentPackage.DistributionPoint
                    
                } 
                             
                Write-Output $PSObject 
                
            } 
            else { 
                Write-Warning -Message "A Deployment Package with the specified source path already exists" 
            } 
        } 
        else { 
            Write-Warning -Message "A Deployment Package with the name '$($Name)' already exists" 
        } 
    } 
    catch [Exception] { 
        Remove-CimSessions 
        Throw $_.Exception.Message 
    }
    Add-DistributionPoint -SiteCode $SiteCode -DistributionPoint $DistributionPoint -DeploymentPackageName $Name -SiteServer $SiteServer
} 
End { 
    # Remove active Cim session established to $SiteServer 
    Remove-CimSessions 
}
 }


 Function Create-DeviceCollection{
 <# 
.SYNOPSIS 
    Creates a device collection
.DESCRIPTION 
    Creates a device collection
.PARAMETER CollectionName
    Specify the name of the device collection that is being created
.PARAMETER SiteCode
    Specify the 3 character server code that the collection is being added to
.EXAMPLE 
    CreateCollection -CollectionName "Office 365 updates" -SiteCode S01
    Creates a collection named "Office 365 updates" on the server "S01"
#>  
 param( 
        [Parameter()]
	    [string]$CollectionName,
        [Parameter()]
	    [string]$SiteCode
)
        Import-Module ((Split-Path $env:SMS_ADMIN_UI_PATH)+"\ConfigurationManager.psd1")
        $PSD = Get-PSDrive -PSProvider CMSite
        CD "$($PSD):"

        $CMCollection = ([WMIClass]”root\sms\site_$($SiteCode):SMS_Collection”).CreateInstance()

        $CMCollection.Name = $CollectionName        
        $CMCollection.LimitToCollectionID = “SMS00001”
        $CMCollection.RefreshType = 2
        $CMCollection.Put()

        $CMRule = ([WMIClass]”root\sms\site_S01:SMS_CollectionRuleQuery”).CreateInstance()

        $CMRule.QueryExpression=”Select SMS_R_System.ResourceId, SMS_R_System.ResourceType, SMS_R_System.Name, SMS_R_System.SMSUniqueIdentifier, SMS_R_System.ResourceDomainORWorkgroup, SMS_R_System.Client from  SMS_R_System inner join SMS_G_System_ADD_REMOVE_PROGRAMS_64 on SMS_G_System_ADD_REMOVE_PROGRAMS_64.ResourceID = SMS_R_System.ResourceId inner join SMS_G_System_ADD_REMOVE_PROGRAMS on SMS_G_System_ADD_REMOVE_PROGRAMS.ResourceId = SMS_R_System.ResourceId where SMS_G_System_ADD_REMOVE_PROGRAMS_64.DisplayName like `"Office 16%`" or SMS_G_System_ADD_REMOVE_PROGRAMS.DisplayName like `"Office 16%`"”

        $CMRule.RuleName = “Office 2016 Query”

        $CMCollection.AddMembershipRule($CMRule)

        $CMSchedule = ([WMIClass]"root\sms\site_S01:SMS_ST_RecurInterval").CreateInstance()

        $CMSchedule.DaySpan = “1”

        $CMSchedule.StartTime = [System.Management.ManagementDateTimeConverter]::ToDmtfDateTime((Get-Date).ToString())

        $CMCollection.RefreshSchedule=$CMSchedule

        $CMCollection.RefreshType = 6

        $CMCollection.Put()
 
 }


 Function Deploy-SoftwareUpdates{
 <# 
.SYNOPSIS 
    Deploy Software update
.DESCRIPTION 
    Deploys a WSUS software update
.PARAMETER Branch
    Specify the branch ID for the update looks like "FRCB1601"
.PARAMETER CollectionName
    Specify the name of the device collection the update should be deployed to
.PARAMETER Bitness
    Specify 32 vs 64 bit
.EXAMPLE 
    DeploySoftwareUpdates -Branch FRCB1601 -Bitness 64 -CollectionName "Office 365 updates"
    Deploys the 64 bit version of the software update "FRCB1601" to the collection "Office 365 updates"
#>  
 Param
    (
        [Parameter()]
	    [string]$Branch,

	    [Parameter()]
	    [String]$CollectionName,

	    [Parameter()]
	    [String]$Bitness
    )
    Import-Module ((Split-Path $env:SMS_ADMIN_UI_PATH)+"\ConfigurationManager.psd1")
        $PSD = Get-PSDrive -PSProvider CMSite
        CD "$($PSD):"


        $bitness = $Bitness

        $officeupdatename = $sun.LocalizedDisplayName

        
        Start-CMSoftwareUpdateDeployment -SoftwareUpdateName $officeupdatename -CollectionName $CollectionName
        
 }



 Function Check-DeploymentStatus{
  <# 
.SYNOPSIS 
    Checks status of a Update that was deployed
.DESCRIPTION 
    Checks status of a Update that was deployed
.PARAMETER Branch
    Specify the branch ID for the update looks like "FRCB1601"
.PARAMETER Bitness
    Specify 32 vs 64 bit
.EXAMPLE 
    CheckDeploymentStatus -Branch FRCB1601 -Bitness 64
    Checks the status of the 64 bit version of the Office 365 update "FRCB1601"
#>  
  Param
    (
        [Parameter()]
	    [string]$Branch,

	    [Parameter()]
	    [String]$Bitness
    )

    Import-Module ((Split-Path $env:SMS_ADMIN_UI_PATH)+"\ConfigurationManager.psd1")
        $PSD = Get-PSDrive -PSProvider CMSite
        CD "$($PSD):"


        $bitness = $Bitness

        $officeupdatename = $sun.LocalizedDisplayName

        Get-CMDeployment -SoftwareName $officeupdatename

 }

 Function Add-Content {
  Param
    (
        [Parameter()]
	    [string]$SiteCode,

	    [Parameter()]
	    [String]$DistributionPoint,

        [Parameter()]
	    [String]$DeploymentPackageName,

        [Parameter()]
	    [String]$SiteServer,
        
        [Parameter()]
	    [array]$ContentIDs,

        [Parameter()]
	    [array]$ContentSourcePath,

        [Parameter()]
	    [array]$DownloadPath

    )
                   
                    $PackageID = (Get-WmiObject -Namespace root/SMS/site_$($SiteCode) -ComputerName $SiteServer -Query "SELECT * FROM SMS_SoftwareUpdatesPackage WHERE Name='$DeploymentPackageName'").PackageID
                    $PackageID

                    $DeployPackage = (Get-WmiObject -Namespace root/SMS/site_$($SiteCode) -ComputerName $SiteServer -Query "SELECT * FROM SMS_SoftwareUpdatesPackage WHERE Name='$DeploymentPackageName'")

                    $DeployPackage.AddUpdateContent($ContentIDs,$ContentSourcePath,$true)
                    
                    
                    
 }


 Function Add-DistributionPoint{
   Param
    (
        [Parameter()]
	    [string]$SiteCode,

	    [Parameter()]
	    [String]$DistributionPoint,

        [Parameter()]
	    [String]$DeploymentPackageName,

        [Parameter()]
	    [String]$SiteServer

    )
        Import-Module ((Split-Path $env:SMS_ADMIN_UI_PATH)+"\ConfigurationManager.psd1")
        $PSD = Get-PSDrive -PSProvider CMSite
        CD "$($PSD):"
        
                $PackageID = (Get-WmiObject -Namespace root/SMS/site_$($SiteCode) -ComputerName $SiteServer -Query "SELECT * FROM SMS_SoftwareUpdatesPackage WHERE Name='$DeploymentPackageName'").PackageID
            
                #echo "This is a Package" 
                start-CMContentDistribution -DeploymentPackageId  $PackageID -DistributionPointName $DistributionPoint
             
                
            


 }