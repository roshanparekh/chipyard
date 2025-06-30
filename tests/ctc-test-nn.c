#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <riscv-pk/encoding.h>
#include "marchid.h"
#include "mmio.h"

#define TEST "CTC 2-Layer NN"

#define OBUS_OFFSET (0x1L << 32)
#define MBUS_SPAD 0x08000000L //64 KiB to 0x08010000
#define CHIP_ID 0x2000L

#define NUM_INPUTS 3
#define NUM_HIDDEN 4
#define NUM_OUTPUTS 2


uint32_t ReLU(int64_t x){    
    return (x < 0) ? 0 : x;
}

void rand_2d_array(int64_t *arr, size_t rows, size_t cols) {
    const int RANGE = 100;
    for (size_t i = 0; i < rows; i++) {
        for (size_t j = 0; j < cols; j++) {
            arr[i * cols + j] = (rand() % (2 * RANGE + 1)) - RANGE;
        }
    }
}

void rand_1d_array(int64_t *arr, size_t num_elems){

    const size_t RANGE = 50;

    for (size_t i = 0; i < num_elems; i++){
        arr[i] = (rand() % (2 * RANGE + 1)) - RANGE;
    }
}

// Note these variable are allocated on both chips
// Wasting memory, but whatever

// layer 1
int64_t W1[NUM_INPUTS][NUM_HIDDEN] = {0};
int64_t b1[NUM_HIDDEN] = {0};
int64_t input[NUM_INPUTS] = {0};

// layer 2
int64_t layer1_result[NUM_HIDDEN] = {0};
int64_t W2[NUM_HIDDEN][NUM_OUTPUTS] = {0};
int64_t b2[NUM_OUTPUTS] = {0};
double  output[NUM_OUTPUTS] = {0};

// chip1 status variables
uint64_t chip1_count = 0;
uint64_t chip0_count = 0;
uint64_t chip0_fin_status = 0;
uint64_t chip1_fin_status = 0;

int main(void) {

    uint64_t chipID = reg_read64(CHIP_ID);

    printf("[TEST - ChipID: %ld] Starting test: %s\n", chipID, TEST);

    // initialize random values into arrays    
    if (chipID == 0){
        printf("[TEST - ChipID: %ld] Initializing arrays...\n", chipID);
        rand_1d_array(input, NUM_INPUTS);
        rand_2d_array(W1, NUM_INPUTS, NUM_HIDDEN);
        rand_1d_array(b1, NUM_OUTPUTS);
    }

    if (chipID == 1){
        printf("[TEST - ChipID: %ld] Initializing arrays...\n", chipID);
        rand_2d_array(W2, NUM_HIDDEN, NUM_OUTPUTS);
        rand_1d_array(b2, NUM_OUTPUTS);
    }

    // Chip0 does layer 1
    if (chipID == 0) {
        for (uint64_t j = 0; j < NUM_HIDDEN; j++){
            uint64_t result = 0;
            for (int i = 0; i < NUM_INPUTS; i++){
                result += (input[i] * W1[i][j]);
            }
            result += b1[j];
            result = ReLU(result);
            
            // send result to chip1
            *((int64_t *) (OBUS_OFFSET + (void *)layer1_result + (j * 8))) = result;
            
            printf("[TEST - ChipID: %ld] Sent %d\n", chipID, result);

            // increment written amount in chip1 over ctc
            *((uint64_t *) (OBUS_OFFSET + (void *)&chip0_count)) = (j + 1);
            printf("[TEST - ChipID: %ld] Sent an incremented counter to chip 1\n", chipID);
        }

        printf("[TEST - ChipID: %ld] Finished with layer 1\n", chipID);
        // Tell chip1 chip0 is finished
        *((uint64_t *) (OBUS_OFFSET + (void *)&chip0_fin_status)) = 1;
    }
    
    // Chip1 does layer 2
    if (chipID == 1) {
        // loop until internal count is equal to chip0 count
        // or chip0 is still doing work
        //printf("chip 1 in while. c0: %d, c1: %d, chip0_fin_status: %d\n", chip0_count, chip1_count, chip0_fin_status);

        int temp = chip1_count;
        int temp1 = chip0_count;
        
        while ((temp != temp1) || (chip0_fin_status == 0)) {
            //            printf("chip 1 in while. c0: %d, c1: %d, chip0_fin_status: %d\n", chip0_count, chip1_count, chip0_fin_status);
            if (temp1 != temp) {
                printf("[TEST - ChipID: %ld] Doing linear transformation at layer 2...\n", chipID);
                for (int i = 0; i < NUM_OUTPUTS; i++) {
                    output[i] += (layer1_result[chip1_count] * W2[chip1_count][i]);
                }
                
                // increment chip 1 counter
                chip1_count++;
            }
            //            printf("chip 1 in while. c0: %d, c1: %d, chip0_fin_status: %d\n", chip0_count, chip1_count, chip0_fin_status);
            
            //            temp = chip1_count;
            // temp1 = chip0_count;
        }

        // once finished add bias and do activation
        for (int i = 0; i < NUM_OUTPUTS; i++) {
            output[i] += b2[i];       
            printf("[TEST - ChipID: %ld] Output[%d] %.2f\n", chipID, i, output[i]);
        }

        printf("[TEST - ChipID: %ld] Finished with layer 2\n", chipID);
        chip1_fin_status = 1;
    }

    int k = 1;
    while (!chip1_fin_status) {
        printf("chip 0 busy wait. chip1_fin_status: %d\n", chip1_fin_status);
        k++; // chip0 busy wait for chip1
    }

    return 0;
}
