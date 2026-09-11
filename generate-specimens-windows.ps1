# Script to generate BDE test files
# Requires Windows 10 / Server 2016 or later for advanced storage/case-sensitivity features.

. .\shared_windows.ps1

$ErrorActionPreference = "Stop"

if (-not (Test-Path "specimens")) {
   New-Item -ItemType Directory -Path "specimens" | Out-Null
}

$UnitSize = 4096
$ImageSize = 64
$DriveLetter = "X"

$SecurePassword = ConvertTo-SecureString "BDEtest1" -AsPlainText -Force
$SecurePin = ConvertTo-SecureString "1234" -AsPlainText -Force

# Create an AES-128-CBC encrypted BDE image with NTFS.
$ImageName = "bde_aes128cbc.vhd"
$ImageFullPath = "${Pwd}\specimens\${ImageName}"

Write-Host "Creating: ${ImageName}" -foreground Yellow

CreateAndMountVhd -ImageFullPath ${ImageFullPath} -ImageSize ${ImageSize} -ImageType "fixed" -FileSystem "ntfs"
CreateTestFileEntriesExtended -DriveLetter ${DriveLetter}

Enable-BitLocker -MountPoint "${DriveLetter}:" -EncryptionMethod Aes128 -PasswordProtector -Password ${SecurePassword} | Out-Null

UnmountVhd -ImageFullPath ${ImageFullPath}

# Create an AES-256-CBC encrypted BDE image with NTFS.
$ImageName = "bde_aes256cbc.vhd"
$ImageFullPath = "${Pwd}\specimens\${ImageName}"

Write-Host "Creating: ${ImageName}" -foreground Yellow

CreateAndMountVhd -ImageFullPath ${ImageFullPath} -ImageSize ${ImageSize} -ImageType "fixed" -FileSystem "ntfs"
CreateTestFileEntriesExtended -DriveLetter ${DriveLetter}

Enable-BitLocker -MountPoint "${DriveLetter}:" -EncryptionMethod Aes256 -PasswordProtector -Password ${SecurePassword} | Out-Null

UnmountVhd -ImageFullPath ${ImageFullPath}

# Create an AES-128-XTS encrypted BDE image with NTFS.
$ImageName = "bde_aes128xts.vhd"
$ImageFullPath = "${Pwd}\specimens\${ImageName}"

Write-Host "Creating: ${ImageName}" -foreground Yellow

CreateAndMountVhd -ImageFullPath ${ImageFullPath} -ImageSize ${ImageSize} -ImageType "fixed" -FileSystem "ntfs"
CreateTestFileEntriesExtended -DriveLetter ${DriveLetter}

Enable-BitLocker -MountPoint "${DriveLetter}:" -EncryptionMethod XtsAes128 -PasswordProtector -Password ${SecurePassword} | Out-Null

UnmountVhd -ImageFullPath ${ImageFullPath}

# Create an AES-256-XTS encrypted BDE image with NTFS.
$ImageName = "bde_aes256xts.vhd"
$ImageFullPath = "${Pwd}\specimens\${ImageName}"

Write-Host "Creating: ${ImageName}" -foreground Yellow

CreateAndMountVhd -ImageFullPath ${ImageFullPath} -ImageSize ${ImageSize} -ImageType "fixed" -FileSystem "ntfs"
CreateTestFileEntriesExtended -DriveLetter ${DriveLetter}

Enable-BitLocker -MountPoint "${DriveLetter}:" -EncryptionMethod XtsAes256 -PasswordProtector -Password ${SecurePassword} | Out-Null

UnmountVhd -ImageFullPath ${ImageFullPath}

# Create an AES-128-CBC encrypted BDE image with NTFS and a recovery key protector.
$ImageName = "bde_aes128cbc_recovery_key.vhd"
$ImageFullPath = "${Pwd}\specimens\${ImageName}"

Write-Host "Creating: ${ImageName}" -foreground Yellow

CreateAndMountVhd -ImageFullPath ${ImageFullPath} -ImageSize ${ImageSize} -ImageType "fixed" -FileSystem "ntfs"
CreateTestFileEntriesExtended -DriveLetter ${DriveLetter}

Enable-BitLocker -MountPoint "${DriveLetter}:" -EncryptionMethod Aes128 -RecoveryKeyPath "${Pwd}\specimens\" -RecoveryKeyProtector | Out-Null

UnmountVhd -ImageFullPath ${ImageFullPath}

# Create an AES-128-CBC encrypted BDE image with NTFS and a recovery password protector.
$ImageName = "bde_aes128cbc_recovery_password.vhd"
$ImageFullPath = "${Pwd}\specimens\${ImageName}"

Write-Host "Creating: ${ImageName}" -foreground Yellow

CreateAndMountVhd -ImageFullPath ${ImageFullPath} -ImageSize ${ImageSize} -ImageType "fixed" -FileSystem "ntfs"
CreateTestFileEntriesExtended -DriveLetter ${DriveLetter}

Enable-BitLocker -MountPoint "${DriveLetter}:" -EncryptionMethod Aes128 -RecoveryPasswordProtector | Out-Null

$RecoveryKey = (Get-BitLockerVolume -MountPoint ${DriveLetter}).KeyProtector |
    Where-Object {$_.KeyProtectorType -eq "RecoveryPassword"} |
    Select-Object -ExpandProperty RecoveryPassword

$RecoveryKey | Out-File -FilePath  "${Pwd}\specimens\bde_aes128cbc_recovery_password.txt" -Force

UnmountVhd -ImageFullPath ${ImageFullPath}

