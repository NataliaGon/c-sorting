#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdlib.h> // For malloc
#include "terminal.h"
#include "sort.h"

SortTimings globalSortTimings;

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
        mergeSort(arrayCopy, 0, dataSize - 1);
        clock_t end = clock();
        double time_taken = ((double)end - start) / CLOCKS_PER_SEC;
        printf("Time taken by Merge Sort: %f seconds\n", time_taken);
        executionTime = time_taken;
    }
    if (strcmp(algorithmType, "Quick") == 0)
    {
        printf("Yep I am here\n");

        clock_t start = clock();
        quickSort(arrayCopy, 0, dataSize - 1);
        clock_t end = clock();
        double time_taken = ((double)end - start) / CLOCKS_PER_SEC;
        printf("Time taken by the algorithm: %f seconds\n", time_taken);
        executionTime = time_taken;
    }
    if (strcmp(algorithmType, "Heap") == 0)
    {
        printf("Heap Sort\n");
        clock_t start = clock();
        heapSort(arrayCopy, dataSize);
        clock_t end = clock();
        double time_taken = ((double)end - start) / CLOCKS_PER_SEC;
        printf("Time taken by Heap Sort: %f seconds\n", time_taken);
        executionTime = time_taken;
    }

    free(arrayCopy);
    arrayCopy = NULL;
}

void terminal_float(const char *algorithmType, int dataSize, double *array)
{
    printf("The algorithmType is: %s\n", algorithmType);
    printf("The data size is: %d\n", dataSize);

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
        mergeSortFloat(arrayCopy, 0, dataSize - 1);
        clock_t end = clock();
        double time_taken = ((double)end - start) / CLOCKS_PER_SEC;
        printf("Time taken by Merge Sort: %f seconds\n", time_taken);
        executionTime = time_taken;
    }
    else if (strcmp(algorithmType, "Quick") == 0)
    {
        clock_t start = clock();
        quickSort_double(arrayCopy, 0, dataSize - 1);
        clock_t end = clock();
        double time_taken = ((double)end - start) / CLOCKS_PER_SEC;
        printf("Time taken by quick Sort: %f seconds\n", time_taken);
        executionTime = time_taken;
    }
    else if (strcmp(algorithmType, "Heap") == 0)
    {
        clock_t start = clock();
        heapSort_double(arrayCopy, dataSize);
        clock_t end = clock();
        double time_taken = ((double)end - start) / CLOCKS_PER_SEC;
        printf("Time taken by Heap Sort: %f seconds\n", time_taken);
        executionTime = time_taken;
    }

    free(arrayCopy);
    arrayCopy = NULL;
}
