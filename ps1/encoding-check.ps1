# Script to verify all encodings for json files

param(
	[Parameter(Mandatory=$true)][string]$path
)

Write-Host "Validating json encodings"

# Powershell version check
if ($PSVersionTable.PSVersion.Major -lt 6)
{
	Write-Host  "Must use PowerShell version 6 or higher"
	exit
}

$invalidItems = New-Object System.Collections.Generic.List[System.String]

$files = Get-ChildItem -Path $path -Filter *.json -Recurse

foreach ($file in $files)
{
	$byte = Get-Content -Path $file -AsByteStream -ReadCount 6 -TotalCount 6

	if (-Not($byte[0] -eq 0x7b))
	{
		$invalidItems.Add("${file} - ${byte}")
	}
}

if ($invalidItems.Count -gt 0)
{
	Write-Host "Valid is: 123"
	foreach ($invalidItem in $invalidItems)
	{
		Write-Host $invalidItem
	}

	Write-Host "Status: 1"

	return 1 
}
else
{
	Write-Host "Status: 0"

	return 0 #success
}