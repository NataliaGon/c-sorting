#import <Cocoa/Cocoa.h>
#import "sort.h"
#import "terminal.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong) NSWindow *window;
@property (strong) NSTextField *inputTextField;
@property (strong) NSTextField *outputLabel;
@property (nonatomic, strong) NSPopUpButton *dropdown;
@property (nonatomic, strong) NSTextField *dropdownLabel; 
@property (nonatomic, strong) NSTextField *dropdownLabelSize; 
@property (strong) NSTextField *executionTimeLabel; 
@property (nonatomic, strong) NSPopUpButton *dropdownSize;
@property (nonatomic, strong) NSString *algorithmType;
@property (nonatomic, strong) NSString *dataSize;
@property (nonatomic) int *array;
@property (strong) NSTableView *resultsTableView; // Table to display results
@property (strong) NSArrayController *arrayController; // Controller to manage data
- (void)updateTableWithTimings:(SortTimings)timings;
- (void)updateExecutionTime:(double)executionTime;
@end

@interface SortResult : NSObject

@property (nonatomic, strong) NSString *algorithmName;
@property (nonatomic) double timeTaken;

- (instancetype)initWithAlgorithmName:(NSString *)algorithmName timeTaken:(double)timeTaken;

@end

@implementation SortResult

- (instancetype)initWithAlgorithmName:(NSString *)algorithmName timeTaken:(double)timeTaken {
    self = [super init];
    if (self) {
        _algorithmName = algorithmName;
        _timeTaken = timeTaken;
    }
    return self;
}

@end


@implementation AppDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        // Set the default value for algorithmType
        _algorithmType = @"Merge";  // Default value
        _dataSize = @"100";  // Default value
    }
    return self;
}

