#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdlib.h> // For malloc
#include "terminal.h"
#include "sort.h"

SortTimings globalSortTimings; // Define the global variable

double executionTime;
void terminal(const char *algorithmType, int dataSize, int *array)
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
        mergeSort(arrayCopy, 0, dataSize - 1); // Call mergeSort
        clock_t end = clock();
        double time_taken = ((double)end - start) / CLOCKS_PER_SEC; // in seconds
        printf("Time taken by Merge Sort: %f seconds\n", time_taken);
        executionTime = time_taken;
    }
    if (strcmp(algorithmType, "Quick") == 0)
    {
        printf("Yep I am here\n");

        clock_t start = clock();
        quickSort(arrayCopy, 0, dataSize - 1); // replace with dataSize
        clock_t end = clock();
        double time_taken = ((double)end - start) / CLOCKS_PER_SEC; // in seconds
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

    // Free memory
    free(arrayCopy);
}
