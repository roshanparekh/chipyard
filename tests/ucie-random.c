#include <stdio.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <riscv-pk/encoding.h>
#include "marchid.h"
#include "mmio.h"

#define UCIE_PHY_Q1_BASE 0x4000
#define UCIE_PHY_Q3_BASE 0x20000
#define TX_TEST_MODE 0x0
#define TX_VALID_FRAMING_MODE 0x8
#define TX_LFSR_SEED 0x10
#define TX_MANUAL_REPEAT 0x90
#define TX_FSM_RST 0x98
#define TX_EXECUTE 0xA0
#define TX_BITS_SENT 0xA8
#define TX_BITS_TO_SEND 0xB0
#define TX_DATA_LANE_GROUP 0xB8
#define TX_DATA_OFFSET 0xC0
#define TX_DATA_CHUNK_IN 0xC8
#define TX_DATA_CHUNK_OUT 0xD0
#define TX_PERMUTE 0xD8
#define TX_TEST_STATE 0x1D8
#define RX_LFSR_SEED 0x1E0
#define RX_BIT_ERRORS 0x260
#define RX_VALID_START_THRESHOLD 0x2E0
#define RX_VALID_STOP_THRESHOLD 0x2E0
#define RX_FSM_RST 0x2F0
#define RX_PAUSE_COUNTERS 0x2F8
#define RX_BITS_RECEIVED 0x300
#define RX_SIGNATURE 0x308
#define RX_DATA_LANE 0x310
#define RX_DATA_OFFSET 0x318
#define RX_DATA_CHUNK 0x320
#define RX_VALID_CHUNK 0x328
#define UCIE_STACK 0x1D28
#define OUTPUT_VALID 0x1D30
#define ERROR_COUNTS 0x1D38
#define PATTERN 0x1DB8
#define PATTERN_UI_COUNT 0x1DC0
#define TRIGGER_NEW 0x1DC8
#define TRIGGER_EXIT 0x1DD0

#define TX_VALID_FRAMING_MODE_UCIE 0 
#define TX_VALID_FRAMING_MODE_SIMPLE 1 
#define TX_TEST_STATE_IDLE 0
#define TX_TEST_STATE_RUN 1
#define TX_TEST_STATE_DONE 2


#define OBUS_OFFSET (0x2L << 32)
#define UCIE_OFFSET 0x1000000000L
#define SPAD_OFFSET 0x580000000L
#define UCIE_OFFCHIP_BASE (UCIE_OFFSET + SPAD_OFFSET)

// Helper Functions
void rand_1d_array(int64_t *arr, size_t num_elems){
    // controls the range of values: [-RANGE, RANGE]
    const int RANGE = 100;

    for (size_t i = 0; i < num_elems; i++){
        arr[i] = (rand() % (2 * RANGE + 1)) - RANGE;
    }
}
// END: Helper Functions

// Global Data 
#define NUMELEM_B1 10            
int64_t src[NUMELEM_B1] = {0};
int64_t dst[NUMELEM_B1] = {0};
// END: Global Data 

int main(void)
{

    rand_1d_array(src, NUMELEM_B1);

    size_t write_start = rdcycle();
    for (int i = 0; i < NUMELEM_B1; i++){
        printf("Writing: %ld\n", src[i]);
        reg_write64(UCIE_OFFCHIP_BASE + i * 8, src[i]);
    }
    size_t write_end = rdcycle();

    printf("Wrote %ld bytes in %ld cycles\n", sizeof(src), write_end - write_start);

    size_t read_start = rdcycle();
    for (int i = 0; i < NUMELEM_B1; i++) {
        dst[i] = reg_read64(UCIE_OFFCHIP_BASE + i * 8);
        printf("Read: %ld\n", dst[i]);
    }
    size_t read_end = rdcycle();

    printf("Read %ld bytes in %ld cycles\n", sizeof(dst), read_end - read_start);

    for (int i = 0; i < NUMELEM_B1; i++) {
        if (src[i] != dst[i]) {
            printf("Remote write/read failed at index %d. [src]: %ld [dst]: %ld\n", i, src[i], dst[i]);
            exit(1);
        }
    }

    printf("Success!\n");

    return 0;
}