- (void)initializeTableWithDefaults {
    NSMutableArray *defaultData = [NSMutableArray array];

    // Add default rows for each algorithm
    NSArray *algorithms = @[@"Quick Sort", @"Merge Sort", @"Heap Sort"];
    for (NSString *algorithm in algorithms) {
        SortResult *result = [[SortResult alloc] initWithAlgorithmName:algorithm timeTaken:0.0]; // Default time = 0.0
        [defaultData addObject:result];
    }

    // Set the default data to the array controller
    [self.arrayController setContent:defaultData];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Window setup
    NSRect frame = NSMakeRect(0, 0, 2000, 600);
    self.window = [[NSWindow alloc] initWithContentRect:frame
                                               styleMask:(NSWindowStyleMaskTitled |
                                                          NSWindowStyleMaskClosable |
                                                          NSWindowStyleMaskResizable)
                                                 backing:NSBackingStoreBuffered
                                                   defer:NO];
    [self.window setTitle:@"Sorting Algorithm Visualizer"];
    [self.window makeKeyAndOrderFront:nil];


    
    // Text field for input
    self.inputTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 120, 360, 30)];
    [self.window.contentView addSubview:self.inputTextField];
  
    
    // Button to trigger sorting
    NSButton *sortButton = [[NSButton alloc] initWithFrame:NSMakeRect(150, 70, 100, 30)];
    [sortButton setTitle:@"Sort"];
    [sortButton setButtonType:NSButtonTypeMomentaryPushIn];
    [sortButton setBezelStyle:NSBezelStyleRounded];
    [sortButton setTarget:self];
    [sortButton setAction:@selector(sortQuick:)];
    [self.window.contentView addSubview:sortButton];
    
    // Label for output
    self.outputLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 30, 360, 30)];
    [self.outputLabel setBezeled:NO];
    [self.outputLabel setDrawsBackground:NO];
    [self.outputLabel setEditable:NO];
    [self.outputLabel setSelectable:NO];
    [self.outputLabel setStringValue:@""]; // Initially empty
    [self.window.contentView addSubview:self.outputLabel];

    // Title above dropdown
    self.dropdownLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(400, 240, 200, 30)];
    [self.dropdownLabel setBezeled:NO];
    [self.dropdownLabel setDrawsBackground:NO];
    [self.dropdownLabel setEditable:NO];
    [self.dropdownLabel setSelectable:NO];
    [self.dropdownLabel setStringValue:@"Choose sort type:"];
    [self.window.contentView addSubview:self.dropdownLabel];

    // Create the dropdown menu
    self.dropdown = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(400, 200, 200, 30) pullsDown:NO];
    [self.dropdown addItemWithTitle:@"Merge"];
    [self.dropdown addItemWithTitle:@"Quick"];
    [self.dropdown addItemWithTitle:@"Heap"];
    [self.dropdown setTarget:self];
    [self.dropdown setAction:@selector(dropdownSelectionChanged:)];
    [self.window.contentView addSubview:self.dropdown];

    // Title above dropdown
    self.dropdownLabelSize = [[NSTextField alloc] initWithFrame:NSMakeRect(100, 240, 200, 30)];
    [self.dropdownLabelSize setBezeled:NO];
    [self.dropdownLabelSize setDrawsBackground:NO];
    [self.dropdownLabelSize setEditable:NO];
    [self.dropdownLabelSize setSelectable:NO];
    [self.dropdownLabelSize setStringValue:@"Step1. Choose data size:"];
    [self.window.contentView addSubview:self.dropdownLabelSize];

    // Create the dropdown menu
    self.dropdownSize = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(100, 200, 200, 30) pullsDown:NO];
    [self.dropdownSize addItemWithTitle:@"10"];
    [self.dropdownSize addItemWithTitle:@"100"];
    [self.dropdownSize addItemWithTitle:@"1000"];
    [self.dropdownSize addItemWithTitle:@"10000"];
    [self.dropdownSize addItemWithTitle:@"100000"];
    [self.dropdownSize setTarget:self];
    [self.dropdownSize setAction:@selector(dropdownChangedSize:)];
    [self.window.contentView addSubview:self.dropdownSize];


    NSButton *sortGeneratedButton = [[NSButton alloc] initWithFrame:NSMakeRect(400, 160, 200, 30)];
    [sortGeneratedButton setTitle:@"Sort generated array"];
    [sortGeneratedButton setButtonType:NSButtonTypeMomentaryPushIn];
    [sortGeneratedButton setBezelStyle:NSBezelStyleRounded];
    [sortGeneratedButton setTarget:self];
    // Set the button type to have no default background
    //[sortGeneratedButton setBezelStyle:NSBezelStyleRegularSquare]; // Optional, keeps a flat look
    [sortGeneratedButton setBordered:NO]; // Removes the border and background
    // Enable the button layer to customize appearance
    sortGeneratedButton.wantsLayer = YES;
    sortGeneratedButton.layer.backgroundColor = [[NSColor systemBlueColor] CGColor]; // Set background color
    sortGeneratedButton.layer.cornerRadius = 5.0; // Optional: round corners
    [sortGeneratedButton setAction:@selector(sortGenerated:)];
    [self.window.contentView addSubview:sortGeneratedButton];
   
    NSButton *generateArrayButton = [[NSButton alloc] initWithFrame:NSMakeRect(100, 160, 200, 30)];
    [generateArrayButton setTitle:@"Generate array"];
    [generateArrayButton setButtonType:NSButtonTypeMomentaryPushIn];
    [generateArrayButton setBezelStyle:NSBezelStyleRounded];
    [generateArrayButton setTarget:self];
    [generateArrayButton setBordered:NO]; 
    generateArrayButton.wantsLayer = YES;
    generateArrayButton.layer.backgroundColor = [[NSColor systemBlueColor] CGColor]; // Set background color
    generateArrayButton.layer.cornerRadius = 5.0; // Optional: round corners
    [generateArrayButton setAction:@selector(generateArray:)];
    [self.window.contentView addSubview:generateArrayButton];

    // Create a new NSTextField for the execution time label
    self.executionTimeLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(100, 100, 300, 30)];
    
    // Set the text field properties (e.g., read-only, no border)
    [self.executionTimeLabel setEditable:NO];
    [self.executionTimeLabel setBezeled:NO];
    [self.executionTimeLabel setDrawsBackground:NO];
    
    // Set initial text (just an example)
    [self.executionTimeLabel setStringValue:[NSString stringWithFormat:@"Execution Time: %.4f seconds", executionTime]];
    
    // Add the text field to the window's content view
    [self.window.contentView addSubview:self.executionTimeLabel];

    
     // Table View to display results
