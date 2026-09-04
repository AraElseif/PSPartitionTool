function New-PartitionDisk {
<#
.SYNOPSIS
Creates and formats one or two partitions on a selected disk.

.DESCRIPTION
Removes all data and OEM partitions from the selected disk, configures it with the GPT
partition style, and creates one or two partitions formatted with NTFS or exFAT. The
selected disk must not contain the operating system or boot partition unless -Force is
specified.

This operation is destructive. Confirm the disk number and back up any required data
before running the command. Administrator privileges are required.

.PARAMETER DiskNumber
Specifies the number of the disk to erase and partition. Valid values range from 0 to 99.

.PARAMETER Filesystem
Specifies the file system for the new partition or partitions. Valid values are NTFS and
Exfat.

.PARAMETER PartitionCount
Specifies whether to create one partition using the available space or two partitions
of approximately equal size.

.PARAMETER Name
Specifies the file system label applied to each new partition. For exFAT, labels longer
than 11 characters produce a warning and are still passed to Format-Volume.

.PARAMETER Force
Allows processing a disk marked as a system or boot disk. This switch bypasses only those
two protections; it does not guarantee that the disk can be cleared safely.

.EXAMPLE
New-PartitionDisk -DiskNumber 2 -Filesystem NTFS -PartitionCount 1 -Name Data

Erases disk 2 and creates one NTFS partition using the available space.

.EXAMPLE
New-PartitionDisk -DiskNumber 2 -Filesystem Exfat -PartitionCount 2 -Name Backup -Verbose

Erases disk 2 and creates two approximately equal exFAT partitions labelled Backup.

.EXAMPLE
New-PartitionDisk -DiskNumber 2 -Filesystem NTFS -PartitionCount 1 -WhatIf

Previews the operation without modifying disk 2.

.EXAMPLE
New-PartitionDisk -DiskNumber 0 -Filesystem NTFS -PartitionCount 1 -Force -Confirm

Requests confirmation before processing a system or boot disk.

.NOTES
Requires the Storage module and administrative privileges. Supports -WhatIf, -Confirm,
and -Verbose through CmdletBinding.
#>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
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

        [String]$Name,

        [Switch]$Force
    )
    $DiskInfo = Get-Disk -Number $DiskNumber -ErrorAction SilentlyContinue
    if ($Force) {
        Write-Warning "-Force has been enabled. System and boot volume protections will be bypassed."
    }
    if (-not (Test-Disk -DiskNumber $DiskNumber -Force:$Force)) {
        throw "The indicated disk is not recognized, or the partitions cannot be removed."
    }
    if ($PSCmdlet.ShouldProcess("Disk $($DiskInfo.Number) - $($DiskInfo.FriendlyName) - Serial: $($DiskInfo.SerialNumber)", "All partitions will be removed.")) {
        try {
            Initialize-ClearPartition `
                -DiskNumber $DiskNumber

            Initialize-CheckPartition `
                -DiskNumber $DiskNumber

            Initialize-NewPartition `
                -DiskNumber $DiskNumber `
                -PartitionCount $PartitionCount `
                -FileSystem $Filesystem `
                -Name $Name
        }   catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}