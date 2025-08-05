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
#define MBUS_SPAD 0x08000000L //64 KiB to 0x0801_0000
#define CHIP_ID 0x2000L
#define DRAM_OFFSET 0x80050000L // to 0x8fff_ffff

volatile uint32_t src[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
volatile uint32_t dest[10];
volatile uint32_t test[10];

int main(void) {

    uint64_t chipID = reg_read64(CHIP_ID);

    volatile int count = 0;

    if (chipID == 0) {
        printf("Triggering MB Train\n");
        reg_write64(UCIEPHYTEST_TRIGGERNEW, 1);
        printf("Trigged\n");

        while(count != 100000) {
            count++;
            if ((count % 1000) == 0) {
                printf("Wait count: %d", count);
            }
        }

        int val = 10;
        printf("Writing %d to %p\n", val, (void *) UCIE_OFFSET);
        reg_write64(UCIE_OFFSET + MBUS_SPAD, val);
        printf("Done writing\n");

        printf("Value after read: %ld\n", reg_read64(UCIE_OFFSET + MBUS_SPAD));
    }

    // if (chipID == 1) {
    //     printf("Triggering MB Train\n");
    //     reg_write64(UCIEPHYTEST_TRIGGERNEW, 1);
    //     printf("Trigged\n");
    // }

    volatile int k = 0;
    while(1){
        if ((k % 10) == 0) {
            printf("[ChipID: %ld] Busy waiting...\n", chipID);
        }
        k++;
    }

    return 0;
}