self.resultsTableView = [[NSTableView alloc] initWithFrame:NSMakeRect(250, 350, 1800, 300)];
[self.resultsTableView setGridStyleMask:NSTableViewSolidHorizontalGridLineMask | NSTableViewSolidVerticalGridLineMask];
[self.resultsTableView setRowHeight:30];

// Create and configure Algorithm Name column
NSTableColumn *algorithmColumn = [[NSTableColumn alloc] initWithIdentifier:@"algorithmName"];
[algorithmColumn setTitle:@"Algorithm"];
[algorithmColumn setWidth:300];
[self.resultsTableView addTableColumn:algorithmColumn];

// Create and configure Time Taken column
NSTableColumn *timeColumn = [[NSTableColumn alloc] initWithIdentifier:@"timeTaken"];
[timeColumn setTitle:@"Time (ms)"];
[timeColumn setWidth:150];
[self.resultsTableView addTableColumn:timeColumn];

// Add columns for each algorithm (Quick, Merge, Heap)
NSTableColumn *quickSortColumn = [[NSTableColumn alloc] initWithIdentifier:@"QuickSort"];
[quickSortColumn setTitle:@"QuickSort"];
[self.resultsTableView addTableColumn:quickSortColumn];

NSTableColumn *mergeSortColumn = [[NSTableColumn alloc] initWithIdentifier:@"MergeSort"];
[mergeSortColumn setTitle:@"MergeSort"];
[self.resultsTableView addTableColumn:mergeSortColumn];

NSTableColumn *heapSortColumn = [[NSTableColumn alloc] initWithIdentifier:@"HeapSort"];
[heapSortColumn setTitle:@"HeapSort"];
[self.resultsTableView addTableColumn:heapSortColumn];

// Create an array controller to bind data to the table
self.arrayController = [[NSArrayController alloc] init];
[self.arrayController setContent:[NSMutableArray array]]; // Empty initially

[self.resultsTableView bind:@"content" toObject:self.arrayController withKeyPath:@"arrangedObjects" options:nil];

// Create the scroll view and add the table view to it
NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(250, 350, 1800, 300)];
[scrollView setDocumentView:self.resultsTableView];
[scrollView setHasVerticalScroller:YES]; // Add a vertical scroller
[scrollView setHasHorizontalScroller:YES]; // Optional: Add a horizontal scroller if needed
[self.window.contentView addSubview:scrollView];

// Initialize table with default data
[self initializeTableWithDefaults];

    
}

- (void)dropdownSelectionChanged:(id)sender {
    self.algorithmType = [self.dropdown titleOfSelectedItem];
    NSLog(@"User selected: %@", self.algorithmType);
}

- (void)dropdownChangedSize:(id)sender {
    self.dataSize = [self.dropdownSize titleOfSelectedItem];
    NSLog(@"User selected: %@", self.dataSize);
}

-(void)generateArray:(id)sender{
   // First, check if arraySize is set properly (e.g., from the dropdown)
    NSInteger size = [self.dataSize intValue]; // Get the array size as an integer
    
    // Allocate memory for the array based on the size
    self.array = malloc(size * sizeof(int)); // Allocate space for 'size' integers
    
    // Check if allocation succeeded
    if (self.array == NULL) {
        NSLog(@"Memory allocation failed.");
        return;
    }
    
    // Populate the array with random values
    for (int i = 0; i < size; i++) {
        self.array[i] = rand() % 1000000; // Random numbers between 0 and 999999
    }
    
    // Optional: Print the generated array to check if it's correct
    NSLog(@"Generated array:");
    for (int i = 0; i < size; i++) {
        NSLog(@"%d", self.array[i]);
    }
}

