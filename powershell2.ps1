# Lab 2 - PowerShell: Getting Started
# Module - Remoting with PowerShell

##### Notes and helpful Items - PLEASE READ #####
# USE ALT+Z to toggle Word Wrap on the remarks for easier reading in VS Code.

# Unless specified, Windows PowerShell and PowerShell 7 consoles need to be launced as Administrator using 'run as administrator' option by right-clicking icon.

# The lab environment has a single client (Client01) and a domain controller (DC01).

# The lab environment has no internet access so actions requiring the Internet will not be performed.

# All remote actions performed with Client as a target in the video course demos will be performed with DC01 instead.

# The commands below are not intended to be run in VS Code. They are intended to be type (preferred) or copy/pasted into the PowerShell console used in each demo.

# Read all of the remarks (hash-tagged green lines) as non-command steps and information is included throughout this script.

# Some demo commands have been modified to work within the lab environment. They will perform the same general tasks, but may have different references such as file directories. Also, any tasks requiring internet access will be skipped.

# Use of cls in code is to clear-host or clear the screen during demos. This can be skipped during your labs if desired.

### Challenge begins here###

# Demo: Requirements for Remoting on Windows PowerShell
    # Lab environment is configured for remote management
    # Commands below for reference to video only
    # Enable PSRemoting on clients
        # Enable-PSRemoting -force

    # Add groups to local security
        # Set-PSSessionConfiguration -Name Microsoft.PowerShell -ShowSecurityDescriptorUI

    # Firewall changes for WMI and Remote Service Management
        # Get-NetFirewallRule | Where-Object -Like "Windows Management Instrumentation*" | Set-NetFirewallRule -Enabled True -Verbose

        # Get-NetFirewallRule | Where-Object -Like "Remote Service Management" | Set-NetFirewallRule -Enabled True -Verbose
    
    # Run these commands in Windows PowerShell console as Administrator

    # Verify Access to DC01
        Get-Service -computername DC01

    # Enter remote PS Session
        Enter-PSSession -ComputerName DC01

    # Commands on remote system
        Get-Service
        Exit

# Demo: Working with Variables
    # Run these commands in Windows PowerShell console as Administrator
 
    # Viewing built-in environment variables in current console
        Get-ChildItem ENV: | more
        $env:Computername
    
    # Viewing PowerShell-specific variables
        Get-Variable | More

    # Viewing Version of PowerShell
        $PSVersionTable

    # Create variable for remote computer
        $ComputerName = “DC01”
        $ComputerName
        Write-Output "The name of the remote computer is $computername"
        Write-Output 'The name of the variable for the remote computername is $computername'

    # Store credentials in a variable
        # When prompted for credentials, use company\administrator and password from the ./LAB_FILES/companypw.txt file
        $credential = Get-Credential
        $credential

    # Run these commands in PowerShell 7 console as Administrator
    
    # Store credentials in PowerShell 7
        # For username and password use:
            # Username: Administrator
            # Password is located in ./companypw.txt in LAB_Files
        
        $credential
            # No response as variables are stored in scope of console
        $cred = Get-Credential
        $cred

    # Run these commands in Windows PowerShell console as Administrator
    
    # Use variable for Computername
        Get-Variable -Name c*
        Get-Service -ComputerName $computername

# Demo: Remoting with PowerShell
    # Run these commands in Windows PowerShell console as Administrator    
    
    #Using -Computername parameter for remote information
        $ComputerName = "DC01"
        Get-Service –computername $ComputerName
            # Note: All PowerShell cmdlets do not support -computername

    #Create a PowerShell session for a remote system
        # For username and password use:
            # Username: Administrator
            # Password is located in ./companypw.txt in LAB_Files

        Get-Command *-PSSession    
        $credential = Get-Credential
        New-PSSession -ComputerName $ComputerName -Credential $credential

    # Access PSSession
        # Session Name and Id values may be different. Enter value in console output. 
        
        #neter
        Enter-PSSession -Name WinRM1 # Enter value in console output. 
            # Commands on Remote System
            $env:Computername
            exit
        Get-PSSession

        # Enter PSSession with Id number
        Enter-PSSession -Id 1 # Enter value in console output. 
            # Commands on Remote System
            $env:Computername
            exit
        Remove-PSSession -id 1 #Enter value in console output. 
        Get-PSSession

