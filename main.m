#import <Cocoa/Cocoa.h>
#import "sort.h"
#import "terminal.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong) NSWindow *window;
@property (strong) NSTextField *inputTextField;
@property (strong) NSTextField *outputLabel;
@property (strong) NSTextField *arrayWarning;
@property (nonatomic, strong) NSPopUpButton *dropdown;
@property (nonatomic, strong) NSTextField *dropdownLabel; 
@property (nonatomic, strong) NSTextField *dropdownLabelSize; 
@property (nonatomic, strong) NSTextField *dropdownLabelDataType;
@property (strong) NSTextField *executionTimeLabel; 
@property (nonatomic, strong) NSPopUpButton *dropdownSize;
@property (nonatomic, strong) NSPopUpButton *dropdownDataType;
@property (nonatomic, strong) NSString *algorithmType;
@property (nonatomic, strong) NSString *dataType;
@property (nonatomic, strong) NSString *dataSize;
@property (nonatomic) int *array;
@property (nonatomic) double *arrayReal;

@end

@interface SortResult : NSObject

@property (nonatomic, strong) NSString *algorithmName;
@property (nonatomic) double timeTaken;

- (instancetype)initWithAlgorithmName:(NSString *)algorithmName timeTaken:(double)timeTaken; //Do we need?

@end

@implementation SortResult

- (instancetype)initWithAlgorithmName:(NSString *)algorithmName timeTaken:(double)timeTaken { //Do we need?
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
        _algorithmType = @"Merge";  
        _dataSize = @"100"; 
        _dataType=@"integer";
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Window setup
    double executionTime = 0.0;
    int swapCounter=0;
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

    // Choose data type LABEL 
    self.dropdownLabelDataType = [[NSTextField alloc] initWithFrame:NSMakeRect(100, 440, 200, 30)];
    [self.dropdownLabelDataType setBezeled:NO];
    [self.dropdownLabelDataType setDrawsBackground:NO];
    [self.dropdownLabelDataType setEditable:NO];
    [self.dropdownLabelDataType setSelectable:NO];
    [self.dropdownLabelDataType setStringValue:@"Step 1. Choose data type:"];
    [self.window.contentView addSubview:self.dropdownLabelDataType];

    // Choose data type DROPDOWN
    self.dropdownDataType = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(100, 420, 200, 30) pullsDown:NO];
    [self.dropdownDataType addItemWithTitle:@"integer"];
    [self.dropdownDataType addItemWithTitle:@"real"];
    [self.dropdownDataType setTarget:self];
    [self.dropdownDataType setAction:@selector(dropdownChangedDataType:)];
    [self.window.contentView addSubview:self.dropdownDataType];

    // Choose data size LABEL
    self.dropdownLabelSize = [[NSTextField alloc] initWithFrame:NSMakeRect(350, 440, 200, 30)];
    [self.dropdownLabelSize setBezeled:NO];
    [self.dropdownLabelSize setDrawsBackground:NO];
    [self.dropdownLabelSize setEditable:NO];
    [self.dropdownLabelSize setSelectable:NO];
    [self.dropdownLabelSize setStringValue:@"Step 2. Choose data size:"];
    [self.window.contentView addSubview:self.dropdownLabelSize];

    // Choose data size DROPDOWN
    self.dropdownSize = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(350, 420, 200, 30) pullsDown:NO];
    [self.dropdownSize addItemWithTitle:@"10"];
    [self.dropdownSize addItemWithTitle:@"100"];
    [self.dropdownSize addItemWithTitle:@"1000"];
    [self.dropdownSize addItemWithTitle:@"10000"];
    [self.dropdownSize addItemWithTitle:@"100000"];
    [self.dropdownSize setTarget:self];
    [self.dropdownSize setAction:@selector(dropdownChangedSize:)];
    [self.window.contentView addSubview:self.dropdownSize];

    // Generate array BUTTON
    NSButton *generateArrayButton = [[NSButton alloc] initWithFrame:NSMakeRect(350, 380, 200, 30)];
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

    // Label Warning-Notificaiton
    self.arrayWarning = [[NSTextField alloc] initWithFrame:NSMakeRect(350, 340, 360, 30)];
    [self.arrayWarning setBezeled:NO];
    [self.arrayWarning setDrawsBackground:NO];
    [self.arrayWarning setEditable:NO];
    [self.arrayWarning setSelectable:NO];
    [self.arrayWarning setStringValue:@""]; // Initially empty
    [self.window.contentView addSubview:self.arrayWarning];

    // Choose sort type LABEL
    self.dropdownLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(600, 440, 200, 30)];
    [self.dropdownLabel setBezeled:NO];
    [self.dropdownLabel setDrawsBackground:NO];
    [self.dropdownLabel setEditable:NO];
    [self.dropdownLabel setSelectable:NO];
    [self.dropdownLabel setStringValue:@"Step 3.Choose sort type:"];
    [self.window.contentView addSubview:self.dropdownLabel];

    // Choose sort type DROPDOWN
    self.dropdown = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(600, 420, 200, 30) pullsDown:NO];
    [self.dropdown addItemWithTitle:@"Merge"];
    [self.dropdown addItemWithTitle:@"Quick"];
    [self.dropdown addItemWithTitle:@"Heap"];
    [self.dropdown setTarget:self];
    [self.dropdown setAction:@selector(dropdownSelectionChanged:)];
    [self.window.contentView addSubview:self.dropdown];

    // Sort generated array BUTTON
    NSButton *sortGeneratedButton = [[NSButton alloc] initWithFrame:NSMakeRect(600, 380, 200, 30)];
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
   

    // Execution time LABEL
    self.executionTimeLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(600, 340, 300, 30)];
    [self.executionTimeLabel setEditable:NO];
    [self.executionTimeLabel setBezeled:NO];
    [self.executionTimeLabel setDrawsBackground:NO];
    [self.executionTimeLabel setStringValue:[NSString stringWithFormat:@""]];
    [self.window.contentView addSubview:self.executionTimeLabel];  
}

