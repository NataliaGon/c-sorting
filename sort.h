#ifndef SORT_H
#define SORT_H

void quickSort(int *array, int low, int high);
void quickSort_double(double *array, int low, int high);
int partition(int *array, int low, int high);
void printArray(int *array, int size);
void heapSort(int arr[], int n);
void heapSort_double(double arr[], int n);
void mergeSort(int arr[], int left, int right);
void mergeSortFloat(double arr[], int left, int right);

extern int swapCounter;

#endif
