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

for %%a in (_compute_game_vector_field_inpainting_pyramid_,_compute_inpainting_pyramid_,_debug_view_,_disocclusion_mask_,_game_motion_vector_field_,_inpainting_,_optical_flow_vector_field_,_,_reconstruct_previous_depth_,_setup_) do (
  for %%b in (_,_16bit_) do (
    call :header %%a %%b
    for /L %%c in (0,1,1) do (
      call :hlsl %%a %%b %%c
    )
  )
)
goto :eof

:license
echo // This file is part of the FidelityFX SDK.>%1
echo // >>%1
echo // Copyright (c) 2023 Advanced Micro Devices, Inc. All rights reserved.>>%1
echo // >>%1
echo // Permission is hereby granted, free of charge, to any person obtaining a copy>>%1
echo // of this software and associated documentation files (the "Software"), to deal>>%1
echo // in the Software without restriction, including without limitation the rights>>%1
echo // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell>>%1
echo // copies of the Software, and to permit persons to whom the Software is>>%1
echo // furnished to do so, subject to the following conditions:>>%1
echo // The above copyright notice and this permission notice shall be included in>>%1
echo // all copies or substantial portions of the Software.>>%1
echo // >>%1
echo // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR>>%1
echo // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,>>%1
echo // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE>>%1
echo // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER>>%1
echo // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,>>%1
echo // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN>>%1
echo // THE SOFTWARE.>>%1
echo.>>%1
echo.>>%1
goto :eof

:hlsl
setlocal
set file=ffx_frameinterpolation%1pass%2permutations_%3.hlsl
if exist %file% goto :eof
echo %file%

call :license %file%
echo #define FFX_GPU 1 >>%file%
if /i %1==_ echo #define FFX_HALF 0 >>%file%
if /i %1==_16bit_ echo #define FFX_HALF 1 >>%file%
echo #define FFX_HLSL 1 >>%file%
echo.>>%file%
echo #define FFX_SPD_NO_WAVE_OPERATIONS >>%file%
echo.>>%file%
echo #define FFX_FRAMEINTERPOLATION_OPTION_UPSAMPLE_SAMPLERS_USE_DATA_HALF 0 >>%file%
echo #define FFX_FRAMEINTERPOLATION_OPTION_ACCUMULATE_SAMPLERS_USE_DATA_HALF 0 >>%file%
echo #define FFX_FRAMEINTERPOLATION_OPTION_REPROJECT_SAMPLERS_USE_DATA_HALF 1 >>%file%
echo #define FFX_FRAMEINTERPOLATION_OPTION_POSTPROCESSLOCKSTATUS_SAMPLERS_USE_DATA_HALF 0 >>%file%
echo #define FFX_FRAMEINTERPOLATION_OPTION_UPSAMPLE_USE_LANCZOS_TYPE 2 >>%file%
echo.>>%file%
echo #define FFX_FRAMEINTERPOLATION_OPTION_INVERTED_DEPTH %3 >>%file%
echo.>>%file%
echo #include "../../hlsl/frameinterpolation/ffx_frameinterpolation%1pass.hlsl">>%file%
goto :eof

:header
setlocal
set file=ffx_frameinterpolation%1pass%2permutations.h
if exist %file% goto :eof
echo %file%

call :license %file%
echo typedef unsigned char BYTE;>>%file%
echo.>>%file%
echo #include "ffx_frameinterpolation%1pass%2permutations_0.h">>%file%
echo #include "ffx_frameinterpolation%1pass%2permutations_1.h">>%file%
echo.>>%file%
echo static const struct { const uint8_t* data; uint32_t size; } g_ffx_frameinterpolation%1pass%2permutations[2] = {>>%file%
echo     { g_ffx_frameinterpolation%1pass%2permutations_0, sizeof(g_ffx_frameinterpolation%1pass%2permutations_0) },>>%file%
echo     { g_ffx_frameinterpolation%1pass%2permutations_1, sizeof(g_ffx_frameinterpolation%1pass%2permutations_1) },>>%file%
echo };>>%file%
goto :eof
