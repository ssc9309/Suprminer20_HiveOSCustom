#ifndef CUBEHASH512CUH
#define CUBEHASH512CUH
#include "cuda_helper_alexis.h"
#include "cuda_vectors_alexis.h"

__device__
inline void rrounds(uint32_t *x)
{
#pragma unroll 2
    for (int r = 0; r < 16; r++)
    {
        /* "add x_0jklm into x_1jklmn modulo 2^32 rotate x_0jklm upwards by 7 bits" */
        x[16] = x[16] + x[0]; x[0] = ROTL32(x[0], 7); x[17] = x[17] + x[1]; x[1] = ROTL32(x[1], 7);
        x[18] = x[18] + x[2]; x[2] = ROTL32(x[2], 7); x[19] = x[19] + x[3]; x[3] = ROTL32(x[3], 7);
        x[20] = x[20] + x[4]; x[4] = ROTL32(x[4], 7); x[21] = x[21] + x[5]; x[5] = ROTL32(x[5], 7);
        x[22] = x[22] + x[6]; x[6] = ROTL32(x[6], 7); x[23] = x[23] + x[7]; x[7] = ROTL32(x[7], 7);
        x[24] = x[24] + x[8]; x[8] = ROTL32(x[8], 7); x[25] = x[25] + x[9]; x[9] = ROTL32(x[9], 7);
        x[26] = x[26] + x[10]; x[10] = ROTL32(x[10], 7); x[27] = x[27] + x[11]; x[11] = ROTL32(x[11], 7);
        x[28] = x[28] + x[12]; x[12] = ROTL32(x[12], 7); x[29] = x[29] + x[13]; x[13] = ROTL32(x[13], 7);
        x[30] = x[30] + x[14]; x[14] = ROTL32(x[14], 7); x[31] = x[31] + x[15]; x[15] = ROTL32(x[15], 7);
        /* "swap x_00klm with x_01klm" */
        xchg(x[0], x[8]); x[0] ^= x[16]; x[8] ^= x[24]; xchg(x[1], x[9]); x[1] ^= x[17]; x[9] ^= x[25];
        xchg(x[2], x[10]); x[2] ^= x[18]; x[10] ^= x[26]; xchg(x[3], x[11]); x[3] ^= x[19]; x[11] ^= x[27];
        xchg(x[4], x[12]); x[4] ^= x[20]; x[12] ^= x[28]; xchg(x[5], x[13]); x[5] ^= x[21]; x[13] ^= x[29];
        xchg(x[6], x[14]); x[6] ^= x[22]; x[14] ^= x[30]; xchg(x[7], x[15]); x[7] ^= x[23]; x[15] ^= x[31];
        /* "swap x_1jk0m with x_1jk1m" */
        xchg(x[16], x[18]); xchg(x[17], x[19]); xchg(x[20], x[22]); xchg(x[21], x[23]); xchg(x[24], x[26]); xchg(x[25], x[27]); xchg(x[28], x[30]); xchg(x[29], x[31]);
        /* "add x_0jklm into x_1jklm modulo 2^32 rotate x_0jklm upwards by 11 bits" */
        x[16] = x[16] + x[0]; x[0] = ROTL32(x[0], 11); x[17] = x[17] + x[1]; x[1] = ROTL32(x[1], 11);
        x[18] = x[18] + x[2]; x[2] = ROTL32(x[2], 11); x[19] = x[19] + x[3]; x[3] = ROTL32(x[3], 11);
        x[20] = x[20] + x[4]; x[4] = ROTL32(x[4], 11); x[21] = x[21] + x[5]; x[5] = ROTL32(x[5], 11);
        x[22] = x[22] + x[6]; x[6] = ROTL32(x[6], 11); x[23] = x[23] + x[7]; x[7] = ROTL32(x[7], 11);
        x[24] = x[24] + x[8]; x[8] = ROTL32(x[8], 11); x[25] = x[25] + x[9]; x[9] = ROTL32(x[9], 11);
        x[26] = x[26] + x[10]; x[10] = ROTL32(x[10], 11); x[27] = x[27] + x[11]; x[11] = ROTL32(x[11], 11);
        x[28] = x[28] + x[12]; x[12] = ROTL32(x[12], 11); x[29] = x[29] + x[13]; x[13] = ROTL32(x[13], 11);
        x[30] = x[30] + x[14]; x[14] = ROTL32(x[14], 11); x[31] = x[31] + x[15]; x[15] = ROTL32(x[15], 11);
        /* "swap x_0j0lm with x_0j1lm" */
        xchg(x[0], x[4]); x[0] ^= x[16]; x[4] ^= x[20]; xchg(x[1], x[5]); x[1] ^= x[17]; x[5] ^= x[21];
        xchg(x[2], x[6]); x[2] ^= x[18]; x[6] ^= x[22]; xchg(x[3], x[7]); x[3] ^= x[19]; x[7] ^= x[23];
        xchg(x[8], x[12]); x[8] ^= x[24]; x[12] ^= x[28]; xchg(x[9], x[13]); x[9] ^= x[25]; x[13] ^= x[29];
        xchg(x[10], x[14]); x[10] ^= x[26]; x[14] ^= x[30]; xchg(x[11], x[15]); x[11] ^= x[27]; x[15] ^= x[31];
        /* "swap x_1jkl0 with x_1jkl1" */
        xchg(x[16], x[17]); xchg(x[18], x[19]); xchg(x[20], x[21]); xchg(x[22], x[23]); xchg(x[24], x[25]); xchg(x[26], x[27]); xchg(x[28], x[29]); xchg(x[30], x[31]);
    }
}

