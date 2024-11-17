#ifndef SORT_H
#define SORT_H

void quickSort(int *array, int low, int high); // works
int partition(int *array, int low, int high);
void printArray(int *array, int size);
void heapSort(int arr[], int n);
void mergeSort(int arr[], int left, int right);

#endif // QUICK_SORT_H
