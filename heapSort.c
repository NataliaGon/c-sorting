#include <stdio.h>
#include "sort.h"

void swap(int *a, int *b)
{
    int temp = *a;
    *a = *b;
    *b = temp;
}

void heapify(int arr[], int n, int i)
{
    int largest = i;       // Initialize largest as root
    int left = 2 * i + 1;  // Left child
    int right = 2 * i + 2; // Right child

    if (left < n && arr[left] > arr[largest])
        largest = left;

    if (right < n && arr[right] > arr[largest])
        largest = right;

    if (largest != i)
    {
        swap(&arr[i], &arr[largest]);
        heapify(arr, n, largest); // Recursively heapify the affected subtree
    }
}

void heapSort(int arr[], int n)
{
    for (int i = n / 2 - 1; i >= 0; i--)
    {
        heapify(arr, n, i); // Build heap
    }

    for (int i = n - 1; i > 0; i--)
    {
        swap(&arr[0], &arr[i]); // Move current root to end
        heapify(arr, i, 0);     // Heapify the reduced heap
    }
}

// void printArray(int arr[], int size)
// {
//     for (int i = 0; i < size; i++)
//     {
//         printf("%d ", arr[i]);
//     }
//     printf("\n");
// }

// int main()
// {
//     int arr[] = {12, 11, 13, 5, 6, 7};
//     int n = sizeof(arr) / sizeof(arr[0]);

//     printf("Original array: \n");
//     printArray(arr, n);

//     heapSort(arr, n);

//     printf("Sorted array: \n");
//     printArray(arr, n);
//     return 0;
// }
