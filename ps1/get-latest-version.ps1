# Script to get the latest version of the heroesdata folder

param (
    [Parameter(Mandatory=$true)][string]$path
)

# Get all directories in the heroesdata folder
$directories = Get-ChildItem -Path $path -Directory

$latestVersion = "0.0.0.0"

# Function to compare two version strings, including handling _ptr suffix
function Compare-Version {
    param (
        [string]$version1,
        [string]$version2
    )

    # Remove _ptr suffix for comparison
    $version1 = $version1 -replace '_ptr$', ''
    $version2 = $version2 -replace '_ptr$', ''

    $v1Parts = $version1 -split '\.'
    $v2Parts = $version2 -split '\.'

    for ($i = 0; $i -lt $v1Parts.Length; $i++) {
        $v1Part = [int]$v1Parts[$i]
        $v2Part = [int]$v2Parts[$i]

        if ($v1Part -gt $v2Part) {
            return 1
        } elseif ($v1Part -lt $v2Part) {
            return -1
        }
    }

    # If versions are equal without _ptr suffix, handle _ptr suffix
    if ($version1.EndsWith('_ptr') -and -not $version2.EndsWith('_ptr')) {
        return -1
    } elseif (-not $version1.EndsWith('_ptr') -and $version2.EndsWith('_ptr')) {
        return 1
    }

    return 0
}

# Loop through each directory and find the latest version
foreach ($dir in $directories) {
    $version = $dir.Name
    if ((Compare-Version $version $latestVersion) -gt 0) {
        $latestVersion = $version
    }
}

Write-Host $latestVersion
