# Script to generate BDE test files
# Requires Windows 7 or later with Hyper-V

. .\shared_windows.ps1

$ErrorActionPreference = "Stop"
$SpecimensPath = "specimens"

if (-not (Test-Path "${SpecimensPath}")) {
   New-Item -ItemType Directory -Path "${SpecimensPath}" | Out-Null
}

$ImageSize = 256MB

$SecurePassword = ConvertTo-SecureString "BDEtest1" -AsPlainText -Force
$SecurePin = ConvertTo-SecureString "1234" -AsPlainText -Force

# Create an AES-128-CBC encrypted BDE image with NTFS using VHDX with sector sizes of logical 512 and physical 4096
$ImageName = "bde_aes128cbc_ntfs_l512_p4096.vhdx"
$ImageFullPath = "${Pwd}\${SpecimensPath}\${ImageName}"

Write-Host "Creating: ${ImageName}" -foreground Yellow

New-VHD -Path ${ImageFullPath} -LogicalSectorSizeBytes 512 -PhysicalSectorSizeBytes 4096 -SizeBytes 256MB

$VirtualDisk = Mount-VHD -Path ${ImageFullPath} -Passthru | Get-Disk

Initialize-Disk -Number ${VirtualDisk}.Number -PartitionStyle GPT 

New-Partition -DiskNumber ${VirtualDisk}.Number -UseMaximumSize -DriveLetter X

Format-Volume -DriveLetter X -FileSystem NTFS -Confirm:$False -Force

CreateTestFileEntriesExtended -DriveLetter "X"
   
Enable-BitLocker -MountPoint "X:" -EncryptionMethod Aes128 -PasswordProtector -Password ${SecurePassword} | Out-Null

Dismount-VHD -Path ${ImageFullPath}

# Create an AES-128-CBC encrypted BDE image with NTFS using VHDX with sector sizes of logical 4096 and physical 4096
$ImageName = "bde_aes128cbc_ntfs_l4096_p4096.vhdx"
$ImageFullPath = "${Pwd}\${SpecimensPath}\${ImageName}"

Write-Host "Creating: ${ImageName}" -foreground Yellow

New-VHD -Path ${ImageFullPath} -LogicalSectorSizeBytes 4096 -PhysicalSectorSizeBytes 4096 -SizeBytes 256MB

$VirtualDisk = Mount-VHD -Path ${ImageFullPath} -Passthru | Get-Disk

Initialize-Disk -Number ${VirtualDisk}.Number -PartitionStyle GPT 

New-Partition -DiskNumber ${VirtualDisk}.Number -UseMaximumSize -DriveLetter X

Format-Volume -DriveLetter X -FileSystem NTFS -Confirm:$False -Force

CreateTestFileEntriesExtended -DriveLetter "X"
   
Enable-BitLocker -MountPoint "X:" -EncryptionMethod Aes128 -PasswordProtector -Password ${SecurePassword} | Out-Null

Dismount-VHD -Path ${ImageFullPath}

# Create an AES-128-CBC encrypted BDE image with exFAT using VHDX with sector sizes of logical 512 and physical 4096
$ImageName = "bde_aes128cbc_exfat_l512_p4096.vhdx"
$ImageFullPath = "${Pwd}\${SpecimensPath}\${ImageName}"

Write-Host "Creating: ${ImageName}" -foreground Yellow

New-VHD -Path ${ImageFullPath} -LogicalSectorSizeBytes 512 -PhysicalSectorSizeBytes 4096 -SizeBytes 256MB

$VirtualDisk = Mount-VHD -Path ${ImageFullPath} -Passthru | Get-Disk

Initialize-Disk -Number ${VirtualDisk}.Number -PartitionStyle GPT 

New-Partition -DiskNumber ${VirtualDisk}.Number -UseMaximumSize -DriveLetter X

Format-Volume -DriveLetter X -FileSystem exFAT -Confirm:$False -Force

CreateTestFileEntries -DriveLetter "X"
   
Enable-BitLocker -MountPoint "X:" -EncryptionMethod Aes128 -PasswordProtector -Password ${SecurePassword} | Out-Null

Dismount-VHD -Path ${ImageFullPath}

# Create an AES-128-CBC encrypted BDE image with exFAT using VHDX with sector sizes of logical 4096 and physical 4096
$ImageName = "bde_aes128cbc_exfat_l4096_p4096.vhdx"
$ImageFullPath = "${Pwd}\${SpecimensPath}\${ImageName}"

Write-Host "Creating: ${ImageName}" -foreground Yellow

New-VHD -Path ${ImageFullPath} -LogicalSectorSizeBytes 4096 -PhysicalSectorSizeBytes 4096 -SizeBytes 256MB

$VirtualDisk = Mount-VHD -Path ${ImageFullPath} -Passthru | Get-Disk

Initialize-Disk -Number ${VirtualDisk}.Number -PartitionStyle GPT 

New-Partition -DiskNumber ${VirtualDisk}.Number -UseMaximumSize -DriveLetter X

Format-Volume -DriveLetter X -FileSystem exFAT -Confirm:$False -Force

CreateTestFileEntries -DriveLetter "X"
   
Enable-BitLocker -MountPoint "X:" -EncryptionMethod Aes128 -PasswordProtector -Password ${SecurePassword} | Out-Null

Dismount-VHD -Path ${ImageFullPath}
