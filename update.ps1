param (
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $artifactsDirectoryRoot,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $version,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string] $consolidatedBuildId
)

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

    # Update consolidatedBuildId
    if ($content -match 'consolidatedBuildId = "(.*)"') {
        $oldConsolidatedBuildId = $Matches.1
        $content = $content.Replace($oldConsolidatedBuildId, $consolidatedBuildId)
    } else {
        throw "Failed to find consolidatedBuildId entry in ""$filePath"""
    }

    # Update sha for each arch
    foreach($arch in "osx-x64", "osx-arm64", "linux-x64") {
        if ($content -match "funcArch = ""$arch""\s*funcSha = ""(.*)""") {
            $oldSha = $Matches.1
            $dropLocation = "$artifactsDirectoryRoot/_core-tools-consolidated-artifacts.official/func-cli-$arch/coretools-cli"
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
