#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE 1000

void generateRandomArray(int *array, int size)
{
    for (int i = 0; i < size; i++)
    {
        array[i] = rand() % 1000000; // Random numbers between 0 and 999999
    }
}

void saveArrayToJson(int *array, int size, const char *filename)
{
    FILE *file = fopen(filename, "w");
    if (file == NULL)
    {
        perror("Could not open file for writing");
        return;
    }

    // Write the array in JSON format
    fprintf(file, "{\n\"numbers\": [");

    for (int i = 0; i < size; i++)
    {
        fprintf(file, "%d", array[i]);
        if (i < size - 1)
        {
            fprintf(file, ", ");
        }
    }

    fprintf(file, "]\n}");
    fclose(file);
}

int main()
{
    int array[ARRAY_SIZE];

    // Seed the random number generator
    srand(time(NULL));

    // Generate the random array
    generateRandomArray(array, ARRAY_SIZE);

    // Save the array to a JSON file
    saveArrayToJson(array, ARRAY_SIZE, "array_data.json");

    printf("Array saved to array_data.json\n");

    return 0;
}
