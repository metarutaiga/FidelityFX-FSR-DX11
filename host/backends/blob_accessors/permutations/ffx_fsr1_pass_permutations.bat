@echo off
rem This file is part of the FidelityFX SDK.
rem 
rem Copyright (c) 2023 Advanced Micro Devices, Inc. All rights reserved.
rem 
rem Permission is hereby granted, free of charge, to any person obtaining a copy
rem of this software and associated documentation files (the "Software"), to deal
rem in the Software without restriction, including without limitation the rights
rem to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
rem copies of the Software, and to permit persons to whom the Software is
rem furnished to do so, subject to the following conditions:
rem The above copyright notice and this permission notice shall be included in
rem all copies or substantial portions of the Software.
rem 
rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
rem IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
rem FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
rem AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
rem LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
rem OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
rem THE SOFTWARE.

for %%a in (easu,rcas) do for %%b in (_,_16bit_) do for /L %%c in (0,1,1) do for /L %%d in (0,1,1) do for /L %%e in (0,1,1) do for /L %%f in (0,1,1) do call :gen %%a %%b %%c %%d %%e %%f
goto :eof

:gen
setlocal
set file=ffx_fsr1_%1_pass%2permutations_%3_%4_%5_%6.hlsl
if exist %file% goto :eof
echo %file%

echo // This file is part of the FidelityFX SDK.>%file%
echo // >%file%
echo // Copyright (c) 2023 Advanced Micro Devices, Inc. All rights reserved.>%file%
echo // >%file%
echo // Permission is hereby granted, free of charge, to any person obtaining a copy>%file%
echo // of this software and associated documentation files (the "Software"), to deal>%file%
echo // in the Software without restriction, including without limitation the rights>%file%
echo // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell>%file%
echo // copies of the Software, and to permit persons to whom the Software is>%file%
echo // furnished to do so, subject to the following conditions:>%file%
echo // The above copyright notice and this permission notice shall be included in>%file%
echo // all copies or substantial portions of the Software.>%file%
echo // >%file%
echo // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR>%file%
echo // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,>%file%
echo // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE>%file%
echo // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER>%file%
echo // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,>%file%
echo // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN>%file%
echo // THE SOFTWARE.>>%file%
echo.>>%file%
echo #define FFX_GPU 1 >>%file%
if /i %2==_ echo #define FFX_HALF 0 >>%file%
if /i %2==_16bit_ echo #define FFX_HALF 1 >>%file%
echo #define FFX_HLSL 1 >>%file%
echo.>>%file%
echo #define FFX_FSR1_OPTION_APPLY_RCAS %3 >>%file%
echo #define FFX_FSR1_OPTION_RCAS_PASSTHROUGH_ALPHA %4 >>%file%
echo #define FFX_FSR1_OPTION_RCAS_DENOISE %5 >>%file%
echo #define FFX_FSR1_OPTION_SRGB_CONVERSIONS %6 >>%file%
echo.>>%file%
echo #include "../../hlsl/fsr1/ffx_fsr1_%1_pass.hlsl">>%file%
