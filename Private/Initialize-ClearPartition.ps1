function Initialize-ClearPartition {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 99)]
        [Int32]$DiskNumber
    )
    try {
        Clear-Disk -Number $DiskNumber -RemoveData -RemoveOEM -Confirm:$false -ErrorAction Stop | Out-Null
        Write-Verbose "Partitions successfully removed."
    }   catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}