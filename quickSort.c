#include <stdio.h>
#include "sort.h"

int swapCounter = 0;

void quickSortExecute(int *array, int low, int high)
{
    if (low < high)
    {
        int pi = partition(array, low, high);
        quickSortExecute(array, low, pi - 1);
        quickSortExecute(array, pi + 1, high);
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
            swapCounter++;
        }
    }
    // Swap array[i + 1] and array[high] (or pivot)
    int temp = array[i + 1];
    array[i + 1] = array[high];
    array[high] = temp;
    swapCounter++;
    return (i + 1);
}

void quickSort(int *array, int low, int high)
{
    swapCounter = 0;
    quickSortExecute(array, low, high);
}
void printArray(int *array, int length)
{
    for (int i = 0; i < length; i++)
    {
        printf("%d ", array[i]);
    }
    printf("\n");
}

// Partition function for double arrays
int partition_double(double *array, int low, int high)
{
    double pivot = array[high]; // Choose the last element as the pivot
    int i = (low - 1);          // Index of the smaller element

    for (int j = low; j < high; j++)
    {
        if (array[j] <= pivot)
        { // Compare with pivot
            i++;
            // Swap array[i] and array[j]
            double temp = array[i];
            array[i] = array[j];
            array[j] = temp;
            swapCounter++;
        }
    }
    // Swap array[i + 1] and array[high] (or pivot)
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

// Quick Sort for double arrays
void quickSort_double(double *array, int low, int high)
{
    swapCounter = 0;
    quickSortExecute_double(array, low, high);
}

// Function to print array of doubles
void printArray_double(double *array, int length)
{
    for (int i = 0; i < length; i++)
    {
        printf("%f ", array[i]); // Print with %f to print doubles
    }
    printf("\n");
}
