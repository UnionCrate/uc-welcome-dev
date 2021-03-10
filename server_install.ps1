# Run PowerShell in Admin Mode
# Optimized For Windows Server 2019 Datacenter
# Assumes C Drive is your install drive

# Comment out the parts you don't need to reduce installation time and disk usage


Function Get-EnvVariableNameList {
  <#
  .SYNOPSIS
  returns the names of all the envirnomental variables as an array list
  .DESCRIPTION
  returns the names of all the envirnomental variables as an array list
  #>
    [cmdletbinding()]
    $allEnvVars = Get-ChildItem Env:
    $allEnvNamesArray = $allEnvVars.Name
    $pathEnvNamesList = New-Object System.Collections.ArrayList
    $pathEnvNamesList.AddRange($allEnvNamesArray)
    return ,$pathEnvNamesList
}


Function Add-EnvVarIfNotPresent {
  <#
  .SYNOPSIS
  Append an environmental variable to Machine, process and user if that variable name isn't already present
  .DESCRIPTION
  Checks if the environmental variable name is present. If it doesn't then the method adds and updates it to machine, process and user
  #>
#[cmdletbinding()]
Param (
[string]$variableNameToAdd,
[string]$variableValueToAdd
   ) 
    $nameList = Get-EnvVariableNameList
    $alreadyPresentCount = ($nameList | Where{$_ -like $variableNameToAdd}).Count
    #$message = ''
    if ($alreadyPresentCount -eq 0)
    {
    [System.Environment]::SetEnvironmentVariable($variableNameToAdd, $variableValueToAdd, [System.EnvironmentVariableTarget]::Machine)
    [System.Environment]::SetEnvironmentVariable($variableNameToAdd, $variableValueToAdd, [System.EnvironmentVariableTarget]::Process)
    [System.Environment]::SetEnvironmentVariable($variableNameToAdd, $variableValueToAdd, [System.EnvironmentVariableTarget]::User)
        $message = "Enviromental variable added to machine, process and user to include $variableNameToAdd"
    }
    else
    {
        $message = 'Environmental variable already exists. Consider using a different function to modify it'
    }
    Write-Information $message
}


Function Get-EnvExtensionList {
  <#
  .SYNOPSIS
  returns the env path extensions as an array list
  .DESCRIPTION
  returns the env path extensions as an array list
  #>
    [cmdletbinding()]
    $pathExtArray =  ($env:PATHEXT).Split("{;}")
    $pathExtList = New-Object System.Collections.ArrayList
    $pathExtList.AddRange($pathExtArray)
    return ,$pathExtList
}


Function Add-EnvExtension {
  <#
  .SYNOPSIS
  Append a path extension to Machine, process and user paths
  .DESCRIPTION
  Checks if the $env:PATHEXT has the path entered. If it doesn't then the method adds and updates it to machine, process and user
  #>
#[cmdletbinding()]
Param (
[string]$pathExtToAdd
   ) 
    $pathList = Get-EnvExtensionList
    $alreadyPresentCount = ($pathList | Where{$_ -like $pathToAdd}).Count
    #$message = ''
    if ($alreadyPresentCount -eq 0)
    {
        $pathList.Add($pathExtToAdd)
        $returnPath = $pathList -join ";"
        [System.Environment]::SetEnvironmentVariable('pathext', $returnPath, [System.EnvironmentVariableTarget]::Machine)
        [System.Environment]::SetEnvironmentVariable('pathext', $returnPath, [System.EnvironmentVariableTarget]::Process)
        [System.Environment]::SetEnvironmentVariable('pathext', $returnPath, [System.EnvironmentVariableTarget]::User)
        $message = "Path extension added to machine, process and user paths to include $pathExtToAdd"
    }
    else
    {
        $message = 'Path extension already exists'
    }
    Write-Information $message
}


