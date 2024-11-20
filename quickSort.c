#include <stdio.h>
#include "sort.h"

/// We have enter comma separeted values;
void quickSort(int *array, int low, int high)
{
    // printf("In quick sort %d\n", high);
    // for (int i = 0; i <= high; i++)
    // {
    //     printf("%d ", array[i]);
    // }
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
