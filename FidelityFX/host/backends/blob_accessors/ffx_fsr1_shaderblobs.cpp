// This file is part of the FidelityFX SDK.
//
// Copyright (C) 2024 Advanced Micro Devices, Inc.
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and /or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#include <FidelityFX/host/ffx_util.h>
#include "ffx_fsr1_shaderblobs.h"
#include "fsr1/ffx_fsr1_private.h"

#include "permutations/ffx_fsr1_easu_pass_permutations.h"
#include "permutations/ffx_fsr1_rcas_pass_permutations.h"

#include "permutations/ffx_fsr1_easu_pass_16bit_permutations.h"
#include "permutations/ffx_fsr1_rcas_pass_16bit_permutations.h"

#include <string.h> // for memset

static FfxShaderBlob fsr1GetEasuPassPermutationBlobByIndex(uint32_t permutationOptions, bool isWave64, bool is16bit)
{
    int APPLY_RCAS = FFX_CONTAINS_FLAG(permutationOptions, FSR1_SHADER_PERMUTATION_APPLY_RCAS);
    int RCAS_PASSTHROUGH_ALPHA = FFX_CONTAINS_FLAG(permutationOptions, FSR1_SHADER_PERMUTATION_RCAS_PASSTHROUGH_ALPHA);
    int SRGB_CONVERSIONS = FFX_CONTAINS_FLAG(permutationOptions, FSR1_SHADER_PERMUTATION_SRGB_CONVERSIONS);

    // Name                                 Type  Format         Dim      HLSL Bind  Count
    // ------------------------------ ---------- ------- ----------- -------------- ------
    // r_input_color                     texture  float4          2d             t0      1 
    // rw_upscaled_output                    UAV  float4          2d             u1      1 
    // rw_internal_upscaled_color            UAV  float4          2d             u0      1 
    // cbFSR1                            cbuffer      NA          NA            cb0      1 
    static const char* boundConstantBufferNames[] = { "cbFSR1" };
    static const uint32_t boundConstantBuffers[] = { 0 };
    static const uint32_t boundConstantBufferCounts[] = { 1 };
    static const uint32_t boundConstantBufferSpaces[] = { 0 };
    static const char* boundSRVTextureNames[] = { "r_input_color" };
    static const uint32_t boundSRVTextures[] = { 0 };
    static const uint32_t boundSRVTextureCounts[] = { 1 };
    static const uint32_t boundSRVTextureSpaces[] = { 0 };
    static const char* boundUAVTextureNames[2][1] = { { "rw_upscaled_output" }, { "rw_internal_upscaled_color" } };
    static const uint32_t boundUAVTextures[2][1] = { { 1 }, { 0 } };
    static const uint32_t boundUAVTextureCounts[] = { 1 };
    static const uint32_t boundUAVTextureSpaces[] = { 0 };

    FfxShaderBlob blob = {
        is16bit ? g_ffx_fsr1_easu_pass_16bit_permutations[APPLY_RCAS][RCAS_PASSTHROUGH_ALPHA][SRGB_CONVERSIONS].data
                : g_ffx_fsr1_easu_pass_permutations[APPLY_RCAS][RCAS_PASSTHROUGH_ALPHA][SRGB_CONVERSIONS].data,
        is16bit ? g_ffx_fsr1_easu_pass_16bit_permutations[APPLY_RCAS][RCAS_PASSTHROUGH_ALPHA][SRGB_CONVERSIONS].size
                : g_ffx_fsr1_easu_pass_permutations[APPLY_RCAS][RCAS_PASSTHROUGH_ALPHA][SRGB_CONVERSIONS].size,
        __crt_countof(boundConstantBufferNames),
        __crt_countof(boundSRVTextureNames),
        __crt_countof(boundUAVTextureNames[0]),
        0,
        0,
        0,
        0,
        boundConstantBufferNames,
        boundConstantBuffers,
        boundConstantBufferCounts,
        boundConstantBufferSpaces,
        boundSRVTextureNames,
        boundSRVTextures,
        boundSRVTextureCounts,
        boundSRVTextureSpaces,
        boundUAVTextureNames[APPLY_RCAS],
        boundUAVTextures[APPLY_RCAS],
        boundUAVTextureCounts,
        boundUAVTextureSpaces,
    };

    return blob;
}

