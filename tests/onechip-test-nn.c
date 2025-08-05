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

    // controls the range of values: [-RANGE, RANGE]
    const int RANGE = 100;
    
    for (size_t i = 0; i < rows; i++) {
        for (size_t j = 0; j < cols; j++) {
            arr[i * cols + j] = (rand() % (2 * RANGE + 1)) - RANGE;
        }
    }
}

void rand_1d_array(int64_t *arr, size_t num_elems){

    // controls the range of values: [-RANGE, RANGE]
    const int RANGE = 50;

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
int64_t output[NUM_OUTPUTS] = {0};

// chip1 status variables
uint64_t chip1_count = 0;
uint64_t chip0_count = 0;
uint64_t chip0_fin_status = 0;
uint64_t chip1_fin_status = 0;

int main(void) {

    uint64_t chipID = reg_read64(CHIP_ID);

    printf("[TEST - ChipID: %ld] Starting test: %s\n", chipID, TEST);

    printf("[TEST - ChipID: %ld] Initializing arrays...\n", chipID);
    rand_1d_array(input, NUM_INPUTS);
    rand_2d_array(W1, NUM_INPUTS, NUM_HIDDEN);
    rand_1d_array(b1, NUM_OUTPUTS);
    rand_2d_array(W2, NUM_HIDDEN, NUM_OUTPUTS);
    rand_1d_array(b2, NUM_OUTPUTS);

    size_t start_total = rdcycle();
    
    size_t start_layer1 = rdcycle();
    
    for (uint64_t j = 0; j < NUM_HIDDEN; j++){
        uint64_t result = 0;
        for (int i = 0; i < NUM_INPUTS; i++){
            result += (input[i] * W1[i][j]);
        }
        result += b1[j];
        result = ReLU(result);
        layer1_result[j] = result;
        
        chip0_count = j + 1;
    }

    // Tell chip1 chip0 is finished
    size_t end_layer1 = rdcycle();
    
    chip0_fin_status = 1;


    size_t start_layer2 = rdcycle();
    
    while ((chip0_count != chip1_count) || (chip0_fin_status == 0)) {

        if (chip0_count != chip1_count) {
            
            for (int i = 0; i < NUM_OUTPUTS; i++) {
                output[i] += (layer1_result[chip1_count] * W2[chip1_count][i]);
            }

            // increment chip 1 counter
            chip1_count++;
        }            
    }
    // once finished add bias and do activation
    for (int i = 0; i < NUM_OUTPUTS; i++) {
        output[i] += b2[i];     
    }

    size_t end_layer2 = rdcycle();


    size_t end_total = rdcycle();
    printf("[TEST - ChipID: %ld] Total time (in cycles): %ld \n", chipID, end_total - start_total);
    printf("[TEST - ChipID: %ld] Total instructions retired: %ld \n", chipID, rdinstret());
    printf("[TEST - ChipID: %ld] Layer 1 time (in cycles): %ld \n", chipID, end_layer1 - start_layer1);
    printf("[TEST - ChipID: %ld] Layer 2 time (in cycles): %ld \n", chipID, end_layer2 - start_layer2);

    for (int i = 0; i < NUM_OUTPUTS; i++) {
        printf("[TEST - ChipID: %ld] Output[%d] %d\n", chipID, i, output[i]);
    }

    return 0;
}
