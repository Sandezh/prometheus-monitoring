param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("add", "list", "remove")]
    $Action,

    [Parameter(Mandatory=$false)]
    $URL,

    [Parameter(Mandatory=$false)]
    $Env = "production"
)

$targetFile = "targets/targets.yml"

if ($Action -eq "list") {
    if (Test-Path $targetFile) {
        Get-Content $targetFile
    } else {
        Write-Host "No targets.yml found." -ForegroundColor Yellow
    }
} elseif ($Action -eq "add") {
    if (-not $URL) {
        Write-Host "Error: URL is required for 'add' action." -ForegroundColor Red
        exit
    }

    $newTarget = @"

- targets:
    - $URL
  labels:
    env: $Env
"@

    Add-Content -Path $targetFile -Value "$newTarget"
    Write-Host "Successfully added $URL to $targetFile" -ForegroundColor Green

} elseif ($Action -eq "remove") {
    if (-not $URL) {
        Write-Host "Error: URL is required for 'remove' action." -ForegroundColor Red
        exit
    }

    if (-not (Test-Path $targetFile)) {
        Write-Host "Error: $targetFile not found." -ForegroundColor Red
        exit
    }

    $content = Get-Content $targetFile -Raw
    
    # Pattern to match the target block including the preceding newline
    # This handles the block format and the extra newline we add
    $pattern = "(?ms)\r?\n\r?\n- targets:\r?\n\s+- $URL\r?\n\s+labels:\r?\n\s+env: $Env"
    
    if ($content -match $pattern) {
        $newContent = $content -replace [regex]::Escape($matches[0]), ""
        $newContent.TrimEnd() | Out-File -FilePath $targetFile -Encoding utf8
        Write-Host "Successfully removed $URL and its block from $targetFile" -ForegroundColor Green
    } else {
        # Try matching without the double newline just in case
        $patternSimple = "(?ms)- targets:\r?\n\s+- $URL\r?\n\s+labels:\r?\n\s+env: $Env"
        if ($content -match $patternSimple) {
            $newContent = $content -replace [regex]::Escape($matches[0]), ""
            $newContent.TrimEnd() | Out-File -FilePath $targetFile -Encoding utf8
            Write-Host "Successfully removed $URL from $targetFile" -ForegroundColor Green
        } else {
            Write-Host "Target $URL with env $Env not found in $targetFile" -ForegroundColor Yellow
        }
    }
}
