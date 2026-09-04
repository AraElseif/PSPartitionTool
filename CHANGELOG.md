# Changelog

All notable changes to PSPartitionTool are documented in this file.

## [Unreleased]

Changes planned for the next release.

## [0.1.0] - 2026-09-02

### Added

- Public `New-PartitionDisk` command for preparing a selected disk.
- Support for creating one or two partitions.
- Support for the `NTFS` and `Exfat` file systems.
- Optional labels for the new partitions.
- Automatic GPT initialization for RAW and unknown disks.
- Automatic conversion of MBR disks to GPT.
- Automatic drive-letter assignment for new partitions.
- Validation that the selected disk exists and is not a system or boot disk.
- Optional `-Force` switch for bypassing system and boot disk protections.
- Support for `-WhatIf`, `-Confirm`, and `-Verbose`.

### Private Functions

- Added `Test-Disk` to verify that the selected disk exists and is not a system or boot disk,
  unless `-Force` is specified.
- Added `Initialize-ClearPartition` to remove existing data and OEM partitions from the disk.
- Added `Initialize-CheckPartition` to initialize or convert the disk to the GPT partition style.
- Added `Initialize-NewPartition` to create one or two partitions, assign drive letters, and format them with the selected file system  and label.

### Documentation

- Added README usage, parameter, behavior, and requirements documentation.
- Added comment-based help for `New-PartitionDisk`.
