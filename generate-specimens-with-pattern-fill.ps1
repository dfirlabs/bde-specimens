# Script to generate BDE test files
# Requires Windows 10 / Server 2016 or later for advanced storage/case-sensitivity features.

. .\shared_windows.ps1

$ErrorActionPreference = "Stop"

if (-not (Test-Path "specimens")) {
   New-Item -ItemType Directory -Path "specimens" | Out-Null
}

$BytesPerSector = 512
$UnitSize = 4096
$ImageSize = 64
$DriveLetter = "X"

$SecurePassword = ConvertTo-SecureString "BDEtest1" -AsPlainText -Force
$SecurePin = ConvertTo-SecureString "1234" -AsPlainText -Force

# Create an AES-128-CBC encrypted BDE Used Space Only image with NTFS.
$ImageName = "bde_pattern_fill.vhd"
$ImageFullPath = "${Pwd}\specimens\${ImageName}"

Write-Host "Creating: ${ImageName}" -foreground Yellow

CreateAndMountVhd -ImageFullPath ${ImageFullPath} -ImageSize ${ImageSize} -ImageType "fixed" -FileSystem "ntfs"

$DriveInfo = Get-PSDrive -Name ${DriveLetter}
$FreeSpaceBytes = ${DriveInfo}.Free

# Fill the free space with patterns, this is to observe the behavior of the BDE relocation log.
if (${FreeSpaceBytes} -gt 0) {
    $TempFilePath = Join-Path "${DriveLetter}:\" "sector_fill.tmp"
    
    $BufferSize = 4 * 1024 * 1024
    $Buffer = New-Object Byte[] $BufferSize
    
    $FileStream = [System.IO.File]::OpenWrite(${TempFilePath})
    $TotalWriteCount = 0
    
    while (${TotalWriteCount} -lt ${FreeSpaceBytes}) {
        $Remaining = ${FreeSpaceBytes} - ${TotalWriteCount}
        $WriteSize = [Math]::Min(${BufferSize}, $Remaining)
        
        for ($BufferOffset = 0; $BufferOffset -lt ${WriteSize}; $BufferOffset++) {
            $ImageOffset = ${TotalWriteCount} + ${BufferOffset}
            
            $SectorIndex = [Math]::Floor(${ImageOffset} / ${BytesPerSector})
            
            $Buffer[${BufferOffset}] = [byte](${SectorIndex} -band 0xFF)
        }
        try {
            $FileStream.Write(${Buffer}, 0, ${WriteSize})
            $TotalWriteCount += ${WriteSize}
        }
        catch {
            break
        }
    }
    $FileStream.Close()
    $FileStream.Dispose()
    
    if (Test-Path ${TempFilePath}) {
        Remove-Item ${TempFilePath} -Force
    }
}

CreateTestFileEntriesExtended -DriveLetter ${DriveLetter}

Enable-BitLocker -MountPoint "${DriveLetter}:" -EncryptionMethod Aes128 -PasswordProtector -Password ${SecurePassword} -UsedSpaceOnly | Out-Null

UnmountVhd -ImageFullPath ${ImageFullPath}