# Demo: Remoting with Invoke-Command
    # Run these commands in Windows PowerShell console as Administrator 
    
    # Help with Invoke-Command
        help Invoke-command
        $ComputerName = "DC01"

    # Storing Credentials in a variable
        # For username and password use:
            # Username: Administrator
            # Password is located in ./companypw.txt in LAB_Files
        $credential = Get-Credential

    # Running get-service on remote system
        Invoke-command -ComputerName $ComputerName -Credential $credential -ScriptBlock { get-service -ComputerName $ComputerName }
            #Note: This fails since you cannot pass variables to remote systems
    
    # Passing variable to remote syste with Using:
        invoke-command -ComputerName $ComputerName -Credential $credential -ScriptBlock { get-service -ComputerName $using:ComputerName }

    # More Information on $using in help
        help about_Remote_Variables

    # Adding remote computer data to variable
        $data =  invoke-command -ComputerName $ComputerName -Credential $credential -ScriptBlock { get-service -ComputerName $using:ComputerName }
        $data | get-member

    # Run these commands in PowerShell 7 console as Administrator
    
    # Running Remote Commands
        # For username and password use:
            # Username: Administrator
            # Password is located in ./companypw.txt in LAB_Files
        invoke-command -ComputerName DC01 -cred (get-credential) -ScriptBlock { Get-ADUser -Identity felixb | format-list }

# Demo: Remoting with New-CimSession
    # Run these commands in Windows PowerShell console as Administrator 
    
    # Help with New-Cimsession
        # For username and password use:
            # Username: Administrator
            # Password is located in ./companypw.txt in LAB_Files
        $ComputerName = 'DC01'
        $credential = Get-Credential
        Help New-Cimsession

    # Storing CIM Session in variable
        $cimsession = New-CimSession -ComputerName $ComputerName -Credential $Credential
        $cimsession

    # View available CIM sessions
        Get-CimSession

    # Accessing DNS Client on remote system
        Help Get-DNSClientServerAddress
        Get-DNSClientServerAddress -CimSession $CimSession
  
  # Lab 2 - PowerShell: Getting Started
# Module - Building a User Inventory Script with PowerShell

##### Notes and helpful Items - PLEASE READ #####
# USE ALT+Z to toggle Word Wrap on the remarks for easier reading in VS Code.

# Unless specified, Windows PowerShell and PowerShell 7 consoles need to be launced as Administrator using 'run as administrator' option by right-clicking icon.

# The lab environment has a single client (Client01) and a domain controller (DC01).

# The lab environment has no internet access so actions requiring the Internet will not be performed.

# All remote actions performed with Client02 as a target in the video course demos will be performed with DC01 instead.

# The commands below are not intended to be run in VS Code. They are intended to be type (preferred) or copy/pasted into the PowerShell console used in each demo.

# Read all of the remarks (hash-tagged green lines) as non-command steps and information is included throughout this script.

# Some demo commands have been modified to work within the lab environment. They will perform the same general tasks, but may have different references such as file directories. Also, any tasks requiring internet access will be skipped.

# Use of cls in code is to clear-host or clear the screen during demos. This can be skipped during your labs if desired.

### Challenge begins here###

# Demo: Running Scripts in PowerShell
    # Run these commands in Windows PowerShell console as Administrator    
    # For this demo, open the follow scripts in <> and run each line of code along with video
        cd ./lab_files/inventory-scripts
        .\view-StoppedService.ps1
    # Error

    # View exectuion policy
    Get-ExecutionPolicy

    # Set exectuion policy to remote signed
    help Set-ExecutionPolicy -Parameter ExecutionPolicy
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
    
    # Run script
    # Enter DC01 as host name for script
    .\View-StoppedService.ps1 

