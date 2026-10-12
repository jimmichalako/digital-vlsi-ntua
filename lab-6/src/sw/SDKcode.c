#include <stdio.h>
#include <unistd.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xparameters_ps.h"
#include "xaxidma.h"
#include "xtime_l.h"
#include "image.h" //test input data

#define TX_DMA_ID XPAR_PS2PL_DMA_DEVICE_ID                       // PS2PL
#define TX_DMA_MM2S_LENGTH_ADDR (XPAR_PS2PL_DMA_BASEADDR + 0x28) // Bytes of data from PS->PL

#define RX_DMA_ID XPAR_PL2PS_DMA_DEVICE_ID                       // PL2PS
#define RX_DMA_S2MM_LENGTH_ADDR (XPAR_PL2PS_DMA_BASEADDR + 0x58) // Bytes of data from PL->PS

#define TX_BUFFER (XPAR_DDR_MEM_BASEADDR + 0x10000000) // 0 + 256MByte
#define RX_BUFFER (XPAR_DDR_MEM_BASEADDR + 0x18000000) // 0 + 384MByte

/* User application global variables & defines */
#define N 0x400           // N=1024
#define IMG_SIZE 0x100000 // N*N=1048576

/* Device instance definitions*/
XAxiDma TXAxiDma; // PS2PL DMA
XAxiDma RXAxiDma; // PL2PS DMA

