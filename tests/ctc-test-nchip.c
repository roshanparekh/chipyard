#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <riscv-pk/encoding.h>
#include "marchid.h"
#include "mmio.h"

#define CTC_0_OFFSET 0x100000000L
#define CTC_1_OFFSET 0x200000000L
#define MBUS_SPAD 0x08000000L //64 KiB to 0x08010000
#define CHIP_ID 0x2000L
#define DRAM_OFFSET 0x80050000L

/*
    CTC Mapping:
    Chip 0:
        CTC 0: Chip 1, 
        CTC 1: Chip 2
    Chip 1:
        CTC 0: Chip 0, 
        CTC 1: Chip 2
    Chip 2:
        CTC 0: Chip 0, 
        CTC 1: Chip 1
*/

volatile uint32_t src[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
volatile uint32_t dest0_1[10] = {0};
volatile uint32_t test0_1[10] = {0};

volatile uint32_t dest0_2[10] = {0};
volatile uint32_t test0_2[10] = {0};

volatile uint32_t dest1_0[10] = {0};
volatile uint32_t test1_0[10] = {0};

volatile uint32_t dest1_2[10] = {0};
volatile uint32_t test1_2[10] = {0};

volatile uint32_t dest2_0[10] = {0};
volatile uint32_t test2_0[10] = {0};

volatile uint32_t dest2_1[10] = {0};
volatile uint32_t test2_1[10] = {0};


int main(void) {

    uint64_t chipID = reg_read64(CHIP_ID);
 

    if (chipID == 0) {

        printf("[TEST - ChipID: %ld] Writing to chip 1 through CTC\n", chipID); 
        for (int i = 0; i < sizeof(src) / 4; i++) {
            *((uint32_t *) (CTC_0_OFFSET + (void *) dest0_1 + i*4)) = src[i];   
        }         
        printf("[TEST - ChipID: %ld] Reading from chip 1 through CTC\n", chipID); 
        for (int i = 0; i < sizeof(src) / 4; i++) {
            test0_1[i] = *((uint32_t *) (CTC_0_OFFSET + (void *) dest0_1 + i*4));
        }

        for (int i = 0; i < sizeof(src) / 4; i++) {
            if (src[i] != test0_1[i]) {
                printf("[TEST - ChipID: %ld] Failed: src[%d]=%d, test0_1[%d]=%d\n", chipID, i, src[i], i, test0_1[i]);
                exit(1);
            }
        }

        printf("[TEST - ChipID: %ld] Writing to chip 2 through CTC\n", chipID); 
        for (int i = 0; i < sizeof(src) / 4; i++) {
            *((uint32_t *) (CTC_1_OFFSET + (void *) dest0_2 + i*4)) = src[i];   
        }         
        printf("[TEST - ChipID: %ld] Reading from chip 2 through CTC\n", chipID); 
        for (int i = 0; i < sizeof(src) / 4; i++) {
            test0_2[i] = *((uint32_t *) (CTC_1_OFFSET + (void *) dest0_2 + i*4));
        }

        for (int i = 0; i < sizeof(src) / 4; i++) {
            if (src[i] != test0_2[i]) {
                printf("[TEST - ChipID: %ld] Failed: src[%d]=%d, test0_2[%d]=%d\n", chipID, i, src[i], i, test0_2[i]);
                exit(1);
            }
        }
    }


    if (chipID == 1) {

        printf("[TEST - ChipID: %ld] Writing to chip 0 through CTC\n", chipID); 
        for (int i = 0; i < sizeof(src) / 4; i++) {
            *((uint32_t *) (CTC_0_OFFSET + (void *) dest1_0 + i*4)) = src[i];   
        }         
        printf("[TEST - ChipID: %ld] Reading from chip 0 through CTC\n", chipID); 
        for (int i = 0; i < sizeof(src) / 4; i++) {
            test1_0[i] = *((uint32_t *) (CTC_0_OFFSET + (void *) dest1_0 + i*4));
        }

        for (int i = 0; i < sizeof(src) / 4; i++) {
            if (src[i] != test1_0[i]) {
                printf("[TEST - ChipID: %ld] Failed: src[%d]=%d, test1_0[%d]=%d\n", chipID, i, src[i], i, test1_0[i]);
                exit(1);
            }
        }

        printf("[TEST - ChipID: %ld] Writing to chip 2 through CTC\n", chipID); 
        for (int i = 0; i < sizeof(src) / 4; i++) {
            *((uint32_t *) (CTC_1_OFFSET + (void *) dest1_2 + i*4)) = src[i];   
        }         
        printf("[TEST - ChipID: %ld] Reading from chip 2 through CTC\n", chipID); 
        for (int i = 0; i < sizeof(src) / 4; i++) {
            test1_2[i] = *((uint32_t *) (CTC_1_OFFSET + (void *) dest1_2 + i*4));
        }

        for (int i = 0; i < sizeof(src) / 4; i++) {
            if (src[i] != test1_2[i]) {
                printf("[TEST - ChipID: %ld] Failed: src[%d]=%d, test1_2[%d]=%d\n", chipID, i, src[i], i, test1_2[i]);
                exit(1);
            }
        }
    }

    if (chipID == 2) {

        printf("[TEST - ChipID: %ld] Writing to chip 0 through CTC\n", chipID); 
        for (int i = 0; i < sizeof(src) / 4; i++) {
            *((uint32_t *) (CTC_0_OFFSET + (void *) dest2_0 + i*4)) = src[i];   
        }         
        printf("[TEST - ChipID: %ld] Reading from chip 0 through CTC\n", chipID); 
        for (int i = 0; i < sizeof(src) / 4; i++) {
            test2_0[i] = *((uint32_t *) (CTC_0_OFFSET + (void *) dest2_0 + i*4));
        }

        for (int i = 0; i < sizeof(src) / 4; i++) {
            if (src[i] != test2_0[i]) {
                printf("[TEST - ChipID: %ld] Failed: src[%d]=%d, test2_0[%d]=%d\n", chipID, i, src[i], i, test2_0[i]);
                exit(1);
            }
        }

        printf("[TEST - ChipID: %ld] Writing to chip 1 through CTC\n", chipID); 
        for (int i = 0; i < sizeof(src) / 4; i++) {
            *((uint32_t *) (CTC_1_OFFSET + (void *) dest2_1 + i*4)) = src[i];   
        }         
        printf("[TEST - ChipID: %ld] Reading from chip 1 through CTC\n", chipID); 
        for (int i = 0; i < sizeof(src) / 4; i++) {
            test2_1[i] = *((uint32_t *) (CTC_1_OFFSET + (void *) dest2_1 + i*4));
        }

        for (int i = 0; i < sizeof(src) / 4; i++) {
            if (src[i] != test2_1[i]) {
                printf("[TEST - ChipID: %ld] Failed: src[%d]=%d, test2_1[%d]=%d\n", chipID, i, src[i], i, test2_1[i]);
                exit(1);
            }
        }
    }


    // busy wait for all chips to finish
    printf("[TEST - ChipID: %ld] Starting to busy wait\n", chipID);
    volatile int k = 12;
    while(1) {
        k = 2342 + k;
    }
    
    return 0;
}
