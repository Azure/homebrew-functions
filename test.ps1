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

$tap = "azure/functions"

# 1) Create the tap (no git repo needed for local use)
brew tap-new --no-git $tap
if (-not $?) { exit 1 }

# 2) Copy formula file into the tap's Formula directory
$tapRepo = (brew --repo $tap).Trim()
if (-not $?) { exit 1 }

$src = "./Formula/azure-functions-core-tools$FileSuffix.rb"
$dst = Join-Path $tapRepo "Formula/azure-functions-core-tools$FileSuffix.rb"

Copy-Item $src $dst -Force
if (-not $?) { exit 1 }

# 3) Install the formula from the tap (no .rb path; use tap/name)
brew install "$tap/azure-functions-core-tools$FileSuffix"
if (-not $?) { exit 1 }

# 4) Verify installation and version
$funcOutput = func --version
if (-not $?) { exit 1 }

Write-Host "func --version output: $funcOutput"

$actualMajorVersion = ([version]$funcOutput.trim()).Major
if ($actualMajorVersion -ne $MajorVersion) {
    Write-Error "Expected: ""$MajorVersion"", Actual ""$actualMajorVersion"""
    exit 1
} else {
    Write-Output "func installed and version matched! 🎉"
}
