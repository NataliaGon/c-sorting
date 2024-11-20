#include <stdio.h>
#include <string.h>
#include <stdlib.h> // For malloc
#include <time.h>   // For time
#include "terminal.h"
#include "sort.h"

/// We have enter comma separeted values;

// quickSort(array, 0, length - 1);

// void readArrayFromTextFile(int *array, int *size)
// {
//     FILE *file = fopen("array_data.csv", "r");
//     if (file == NULL)
//     {
//         perror("Could not open file for reading");
//         return;
//     }
//     int i = 0;
//     while (fscanf(file, "%d,", &array[i]) == 1)
//     {
//         i++;
//     }
//     *size = i;
//     fclose(file);
// }
void generateRandomArray(int *array, int size)
{
    for (int i = 0; i < size; i++)
    {
        array[i] = rand() % 1000000; // Random numbers between 0 and 999999
    }
}

void terminal(const char *algorithmType, int dataSize, int *array)
{
    printf("The algorithmType is: %s\n, %d\n", algorithmType, dataSize);
    // Generate date based on the data type and data size
    // int array[10]; // replace with dataSize

    // Gnerate the array from the text file
    generateRandomArray(array, 10); // replace with dataSize
    printf("Nearby");
    if (strcasecmp(algorithmType, "Merge") == 0)
    {

        printf("Merge");
        // mergeSort();

        for (int i = 0; i < 1000; i++)
        {
            printf("%d", array[i]);
            if (i < 1000 - 1)
            {
                printf(", "); // Print a comma between elements
            }
        }
        printf("\n"); // Newline at the end
    }
    if (strcmp(algorithmType, "Quick") == 0)
    {
        printf("Yep I am here\n");
        clock_t start = clock();
        quickSort(array, 0, dataSize - 1); // replace with dataSize
        clock_t end = clock();
        double time_taken = ((double)end - start) / CLOCKS_PER_SEC; // in seconds
        printf("Time taken by the algorithm: %f seconds\n", time_taken);
        //  printf("Array contents: ");
        //  for (int i = 0; i < size; i++)
        //  {
        //      printf("%d", array[i]);
        //      if (i < size - 1)
        //      {
        //          printf(", "); // Print a comma between elements
        //      }
        //  }
        //  printf("\n"); // Newline at the end
    }
    if (strcmp(algorithmType, "Heap") == 0)
    {
        // heapSort();
        // printf("Array contents: ");
        // for (int i = 0; i < size; i++)
        // {
        //     printf("%d", array[i]);
        //     if (i < size - 1)
        //     {
        //         printf(", "); // Print a comma between elements
        //     }
        // }
        // printf("\n"); // Newline at the end
    }
}
