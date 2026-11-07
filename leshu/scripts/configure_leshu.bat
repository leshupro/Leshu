@echo off
rem Leshu: PGO + ThinLTO, generic x86-64-v3 (AVX2). Uso: configure_leshu.bat gen ^| use
rem   gen -> build-leshugen (instrumentado)   use -> build-leshu (pgo\v3.profdata, ThinLTO)
call "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat" >nul || exit /b 1
set "VULKAN_SDK=C:\VulkanSDK\1.4.363.0"
set "PATH=%VULKAN_SDK%\Bin;%PATH%"
set "LLVM=C:/Program Files/Microsoft Visual Studio/18/Community/VC/Tools/Llvm/x64"
if "%2"=="" (set "PROFILE=v3.profdata") else (set "PROFILE=%2")
set "BASEFLAGS=/O2 /DNDEBUG /Z7 /DNOMINMAX -march=x86-64-v3 /D_USE_STD_VECTOR_ALGORITHMS=0"
if "%1"=="gen" (
  set "DIR=build-leshugen"
  set "EXTRA=-fprofile-instr-generate"
  set "LINKEXTRA=D:/lichii/pgo/clang_rt.profile-x86_64.lib"
  set "LTO=OFF"
) else (
  set "DIR=build-leshu"
  set "EXTRA=-fprofile-instr-use=D:/lichii/pgo/%PROFILE% -Wno-profile-instr-unprofiled -Wno-profile-instr-out-of-date -Wno-backend-plugin"
  set "LINKEXTRA="
  set "LTO=ON"
)
cd /d D:\lichii
cmake -S v3src -B %DIR% -G Ninja ^
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
