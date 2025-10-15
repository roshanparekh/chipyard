#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <riscv-pk/encoding.h>
#include "marchid.h"
#include "mmio.h"

#define TEST "UCIe Basic"

#define UCIEPHYTEST_OFFSET 0x20000
#define UCIEPHYTEST_TRIGGERNEW (UCIEPHYTEST_OFFSET + 0x24d8)
#define UCIEPHYTEST_TRIGGEREXIT (UCIEPHYTEST_OFFSET + 0x24e0)


#define UCIE_OFFSET 0x100000000L
#define SPAD_OFFSET 0x580000000L
#define UCIE_OFFCHIP_BASE (UCIE_OFFSET + SPAD_OFFSET)
#define CHIP_ID 0x2000L

volatile uint32_t src[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
volatile uint32_t dest[10];
volatile uint32_t test[10];

int main(void) {

    uint64_t chipID = reg_read64(CHIP_ID);

    // Chip 0 do some stuff
    if (chipID == 0) {
        int val = 10;
        printf("Writing %d to %p\n", val, (void *) UCIE_OFFCHIP_BASE);
        reg_write64(UCIE_OFFCHIP_BASE, val);
        printf("Done writing\n");

        printf("Value after read: %ld\n", reg_read64(UCIE_OFFCHIP_BASE));
    }

    // Chip 1 do some stuff
    if (chipID == 1) {
        
    }

    volatile int k = 0;
    while(1){
        if ((k % 10000) == 0) {
            printf("[ChipID: %ld] Busy waiting...\n", chipID);
        }
        k++;
    }

    return 0;
}
