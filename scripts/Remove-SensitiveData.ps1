param(
    [Parameter(Mandatory=$true)]
    [string]$InputPath,
    [string]$OutputPath
)

if (-not (Test-Path $InputPath)) {
    Write-Error "Input file not found: $InputPath"
    exit 1
}

$content = Get-Content $InputPath -Raw

$patterns = @(
    '(?im)^(.*\buser(name)?\b\s*[=:]\s*)(.+)$',
    '(?im)^(.*\bpass(word)?\b\s*[=:]\s*)(.+)$',
    '(?im)^(.*\bserver(name)?\b\s*[=:]\s*)(.+)$',
    '(?im)^(.*\bpc(name)?\b\s*[=:]\s*)(.+)$'
)

foreach ($pattern in $patterns) {
    $content = [Regex]::Replace($content, $pattern, '$1[REDACTED]')
}

if ($OutputPath) {
    Set-Content -Path $OutputPath -Value $content
    Write-Host "Sanitized file written to $OutputPath"
} else {
    Set-Content -Path $InputPath -Value $content
    Write-Host "Sensitive data removed from $InputPath"
}
