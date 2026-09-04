function Initialize-CheckPartition {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, 10)]
        [Int32]$DiskNumber
    )
    $Partition = (Get-Disk -Number $DiskNumber -ErrorAction SilentlyContinue).PartitionStyle
    try {
        switch ($Partition) {
            'RAW' {
                Write-Verbose "Initializing the disk using the GPT partition style."
                    Initialize-Disk -Number $DiskNumber -PartitionStyle GPT -ErrorAction Stop | Out-Null
            }
            'Unknown' {
                Write-Verbose "Initializing the disk using the GPT partition style."
                    Initialize-Disk -Number $DiskNumber -PartitionStyle GPT -ErrorAction Stop | Out-Null
            }
            'MBR' {
                Write-Verbose "Converting the partition style from MBR to GPT."
                    Get-Disk -Number $DiskNumber | Set-Disk -PartitionStyle GPT -ErrorAction Stop | Out-Null
            }
            'GPT' {
                Write-Verbose "The disk already uses the GPT partition style."
            }
        }
    }   catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}