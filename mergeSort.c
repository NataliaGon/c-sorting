#include <stdio.h>
#include "sort.h"

void merge(int arr[], int left, int mid, int right)
{
    int n1 = mid - left + 1;
    int n2 = right - mid;

    int L[n1], R[n2];

    for (int i = 0; i < n1; i++)
        L[i] = arr[left + i];
    for (int j = 0; j < n2; j++)
        R[j] = arr[mid + 1 + j];

    int i = 0, j = 0, k = left;
    while (i < n1 && j < n2)
    {
        if (L[i] <= R[j])
        {
            arr[k] = L[i];
            i++;
        }
        else
        {
            arr[k] = R[j];
            j++;
        }
        k++;
        swapCounter++;
    }

    while (i < n1)
    {
        arr[k] = L[i];
        i++;
        k++;
        swapCounter++;
    }

    while (j < n2)
    {
        arr[k] = R[j];
        j++;
        k++;
        swapCounter++;
    }
}

void mergeSort(int arr[], int left, int right)
{
    swapCounter = 0;
    if (left < right)
    {
        int mid = left + (right - left) / 2;

        mergeSort(arr, left, mid);
        mergeSort(arr, mid + 1, right);

        merge(arr, left, mid, right);
    }
}

// Merge function for floats
void mergeFloat(double arr[], int left, int mid, int right)
{
    int n1 = mid - left + 1;
    int n2 = right - mid;

    float L[n1], R[n2];

    for (int i = 0; i < n1; i++)
        L[i] = arr[left + i];
    for (int j = 0; j < n2; j++)
        R[j] = arr[mid + 1 + j];

    int i = 0, j = 0, k = left;
    while (i < n1 && j < n2)
    {
        if (L[i] <= R[j])
        {
            arr[k] = L[i];
            i++;
        }
        else
        {
            arr[k] = R[j];
            j++;
        }
        k++;
        swapCounter++;
    }

    while (i < n1)
    {
        arr[k] = L[i];
        i++;
        k++;
        swapCounter++;
    }

    while (j < n2)
    {
        arr[k] = R[j];
        j++;
        k++;
        swapCounter++;
    }
}

// Merge Sort function for floats
void mergeSortFloat(double arr[], int left, int right)
{
    swapCounter = 0;
    if (left < right)
    {
        int mid = left + (right - left) / 2;

        mergeSortFloat(arr, left, mid);
        mergeSortFloat(arr, mid + 1, right);

        mergeFloat(arr, left, mid, right);
    }
}