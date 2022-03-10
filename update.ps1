param (
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $dropLocation
)

$files= Get-ChildItem -Recurse -Path "$dropLocation"

foreach($file in $files)
{
    if ($file.FullName -match '\.([0-9]+\.[0-9]+\.[0-9]+)\.zip$')
    {
        $version = $Matches.1
        Write-Host "New func version: ""$version"""
        break
    }
}

if (-Not $version) {
    throw "Failed to determine new func version from drop ""$dropLocation"""
}

function updateFormula([string]$fileSuffix) {
    $filePath = "./Formula/azure-functions-core-tools$fileSuffix.rb"
    $content = Get-Content $filePath -Raw

    # Update version
    if ($content -match 'funcVersion = "(.*)"') {
        $oldVersion = $Matches.1
        $content = $content.Replace($oldVersion, $version)
    } else {
        throw "Failed to find funcVersion entry in ""$filePath"""
    }

    # Update sha for each arch
    foreach($arch in "osx-x64", "linux-x64") {
        if ($content -match "funcArch = ""$arch""\s*funcSha = ""(.*)""") {
            $oldSha = $Matches.1
            $shaPath = Join-Path $dropLocation "Azure.Functions.Cli.$arch.$version.zip.sha2"
            $sha = Get-Content -Path $shaPath
            $content = $content.Replace($oldSha, $sha)
        } else {
            Write-Host "Skipping arch ""$arch"", not found in ""$filePath"""
        }
    }

    Set-Content -Path $filePath -Value $content -NoNewline
    Write-Host "Updated formula $filePath"
}

$majorVersion=([version]$version).Major

updateFormula "@$majorVersion"

# Also update files with legacy suffixes
if($majorVersion -eq "2")
{
    updateFormula ""
}
elseif($majorVersion -eq "3")
{
    updateFormula "-v3-preview"
}