__device__
inline void ten_r_unroll(uint32_t *x) {
#pragma unroll 10
    for (int i = 0; i < 10; ++i)
        rrounds(x);
}

__device__
inline void ten_r(uint32_t *x) {
    for (int i = 0; i < 10; ++i)
        rrounds(x);
}

__device__
inline void x11_cubehash512_gpu_hash_64_start(uint32_t *x, uint32_t *hash) {
    // erste H�lfte des Hashes (32 bytes)
    //Update32(x, (const BitSequence*)Hash);
    *(uint2x4*)&x[0] ^= __ldg4((uint2x4*)&hash[0]);

    rrounds(x);

    // zweite H�lfte des Hashes (32 bytes)
    //        Update32(x, (const BitSequence*)(Hash+8));
    *(uint2x4*)&x[0] ^= __ldg4((uint2x4*)&hash[8]);

    rrounds(x);

    // Padding Block
    x[0] ^= 0x80;
    rrounds(x);

    //  Final(x, (BitSequence*)Hash);
    x[31] ^= 1;
}

__device__
inline void x11_cubehash512_gpu_hash_64(uint32_t *hash) {
    uint32_t x[32] = {
        0x2AEA2A61, 0x50F494D4, 0x2D538B8B, 0x4167D83E,
        0x3FEE2313, 0xC701CF8C, 0xCC39968E, 0x50AC5695,
        0x4D42C787, 0xA647A8B3, 0x97CF0BEF, 0x825B4537,
        0xEEF864D2, 0xF22090C4, 0xD0E5CD33, 0xA23911AE,
        0xFCD398D9, 0x148FE485, 0x1B017BEF, 0xB6444532,
        0x6A536159, 0x2FF5781C, 0x91FA7934, 0x0DBADEA9,
        0xD65C8A2B, 0xA5A70E75, 0xB1C62456, 0xBC796576,
        0x1921C8F7, 0xE7989AF1, 0x7795D246, 0xD43E3B44
    };

    x11_cubehash512_gpu_hash_64_start(x, hash);
    ten_r(x);

    *(uint2x4*)&hash[ 0] = *(uint2x4*)&x[ 0];
    *(uint2x4*)&hash[ 8] = *(uint2x4*)&x[ 8];
}

__device__
inline void x11_cubehash512_gpu_hash_64_unroll_10r(uint32_t *hash) {
    uint32_t x[32] = {
        0x2AEA2A61, 0x50F494D4, 0x2D538B8B, 0x4167D83E,
        0x3FEE2313, 0xC701CF8C, 0xCC39968E, 0x50AC5695,
        0x4D42C787, 0xA647A8B3, 0x97CF0BEF, 0x825B4537,
        0xEEF864D2, 0xF22090C4, 0xD0E5CD33, 0xA23911AE,
        0xFCD398D9, 0x148FE485, 0x1B017BEF, 0xB6444532,
        0x6A536159, 0x2FF5781C, 0x91FA7934, 0x0DBADEA9,
        0xD65C8A2B, 0xA5A70E75, 0xB1C62456, 0xBC796576,
        0x1921C8F7, 0xE7989AF1, 0x7795D246, 0xD43E3B44
    };

    x11_cubehash512_gpu_hash_64_start(x, hash);
    ten_r_unroll(x);

    *(uint2x4*)&hash[ 0] = *(uint2x4*)&x[ 0];
    *(uint2x4*)&hash[ 8] = *(uint2x4*)&x[ 8];
}

#endif
