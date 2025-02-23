#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdlib.h> // For malloc
#include "terminal.h"
#include "sort.h"

double executionTime;

void terminal_integer(const char *algorithmType, int dataSize, int *array)
{
    printf("The algorithmType is: %s\n, %d\n", algorithmType, dataSize);

    // Allocate memory for a copy of the array
    int *arrayCopy = (int *)malloc(dataSize * sizeof(int));
    if (arrayCopy == NULL)
    {
        printf("Memory allocation for array copy failed.\n");
        return;
    }

    // Copy the contents of the original array into the new array
    for (int i = 0; i < dataSize; i++)
    {
        arrayCopy[i] = array[i];
    }

    if (strcasecmp(algorithmType, "Merge") == 0)
    {

        printf("Merge");
        printf("Merge Sort\n");
        clock_t start = clock();
        mergeSort_integer(arrayCopy, 0, dataSize - 1);
        clock_t end = clock();
        double time_taken = ((double)end - start) / CLOCKS_PER_SEC;
        executionTime = time_taken;
    }
    if (strcmp(algorithmType, "Quick") == 0)
    {
        printf("Yep I am here\n");

        clock_t start = clock();
        quickSort_integer(arrayCopy, 0, dataSize - 1);
        clock_t end = clock();
        double time_taken = ((double)end - start) / CLOCKS_PER_SEC;
        executionTime = time_taken;
    }
    if (strcmp(algorithmType, "Heap") == 0)
    {
        printf("Heap Sort\n");
        clock_t start = clock();
        heapSort_integer(arrayCopy, dataSize);
        clock_t end = clock();
        double time_taken = ((double)end - start) / CLOCKS_PER_SEC;
        executionTime = time_taken;
    }

    free(arrayCopy);
    arrayCopy = NULL;
}

void terminal_real(const char *algorithmType, int dataSize, double *array)
{
    // Allocate memory for a copy of the array
    double *arrayCopy = (double *)malloc(dataSize * sizeof(double));
    if (arrayCopy == NULL)
    {
        printf("Memory allocation for array copy failed.\n");
        return;
    }

    for (int i = 0; i < dataSize; i++)
    {
        arrayCopy[i] = array[i];
    }

    if (strcmp(algorithmType, "Merge") == 0)
    {
        clock_t start = clock();
        mergeSort_double(arrayCopy, 0, dataSize - 1);
        clock_t end = clock();
        double time_taken = ((double)end - start) / CLOCKS_PER_SEC;
        executionTime = time_taken;
    }
    else if (strcmp(algorithmType, "Quick") == 0)
    {
        clock_t start = clock();
        quickSort_double(arrayCopy, 0, dataSize - 1);
        clock_t end = clock();
        double time_taken = ((double)end - start) / CLOCKS_PER_SEC;
        executionTime = time_taken;
    }
    else if (strcmp(algorithmType, "Heap") == 0)
    {
        clock_t start = clock();
        heapSort_double(arrayCopy, dataSize);
        clock_t end = clock();
        double time_taken = ((double)end - start) / CLOCKS_PER_SEC;
        executionTime = time_taken;
    }

    free(arrayCopy);
    arrayCopy = NULL;
}
