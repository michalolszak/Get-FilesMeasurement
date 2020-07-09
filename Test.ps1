#in order to work, all following files have to be in one Get-FIlesMeasurement folder:
# please adjust paths before
#  Name
#  ----
#  testFolder1
#  testFolder2
#  Get-FilesMeasurement.ps1
#  pathsFile.csv
#  pathsFile.txt
#  Test.ps1
$folderLocation = Split-Path -Parent $PSCommandPath
#dotsourcing function
. "$folderLocation\Get-FilesMeasurement.ps1"
#variables containing paths
# important
$singlePath = "$folderLocation" # put here single path to folder
$multiplePaths = "$folderLocation\testFolder1", "$folderLocation\testFolder2" # #put here multiple paths to folder
# put here path to file containg paths
# WARNING - fill with proper absolute paths
$filePath = "$folderLocation\pathsFile.txt"
#get content of csv file here (supported only via pipeline by property name)
#WARNING  - must be filled with propert absolute paths
$scvFilePath = (import-csv "$folderLocation\pathsFile.csv")
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
Get-FilesMeasurement -FilePath "$filePath" -Verbose
# csv are not supported in file proprety
write-host "Not supported files extension" -ForegroundColor cyan
Get-FilesMeasurement -FilePath "$scvFilePath" -Verbose
#Support for pipe(value)
write-host "Pipeline Support by value" -ForegroundColor Cyan
$singlePath | Get-FilesMeasurement -Verbose
$multiplePaths | Get-FilesMeasurement -Verbose
#Support for pipe(property name) - will show error if file won't be filled wil proper paths
write-host "Pipeline support by property name" -ForegroundColor cyan
$scvFilePath | Get-FilesMeasurement -Verbose
#this is not allowed
write-host "Not allowed pipeline input" -ForegroundColor cyan
$filePath | Get-FilesMeasurement -Verbose
