function Test-Disk{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 99)]
        [Int32]$DiskNumber,

        [Switch]$Force
    )
    $DiskInfo = Get-Disk -Number $DiskNumber -ErrorAction SilentlyContinue
    if (-not $DiskInfo) {
        return $false
    }
    if (-not $force -and ($DiskInfo.IsSystem -or $DiskInfo.IsBoot)) {
        return $false
    }
    Write-Verbose "Correctly checked the disc."
    return $true
}