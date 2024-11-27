#include <stdio.h>
#include "sort.h"

void swap(int *a, int *b)
{
    int temp = *a;
    *a = *b;
    *b = temp;
    swapCounter++;
}

// Heapify a subtree rooted at index i, where n is the size of the heap
void heapify(int arr[], int n, int i)
{
    int largest = i;       // Initialize largest as root
    int left = 2 * i + 1;  // Left child index
    int right = 2 * i + 2; // Right child index

    // If left child is larger than root
    if (left < n && arr[left] > arr[largest])
        largest = left;

    // If right child is larger than largest so far
    if (right < n && arr[right] > arr[largest])
        largest = right;

    // If largest is not root, swap it with the largest child
    if (largest != i)
    {
        swap(&arr[i], &arr[largest]);

        // Heapify the affected subtree
        heapify(arr, n, largest);
    }
}

// Main function to perform heap sort
void heapSort(int arr[], int n)
{

    swapCounter = 0;
    // Build the max heap (rearrange the array)
    for (int i = n / 2 - 1; i >= 0; i--)
    {
        heapify(arr, n, i); // Heapify each subtree
    }

    // Extract elements one by one from the heap
    for (int i = n - 1; i > 0; i--)
    {
        // Move current root (largest element) to the end of the array
        swap(&arr[0], &arr[i]);

        // Heapify the reduced heap (exclude the last element in the heap)
        heapify(arr, i, 0);
    }
}

// Swap function for double
void swap_double(double *a, double *b)
{
    double temp = *a;
    *a = *b;
    *b = temp;
    swapCounter++;
}

// Heapify a subtree rooted at index i (for double array)
void heapify_double(double arr[], int n, int i)
{
    int largest = i;       // Initialize largest as root
    int left = 2 * i + 1;  // Left child index
    int right = 2 * i + 2; // Right child index

    // If left child is larger than root
    if (left < n && arr[left] > arr[largest])
        largest = left;

    // If right child is larger than largest so far
    if (right < n && arr[right] > arr[largest])
        largest = right;

    // If largest is not root, swap it with the largest child
    if (largest != i)
    {
        swap_double(&arr[i], &arr[largest]);

        // Heapify the affected subtree
        heapify_double(arr, n, largest);
    }
}

// Main function to perform heap sort for double arrays
void heapSort_double(double arr[], int n)
{
    swapCounter = 0;
    // Build the max heap (rearrange the array)
    for (int i = n / 2 - 1; i >= 0; i--)
    {
        heapify_double(arr, n, i); // Heapify each subtree
    }

    // Extract elements one by one from the heap
    for (int i = n - 1; i > 0; i--)
    {
        // Move current root (largest element) to the end of the array
        swap_double(&arr[0], &arr[i]);

        // Heapify the reduced heap (exclude the last element in the heap)
        heapify_double(arr, i, 0);
    }
}
