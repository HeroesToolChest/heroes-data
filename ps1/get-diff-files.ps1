# Script to find all the new files when comparing the old and new

param(
	[Parameter(Mandatory=$true)][string]$oldPath,
	[Parameter(Mandatory=$true)][string]$newPath,
	[Parameter(Mandatory=$true)][string]$partialPath
)

$hdpJson = '.hdp.json'

$versions = Get-ChildItem -Path $newPath -Directory -Name

function New-DirectoryIfNotExist
{
	param([parameter(Mandatory)][string]$path)
	
	if (-not (Test-Path $path -PathType Container))
	{
		New-Item -ItemType Directory -Force -Path $path | Out-Null
	}
}

function Copy-NewFiles
{
	param([parameter(Mandatory)]$version, [parameter(Mandatory)][string]$directory)
	
	if ((Test-Path "${oldPath}/${version}/${directory}" -PathType Container) -and (Test-Path "${newPath}/${version}/${directory}" -PathType Container))
	{		
		Write-Host "Both paths exists"
		Write-Host "${oldPath}/${version}/${directory}"
		Write-Host "${newPath}/${version}/${directory}"
		"====================="
		$oldDataFiles = Get-ChildItem -Path "${oldPath}/${version}/${directory}" -Name
		$newDataFiles = Get-ChildItem -Path "${newPath}/${version}/${directory}" -Name
		
		foreach ($dataFile in $newDataFiles)
		{
			Write-Host "Current data file ${dataFile}"
			$newDataFileHash = Get-FileHash "${newPath}/${version}/${directory}/${dataFile}" -Algorithm SHA256
			
			# check if its a new file
			if (-not (Test-Path "${oldPath}/${version}/${directory}/${dataFile}" -PathType Leaf))
			{
				Write-Host "New file"
				New-DirectoryIfNotExist -Path "${partialPath}/${version}/${directory}"
			
				Copy-Item -Path "${newPath}/${version}/${directory}/${dataFile}" -Destination "${partialPath}/${version}/${directory}" -Recurse
			}
			else # existing file
			{	
				Write-Host "Existing file"

				# check if the file was modified
				$oldDataFileHash = Get-FileHash "${oldPath}/${version}/${directory}/${dataFile}" -Algorithm SHA256
				
				if ($oldDataFileHash.Hash -ne $newDataFileHash.Hash)
				{
					Write-Host "Hash is different, has been modified"
					New-DirectoryIfNotExist -Path "${partialPath}/${version}/${directory}"

					Copy-Item -Path "${newPath}/${version}/${directory}/${dataFile}" -Destination "${partialPath}/${version}/${directory}" -Recurse
				}
			}			
		}
	}
	elseif ((Test-Path "${oldPath}/${version}/${directory}" -PathType Container) -and (-not (Test-Path "${newPath}/${version}/${directory}" -PathType Container)))
	{
		Continue
	}
	elseif ((-not (Test-Path "${oldPath}/${version}/${directory}" -PathType Container)) -and (Test-Path "${newPath}/${version}/${directory}" -PathType Container))
	{
		Write-Host "Brand new directory"
		New-DirectoryIfNotExist -Path "${partialPath}/${version}/${directory}"
							
		Copy-Item -Path "${newPath}/${version}/${directory}" -Destination "${partialPath}/${version}/${directory}" -Recurse
	}
	else # neither exists
	{
		Continue
	}
}

Write-Host "All version from new path:"
Write-Host "${versions}"

foreach ($version in $versions)
{
	# check if its a new folder (new version)
	if (-not (Test-Path "${oldPath}/${version}" -PathType Container))
	{
		Write-Host "Brand new version: ${version}"

		Copy-Item -Path "${newPath}/${version}" -Destination "${partialPath}/${version}" -Recurse
	}
	else
	{
		Write-Host "Existing version"
		Copy-NewFiles -Version $version -Directory "data"
		Copy-NewFiles -Version $version -Directory "gamestrings"
		
		# .hdp.json file check
		$oldHdpJsonHash = Get-FileHash "${oldPath}/${version}/${hdpJson}" -Algorithm SHA256
		$newHdpJsonHash = Get-FileHash "${newPath}/${version}/${hdpJson}" -Algorithm SHA256
		
		if ($oldHdpJsonHash.Hash -ne $newHdpJsonHash.Hash)
		{
			Copy-Item -Path "${newPath}/${version}/${hdpJson}" -Destination "${partialPath}/${version}/${hdpJson}" -Recurse
		}	
	}
}