Function Remove-EnvExtension {
  <#
  .SYNOPSIS
  Remove a path extension from machine, process and user paths
  .DESCRIPTION
  Checks if the $env:PATHEXT has the path entered. If it does, then it removes it from machine, process and user
  #>
    #[cmdletbinding()]
    Param (
    [string]$PathExtToRemove
       ) 
    # End of Parameters
    $preRemovalExtArray = Get-EnvExtensionList
    $pathList = New-Object System.Collections.ArrayList
    $pathList = $preRemovalExtArray | Where{!($_ -like $PathExtToRemove)}
    [int] $dif = $preRemovalExtArray.Count - $pathList.Count
    If($dif -gt 0)
    {
    $returnPath = $pathList -join ";"
    [System.Environment]::SetEnvironmentVariable('pathext', $returnPath, [System.EnvironmentVariableTarget]::Machine)
    [System.Environment]::SetEnvironmentVariable('pathext', $returnPath, [System.EnvironmentVariableTarget]::Process)
    [System.Environment]::SetEnvironmentVariable('pathext', $returnPath, [System.EnvironmentVariableTarget]::User)
    }
    $message = "Removed " + $dif.ToString() + " paths fom the machine, process, and user environments."
    Write-InformatioN $message
}


Function Get-EnvPathList {
  <#
  .SYNOPSIS
  returns the env paths as an array list
  .DESCRIPTION
  returns the env paths as an array list
  #>
    [cmdletbinding()]
    $pathArray =  ($env:PATH).Split("{;}")
    $pathList = New-Object System.Collections.ArrayList
    $pathList.AddRange($pathArray)
    return ,$pathList
}


Function Add-EnvPath {
  <#
  .SYNOPSIS
  Append a path to Machine, process and user paths
  .DESCRIPTION
  Checks if the $env:Path has the path entered. If it doesn't then the method adds and updates it to machine, process and user
  #>
#[cmdletbinding()]
Param (
[string]$pathToAdd
   ) 
    $pathList = Get-EnvPathList
    $alreadyPresentCount = ($pathList | Where{$_ -like $pathToAdd}).Count
    #$message = ''
    if ($alreadyPresentCount -eq 0)
    {
        $pathList.Add($pathToAdd)
        $returnPath = $pathList -join ";"
        [System.Environment]::SetEnvironmentVariable('path', $returnPath, [System.EnvironmentVariableTarget]::Machine)
        [System.Environment]::SetEnvironmentVariable('path', $returnPath, [System.EnvironmentVariableTarget]::Process)
        [System.Environment]::SetEnvironmentVariable('path', $returnPath, [System.EnvironmentVariableTarget]::User)
        $message = "Path added to machine, process and user paths to include $pathToAdd"
    }
    else
    {
        $message = 'Path already exists'
    }
    Write-Information $message
}


Function Remove-EnvPath {
  <#
  .SYNOPSIS
  Remove a path from machine, process and user paths
  .DESCRIPTION
  Checks if the $env:Path has the path entered. If it does, then it removes it from machine, process and user
  #>
    #[cmdletbinding()]
    Param (
    [string]$PathToRemove
       ) 
    # End of Parameters
    $preRemovalPathArray = Get-EnvPathList
    $pathList = New-Object System.Collections.ArrayList
    $pathList = $preRemovalPathArray | Where{!($_ -like $PathToRemove)}
    [int] $dif = $preRemovalPathArray.Count - $pathList.Count
    If($dif -gt 0)
    {
    $returnPath = $pathList -join ";"
    [System.Environment]::SetEnvironmentVariable('path', $returnPath, [System.EnvironmentVariableTarget]::Machine)
    [System.Environment]::SetEnvironmentVariable('path', $returnPath, [System.EnvironmentVariableTarget]::Process)
    [System.Environment]::SetEnvironmentVariable('path', $returnPath, [System.EnvironmentVariableTarget]::User)
    }
    $message = "Removed " + $dif.ToString() + " paths fom the machine, process, and user environments."
    Write-InformatioN $message
}

# Disable Internet Explorer Enhanced Security Configuration - Used in Windows Server INstalls
Function Disable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
    Stop-Process -Name Explorer
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}


# Disable the enhanced security configuration on IE in Windows Server
Disable-InternetExplorerESC

# Set timezone of the machine to Eastern Time
Set-TimeZone -Name "Eastern Standard Time"

# Allows Powershell scripts to be run without constantly asking for heightened privilages during this install
Set-ExecutionPolicy Bypass -Scope Process -Force

#Install Nuget Package provider. Many Powershell libraries rely on Nuget .Net packages
Install-PackageProvider -Name NuGet -Force

# Install Powershell Get to facilitate installing packages from PowerShellGallery.com
Install-Module -Name PowerShellGet -Force 

