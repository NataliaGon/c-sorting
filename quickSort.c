#include <stdio.h>
#include "quickSort.h"

/// We have enter comma separeted values;
void quickSort(int *array, int low, int high)
{
    if (low < high)
    {
        int pi = partition(array, low, high);
        quickSort(array, low, pi - 1);
        quickSort(array, pi + 1, high);
    }
}

int partition(int *array, int low, int high)
{
    int pivot = array[high]; // Choose the last element as the pivot
    int i = (low - 1);       // Index of the smaller element

    for (int j = low; j < high; j++)
    {
        if (array[j] <= pivot)
        { // Compare with pivot
            i++;
            // Swap array[i] and array[j]
            int temp = array[i];
            array[i] = array[j];
            array[j] = temp;
        }
    }
    // Swap array[i + 1] and array[high] (or pivot)
    int temp = array[i + 1];
    array[i + 1] = array[high];
    array[high] = temp;

    return (i + 1);
}

void printArray(int *array, int length)
{
    for (int i = 0; i < length; i++)
    {
        printf("%d ", array[i]);
    }
    printf("\n");
}

// #include <stdio.h>

// void quickSort(int *array, int low, int high);
// int partition(int *array, int low, int high);

// void quickSort(int *array, int low, int high)
// {
//     if (low < high)
//     {
//         // Find pivot index after partitioning
//         int pivotIndex = partition(array, low, high);

//         // Recursively apply QuickSort to subarrays
//         quickSort(array, low, pivotIndex - 1);
//         quickSort(array, pivotIndex + 1, high);
//     }
// }

// // Partition function to rearrange elements around pivot
// int partition(int *array, int low, int high)
// {
//     int pivot = array[high];
//     int i = low - 1;

//     for (int j = low; j < high; j++)
//     {
//         if (array[j] < pivot)
//         {
//             i++;
//             // Swap elements
//             int temp = array[i];
//             array[i] = array[j];
//             array[j] = temp;
//         }
//     }
//     // Place pivot in correct position
//     int temp = array[i + 1];
//     array[i + 1] = array[high];
//     array[high] = temp;
//     return i + 1;
// }

// int main()
// {
//     int array[] = {10, 7, 8, 9, 1, 5};
//     int n = sizeof(array) / sizeof(array[0]);

//     quickSort(array, 0, n - 1);

//     printf("Sorted array: ");
//     for (int i = 0; i < n; i++)
//     {
//         printf("%d ", array[i]);
//     }
//     printf("\n");

//     return 0;
// }