- (void)dropdownSelectionChanged:(id)sender {
    self.algorithmType = [self.dropdown titleOfSelectedItem];
    NSLog(@"User selected: %@", self.algorithmType);
}

- (void)dropdownChangedSize:(id)sender {
    self.dataSize = [self.dropdownSize titleOfSelectedItem];
    NSLog(@"User selected: %@", self.dataSize);
}
- (void)dropdownChangedDataType:(id)sender {
    self.dataType = [self.dropdownDataType titleOfSelectedItem];
    NSLog(@"Data type: %@", self.dataType);
}
-(void)generateArray:(id)sender{
   // First, check if arraySize is set properly (e.g., from the dropdown)
    NSLog(@"Data type in generate array: %@", self.dataType);
  
    [self.arrayWarning setStringValue: @"Array is generating. Please wait."];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];  // Allow UI updates with notification
    NSInteger size = [self.dataSize intValue]; // Get the array size as an integer
   
    if([self.dataType isEqualToString:@"integer"]){
    // Allocate memory for the array based on the size
    self.array = malloc(size * sizeof(int)); // Allocate space for 'size' integers
    
    if (self.array == NULL) {
        NSLog(@"Memory allocation failed.");
        return;
    }
    
    for (int i = 0; i < size; i++) {
        self.array[i] = rand() % 1000000; 
    }
    [self.arrayWarning setStringValue: @"Array is generated"];
    NSLog(@"Generated array:");
    for (int i = 0; i < size; i++) {
        NSLog(@"%d", self.array[i]);
    }

    }
    if([self.dataType isEqualToString:@"real"]){
        NSLog(@"To generate real");
         self.arrayReal = malloc(size * sizeof(double));

    if (self.arrayReal == NULL) {
        NSLog(@"Memory allocation failed.");
        return;
    }
    
    // Populate the array with random values
    for (int i = 0; i < size; i++) {
       double randomNum = (double)(rand() % 1000000) / 1000.0;  // Random float value
            if (rand() % 2 == 0) {
                randomNum = -randomNum;  // 50% chance to make it negative
            }
            self.arrayReal[i] = randomNum; 
    }
    [self.arrayWarning setStringValue: @"Array is generated"];
    // Optional: Print the generated array to check if it's correct
    NSLog(@"Generated array:");
    for (int i = 0; i < size; i++) {
        NSLog(@"%f", self.arrayReal[i]);
    }
    }
   
}

- (void)sortGenerated:(id)sender{
    //add here data type
     if([self.dataType isEqualToString:@"real"]){
         if (self.arrayReal == NULL) {
        [self.arrayWarning setStringValue: @"Array is not generated yet."];
        return;
        }
      
        terminal_float([self.algorithmType UTF8String], [self.dataSize intValue], self.arrayReal); //convert to C string from Object-C string

        [self updateExecutionTime:executionTime]; // Call the update method with the execution time

     }
     if([self.dataType isEqualToString:@"integer"]){
        if (self.array == NULL) {
        [self.arrayWarning setStringValue: @"Array is not generated yet."];
        return;
        }
      
        terminal([self.algorithmType UTF8String], [self.dataSize intValue], self.array); //convert to C string from Object-C string

        [self updateExecutionTime:executionTime]; // Call the update method with the execution time
     }
    
}

- (void)updateExecutionTime:(double)executionTime {
    // Update the text field with the new execution time
      NSLog(@"Object-C execution time: %f ", executionTime);
    [self.executionTimeLabel setStringValue:[NSString stringWithFormat:@"Execution Time: %f seconds and made %d swaps", executionTime, swapCounter]];
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
    mergeSort(array, 0, length-1);
   // heapSort(array, length);

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
    
    free(array);
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