static FfxShaderBlob fsr1GetRcasPassPermutationBlobByIndex(uint32_t permutationOptions, bool isWave64, bool is16bit)
{
    int APPLY_RCAS = FFX_CONTAINS_FLAG(permutationOptions, FSR1_SHADER_PERMUTATION_APPLY_RCAS);
    int RCAS_PASSTHROUGH_ALPHA = FFX_CONTAINS_FLAG(permutationOptions, FSR1_SHADER_PERMUTATION_RCAS_PASSTHROUGH_ALPHA);
    int SRGB_CONVERSIONS = FFX_CONTAINS_FLAG(permutationOptions, FSR1_SHADER_PERMUTATION_SRGB_CONVERSIONS);

    // Name                                 Type  Format         Dim      HLSL Bind  Count
    // ------------------------------ ---------- ------- ----------- -------------- ------
    // r_internal_upscaled_color         texture  float4          2d             t0      1 
    // rw_upscaled_output                    UAV  float4          2d             u0      1 
    // cbFSR1                            cbuffer      NA          NA            cb0      1 
    static const char* boundConstantBufferNames[] = { "cbFSR1" };
    static const uint32_t boundConstantBuffers[] = { 0 };
    static const uint32_t boundConstantBufferCounts[] = { 1 };
    static const uint32_t boundConstantBufferSpaces[] = { 0 };
    static const char* boundSRVTextureNames[] = { "r_internal_upscaled_color" };
    static const uint32_t boundSRVTextures[] = { 0 };
    static const uint32_t boundSRVTextureCounts[] = { 1 };
    static const uint32_t boundSRVTextureSpaces[] = { 0 };
    static const char* boundUAVTextureNames[] = { "rw_upscaled_output" };
    static const uint32_t boundUAVTextures[] = { 0 };
    static const uint32_t boundUAVTextureCounts[] = { 1 };
    static const uint32_t boundUAVTextureSpaces[] = { 0 };

    FfxShaderBlob blob = {
        is16bit ? g_ffx_fsr1_rcas_pass_16bit_permutations[APPLY_RCAS][RCAS_PASSTHROUGH_ALPHA][SRGB_CONVERSIONS].data
                : g_ffx_fsr1_rcas_pass_permutations[APPLY_RCAS][RCAS_PASSTHROUGH_ALPHA][SRGB_CONVERSIONS].data,
        is16bit ? g_ffx_fsr1_rcas_pass_16bit_permutations[APPLY_RCAS][RCAS_PASSTHROUGH_ALPHA][SRGB_CONVERSIONS].size
                : g_ffx_fsr1_rcas_pass_permutations[APPLY_RCAS][RCAS_PASSTHROUGH_ALPHA][SRGB_CONVERSIONS].size,
        __crt_countof(boundConstantBufferNames),
        __crt_countof(boundSRVTextureNames),
        __crt_countof(boundUAVTextureNames),
        0,
        0,
        0,
        0,
        boundConstantBufferNames,
        boundConstantBuffers,
        boundConstantBufferCounts,
        boundConstantBufferSpaces,
        boundSRVTextureNames,
        boundSRVTextures,
        boundSRVTextureCounts,
        boundSRVTextureSpaces,
        boundUAVTextureNames,
        boundUAVTextures,
        boundUAVTextureCounts,
        boundUAVTextureSpaces,
    };

    return blob;
}

FfxErrorCode fsr1GetPermutationBlobByIndex(
    FfxFsr1Pass passId,
    uint32_t permutationOptions,
    FfxShaderBlob* outBlob) {

    bool isWave64 = FFX_CONTAINS_FLAG(permutationOptions, FSR1_SHADER_PERMUTATION_FORCE_WAVE64);
    bool is16bit = FFX_CONTAINS_FLAG(permutationOptions, FSR1_SHADER_PERMUTATION_ALLOW_FP16);

    switch (passId) {

        case FFX_FSR1_PASS_EASU:
        case FFX_FSR1_PASS_EASU_RCAS:
        {
            FfxShaderBlob blob = fsr1GetEasuPassPermutationBlobByIndex(permutationOptions, isWave64, is16bit);
            memcpy(outBlob, &blob, sizeof(FfxShaderBlob));
            return FFX_OK;
        }

        case FFX_FSR1_PASS_RCAS:
        {
            FfxShaderBlob blob = fsr1GetRcasPassPermutationBlobByIndex(permutationOptions, isWave64, is16bit);
            memcpy(outBlob, &blob, sizeof(FfxShaderBlob));
            return FFX_OK;
        }

        default:
            FFX_ASSERT_FAIL("Should never reach here.");
            break;
    }

    // return an empty blob
    memset(&outBlob, 0, sizeof(FfxShaderBlob));
    return FFX_OK;
}

FfxErrorCode fsr1IsWave64(uint32_t permutationOptions, bool& isWave64)
{
    isWave64 = FFX_CONTAINS_FLAG(permutationOptions, FSR1_SHADER_PERMUTATION_FORCE_WAVE64);
    return FFX_OK;
}