# Facilitates using the Windows package installer Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#choco install chocolatey-core.extension

# Install 7zip compression software
choco install 7zip -y

#Install git and update the environmental path
choco install git -y
Add-EnvPath 'C:\Program Files\Git\cmd'

# Install a HexEditor hXD
choco install hxd -y

# Install Adobe Acrobat Reader
choco install adobereader -y

# Install Google Chrome Browswer
choco install googlechrome -y

# Install Firefox Browser
choco install firefox -y

# Install VS Code - the lightweight multi OS and multi language code editor
choco install vscode -y
# VS Code Powershell Extension
choco install vscode-powershell -y
# VS Code C# Extension
choco install vscode-csharp -y
# VS Code Docker Extension
choco install vscode-docker -y
#VS Code Icons Extension
choco install vscode-icons -y
# VS Code extension for Python
choco install vscode-python -y
# VS Code Python test runner
choco install vscode-python-test-adapter -y

# Install Resharper Command Line Tools -Jetbrains tool that allows code inspection from command line
choco install resharper-clt -y

# Install Docker Related Items
choco install docker-desktop -y
choco install docker-cli -y

# Install NodeJS
choco install nodejs -y
# Add Node to the Environmental Path List
Add-EnvPath 'C:\Program Files\nodejs\'
#Install Typescript - a typed version of Javascript created by Microsoft
choco install typescript -y
# Install some Azure Functions Tools that surprisingly use NPM to install
npm i -g azure-functions-core-tools@3 --unsafe-perm true

# Install SQL Server Management Studio, the heavy weight SQL Server IDE
choco install sql-server-management-studio -y

# Install Putty, the well known SSH Client
choco install putty -y

# Install Keeper Security Desktop App
choco install keeper -y

# Install Pritunl VPN Client
choco install pritunl-client -y

#Install Azure PowerShell Tools
Install-Module -Name Az -AllowClobber -Force

# Install Azure CLI - A python command line tool for working with Azure
choco install azure-cli -y

# Azure Core Function Tools
choco install azure-functions-core-tools -y

# Azure Data Studio
choco install azure-data-studio -y

# Azure Storage Explorer
choco install microsoftazurestorageexplorer -y

# Postman - API and Http utility tool
choco install postman -y

# Tailblazer - Log reading utility Tool
choco install tailblazer -y 

# Install Pycharm Professional - IDE for Python
choco install pycharm -y

# Install Pycharm Community Edition
# choco install pycharm-community -y

# Install Microsoft Office 365 Busineess Desktop
choco install office365business -y

# Install Slack Messaging Desktop App
choco install slack -y

# Install Lunacy UX Design App to work with Sketch Files
choco install lunacy -y

# Install Zeplin UX Design App 
#choco install zeplin -y

# Filezilla FTP client
choco install filezilla -y

# Install .Net Core Runtime used to run the OS independent version of the .Net runtime
choco install dotnetcore -y

# Install Pulumi - A cloud infrastructure as code tool
choco install pulumi -y

# *** Install all the Visual Studio Community Edition 2019 Related items Just to get the C++ compiler
# *** This is only needed if you use Visual Studio or need the compiler in Windows
# Install build stuff and C and C++ items needed by some of the Python NLP Libraries to work faster
# You can skip these installs if you are not using any of the NLP Libraries like Gensim or SpaCy
choco install microsoft-build-tools -y
choco install kb2999226 -y
choco install vcredist140 -y
choco install vcredist2017 -y
choco install vcredist-all -y
choco install visualstudio2019-workload-netcorebuildtools -y
choco install visualstudio2019buildtools -y
choco install visualcppbuildtools -y
choco install visualstudio2019community -y 
# Python Tools for Visual Studio
#choco install visualstudio2019-workload-python -y
choco install visualstudio2019-workload-azurebuildtools -y
# Tool for building .Net Console Applications
choco install visualstudio2019-workload-manageddesktop -y
# Azure connection for visual studio 2019
choco install visualstudio2019-workload-data -y
# .Net Core Tooling for Visual Studio 2019
choco install visualstudio2019-workload-netcoretools -y
# SQL Server Integration for Visual Studio 2019
choco install ssis-vs2019 -y
# Add Path For Visual Studio 2019 Community Edition, Visual Studio Installer and redirect any hard coded references to newest visual studio
$newVSpath = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools"
Add-EnvVarIfNotPresent "VS140COMNTOOLS" $newVSpath
Add-EnvVarIfNotPresent "VSSDK140Install" $newVSpath
Add-EnvVarIfNotPresent "VS130COMNTOOLS" $newVSpath
Add-EnvVarIfNotPresent "VS120COMNTOOLS" $newVSpath
Add-EnvVarIfNotPresent "VS110COMNTOOLS" $newVSpath
Add-EnvVarIfNotPresent "VS100COMNTOOLS" $newVSpath
Add-EnvVarIfNotPresent "VS90COMNTOOLS" $newVSpath


