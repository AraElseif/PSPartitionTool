# PSPartitionTool

PowerShell module for erasing and preparing a non-system disk. It removes existing data
and OEM partitions, configures the disk with the GPT partition style, and creates one or
two NTFS or exFAT partitions.

> WARNING: `New-PartitionDisk` is destructive. All data and OEM partitions on the selected
> disk are removed. Verify the disk number and back up required data before continuing.

## Usage

Import the module and call its public function:

```powershell
Import-Module .\PSPartitionTool.psd1
New-PartitionDisk -DiskNumber 2 -Filesystem NTFS -PartitionCount 1 -Name Data
```

Create two approximately equal partitions:

```powershell
New-PartitionDisk -DiskNumber 2 -Filesystem Exfat -PartitionCount 2 -Name Backup -Verbose
```

Preview the operation without changing the disk:

```powershell
New-PartitionDisk -DiskNumber 2 -Filesystem NTFS -PartitionCount 1 -WhatIf
```

Use `-Force` only when the system or boot disk is intentionally being erased. The command
also supports `-Confirm` and `-Verbose`.

## Parameters

| Parameter         | Required | Description |
|.......................|..........|.............|
| **DiskNumber**        | Yes      | Disk number to process, from 0 to 99. |
| **Filesystem**        | Yes      | `NTFS` or `Exfat`. |
| **PartitionCount**    | Yes      | `1` for all available space or `2` for two approximately equal partitions. |
| **Name**              | No       | Label applied to each new partition. |
| **Force**             | No       | Bypasses the system and boot disk checks. |

For exFAT, labels longer than 11 characters generate a warning. The current implementation
continues and passes the label to `Format-Volume`, so use an 11-character label or shorter.

## Behavior and Requirements

- Disks containing the operating system or boot partition are rejected unless `-Force` is used.
- Existing data and OEM partitions are removed with `Clear-Disk`.
- RAW and unknown disks are initialized as GPT; MBR disks are converted to GPT.
- New partitions receive drive letters automatically and are formatted immediately.
- Windows PowerShell 5.1 or PowerShell 7 is required.
- Run PowerShell with administrator privileges.
- The Storage module and its disk cmdlets must be available.

## Documentation

For the complete command reference, run:

```powershell
Get-Help New-PartitionDisk -Full
```

## Author

**AraElseif**

## Repository

GitHub: [github.com/AraElseif/PSPartitionTool](https://github.com/AraElseif/PSPartitionTool)

See [CHANGELOG.md](CHANGELOG.md) for the version history.
