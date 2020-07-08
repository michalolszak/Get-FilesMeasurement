# Get-FilesMeasurement
    Get info about files properties- count and max, in provided folders

    .Synopsis
   Get info about files properties- count and max, in provided folders
.DESCRIPTION
   Get info about files properties- count and max, in provided folders
   Function has two parameters one for array of strings as arguments for path parameter second for file with list of paths from file.
   Paths in File will be stripped of any quotes, as powershell automagically adds double qoutes to paths with whitespaces.
   Function uses Get-ChildItem converget with Measure-Object it measuers Count and Sum property Length, for files in provided paths.

   Results shows Microsoft.PowerShell.Commands.GenericMeasureInfo
   for property Length.
   If you are processing large amount of folders use verbose to distinguish beetwen outcome.
   Function alias - "gfp"
.PARAMETER file
    List of absolute paths to folders for which we want to compute.
    It might be file with absolute paths to folders separated by newline
    e.g.:
    'c:\folder1\folderA'
    "d:\folder5\"
    All qoutes ale stripped upon processing.
.PARAMETER filepath
    Absolute Path of txt or csv file with list of absolute folder paths, on which we want to use this functions.
    CSV file should contain header [path].
    Belongs to Parameter set = FilePath
.EXAMPLE
    Get-FilesMeasurement

    Description
    ---------------------------------------
    Test of default parameter with default value ( computers = '$psscriptroot' ) in default ParameterSet = Argument.
.EXAMPLE
    Get-FilesMeasurement -path "C:\folder"

    Description
    ---------------------------------------
    Test of default parameter with default value ( computers = '$psscriptroot' ) in default ParameterSet = Argument.
.EXAMPLE
    Get-FilesMeasurement -FilePath "C:\folder"

    Description
    ---------------------------------------
    Test of default parameter with default value ( computers = '$psscriptroot' ) in default ParameterSet = Argument.
.EXAMPLE
    'C:\folder' | Get-FilesMeasurement

    Description
    ---------------------------------------
    Test of pipeline by value of path parameter.
.EXAMPLE
   'd:\folder', 'c:\folder' | Select-Object @{label="path";expression={$_}} | Get-FilesMeasurement
   or
   (Get-Content $psscriptroot\pathsFile.csv) | Get-FilesMeasurement

    Description
    ---------------------------------------
    Test of values from pipeline by property name (paths).
.INPUTS
   System.String

    Paths parameter pipeline both by Value and by Property Name value and has default value of localhost. (Parameter Set = ComputerNames)
    FilePath parameter does not pipeline and does not have default value. (Parameter Set = FilePath)
.OUTPUTS
   Microsoft.PowerShell.Commands.GenericMeasureInfo
   Returns Generic measure info and path of supplied folder.
.NOTES
    FunctionName : Get-FileMeasurement
    Created by   : Michał Olszak
    Date Coded   : 2020-07-08
    More info    : michal.olszak@ing.com
    GitHub       :
