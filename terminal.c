#include <stdio.h>
#include <string.h>
#include <time.h>   // For time
#include <stdlib.h> // For malloc
#include "terminal.h"
#include "sort.h"

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
        // mergeSort();
    }
    if (strcmp(algorithmType, "Quick") == 0)
    {
        printf("Yep I am here\n");
        // printf("Array received in terminal function:\n");
        // for (int i = 0; i < dataSize; i++)
        // {
        //     printf("%d ", arrayCopy[i]); // Print the array to check if values are as expected
        // }
        clock_t start = clock();
        quickSort(arrayCopy, 0, dataSize - 1); // replace with dataSize
        clock_t end = clock();
        double time_taken = ((double)end - start) / CLOCKS_PER_SEC; // in seconds
        printf("Time taken by the algorithm: %f seconds\n", time_taken);
    }
    if (strcmp(algorithmType, "Heap") == 0)
    {
        // heapSort();
    }
}
