#include <stdio.h>
#include "sort.h"

int swapCounter = 0;

int partition_integer(int *array, int low, int high)
{
    int pivot = array[high];
    int i = (low - 1);

    for (int j = low; j < high; j++)
    {
        if (array[j] <= pivot)
        {
            i++;
            int temp = array[i];
            array[i] = array[j];
            array[j] = temp;
            swapCounter++;
        }
    }

    int temp = array[i + 1];
    array[i + 1] = array[high];
    array[high] = temp;
    swapCounter++;
    return (i + 1);
}

void quickSortExecute_integer(int *array, int low, int high)
{
    if (low < high)
    {
        int pi = partition_integer(array, low, high);
        quickSortExecute_integer(array, low, pi - 1);
        quickSortExecute_integer(array, pi + 1, high);
    }
}

void quickSort_integer(int *array, int low, int high)
{
    swapCounter = 0;
    quickSortExecute_integer(array, low, high);
}

// void printArray_integer(int *array, int length)
// {
//     for (int i = 0; i < length; i++)
//     {
//         printf("%d ", array[i]);
//     }
//     printf("\n");
// }

int partition_double(double *array, int low, int high)
{
    double pivot = array[high];
    int i = (low - 1);

    for (int j = low; j < high; j++)
    {
        if (array[j] <= pivot)
        {
            i++;
            double temp = array[i];
            array[i] = array[j];
            array[j] = temp;
            swapCounter++;
        }
    }

    double temp = array[i + 1];
    array[i + 1] = array[high];
    array[high] = temp;
    swapCounter++;
    return (i + 1);
}

void quickSortExecute_double(double *array, int low, int high)
{
    if (low < high)
    {
        int pi = partition_double(array, low, high);
        quickSortExecute_double(array, low, pi - 1);
        quickSortExecute_double(array, pi + 1, high);
    }
}

void quickSort_double(double *array, int low, int high)
{
    swapCounter = 0;
    quickSortExecute_double(array, low, high);
}