int main()
{
    Xil_DCacheDisable();
    XTime preExecCyclesFPGA = 0;
    XTime postExecCyclesFPGA = 0;
    XTime preExecCyclesSW = 0;
    XTime postExecCyclesSW = 0;
    // User application local variables
    init_platform();
    /**************************DEVICE INITIALIZATION******************************/
    u8 *TxBufferPtr;
    u32 *RxBufferPtr;
    TxBufferPtr = (u8 *)TX_BUFFER;  // 8bit input
    RxBufferPtr = (u32 *)RX_BUFFER; // 32bit output
    // Step 1: Initialize TX-DMA Device (PS->PL)
    /* Configure & Initialize PS2PL */
    XAxiDma_Config *TXCfgPtr;

    TXCfgPtr = XAxiDma_LookupConfig(TX_DMA_ID);

    XAxiDma_CfgInitialize(&TXAxiDma, TXCfgPtr);

    XAxiDma_IntrDisable(&TXAxiDma, XAXIDMA_IRQ_ALL_MASK, // disable interrupts
                        XAXIDMA_DEVICE_TO_DMA);
    XAxiDma_IntrDisable(&TXAxiDma, XAXIDMA_IRQ_ALL_MASK, // we want polling mode
                        XAXIDMA_DMA_TO_DEVICE);

    // Step 2: Initialize RX-DMA Device (PL->PS)
    /* Configure & Initialize PS2PL */
    XAxiDma_Config *RXCfgPtr;

    RXCfgPtr = XAxiDma_LookupConfig(RX_DMA_ID);

    XAxiDma_CfgInitialize(&RXAxiDma, RXCfgPtr);

    XAxiDma_IntrDisable(&RXAxiDma, XAXIDMA_IRQ_ALL_MASK, // disable interrupts
                        XAXIDMA_DEVICE_TO_DMA);
    XAxiDma_IntrDisable(&RXAxiDma, XAXIDMA_IRQ_ALL_MASK, // we want polling mode
                        XAXIDMA_DMA_TO_DEVICE);

    for (int Index = 0; Index < IMG_SIZE; Index++)
    { // Data to accelerator
        TxBufferPtr[Index] = pixels[Index];
    }
    for (int Index = 0; Index < 10; Index++)
    {
        RxBufferPtr[Index] = Index;
    }
    /*****************************************************************************/
    XTime_GetTime(&preExecCyclesFPGA);
    // Step 3 : Perform FPGA processing
    //      3a: Setup RX-DMA transaction
    //      3b: Setup TX-DMA transaction
    //      3c: Wait for TX-DMA & RX-DMA to finish
    XAxiDma_SimpleTransfer(&RXAxiDma, (UINTPTR)RxBufferPtr,
                           IMG_SIZE * 4, XAXIDMA_DEVICE_TO_DMA);
    XAxiDma_SimpleTransfer(&TXAxiDma, (UINTPTR)TxBufferPtr,
                           IMG_SIZE, XAXIDMA_DMA_TO_DEVICE);

    if (XAxiDma_Busy(&RXAxiDma, XAXIDMA_DEVICE_TO_DMA))
        print("RX DEVICE TO DMA BUSY\r\n");
    if (XAxiDma_Busy(&RXAxiDma, XAXIDMA_DMA_TO_DEVICE))
        print("RX DMA TO DEVICE BUSY\r\n");
    if (XAxiDma_Busy(&TXAxiDma, XAXIDMA_DEVICE_TO_DMA))
        print("TX DEVICE TO DMA BUSY\r\n");
    if (XAxiDma_Busy(&TXAxiDma, XAXIDMA_DMA_TO_DEVICE))
        print("TX DMA TO DEVICE BUSY\r\n");

    XTime_GetTime(&postExecCyclesFPGA);
    /*****************************************************************************/
    XTime_GetTime(&preExecCyclesSW);
    // Step 5: Perform SW processing
    int *r_sw = (int *)malloc(N * N * sizeof(int));
    int *g_sw = (int *)malloc(N * N * sizeof(int));
    int *b_sw = (int *)malloc(N * N * sizeof(int));
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            int right = (j < N - 1) ? (j + 1) : 0;
            int left = (j > 0) ? (j - 1) : 0;
            int up = (i > 0) ? (i - 1) : 0;
            int down = (i < N - 1) ? (i + 1) : 0;

            int r = (j < N - 1) ? pixels[right + N * i] : 0;
            int l = (j > 0) ? pixels[i * N + left] : 0;
            int u = (i > 0) ? pixels[up * N + j] : 0;
            int d = (i < N - 1) ? pixels[down * N + j] : 0;

            int d1 = ((i > 0) && (j > 0)) ? pixels[up * N + left] : 0;
            int d2 = ((i > 0) && j < (N - 1)) ? pixels[up * N + right] : 0;
            int d3 = ((i < N - 1) && (j > 0)) ? pixels[down * N + left] : 0;
            int d4 = ((i < N - 1) && (j < N - 1)) ? pixels[down * N + right] : 0;
            int cc = pixels[i * N + j];
            if (i % 2)
            {
                if (j % 2)
                { // green
                    r_sw[i * N + j] = (r + l) / 2;
                    g_sw[i * N + j] = cc;
                    b_sw[i * N + j] = (u + d) / 2;
                }
                else
                { // red
                    r_sw[i * N + j] = cc;
                    g_sw[i * N + j] = (u + d + r + l) / 4;
                    b_sw[i * N + j] = (d1 + d2 + d3 + d4) / 4;
                }
            }
            else
            {
                if (j % 2)
                { // blue
                    r_sw[i * N + j] = (d1 + d2 + d3 + d4) / 4;
                    g_sw[i * N + j] = (u + d + r + l) / 4;
                    b_sw[i * N + j] = cc;
                }
                else
                { // green
                    r_sw[i * N + j] = (u + d) / 2;
                    g_sw[i * N + j] = cc;
                    b_sw[i * N + j] = (r + l) / 2;
                }
            }
        }
    }
    XTime_GetTime(&postExecCyclesSW);
    /*****************************************************************************/
    // Step 6: Compare FPGA and SW results
    //     6a: Report total percentage error
    //     6b: Report FPGA execution time in cycles (use preExecCyclesFPGA and postExecCyclesFPGA)
    //     6c: Report SW execution time in cycles (use preExecCyclesSW and postExecCyclesSW)
    //     6d: Report speedup (SW_execution_time / FPGA_exection_time)
    int *r_hw = (int *)malloc(N * N * sizeof(int));
    int *g_hw = (int *)malloc(N * N * sizeof(int));
    int *b_hw = (int *)malloc(N * N * sizeof(int));
    int err = 0;
    int err_per, FPGA_cycles, SW_cycles, speedup;
    for (int i = 0; i < IMG_SIZE; i++)
    {
        r_hw[i] = (RxBufferPtr[i] >> 16) & 0xff;
        g_hw[i] = (RxBufferPtr[i] >> 8) & 0xff;
        b_hw[i] = RxBufferPtr[i] & 0xff;
        if (r_hw[i] == r_sw[i] && g_hw[i] != g_sw[i] && b_hw[i] == b_sw[i])
            err++;
    }
    err_per = (err / IMG_SIZE) * 100;
    FPGA_cycles = postExecCyclesFPGA - preExecCyclesFPGA;
    SW_cycles = postExecCyclesSW - preExecCyclesSW;
    speedup = SW_cycles / FPGA_cycles;
    printf("Total Percentage error: %d %% \n", err_per);
    printf("FPGA execution time in cycles: %d \n", FPGA_cycles);
    printf("SW execution time in cycles: %d \n", SW_cycles);
    printf("Speedup: %d \n", speedup);
    cleanup_platform();
    return 0;
}