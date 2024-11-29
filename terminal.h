#ifndef TERMINAL_H
#define TERMINAL_H

#define REPETITIONS 5
#define DATA_SIZES 3
#define ALGORITHMS 3
#define DATA_TYPES 2

typedef struct
{
    double times[DATA_TYPES][DATA_SIZES][REPETITIONS]; // Stores times for each data type, data size, and repetition
} AlgorithmTimings;

typedef struct
{
    AlgorithmTimings quickSort;
    AlgorithmTimings mergeSort;
    AlgorithmTimings heapSort;
} SortTimings;

extern double executionTime;

extern SortTimings globalSortTimings; // Declare the global variable

void terminal_integer(const char *algorithmType, int dataSize, int *array);
void terminal_float(const char *algorithmType, int dataSize, double *array);

#endif
