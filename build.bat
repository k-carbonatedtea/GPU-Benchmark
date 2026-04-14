@echo off
REM One-click build script for GPU Benchmark

echo =============================================
echo   GPU Benchmark - One-Click Build
echo =============================================
echo.

REM Check if we're in the right directory
if not exist "CMakeLists.txt" (
    echo ERROR: CMakeLists.txt not found!
    echo Please run this script from the GPU-Benchmark directory
    pause
    exit /b 1
)

REM Set CUDA Toolkit environment variable (required for MSBuild CUDA targets)
set "CUDA_PATH_V13_2=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v13.2"
set "CUDA_PATH=%CUDA_PATH_V13_2%"

if not exist "%CUDA_PATH_V13_2%\bin\nvcc.exe" (
    echo ERROR: CUDA Toolkit v13.2 not found at %CUDA_PATH_V13_2%
    pause
    exit /b 1
)

echo Using CUDA: %CUDA_PATH_V13_2%

REM Check for Visual Studio
if not exist "%VSINSTALLDIR%" (
    echo WARNING: Visual Studio not found.
    echo Please run from "Developer Command Prompt for VS 2022"
    echo.
)

echo [1/3] Cleaning previous build...
rmdir /s /q build 2>nul
mkdir build
cd build

echo.
echo [2/3] Configuring with CMake...
cmake -G "Visual Studio 17 2022" -A x64 ..
if errorlevel 1 (
    echo ERROR: CMake configuration failed!
    cd ..
    pause
    exit /b 1
)

echo.
echo [3/3] Building Release version...
cmake --build . --config Release
if errorlevel 1 (
    echo ERROR: Build failed!
    cd ..
    pause
    exit /b 1
)

cd ..

echo.
echo =============================================
echo   Build Complete!
echo =============================================
echo.
echo Executables:
echo   CLI:  build\Release\GPU-Benchmark.exe
echo   GUI:  build\Release\GPU-Benchmark-GUI.exe
echo.
echo =============================================
echo.

pause