# Demo: Using PowerShell ISE
    # Run this in Windows PowerShell ISE as Administrator
    # Right-Click Windows PowerShell ISE Icon from desktop
    # For this demo, follow along with the video to view and create scripts in the ISE

# Demo: Using Visual Studio Code
    # Note: The PowerShell VS Code extension are already installed in lab environment
    # Open View-StoppedServices.ps1 from LAB_Files folder on desktop
     code ./lab_files/inventory_scripts/View-StoppedServices.ps1  

# Demo: Working with Script Basics
    # Run these commands in Windows PowerShell and Visual Studio Code as Administrator
    
    # Run get-servicestatus.ps1
    ./lab_files/inventorty_scripts/get-servicestatus.ps1

    # Open script in VS Code to follow along with demo video
    code ./get-servicestatus.ps1

    # When running the script with a computername use DC01

# Demo: Walking Through Parameterized Script Steps
    # Run this lab in Visual Studio Code as Administrator
    # When asked to specify a computer name use DC01

    # For this demo, open the follow scripts in Visual Studio Code and follow along with video:
        code ./Get-ServiceExamplept1-base.ps1
        code ./Get-ServiceExamplept2-base.ps1
        code ./Get-ServiceExamplept3-base.ps1
        code ./Get-ServiceExamplept4-base.ps1
    
    # To review what each script looks like at each stage, open the following in Visual Studio:
        code ./Get-ServiceExamplept1.ps1
        code ./Get-ServiceExamplept2.ps1
        code ./Get-ServiceExamplept3.ps1
        code ./Get-ServiceExamplept4.ps1

# Demo: Building a Remote Information Gathering Script in PowerShell
    # 
    # For this demo, open the follow scripts in <> and run each line of code along with video
    code ./ScriptTasks.ps1
    code ./ScriptCommands.ps1
    code ./Get-Memory.ps1
    code ./BaseTemplate.ps1
    code ./Get-helpdesksupportdata.ps1

    # Start following along with the video on ScriptTasks.ps1 and ScriptCommands.ps1
    # This will walk you through each command.
    # Optionally, you can run each of the commands as is done in the video
    
    # When prompted for credentials, use Administrator and the password in ./LAB_FILES/companypw.txt

    # As all of the code is filled in for you in get-helpdesksupportdata.ps1, you can:
        # Review the code live along with the video
        # Copy over portions of the code into the basetemplate.ps1 script, and attempt running it
        # Make changes and see what happens
            # Try Changing line 62 to use mb instead of gb
            # Add additional examples to help files
            # Try changing the output of the script
            # Customize the credential window prompt on line 49
            #Use the video and the final script, get-helpdesksupportdata.ps1 as a guide and reference

#Additional ideas
$Computername = "mb-ps-ws01"
$MemoryInGB = ((((Get-CimInstance Win32_PhysicalMemory -ComputerName $Computername).Capacity|measure -Sum).Sum)/1mb)

#base template
<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>

#Script Name
#Creator
#Date
#Updated
#References, if any  

#Variables

#Parameters

#Enter Tasks Below as Remarks




<#
.Synopsis
   This is a script to gather information for Help Desk support calls

.DESCRIPTION
   This is a basic script designed to gather user and computer information for helpdeks support calls.
   Information gathered includes:
   DNS Name & IP Address
   DNS Server
   Name of Operating System
   Amount of Memory in target computer
   Amount of free space on disk
   Last Reboot of System


.EXAMPLE
   Get-Support
   PS C:\scripts\M5> .\get-helpdesksupportdata.ps1

    cmdlet get-helpdesksupportdata.ps1 at command pipeline position 1
    Supply values for the following parameters:
    ComputerName: $ComputerName
    Username: mbender

    In this example, the script is simply run and the parameters are input as they are mandatory.
.EXAMPLE
   Get-SupportInfo.ps1 -ComputerName Client1 -Username usrmvb

   This example has mandatory parameters input when calling script.

