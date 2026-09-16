@echo off

rem Script to generate BDE test files
rem Requires Windows 7 or later with TPM (for manage-bde).

rem Split the output of ver e.g. "Microsoft Windows [Version 10.0.10586]"
rem and keep the last part "10.0.10586]".
for /f "tokens=1,2,3,4" %%a in ('ver') do (
	set version=%%d
)

rem Replace dots by spaces "10 0 10586]".
set version=%version:.= %

rem Split the last part of the ver output "10 0 10586]" and keep the first
rem 2 values formatted with a dot as separator "10.0".
for /f "tokens=1,2,*" %%a in ("%version%") do (
	set version=%%a.%%b
)

rem TODO add check for other supported versions of Windows
rem Also see: https://en.wikipedia.org/wiki/Ver_(command)

if not "%version%" == "10.0" (
	echo Unsupported Windows version: %version%

	exit /b 1
)

set specimenspath=specimens\%version%

if exist "%specimenspath%" (
	echo Specimens directory: %specimenspath% already exists.

	exit /b 1
)

mkdir "%specimenspath%"

rem Create a fixed-size VHD image with an AES 128-bit BDE encrypted volume with a password
set unitsize=4096
set imagename=bde_aes_128bit.vhd
set imagesize=64

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

rem This will ask for a password
manage-bde -On x: -DiscoveryVolumeType "[none]" -EncryptionMethod aes128 -Password -Synchronous

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with an AES 256-bit BDE encrypted volume with a password
set unitsize=4096
set imagename=bde_aes_256bit.vhd
set imagesize=64

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

rem This will ask for a password
manage-bde -On x: -DiscoveryVolumeType "[none]" -EncryptionMethod aes256 -Password -Synchronous

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with an AES-XTS 128-bit BDE encrypted volume with a password
set unitsize=4096
set imagename=bde_aes-xts_128bit.vhd
set imagesize=64

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

rem This will ask for a password
manage-bde -On x: -DiscoveryVolumeType "[none]" -EncryptionMethod xts_aes128 -Password -Synchronous

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with an AES-XTS 256-bit BDE encrypted volume with a password
set unitsize=4096
set imagename=bde_aes-xts_256bit.vhd
set imagesize=64

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

rem This will ask for a password
manage-bde -On x: -DiscoveryVolumeType "[none]" -EncryptionMethod xts_aes256 -Password -Synchronous

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with a BDE encrypted volume with a password and recovery password
set unitsize=4096
set imagename=bde_recovery_password.vhd
set imagesize=64

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

rem This will ask for a password
manage-bde -On x: -DiscoveryVolumeType "[none]" -Password -RecoveryPassword -Synchronous

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with a BDE encrypted volume with a password and recovery key
set unitsize=4096
set imagename=bde_recovery_key.vhd
set imagesize=64

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

rem This will ask for a password
manage-bde -On x: -DiscoveryVolumeType "[none]" -Password -RecoveryKey %cd%\%specimenspath% -Synchronous

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem Create a fixed-size VHD image with a BDE encrypted volume with a password and startup key
set unitsize=4096
set imagename=bde_startup_key.vhd
set imagesize=64

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

rem This will ask for a password
manage-bde -On x: -DiscoveryVolumeType "[none]" -Password -StartupKey %cd%\%specimenspath% -Synchronous

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

rem TODO: create image with -Certificate
rem TODO: create image with -TPMAndPIN
rem TODO: create image with -TPMAndStartupKey
rem TODO: create image with -TPMAndPINAndStartupKey
rem TODO: create image with -ADAccountOrGroup

rem Create a fixed-size VHD image with an AES 128-bit BDE encrypted volume with a discovery volume
set unitsize=4096
set imagename=bde_discovery_volume.vhd
set imagesize=64

echo create vdisk file=%cd%\%specimenspath%\%imagename% maximum=%imagesize% type=fixed > CreateVHD.diskpart
echo select vdisk file=%cd%\%specimenspath%\%imagename% >> CreateVHD.diskpart
echo attach vdisk >> CreateVHD.diskpart
echo convert mbr >> CreateVHD.diskpart
echo create partition primary >> CreateVHD.diskpart

