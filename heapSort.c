#include <stdio.h>
#include "sort.h"

void swap_integer(int *a, int *b)
{
    int temp = *a;
    *a = *b;
    *b = temp;
    swapCounter++;
}

void heapify_integer(int arr[], int n, int i)
{
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    if (left < n && arr[left] > arr[largest])
        largest = left;

    if (right < n && arr[right] > arr[largest])
        largest = right;

    if (largest != i)
    {
        swap_integer(&arr[i], &arr[largest]);
        heapify_integer(arr, n, largest);
    }
}

void heapSort_integer(int arr[], int n)
{
    swapCounter = 0;
    for (int i = n / 2 - 1; i >= 0; i--)
    {
        heapify_integer(arr, n, i);
    }
    for (int i = n - 1; i > 0; i--)
    {
        swap_integer(&arr[0], &arr[i]);
        heapify_integer(arr, i, 0);
    }
}

void swap_double(double *a, double *b)
{
    double temp = *a;
    *a = *b;
    *b = temp;
    swapCounter++;
}

void heapify_double(double arr[], int n, int i)
{
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    if (left < n && arr[left] > arr[largest])
        largest = left;

    if (right < n && arr[right] > arr[largest])
        largest = right;

    if (largest != i)
    {
        swap_double(&arr[i], &arr[largest]);
        heapify_double(arr, n, largest);
    }
}

void heapSort_double(double arr[], int n)
{
    swapCounter = 0;

    for (int i = n / 2 - 1; i >= 0; i--)
    {
        heapify_double(arr, n, i);
    }

    for (int i = n - 1; i > 0; i--)
    {
        swap_double(&arr[0], &arr[i]);
        heapify_double(arr, i, 0);
    }
}
