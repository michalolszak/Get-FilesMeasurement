#in order to work, all following files have to be in one Get-FIlesMeasurement folder:
#  Name
#  ----
#  testFolder1
#  testFolder2
#  Get-FilesMeasurement.ps1
#  pathsFile.csv
#  pathsFile.txt
#  Test.ps1
#dotsourcing function
. ".\Get-FilesMeasurement\Get-FilesMeasurement.ps1"
#variables containing paths
$singlePath = ".\Get-FilesMeasurement" # put here single path to folder
$multiplePaths = '.\Get-FilesMeasurement\testFolder1', '.\Get-FilesMeasurement\testFolder2' # #put here multiple paths to folder
$filePath = ".\Get-FilesMeasurement\pathsFile.txt" # put here path to file containg paths
#get content of csv file here (supported only via pipeline by property name)
$scvFilePath = (Get-Content ".\Get-FilesMeasurement\pathsFile.csv")
#deafult behavior
Get-FilesMeasurement -Verbose
#deafult behavior alias
GFP
#byArgument
write-host "ByArgument" -ForegroundColor cyan
Get-FilesMeasurement $singlePath -Verbose
Get-FilesMeasurement $multiplePaths -Verbose
Get-FilesMeasurement -Path $singlePath -Verbose
Get-FilesMeasurement -Path $multiplePaths -Verbose
Get-FilesMeasurement -FilePath ".\Get-FilesMeasurement\pathsFile.txt" -Verbose
# csv are not supported in file proprety
write-host "Not supported files extension" -ForegroundColor cyan
Get-FilesMeasurement -FilePath ".\Get-FilesMeasurement\pathsFile.csv" -Verbose
#Support for pipe(value)
write-host "Pipeline Support by value" -ForegroundColor Cyan
$singlePath | Get-FilesMeasurement -Verbose
$multiplePaths | Get-FilesMeasurement -Verbose
#Support for pipe(property name)
write-host "Pipeline support by property name" -ForegroundColor cyan
$scvFilePath | Get-FilesMeasurement -Verbose
#this is not allowed
write-host "Not allowed pipeline input" -ForegroundColor cyan
$filePath | Get-FilesMeasurement -Verbose


Get-ChildItem -Path "C:\Workspace\DevelopmentPowerShell\Get-FilesMeasurement" | select Name