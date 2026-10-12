#include <stdio.h>
#include <stdlib.h>

int main()
{
    int N;
    FILE *inputFile = fopen("input.txt", "r");
    FILE *outputFile = fopen("output.txt", "w");

    printf("Give me N: ");
    scanf("%d", &N);
    int input[N][N];
    int output[N][N][3];

    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            fscanf(inputFile, "%d", &input[i][j]);
        }
    }

    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            for (int i = 0; i < N; i++)
            {
                for (int j = 0; j < N; j++)
                {
                    int right = (j < N - 1) ? j + 1 : 0;
                    int left = (j > 0) ? j - 1 : 0;
                    int up = (i > 0) ? i - 1 : 0;
                    int down = (i < N - 1) ? i + 1 : 0;

                    int r = (j < N - 1) ? input[i][right] : 0;
                    int l = (j > 0) ? input[i][left] : 0;
                    int u = (i > 0) ? input[up][j] : 0;
                    int d = (i < N - 1) ? input[down][j] : 0;
                    int d1 = (i > 0 && j > 0) ? input[up][left] : 0;
                    int d2 = (i > 0 && j < N - 1) ? input[up][right] : 0;
                    int d3 = (i < N - 1 && j > 0) ? input[down][left] : 0;
                    int d4 = (i < N - 1 && j < N - 1) ? input[down][right] : 0;

                    if (i % 2)
                    {
                        if (j % 2)
                        {
                            output[i][j][0] = (r + l) / 2;
                            output[i][j][1] = input[i][j];
                            output[i][j][2] = (u + d) / 2;
                        }
                        else
                        {
                            output[i][j][0] = input[i][j];
                            output[i][j][1] = (u + d + r + l) / 4;
                            output[i][j][2] = (d1 + d2 + d3 + d4) / 4;
                        }
                    }
                    else
                    {
                        if (j % 2)
                        {
                            output[i][j][0] = (d1 + d2 + d3 + d4) / 4;
                            output[i][j][1] = (u + d + r + l) / 4;
                            output[i][j][2] = input[i][j];
                        }
                        else
                        {
                            output[i][j][0] = (u + d) / 2;
                            output[i][j][1] = input[i][j];
                            output[i][j][2] = (r + l) / 2;
                        }
                    }
                }
            }
        }
        printf("\n");
    }

    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            fprintf(outputFile, "%d %d %d\n", output[i][j][0], output[i][j][1], output[i][j][2]);
        }
    }

    return 0;
}