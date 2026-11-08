@echo off
rem Leshu 5 (zortos293/Lichii base). Uso: configure_z.bat <builddir> <profile|gen|none>
rem   <profile> = ruta .profdata (PGO use), gen = instrumentado, none = sin PGO. Sin -march (x86-64 generico, como la oficial).
call "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat" >nul || exit /b 1
set "VULKAN_SDK=C:\VulkanSDK\1.4.363.0"
set "PATH=%VULKAN_SDK%\Bin;%PATH%"
set "CPM_SOURCE_CACHE=D:/lichii/v3src/.cache/cpm"
set "LLVM=C:/Program Files/Microsoft Visual Studio/18/Community/VC/Tools/Llvm/x64"
set "BASEFLAGS=/O2 /DNDEBUG /Z7 /DNOMINMAX /D_USE_STD_VECTOR_ALGORITHMS=0"
set "LINKEXTRA="
set "LTO=ON"
if "%2"=="gen" (
  set "EXTRA=-fprofile-instr-generate"
  set "LINKEXTRA=D:/lichii/pgo/clang_rt.profile-x86_64.lib"
  set "LTO=OFF"
) else if "%2"=="none" (
  set "EXTRA="
) else (
  set "EXTRA=-fprofile-instr-use=%2 -Wno-profile-instr-unprofiled -Wno-profile-instr-out-of-date -Wno-backend-plugin"
)
cd /d D:\lichii
cmake -S zsrc -B %1 -G Ninja ^
  -DCMAKE_BUILD_TYPE=Release ^
  "-DCMAKE_C_COMPILER=%LLVM%/bin/clang-cl.exe" "-DCMAKE_CXX_COMPILER=%LLVM%/bin/clang-cl.exe" ^
  "-DCMAKE_LINKER=%LLVM%/bin/lld-link.exe" "-DCMAKE_AR=%LLVM%/bin/llvm-lib.exe" ^
  "-DCMAKE_C_FLAGS_RELEASE=%BASEFLAGS% %EXTRA%" ^
  "-DCMAKE_CXX_FLAGS_RELEASE=%BASEFLAGS% %EXTRA%" ^
  "-DCMAKE_EXE_LINKER_FLAGS_RELEASE=/DEBUG:FULL /OPT:REF /OPT:ICF %LINKEXTRA%" ^
  -DENABLE_LTO=%LTO% ^
  -DBUILD_TESTING=OFF -DYUZU_TESTS=OFF ^
  -DYUZU_CMD=ON -DYUZU_ROOM=OFF -DYUZU_ROOM_STANDALONE=OFF ^
  -DYUZU_USE_BUNDLED_QT=ON -DYUZU_USE_BUNDLED_SDL3=ON ^
  -DVulkanHeaders_FORCE_BUNDLED=ON -DVulkanUtilityLibraries_FORCE_BUNDLED=ON ^
  -DENABLE_UPDATE_CHECKER=OFF -DUSE_DISCORD_PRESENCE=OFF -DENABLE_WERROR=OFF