echo format fs=ntfs label="TestVolume" unit=%unitsize% quick >> CreateVHD.diskpart

echo assign letter=x >> CreateVHD.diskpart

call :run_diskpart CreateVHD.diskpart

call :create_test_file_entries x

rem This will ask for a password
manage-bde -On x: -DiscoveryVolumeType "[default]" -Password -Synchronous

echo select vdisk file=%cd%\%specimenspath%\%imagename% > UnmountVHD.diskpart
echo detach vdisk >> UnmountVHD.diskpart

call :run_diskpart UnmountVHD.diskpart

exit /b 0

rem Creates test file entries
:create_test_file_entries
SETLOCAL
SET driveletter=%1

rem Create an empty file
type nul >> %driveletter%:\emptyfile

rem Create a directory
mkdir %driveletter%:\testdir1

rem Create a file that can be stored as inline data
echo My file > %driveletter%:\testdir1\testfile1

rem Create a file that cannot be stored as inline data
copy LICENSE %driveletter%:\testdir1\TestFile2

rem Create a file with a long filename
type nul >> "%driveletter%:\My long, very long file name, so very long"

rem Create a hard link to a file
mklink /H %driveletter%:\file_hardlink1 %driveletter%:\testdir1\testfile1

rem Create a symbolic link to a file
mklink %driveletter%:\file_symboliclink1 %driveletter%:\testdir1\testfile1

rem Create a junction (hard link to a directory)
mklink /J %driveletter%:\directory_junction1 %driveletter%:\testdir1

rem Create a symbolic link to a directory
mklink /D %driveletter%:\directory_symboliclink1 %driveletter%:\testdir1

rem Create a file with an alternative data stream (ADS)
type nul >> %driveletter%:\file_ads1
echo My file ADS > %driveletter%:\file_ads1:myads

rem Create a directory with an alternative data stream (ADS)
mkdir %driveletter%:\directory_ads1
echo My directory ADS > %driveletter%:\directory_ads1:myads

rem Create a file with valid data size set
copy LICENSE %driveletter%:\testdir1\file_valid_data_size1
fsutil file setValidData %driveletter%:\testdir1\file_valid_data_size1 18652

rem Create a file with short name set
echo My short file > %driveletter%:\testdir1\file_short_name1
fsutil file setShortName %driveletter%:\testdir1\file_short_name1 short1

rem Create a file with a sparse data run
copy LICENSE %driveletter%:\testdir1\file_sparse1
fsutil sparse setflag %driveletter%:\testdir1\file_sparse1
fsutil sparse setRange %driveletter%:\testdir1\file_sparse1 0 18000

rem Create a case-sensitive directory
rem This requires Microsoft-Windows-Subsystem-Linux to be enabled
rem Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
mkdir %driveletter%:\testdir2\normal
mkdir %driveletter%:\testdir2\sensitive
fsutil file setCaseSensitiveInfo %driveletter%:\testdir2\sensitive enable

echo My second file > %driveletter%:\testdir2\normal\testfile1
echo My second file > %driveletter%:\testdir2\sensitive\testfile1

echo My third file > %driveletter%:\testdir2\normal\TestFile1
echo My third file > %driveletter%:\testdir2\sensitive\TestFile1

ENDLOCAL
exit /b 0

rem Runs diskpart with a script
rem Note that diskpart requires Administrator privileges to run
:run_diskpart
SETLOCAL
set diskpartscript=%1

rem Note that diskpart requires Administrator privileges to run
diskpart /s %diskpartscript%

if %errorlevel% neq 0 (
	echo Failed to run: "diskpart /s %diskpartscript%"

	exit /b 1
)

del /q %diskpartscript%

rem Give the system a bit of time to adjust
choice /t 1 /d y > nul

ENDLOCAL
exit /b 0
