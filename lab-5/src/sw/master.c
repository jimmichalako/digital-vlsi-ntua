#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "sleep.h"
#include <inttypes.h>
#include "xil_types.h"
#include "xil_io.h"
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "sleep.h"
#include "S00_AXI.h"
#define IP_ADDR 0x43C00000

int main() {
    init_platform();
    unsigned int A, B, x, y, clk, rst, valid_in, valid_out;

    while (1) {
        xil_printf("Give me x: \n");
        scanf("%u", &x);
        xil_printf("Give me valid_in: \n");
        scanf("%u", &valid_in);
        xil_printf("Give me rst: \n");
        scanf("%u", &rst);
        A = rst << 9 | valid_in << 8 | x;
        xil_printf("A is : %u \n", A);
        S00_AXI_mWriteReg(XPAR_S00_AXI_0_S00_AXI_BASEADDR, S00_AXI_S00_AXI_SLV_REG0_OFFSET, A);
        B = S00_AXI_mReadReg(XPAR_S00_AXI_0_S00_AXI_BASEADDR, S00_AXI_S00_AXI_SLV_REG1_OFFSET);
        valid_out = B & 0x80000;
        valid_out = valid_out >> 19;
        y = B & 0x7FFFF;
        xil_printf("valid_out is: %u, y is: %u, B is %u\n\r", valid_out, y, B);

        if ((rst == 1) && (valid_in == 1)) {
            while (valid_out == 0) {
                B = Xil_In32(IP_ADDR + 0x04);
                valid_out = B & 0x80000;
                valid_out = valid_out >> 19;
            }
        }
        y = B & 0x7FFFF;
        xil_printf("valid_out is: %u, y is: %u, B is %u\n\r", valid_out, y, B);
    }
    cleanup_platform();
    return 0;
}

