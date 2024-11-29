#include <stdio.h>
#include "sort.h"

void merge_integer(int arr[], int left, int mid, int right)
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

void mergeSort_integer(int arr[], int left, int right)
{
    swapCounter = 0;
    if (left < right)
    {
        int mid = left + (right - left) / 2;

        mergeSort_integer(arr, left, mid);
        mergeSort_integer(arr, mid + 1, right);

        merge_integer(arr, left, mid, right);
    }
}

void merge_double(double arr[], int left, int mid, int right)
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

void mergeSort_double(double arr[], int left, int right)
{
    swapCounter = 0;
    if (left < right)
    {
        int mid = left + (right - left) / 2;

        mergeSort_double(arr, left, mid);
        mergeSort_double(arr, mid + 1, right);

        merge_double(arr, left, mid, right);
    }
}