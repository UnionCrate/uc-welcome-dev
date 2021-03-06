
# Optimized For Windows 10 Pro
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

# Install Resharper Command Line Tools -Jetbrains tool that allows code inspection from command line
choco install resharper-clt -y

# Install NodeJS
choco install nodejs -y
# Add Node to the Environmental Path List
Add-EnvPath 'C:\Program Files\nodejs\'
#Install Typescript - a typed version of Javascript created by Microsoft
choco install typescript -y
# Install some Azure Functions Tools that surprisingly use NPM to install
npm i -g azure-functions-core-tools@3 --unsafe-perm true

# Install Sysinternals Tools - these are a number of Windows tools used to fix Windows issues
#choco install sysinternals -y

# Install SQL Server Management Studio, the heavy weight SQL Server IDE
choco install sql-server-management-studio -y

# Enable Linux Subsystem, With restart surpressed
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -n
# ** NOTE THAT A RESTAT IS REQUIRED BEFORE INSTALLING A PARTICULAR LINUX DISTRO
#Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile Ubuntu.appx -UseBasicParsing
#Add-AppxPackage .\Ubuntu.appx

# Install Putty, the well known SSH Client
choco install putty -y

# Turn on Windows Native SSH Client
# Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# Install SSH Server  
# See https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse
# Install the OpenSSH Server
# Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
#Start-Service sshd
# OPTIONAL but recommended:
#Set-Service -Name sshd -StartupType 'Automatic'
# Confirm the Firewall rule is configured. It should be created automatically by setup. 
#Get-NetFirewallRule -Name *ssh*
# There should be a firewall rule named "OpenSSH-Server-In-TCP", which should be enabled
# If the firewall does not exist, create one
#New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Enable Hyper V Virtual Machine Hypervisor with restart postponed
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -n
# You will still need to chose an ISO to run in the VM at a later point in time

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

# Azure Cloud Studio
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

# MySQL Related items
choco install mysql.workbench -y
choco install mysql-odbc -y

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


# Install Python 3.7
# Todo need to check what version of Python 3 is installed
# Python for windows changed the default install path. This forces it back to the old path for package compatibility
choco install python --version=3.7.5 --params "/InstallDir:C:\Python37" -y --force
# Update the path variables to facilitate using Pip and Pip3 to install Python packages
Add-EnvExtension '.PY'
Add-EnvExtension '.PYW'
Add-EnvPath 'C:\Program Files\Python37\'
Add-EnvPath 'C:\Program Files\Python37'
Add-EnvPath 'C:\Program Files\Python37\Scripts'
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

# Old approach to the C++ compiler
# #Make the temp folder that holds the install files
# $tempDirectory = "C:\temp_provision"
# New-Item -ItemType directory -Path $tempDirectory -Force | Out-Null
# # Download and Install the Visual C++ compiler for Python 2.7 and 3.6
# # make sure 7zip is installed first
# #$visualCppUrl = "https://www.microsoft.com/en-us/download/confirmation.aspx?id=44266"
# $visualCppUrl = "https://download.microsoft.com/download/7/9/6/796EF2E4-801B-4FC4-AB28-B59FBF6D907B/VCForPython27.msi"
# $visualCppLoc = $tempDirectory + "\Cpp.msi"
# Invoke-RestMethod $visualCppUrl -outfile $visualCppLoc
# Start-Process -FilePath $visualCppLoc -Wait -ArgumentList "/q" -Verb runas
# msiexec /i C:\temp_provision\Cpp.msi ALLUSERS=1 /q


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

#Install pytest
python -m pip install pytest

#Install SpaCy
python -m pip install -U spacy
# Install the Language Models for SpaCy
pip install https://github.com/explosion/spacy-models/releases/download/en_core_web_lg-2.0.0/en_core_web_lg-2.0.0.tar.gz
#python -m spacy download en
#python -m spacy.en.download all
#python -m spacy download xx
#python -m spacy download en_core_web_lg

# Install Gensim
python -m pip install --upgrade gensim
python -m pip install pyro4

# python Windows bindings
#python -m pip install pywinpty
# temporary fix until pywinpty installs with better wheeel
python -m pip install https://github.com/gbonventre/WindowsMLInstall/blob/master/pywinpty-0.5.4-cp37-cp37m-win_amd64.whl?raw=true

