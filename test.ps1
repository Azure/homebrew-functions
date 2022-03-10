param (
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $MajorVersion,

    [Parameter(Mandatory=$true)]
    [AllowEmptyString()]
    [string]
    $FileSuffix
)

brew tap azure/functions
if (-not $?) { exit 1 }

brew install "./Formula/azure-functions-core-tools$FileSuffix.rb"
if (-not $?) { exit 1 }

$funcOutput = func --version
if (-not $?) { exit 1 }

$actualMajorVersion = ([version]$funcOutput.trim()).Major
if ($actualMajorVersion -ne $MajorVersion) {
    Write-Error "Expected: ""$MajorVersion"", Actual ""$actualMajorVersion"""
    exit 1
} else {
    Write-Output "func installed and version matched! 🎉"
}