.EXAMPLE
   Get-SupportInfo.ps1 -ComputerName Client1 -Username usrmvb | out-file c:\UserInfo.txt

   This example sends the output of the script to a text file.
#>

#Get-Helpdesksupport.ps1
#Michael Bender
#Created: July 15, 2015
#Updated: March 11, 2019
#Updates: Cleaned up code, removed unused commands
#References

##Paramaters for Computername & UserName
Param (
[Parameter(Mandatory=$true)][string]$ComputerName
)
#Variables
$Credential = Get-Credential
$CimSession = New-CimSession -computername $ComputerName -Credential $Credential
$Analyst = $Credential.UserName
#Commands

#OS Description
   $OS= (Get-CimInstance Win32_OperatingSystem -ComputerName $ComputerName).caption

#Disk Freespace on OS Drive 
   $drive = Get-CimInstance -class Win32_logicaldisk | Where-Object DeviceID -EQ 'C:'
   $Freespace = (($drive.Freespace)/1gb)

#Amount of System Memory
   $MemoryInGB = ((((Get-CimInstance Win32_PhysicalMemory -ComputerName $Computername).Capacity|measure -Sum).Sum)/1gb)

#Last Reboot of System
   $LastReboot = (Get-CIMInstance -Class Win32_OperatingSystem –ComputerName $ComputerName).LastBootUpTime      

#IP Address & DNS Name
   $DNS = Resolve-DnsName -Name $ComputerName | Where-Object Type -eq "A" 
   $DNSName = $DNS.Name
   $DNSIP = $DNS.IPaddress 
   $IPInfo = Get-CimInstance Win32_NetworkAdapterConfiguration

#DNS Server of Target
   $DNSServer = (Get-DNSClientServerAddress -cimsession $CimSession -InterfaceAlias "ethernet" -AddressFamily IPv4).ServerAddresses

#Write Output to Screen 
#Clear-Host
Write-Output "Help Desk Support Information for $Computername"
Write-Output "-----------------------------------------------"
Write-Output "Support Analyst: $Analyst";""
Write-output "Computername: $Computername";""
Write-Output "Last System Reboot of $computername : $LastReboot ";""
Write-Output "DNS Name of $computername :$DNSName";""
Write-Output "IP Address of $DNSName : $DNSIP";""
Write-Output "DNS Server(s) for $ComputerName : $DNSServer";""
Write-Output "Total System RAM in $computerName : $MemoryInGB GB";""
Write-Output "Freespace on C:  $Freespace GB";""
Write-Output "Version of Operating System: $OS"

#Get-Memory
#Measure
Get-CimInstance Win32_PhysicalMemory -ComputerName Client02
(Get-CimInstance Win32_PhysicalMemory -ComputerName Client02).Capacity
(Get-CimInstance Win32_PhysicalMemory -ComputerName Client02).Capacity | measure -Sum
(((Get-CimInstance Win32_PhysicalMemory -ComputerName Client02).Capacity | measure -Sum).Sum)
((((Get-CimInstance Win32_PhysicalMemory -ComputerName Client02).Capacity | measure -Sum).Sum)/1gb)



#Get-Service example
#Step 1 Run HardCoded command
get-service -ComputerName DC01   |
                         Where-Object -Property Status -eq 'Stopped'

#Step 1 Run HardCoded command
get-service -ComputerName DC01   |
                         Where-Object -Property Status -eq 'Stopped'

#Step 1 Run HardCoded command
get-service -ComputerName DC01   |
                         Where-Object -Property Status -eq 'Stopped'

# step 2 Add Variables
$Computername = "Client02"
get-service -ComputerName $Computername   |
                         Where-Object -Property Status -eq 'Stopped'

# step 2 Add Variables
$Computername = "Client02"
get-service -ComputerName $Computername   |
                         Where-Object -Property Status -eq 'Stopped'

#Get-ServiceExamplept3.ps1