# Create an AES-128-CBC encrypted BDE image with NTFS and a startup key protector.
$ImageName = "bde_aes128cbc_startup_key.vhd"
$ImageFullPath = "${Pwd}\specimens\${ImageName}"

Write-Host "Creating: ${ImageName}" -foreground Yellow

CreateAndMountVhd -ImageFullPath ${ImageFullPath} -ImageSize ${ImageSize} -ImageType "fixed" -FileSystem "ntfs"
CreateTestFileEntriesExtended -DriveLetter ${DriveLetter}

Enable-BitLocker -MountPoint "${DriveLetter}:" -EncryptionMethod Aes128 -StartupKeyProtector -StartupKeyPath "${Pwd}\specimens\" | Out-Null

UnmountVhd -ImageFullPath ${ImageFullPath}

# TODO: AdAccountOrGroupProtector
# Create an AES-128-CBC encrypted BDE image with NTFS and an account key protector.
# $ImageName = "bde_aes128cbc_account.vhd"
# $ImageFullPath = "${Pwd}\specimens\${ImageName}"
#
# Write-Host "Creating: ${ImageName}" -foreground Yellow
#
# CreateAndMountVhd -ImageFullPath ${ImageFullPath} -ImageSize ${ImageSize} -ImageType "fixed" -FileSystem "ntfs"
# CreateTestFileEntriesExtended -DriveLetter ${DriveLetter}
#
# Enable-BitLocker -MountPoint "${DriveLetter}:" -EncryptionMethod Aes128 -AdAccountOrGroup "Domain\User" -AdAccountOrGroupProtector | Out-Null
#
# UnmountVhd -ImageFullPath ${ImageFullPath}

$Tpm = Get-Tpm

if ($tpm.TpmPresent) {
    # Create an AES-128-CBC encrypted BDE image with NTFS and a TPM protector.
    $ImageName = "bde_aes128cbc_tpm.vhd"
    $ImageFullPath = "${Pwd}\specimens\${ImageName}"

    Write-Host "Creating: ${ImageName}" -foreground Yellow

    CreateAndMountVhd -ImageFullPath ${ImageFullPath} -ImageSize ${ImageSize} -ImageType "fixed" -FileSystem "ntfs"
    CreateTestFileEntriesExtended -DriveLetter ${DriveLetter}

    Enable-BitLocker -MountPoint "${DriveLetter}:" -EncryptionMethod Aes128 -TpmProtector | Out-Null

    UnmountVhd -ImageFullPath ${ImageFullPath}

    # Create an AES-128-CBC encrypted BDE image with NTFS and a TPM and pin protector.
    $ImageName = "bde_aes128cbc_tpm_and_pin.vhd"
    $ImageFullPath = "${Pwd}\specimens\${ImageName}"

    Write-Host "Creating: ${ImageName}" -foreground Yellow

    CreateAndMountVhd -ImageFullPath ${ImageFullPath} -ImageSize ${ImageSize} -ImageType "fixed" -FileSystem "ntfs"
    CreateTestFileEntriesExtended -DriveLetter ${DriveLetter}

    Enable-BitLocker -MountPoint "${DriveLetter}:" -EncryptionMethod Aes128 -TpmAndPinProtector -Pin $SecurePin | Out-Null

    UnmountVhd -ImageFullPath ${ImageFullPath}

    # TODO: TpmAndStartupKeyProtector
    # TODO: TpmAndPinAndStartupKeyProtector
}

# TODO: HardwareEncryption

# Create an AES-128-CBC encrypted BDE Used Space Only image with NTFS.
$ImageName = "bde_aes128_used_space.vhd"
$ImageFullPath = "${Pwd}\specimens\${ImageName}"

Write-Host "Creating: ${ImageName}" -foreground Yellow

CreateAndMountVhd -ImageFullPath ${ImageFullPath} -ImageSize ${ImageSize} -ImageType "expandable" -FileSystem "ntfs"
CreateTestFileEntriesExtended -DriveLetter ${DriveLetter}

Enable-BitLocker -MountPoint "${DriveLetter}:" -EncryptionMethod Aes128 -PasswordProtector -Password ${SecurePassword} -UsedSpaceOnly | Out-Null

UnmountVhd -ImageFullPath ${ImageFullPath}

# Create an AES-128-CBC encrypted BDE image with FAT.
$ImageName = "bde_aes128cbc_fat.vhd"
$ImageFullPath = "${Pwd}\specimens\${ImageName}"

Write-Host "Creating: ${ImageName}" -foreground Yellow

CreateAndMountVhd -ImageFullPath ${ImageFullPath} -ImageSize ${ImageSize} -ImageType "fixed" -FileSystem "fat"
CreateTestFileEntries -DriveLetter ${DriveLetter}

Enable-BitLocker -MountPoint "${DriveLetter}:" -EncryptionMethod Aes128 -PasswordProtector -Password ${SecurePassword} | Out-Null

UnmountVhd -ImageFullPath ${ImageFullPath}

# Create an AES-128-CBC encrypted BDE image with exFAT.
$ImageName = "bde_aes128cbc_exfat.vhd"
$ImageFullPath = "${Pwd}\specimens\${ImageName}"

Write-Host "Creating: ${ImageName}" -foreground Yellow

CreateAndMountVhd -ImageFullPath ${ImageFullPath} -ImageSize ${ImageSize} -ImageType "fixed" -FileSystem "exfat"
CreateTestFileEntries -DriveLetter ${DriveLetter}

Enable-BitLocker -MountPoint "${DriveLetter}:" -EncryptionMethod Aes128 -PasswordProtector -Password ${SecurePassword} | Out-Null

UnmountVhd -ImageFullPath ${ImageFullPath}

# ReFS - Appears to be not supported
