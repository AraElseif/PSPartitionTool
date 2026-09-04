function Initialize-NewPartition {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 99)]
        [Int32]$DiskNumber,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Exfat', 'NTFS')]
        [String]$Filesystem,

        [Parameter(Mandatory = $true)]
        [ValidateRange(1, 2)]
        [Int32]$PartitionCount,

        [String]$Name
    )
    $Disk = Get-Disk -Number $DiskNumber -ErrorAction Stop
    $HalfSize = [math]::Floor($disk.Size / 2)
    if ($Filesystem -eq 'Exfat' -and $Name.Length -gt 11) {
        Write-Warning "You cannot enter more than 11 characters for the label in the exFat format."
    }
    $PartitionSizes = switch ($PartitionCount) {
        1 {
            @(0)
        }
        2 {
            @($HalfSize, 0)
        }
    }
    foreach ($PartitionSize in $PartitionSizes) {
        $PartitionParameters = @{
            DiskNumber        = $DiskNumber
            AssignDriveLetter = $true
        }
        if ($PartitionSize -eq 0) {
            $PartitionParameters.UseMaximumSize = $true
        }
        else {
            $PartitionParameters.Size = $PartitionSize
        }
        try {
            New-Partition @PartitionParameters -ErrorAction Stop |
                Format-Volume -FileSystem $Filesystem -NewFileSystemLabel $Name -ErrorAction Stop |
                    Out-Null
        }   catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
        Write-Verbose "$PartitionCount partition(s) created and formatted successfully."
    }
}