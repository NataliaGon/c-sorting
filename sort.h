#ifndef SORT_H
#define SORT_H

void quickSort_integer(int *array, int low, int high);
void quickSort_double(double *array, int low, int high);
void heapSort_integer(int arr[], int n);
void heapSort_double(double arr[], int n);
void mergeSort_integer(int arr[], int left, int right);
void mergeSort_double(double arr[], int left, int right);

extern int swapCounter;
extern double executionTime;

#endif