- (void)sortGenerated:(id)sender{
    terminal([self.algorithmType UTF8String], [self.dataSize intValue], self.array); //convert to C string from Object-C string
    // After sorting, update the table with the timings
   //[self updateTableWithTimings:globalSortTimings];

    [self updateExecutionTime:executionTime]; // Call the update method with the execution time
}

- (void)updateExecutionTime:(double)executionTime {
    // Update the text field with the new execution time
    [self.executionTimeLabel setStringValue:[NSString stringWithFormat:@"Execution Time: %.4f seconds", executionTime]];
}

- (void)sortQuick:(id)sender {
    // Get the text from the input field
    NSString *inputText = [self.inputTextField stringValue];
    
    // Split the string into an array of numbers
    NSArray *stringArray = [inputText componentsSeparatedByString:@","];
    int length = (int)[stringArray count];
    int *array = malloc(length * sizeof(int));
    
    // Convert strings to integers
    for (int i = 0; i < length; i++) {
        array[i] = [stringArray[i] intValue];
    }

    // Print the array before sorting
    NSLog(@"Array before sorting:");
    printArray(array, length);

    // Call quickSort on the array
    quickSort(array, 0, length - 1);

    // Print the sorted array
    NSLog(@"Array after sorting:");
    printArray(array, length);
    
    // Create a string from the sorted array to display in the output label
    NSMutableString *sortedString = [NSMutableString string];
    for (int i = 0; i < length; i++) {
        [sortedString appendFormat:@"%d", array[i]];
        if (i < length - 1) {
            [sortedString appendString:@", "]; // Add a comma between numbers
        }
    }
    
    // Set the output label to the sorted string
    [self.outputLabel setStringValue:sortedString];
    
    // Free allocated memory
    free(array);
}

- (void)updateTableWithTimings:(SortTimings)timings {
    NSMutableArray *resultData = [NSMutableArray array];

    // Iterate through the algorithms and data sizes to get the timing data
    for (int algorithmIndex = 0; algorithmIndex < ALGORITHMS; algorithmIndex++) {
        NSString *algorithmName;
        if (algorithmIndex == 0) {
            algorithmName = @"Quick Sort";
        } else if (algorithmIndex == 1) {
            algorithmName = @"Merge Sort";
        } else {
            algorithmName = @"Heap Sort";
        }
        NSLog(@"Sorting completed yyyy"); 
        for (int sizeIndex = 0; sizeIndex < DATA_SIZES; sizeIndex++) {
            // For each repetition, get the timing data
            for (int repetitionIndex = 0; repetitionIndex < REPETITIONS; repetitionIndex++) {
                double timeTaken = 0;
                if (algorithmIndex == 0) {
                    timeTaken = timings.quickSort.times[0][sizeIndex][repetitionIndex];
                } else if (algorithmIndex == 1) {
                    timeTaken = timings.mergeSort.times[0][sizeIndex][repetitionIndex];
                } else {
                    timeTaken = timings.heapSort.times[0][sizeIndex][repetitionIndex];
                }

                // Create a SortResult object for each repetition and add it to the resultData array
                SortResult *result = [[SortResult alloc] initWithAlgorithmName:algorithmName timeTaken:timeTaken];
                [resultData addObject:result];
            }
        }
    }

    // Bind the result data to the table view
    [self.arrayController setContent:resultData];
}


@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSApplication *app = [NSApplication sharedApplication];
        AppDelegate *delegate = [[AppDelegate alloc] init];
        [app setDelegate:delegate];
        [app run];
    }
    return 0;
}