# Install MySQL Related items
choco install mysql.installer -y
choco install mysql.odbc -y
choco install mysql-python -y
choco install mysql-connector -y #The .Net connector
choco install mysql-cli -y
choco install mysql.workbench -y

# Install TablePlus
choco install tableplus -y


# Install Python 3.7
# Todo need to check what version of Python 3 is installed
# Python for windows changed the default install path. This forces it back to the old path for package compatibility
choco install python --version=3.7.5 --params "/InstallDir:C:\Python37" -y --force
# Update the path variables to facilitate using Pip and Pip3 to install Python packages
Add-EnvExtension '.PY'
Add-EnvExtension '.PYW'
Add-EnvPath 'C:\Python37\Scripts\'
Add-EnvPath 'C:\Python37\'
Add-EnvPath 'C:\Python37\Scripts'
# Todo add also C:\Users\<computer>\AppData\Roaming\Python\Python37\Scripts

# You can comment out this C++ Compiler part if you are not using any of the NLP Libraries such as GenSim or SpaCy
# This package installer sometimes has intermitent errors during install, hence the for loop approach
$isInstalled = $false
For ($i=0; $i -le 10; $i++) {
    try{
        choco install vcpython27 -y
        $isInstalled = $true
        If($isInstalled) {break}
        }
    catch{}
    }


# Upgrade Pip - Yes this is redundant and needs to be cleaned up
python -m pip install --upgrade pip setuptools
# upgrade setup tools 
python -m pip install -U wheel
# upgrade Pip installer
python -m pip install --upgrade pip
pip3 install --upgrade pip

# Cmake 
python -m pip install cmake

#Install Cython
python -m pip install Cython



# python Windows bindings
#python -m pip insta+ll pywinpty
# temporary fix until pywinpty installs with better wheeel
python -m pip install https://github.com/gbonventre/WindowsMLInstall/blob/master/pywinpty-0.5.4-cp37-cp37m-win_amd64.whl?raw=true

# pip install the mysql 64 bit wheel from https://www.lfd.uci.edu/~gohlke/pythonlibs/#mysqlclient
python -m pip install https://github.com/UnionCrate/uc-welcome-dev/blob/master/mysqlclient-37_amd64.whl?raw=true



#Install Jupyter
python -m pip install jupyter
pip3 install jupyter notebook # This used to not be superfluous


# Download requirements.txt From Github to System32 folder. Yes you could use another destination
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$someWebclient = New-Object System.Net.WebClient
$someUrl = "https://raw.githubusercontent.com/UnionCrate/uc-welcome-dev/master/requirements.txt?raw=true"
$someDestination = "C:\Windows\System32\requirements.txt"
$someWebclient.DownloadFile($someUrl,$someDestination)
cd C:\Windows\System32\
pip install -r requirements.txt


#Install virutal environment
python -m pip install virtualenv

# parallel analytics
python -m pip install dask[complete]


#install the PYODBC driver for SQL Server
# See full Install Instructions in https://docs.microsoft.com/en-us/sql/connect/python/pyodbc/step-1-configure-development-environment-for-pyodbc-python-development
# download and install this - I think that this can be replaced with the chocolatey package
#https://www.microsoft.com/en-us/download/confirmation.aspx?id=56567
# Todo Make sure that python version is 3.7
cd C:\Python37\Scripts 
python -m pip install pyodbc
# pay attention to which version of the ODBC driver is used becuase each database connection references it

#https://aka.ms/vs/15/release/VC_redist.x64.exe

# The non-GPU version of TensorFlow
pip install tensorflow



# RESTART AT END 
Restart-Computer -Force