#Install Jupyter
python -m pip install jupyter
pip3 install jupyter notebook # This used to not be superfluous

python -m pip install --user certifi

#Install SciKitLearn
python -m pip install -U scikit-learn

#Install NLTK
python -m pip install -U nltk

# Commented the corpora of NLTK for now
#Make the temp folder that holds NLTK corpora
# Todo issue installing NLTK corpora
#$nltkDirectory = "C:\nltk_data"
#New-Item -ItemType directory -Path $nltkDirectory -Force | Out-Null
#cd C:\nltk_data
# can't get punkt installed
#python -m nltk.downloader punkt 
# Download the NLTK popular corpora
#python -m nltk.downloader popular
# Download all the NLTK corpora
# couldn't get it all installed correctly
#python -m nltk.downloader all
# python -c "import nltk; nltk.download('punkt')"
#cd C:\Windows\System32

#Install TextBlob
python -m pip install -U textblob
python -m textblob.download_corpora

#Prerequisites for MatPlotLib
choco install ffmpeg -y
choco install ghostscript -y
choco install miktex -y
python -m pip install pytz
python -m pip install -U pyparsing
python -m pip install kiwisolver
python -m pip install Cycler
# Download Freetype From Github to System32 folder
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$freetypeWebclient = New-Object System.Net.WebClient
$freetypeUrl = "https://github.com/ubawurinna/freetype-windows-binaries/raw/master/win64/freetype.dll"
$freetypeDestination = "C:\Windows\System32\freetype.dll"
$freetypeWebclient.DownloadFile($freetypeUrl,$freetypeDestination)

#Install MatPlotLib
python -m pip install matplotlib

# Install statsmodels
python -m pip install -U statsmodels

#Install Pandas
python -m pip install pandas

#Install NumPy
python -m pip install numpy

#Install SciPy. Probably already installed from a previous package
python -m pip install scipy

#Instal PatSy
python -m pip install patsy

#Install Seaborne - lots of dependencies needed. So install after some other libraries installed
python -m pip install seaborn

#Install Nose Test Suite
python -m pip install nose

#Install  Jinja2
python -m pip install Jinja2

#Install Six
python -m pip install six

python -m pip install --user pipenv

python -m pipenv install requests

python -m pip install tornado

python -m pip install pyyaml

python -m pip install python-dateutil

#Install Bokeh
python -m pip install bokeh

#Install virutal environment
python -m pip install virtualenv

python -m pip install pyqtgraph

python -m pip install flask

python -m pip install virtualenvwrapper-win

python -m pip install django

# parallel analytics
python -m pip install dask[complete]

# X-13ARIMA-SEATS , Todo: Add to installer for this timeseries library

# Todo add install for Stanford CoreNLP python wrapper

# Http Server
python -m pip install gunicorn


python -m pip install kombu
python -m pip install mock
python -m pip install networkx
python -m pip install isoweek

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

# Install Keras
python -m pip install keras

# Install PyTourch Non-GPU Version
# https://pytorch.org/get-started/locally/
pip3 install torch==1.4.0+cpu torchvision==0.5.0+cpu -f https://download.pytorch.org/whl/torch_stable.html

# Install Cognitive Toolkit (formerly CNTK) non-GPU version
# Microsoft CNTK only supports Python 3.6 no Python 3.7 yet
#python -m pip install cntk


#Install Python AWS Client Library
python -m pip install boto3

# Install Azure related Python libraries there are ones in preview so wait before installing these
#python -m pip install azure                
#python -m pip install azure-batch          # Install the latest Batch runtime library
#python -m pip install azure-mgmt-scheduler # Install the latest Storage management library
#python -m pip install azure-mgmt-compute # will install only the latest Compute Management library
#python -m pip install azure-cosmosdb-table  # pip install stuff for storage tables and cosmos bs
#python -m pip install azure-datalake-store # pip install for Azure datalake client library
#python -m pip install azure-mgmt-datalake-store # pip install Azure data lake management operations
#python -m pip install azure-mgmt-resource # include modules for active directory

# Install Google Cloud PowerShell Library
#Install-Module -Name GoogleCloud -Force

# Install Google Cloud Python Client Libraries
#python -m pip install --upgrade google-cloud

# Install AWS PowerShell Library
#Install-Module -Name AWSPowerShell -Force


# RESTART AT END 
Restart-Computer -Force
