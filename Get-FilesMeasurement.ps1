#region info
<#
.Synopsis
   Get info about files properties- count and max, in provided folders
.DESCRIPTION
   Get info about files properties- count and max, in provided folders
   Function has two parameters one for array of strings as arguments for path parameter second for file with list of paths from file.
   Paths in File will be stripped of any quotes, as powershell automagically adds double qoutes to paths with whitespaces.
   Function uses Get-ChildItem converget with Measure-Object - it measuers Count and Sum for property Length, for files in provided paths.

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
    GitHub       : https://github.com/michalolszak/Get-FilesMeasurement
#>
#endregion info
#region Function
function Get-FilesMeasurement
{
    [CmdletBinding(DefaultParameterSetName='byArgument',
                  PositionalBinding=$false,
                  ConfirmImpact='none')]
    [Alias("gfp")]
    [OutputType('Microsoft.PowerShell.Commands.GenericMeasureInfo')]
    Param
    (
        # Path - only to be used with pipeline and array of string as argument
        [Parameter(ParameterSetName = 'byArgument',
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   position=0,
                   ValueFromRemainingArguments=$false,
                   HelpMessage="literPaths to folder, separated by comma. No wildcards accepted"
                   )]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript(
            {
                if (test-path -PathType leaf -LiteralPath ($_.trim("'")).trim('"'))
                {
                    throw "You cant use FilePath here. PLease use parameter Fileinfo"
                }
                elseif(test-path -LiteralPath ($_.trim("'")).trim('"'))
                    {
                        $true
                    }
                else
                    {
                        throw "${$_} - This path is not correct, check it again for correctness. Maybe network issue?"
                    }
            })]
        [Alias("pt","source")]
        [String[]]$path = $PSScriptRoot,

        # File - set when providing generic file
        [Parameter(ParameterSetName='FilePath',
                    HelpMessage="Path to file containing valid paths")]
        [ValidateScript(
            {
                    if(test-path -LiteralPath (($_.trim("'")).trim('"')) -pathtype leaf)
                    {

                        $true
                    }
                    else
                    {
                        throw "${$_} - This path is not correct, check it again for correctness. Maybe network issue? This should be path to file"
                    }
            })]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Alias("file")]
        [string]$FilePath
    )
    Begin
    {
        if ($pscmdlet.ParameterSetName -eq 'FilePath')
        {
            Write-Verbose -message "Reading content of: $FilePath"
            $path = ((Get-Content -LiteralPath $FilePath).trim("'")).trim('"')
            foreach ($item in $path)
            {
                if (-not (test-path -literalPath $item))
                {
                    throw "Path ${$item} inside file ${$FilePath} is incorrect, or network issue"
                }
            }
        }
    }
    Process
    {
        ForEach ($item in $path)
        {
            $getResults = (Get-ChildItem -Path $item -File -Recurse | Measure-Object -property Length -sum)
            if ($null -eq $getResults)
            {
                Write-host "There are no files inside $item and its child containers"
            }
            else
            {
                Write-Verbose $item
                $getResults
            }
        }
    }
    End
    {

    }
}
#endregion Function



