@echo off
rem Compila un directorio de build. Uso: build_dir.bat <builddir> [jobs]
call "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat" >nul || exit /b 1
set "VULKAN_SDK=C:\VulkanSDK\1.4.363.0"
set "PATH=%VULKAN_SDK%\Bin;%PATH%"
cd /d D:\lichii
set J=%2
if "%J%"=="" set J=16
cmake --build %1 -j %J%
