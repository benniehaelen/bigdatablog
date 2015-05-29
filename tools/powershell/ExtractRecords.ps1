# =============================================================================
#	ExtractRecords.ps1
#	
#	This script will extract the first N records from the specified inputfile
#	and write them to the specified output file, optionally skipping the first
#	(header) record.
#
#	Author: Bennie Haelen (http://www.benniehaelen.com)
#	Date: 5/29/2015
# =============================================================================
param([string]$inputfileName, 
      [string]$outputFileName,
      [int]$records = 1000,
	  [boolean]$skipFirstRecord = $true)

Write-Host "Input File Name: $inputFileName" -foregroundcolor "magenta"
Write-Host "Output File Name: $outputFileName" -foregroundcolor "magenta"
Write-Host "Number of Records: $records records" -foregroundcolor "magenta"

# Make sure that the input and output file names are specified
if (-Not ($inputFileName)) 
{ 
	Throw "You must specify an input file name" 
}

if (-Not ($outputFileName)) 
{ 
	Throw "You must specify an output file name" 
}

# Make sure that the input file exists
if (-Not (Test-Path $inputFileName))
{
	Throw "File $inputFileName does not exist!"
	exit
}

# Remove the output file if it already exists
if (Test-Path $outputFileName)
{
	Remove-Item $outputFileName
}

try
{
	$reader = [System.IO.File]::OpenText($inputFileName)
	$writer = New-Object System.IO.StreamWriter $outputFileName

	# Skip over first line since it contains headers
	$currentRecord = 0
	if ($skipFirstRecord)
	{
		$line = $reader.ReadLine()
		Write-Host $skipFirstRecord
		$currentRecord = 1
	}
	
	for (; $currentRecord -le $records; $currentRecord++)
	{
		$line = $reader.ReadLine()
		if ($null -eq $line)
		{
			break;
		}
		$writer.WriteLine($line);
	}
}
finally
{
	Write-Host "Completed, wrote: $($currentRecord - 1) records to $outputFileName..."
	if ($reader -ne $NULL)
	{
		$reader.Dispose();
	}
	
	if ($writer -ne $NULL)
	{
		$writer.Dispose();
	}
}
