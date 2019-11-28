# Script to verify all file namnes
# Data be in <name>_<version>_localized.json
# Gaemstrings be in <name>_<version>_<locale>.json

param(
	[Parameter(Mandatory=$true)][string]$path
)

Write-Host "Validating file names"

# Powershell version check
if ($PSVersionTable.PSVersion.Major -lt 6)
{
	Write-Host  "Must use PowerShell version 6 or higher"
	exit
}

$success = 0

$versions = Get-ChildItem -Path $path -Directory -Name

Write-Host "All versions from new path:"
Write-Host "${versions}"

foreach ($version in $versions)
{
	$major,$minor,$rev,$build = $version.Split(".")

	$build,$ptr = $build.Split("_")

	if (Test-Path "${path}/${version}/data" -PathType Container)
	{
		Write-Host "Checking all data files in ${path}/${version}/data"

		[array]$files = Get-ChildItem -Path "${path}/${version}/data" -Name
		foreach ($file in $files)
		{
			$ext = [System.IO.Path]::GetExtension($file)

			if ($ext -ne ".json")
			{
				Write-Host "Invalid file type of ${ext}"
				$success = 1

				Continue
			}

			$name,$fileBuild,$localized = $file.Split("_")

			if (-not (($name -ne $null) -and ($fileBuild -eq $build) -and ($localized -eq 'localized.json')))
			{
				Write-Host "Invalid file name format ${path}/${version}/data/${file}"
				$success = 1

				Continue
			}
		}
	}

	if (Test-Path "${path}/${version}/gamestrings" -PathType Container)
	{
		Write-Host "Checking all data files in ${path}/${version}/gamestrings"

		[array]$files = Get-ChildItem -Path "${path}/${version}/gamestrings" -Name
		foreach ($file in $files)
		{
			$ext = [System.IO.Path]::GetExtension($file)

			if ($ext -ne ".json")
			{
				Write-Host "Invalid file type of ${ext}"
				$success = 1

				Continue
			}

			$name,$fileBuild,$localized = $file.Split("_")
		
			if (-not (($name -eq 'gamestrings') -and ($fileBuild -eq $build) -and ($localized -ne $null)))
			{
				Write-Host "Invalid file name format ${path}/${version}/gamestrings/${file}"
				$success = 1

				Continue
			}
		}
	}
}

Write-Host "Status: ${success}"

return $success #success is 0