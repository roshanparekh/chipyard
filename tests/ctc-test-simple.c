#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <riscv-pk/encoding.h>
#include "marchid.h"
#include "mmio.h"

#define TEST "CTC Simple"

#define OBUS_OFFSET (0x1L << 32)
#define MBUS_SPAD 0x08000000L //64 KiB to 0x08010000
#define CHIP_ID 0x2000L
#define DRAM_OFFSET 0x80050000L

/*
  Results from runs:
  --------------------------------------------------
  Run 1:  
  [TEST - ChipID: 0] Global variable address: 0x7b
  [TEST - ChipID: 1] Global variable address: 0x7b
  [TEST - ChipID: 0] Local variable address: 0x1c8
  [TEST - ChipID: 1] Local variable address: 0x1c8
  -------------------------------------------------- 
 */

uint64_t global_var = 123;
uint64_t chip1_fin = 0;

int main(void) {


    uint64_t chipID = reg_read64(CHIP_ID);
    uint64_t local_var = 2342;



    reg_write64(DRAM_OFFSET, 0);

    if (chipID == 0) {
        printf("[TEST - ChipID: %ld] global_var addr: %p\n", chipID, (void *)global_var);

        printf("[TEST - ChipID: %ld] Value at 0x8000_0000 (before write): %ld\n", chipID, reg_read64(DRAM_OFFSET));
        reg_write64(DRAM_OFFSET, local_var);
        printf("[TEST - ChipID: %ld] Value at 0x8000_0000 (after write): %ld\n", chipID, reg_read64(DRAM_OFFSET));
        
        printf("[TEST - ChipID: %ld] local_var value: %ld\n", chipID, local_var);
        printf("[TEST - ChipID: %ld] local_var addr: %p\n", chipID, (void *)local_var);
        printf("[TEST - ChipID: %ld] chipID addr: %p\n", chipID, (void *)chipID);        
    }


    if (chipID == 1) {
        printf("[TEST - ChipID: %ld] local_var addr (before change): %p\n", chipID, (void *)local_var);
        printf("[TEST - ChipID: %ld] Value at 0x8000_0000 (likely before chip 0 write): %ld\n", chipID, reg_read64(DRAM_OFFSET));

        printf("[TEST - ChipID: %ld] local_var value: %ld\n", chipID, reg_read64(DRAM_OFFSET));

        printf("[TEST - ChipID: %ld] : %p\n", chipID, (void *)global_var);
        
        printf("[TEST - ChipID: %ld] global_var addr: %p\n", chipID, (void *)global_var);
        printf("[TEST - ChipID: %ld] local_var addr (after change): %p\n", chipID, (void *)local_var);
        printf("[TEST - ChipID: %ld] local_var value: %ld\n", chipID, local_var);
        printf("[TEST - ChipID: %ld] chipID addr: %p\n", chipID, (void *)chipID);
        printf("[TEST - ChipID: %ld] Value at 0x8000_0000 (likely after chip 0 write): %ld\n", chipID, reg_read64(DRAM_OFFSET));
        chip1_fin = 1;
    }

    int k = 1;
    int chipid_1_count = 0;
    if (chipID == 1)
        printf("chipid_1_countn: %ld\n", chipid_1_count);
    
    while((chipID == 1) && (chipid_1_count != 10)) {
        printf("chipid_1_countn: %ld\n", chipid_1_count);
        chipid_1_count++;
    }

    while (!chip1_fin) {
        printf("chip 0 busy wait. chip1_fin: %ld\n", chip1_fin);
        k++; // chip0 busy wait for chip1
    }

    if (chipID == 0)
        printf("chip 0 busy wait. chip1_fin: %ld\n", chip1_fin);

    return 0;
}