#Region Step 3 Parameterize Variable
# Create $computername parameter that is mandatory and allows multiple inputs
param (
    [Parameter(Mandatory=$True)]
    [string[]]
    $Computername
)

#Enter Script Block Here
get-service -ComputerName $Computername   |
                         Where-Object -Property Status -eq 'Stopped'
                        

#Get-ServiceExamplept3.ps1

#Region Step 3 Parameterize Variable
# Create $computername parameter that is mandatory and allows multiple inputs
param (
    [Parameter(Mandatory=$True)]
    [string[]]
    $Computername
)

#Enter Script Block Here - Copy from Get-ServiceExamplePt2.ps1


#Step 4 Add Logic
param (
    [Parameter(Mandatory=$True)][string[]]$Computername
)

#Loop through each computer in computername parameter, and perform actions in code block
foreach ($target in $Computername) {

    #Enter Code Block Here and change variable to match foreach condition
    get-service -ComputerName $Computername   |
    Where-Object -Property Status -eq 'Stopped'

}


#Get-ServiceStatus.ps1 - Script displays the status of services running on a specified machine

#Creates a mandatory parameter for Computername and for Service Status

Param (
    [Parameter(Mandatory=$true)]    
    [string[]]                      #Additional [] after string denotes this parameter accepts multiple inputs
     $Computername                  #Note this is the same name as the variable used in your code below
)

#Creates a variable for Get-Service Objects
#As it can hold multiple objects, referred to as an array
$Services = Get-Service -ComputerName $Computername     #

#Use foreach construct to perform actions on each object in $Services
Foreach ($service in $services) {
    
    #Create variable containing status and displayname using member enumeration
    $ServiceStatus = $service.Status                # decimal notating the variable allows access to properties of each object
    $ServiceDisplayName = $Service.displayname

    #Use if-else construct for decision making
    
    if ($ServiceStatus -eq 'Running') {
        Write-Output "Service OK - Status of $ServiceDisplayname is $ServiceStatus"
    }
    Else {
        Write-Output "Check Service - Status of $ServiceDisplayname is $ServiceStatus"
       
    }
}



# Member Enumeration of Objects
$OS= Get-CimInstance Win32_OperatingSystem | select Caption
$OS
$OSv2 = (Get-CimInstance Win32_OperatingSystem).Caption
$OSv2


#OS Description
    $OS= (Get-CimInstance Win32_OperatingSystem -ComputerName Client02).caption
    $OS

#Disk Freespace on OS Drive 
   $drive = Get-WmiObject -class Win32_logicaldisk | Where-Object DeviceID -EQ 'C:'
   $Freespace = (($drive.Freespace)/1gb)
   $drive
   $freespace

#Amount of System Memory
   $MemoryInGB = ((((Get-CimInstance Win32_PhysicalMemory -ComputerName Client02).Capacity|measure -Sum).Sum)/1gb)
   $MemoryInGB

#Last Reboot of System
   $LastReboot = (Get-CIMInstance -Class Win32_OperatingSystem –ComputerName Client02).LastBootUpTime      
   $LastReboot

#IP Address & DNS Name
   $DNS = Resolve-DnsName -Name Client02 | Where-Object Type -eq "A" 
   $DNSName = $DNS.Name
   $DNSIP = $DNS.IPaddress 
   $DNS
   $DNSName
   $DNSIP

#DNS Server of Target
   $CimSession = New-CimSession -ComputerName Client02 -Credential (Get-Credential)
   (Get-DNSClientServerAddress -cimsession $CimSession -InterfaceAlias "ethernet" -AddressFamily IPv4).ServerAddresses
   


#OS Description

#Disk Freespace on OS Drive 

#Amount of System Memory

#Last Reboot of System

#IP Address & DNS Name

#DNS Server of Target

#Write Output to Screen 


# Script for viewing stopped services on a windows client
# Run in Windows PowerShell only

$computername=Read-host -Prompt "Enter name of host"

$stoppedService = get-service -ComputerName $computername   |
                        Where-Object -Property Status -eq 'Stopped'

Write-Output $stoppedService
