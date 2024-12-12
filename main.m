#import <Cocoa/Cocoa.h>
#import "sort.h"
#import "terminal.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>
@property (strong) NSWindow *window;
@property (strong) NSTextField *arrayNotification;
@property (nonatomic, strong) NSPopUpButton *dropdownAlgorithmType;
@property (nonatomic, strong) NSPopUpButton *dropdownSize;
@property (nonatomic, strong) NSPopUpButton *dropdownDataType;
@property (nonatomic, strong) NSTextField *dropdownLabelAlgorithmType; 
@property (nonatomic, strong) NSTextField *dropdownLabelSize; 
@property (nonatomic, strong) NSTextField *dropdownLabelDataType;
@property (strong) NSTextField *executionTimeLabel; 
@property (nonatomic, strong) NSString *algorithmType;
@property (nonatomic, strong) NSString *dataType;
@property (nonatomic, strong) NSString *dataSize;
@property (nonatomic) int *arrayInteger;
@property (nonatomic) double *arrayReal;
@property (strong) NSWindow *graphWindow;
@property (nonatomic) BOOL isGraphWindowOpen;
@property (nonatomic) double executionTime;
@property (nonatomic) int swapCounter;

@end

@implementation AppDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        _algorithmType = @"Merge";  
        _dataSize = @"1000"; 
        _dataType=@"Integer";
        _isGraphWindowOpen = NO; 
        _executionTime = 0.0;
        _swapCounter=0;
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // double executionTime = 0.0;
    // int swapCounter=0;

    NSRect frame = NSMakeRect(0, 0, 2000, 600);
    self.window = [[NSWindow alloc] initWithContentRect:frame
                                               styleMask:(NSWindowStyleMaskTitled |
                                                          NSWindowStyleMaskClosable |
                                                          NSWindowStyleMaskResizable)
                                                 backing:NSBackingStoreBuffered
                                                   defer:NO];
    [self.window setTitle:@"Sorting Algorithm Visualizer"];
    [self.window makeKeyAndOrderFront:nil];

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
    [self.dropdownDataType addItemWithTitle:@"Integer"];
    [self.dropdownDataType addItemWithTitle:@"Real"];
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

    // Warning-Notificaiton LABEL
    self.arrayNotification = [[NSTextField alloc] initWithFrame:NSMakeRect(350, 340, 360, 30)];
    [self.arrayNotification setBezeled:NO];
    [self.arrayNotification setDrawsBackground:NO];
    [self.arrayNotification setEditable:NO];
    [self.arrayNotification setSelectable:NO];
    [self.arrayNotification setStringValue:@""];
    [self.window.contentView addSubview:self.arrayNotification];

    // Choose sort type LABEL
    self.dropdownLabelAlgorithmType = [[NSTextField alloc] initWithFrame:NSMakeRect(600, 440, 200, 30)];
    [self.dropdownLabelAlgorithmType setBezeled:NO];
    [self.dropdownLabelAlgorithmType setDrawsBackground:NO];
    [self.dropdownLabelAlgorithmType setEditable:NO];
    [self.dropdownLabelAlgorithmType setSelectable:NO];
    [self.dropdownLabelAlgorithmType setStringValue:@"Step 3.Choose sort type:"];
    [self.window.contentView addSubview:self.dropdownLabelAlgorithmType ];

    // Choose sort type DROPDOWN
    self.dropdownAlgorithmType = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(600, 420, 200, 30) pullsDown:NO];
    [self.dropdownAlgorithmType addItemWithTitle:@"Merge"];
    [self.dropdownAlgorithmType addItemWithTitle:@"Quick"];
    [self.dropdownAlgorithmType addItemWithTitle:@"Heap"];
    [self.dropdownAlgorithmType setTarget:self];
    [self.dropdownAlgorithmType setAction:@selector(dropdownSelectionChanged:)];
    [self.window.contentView addSubview:self.dropdownAlgorithmType];

    // Sort generated array BUTTON
    NSButton *sortGeneratedButton = [[NSButton alloc] initWithFrame:NSMakeRect(600, 380, 200, 30)];
    [sortGeneratedButton setTitle:@"Sort generated array"];
    [sortGeneratedButton setButtonType:NSButtonTypeMomentaryPushIn];
    [sortGeneratedButton setBezelStyle:NSBezelStyleRounded];
    [sortGeneratedButton setTarget:self];
    [sortGeneratedButton setBordered:NO];
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
    
      // Open Graph Window Button
NSButton *openGraphWindowButton = [[NSButton alloc] initWithFrame:NSMakeRect(850, 380, 200, 30)];
[openGraphWindowButton setTitle:@"Open/Close Graph"];
[openGraphWindowButton setButtonType:NSButtonTypeMomentaryPushIn];
[openGraphWindowButton setBezelStyle:NSBezelStyleRounded];
[openGraphWindowButton setTarget:self];
[openGraphWindowButton setBordered:NO];
openGraphWindowButton.wantsLayer = YES;
openGraphWindowButton.layer.backgroundColor = [[NSColor systemBlueColor] CGColor];
openGraphWindowButton.layer.cornerRadius = 5.0;
[openGraphWindowButton setAction:@selector(openGraphWindow:)];
[self.window.contentView addSubview:openGraphWindowButton];

    
}

- (void)dealloc {
    // Free dynamically allocated memory when the object is deallocated
    if (self.arrayInteger != NULL) {
        free(self.arrayInteger);
        self.arrayInteger = NULL;  
    }
    if (self.arrayReal != NULL) {
        free(self.arrayReal);
        self.arrayReal = NULL; 
    }
}


- (void)dropdownSelectionChanged:(id)sender {
    self.algorithmType = [self.dropdownAlgorithmType titleOfSelectedItem];
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
  
    [self.arrayNotification setStringValue: @"Array is generating. Please wait."];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];  // Allow UI updates with notification
    NSInteger size = [self.dataSize intValue]; // Get the array size as an integer
   
    if([self.dataType isEqualToString:@"Integer"]){
    // Allocate memory for the array based on the size
    self.arrayInteger = malloc(size * sizeof(int)); // Allocate space for 'size' integers
    
    if (self.arrayInteger == NULL) {
        NSLog(@"Memory allocation failed.");
        return;
    }
    
    for (int i = 0; i < size; i++) {
        self.arrayInteger[i] = rand() % 1000000; 
    }
    [self.arrayNotification setStringValue: @"Array is generated"];
    NSLog(@"Generated array:");
    for (int i = 0; i < size; i++) {
        NSLog(@"%d", self.arrayInteger[i]);
    }

    }
    if([self.dataType isEqualToString:@"Real"]){
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
    [self.arrayNotification setStringValue: @"Array is generated"];
    // Optional: Print the generated array to check if it's correct
    NSLog(@"Generated array:");
    for (int i = 0; i < size; i++) {
        NSLog(@"%f", self.arrayReal[i]);
    } 
    }
}

- (void)sortGenerated:(id)sender{
   
      if([self.dataType isEqualToString:@"Integer"]){
        if (self.arrayInteger == NULL) {
        [self.arrayNotification setStringValue: @"Array is not generated yet."];
        return;
        }
      
        terminal_integer([self.algorithmType UTF8String], [self.dataSize intValue], self.arrayInteger);

        [self updateExecutionTime:executionTime]; 
     }

     if([self.dataType isEqualToString:@"Real"]){
         if (self.arrayReal == NULL) {
        [self.arrayNotification setStringValue: @"Array is not generated yet."];
        return;
        }
      
        terminal_real([self.algorithmType UTF8String], [self.dataSize intValue], self.arrayReal); 

        [self updateExecutionTime:executionTime]; 

     }
}

- (void)updateExecutionTime:(double)executionTime {
    [self.executionTimeLabel setStringValue:[NSString stringWithFormat:@"Execution Time: %f seconds \nSwaps: %d ", executionTime, swapCounter]];
}

- (void)openGraphWindow:(id)sender {
    if (self.isGraphWindowOpen) {
        // If the graph window is already open, close it
        [self.graphWindow close];
        self.graphWindow = nil;  // Reset the window reference
        self.isGraphWindowOpen = NO;
    } else {
        // If the graph window is not open, create and open it
        NSRect frame = NSMakeRect(0, 0, 800, 600);
        
        // Create the graph window if it's not already created or has been closed
        if (!self.graphWindow) {
            self.graphWindow = [[NSWindow alloc] initWithContentRect:frame
                                                          styleMask:(NSWindowStyleMaskTitled |
                                                                       NSWindowStyleMaskClosable |
                                                                       NSWindowStyleMaskResizable)
                                                            backing:NSBackingStoreBuffered
                                                              defer:NO];
            [self.graphWindow setTitle:@"Graph Window"];
        }
        
        // Add a custom view to draw the graph
        NSView *graphView = [[NSView alloc] initWithFrame:frame];
        [self.graphWindow.contentView addSubview:graphView];
        
        // Draw the graph on the view
        [self drawGraphInView:graphView];
        
        // Show the graph window
        [self.graphWindow makeKeyAndOrderFront:nil];
        self.isGraphWindowOpen = YES;
    }
}

- (void)windowWillClose:(NSNotification *)notification {
    // Check if the window being closed is the graph window
    if (notification.object == self.graphWindow) {
        // Reset the graph window reference to nil when it is closed
        self.graphWindow = nil; // Properly reset the graph window reference
        self.isGraphWindowOpen = NO; // Track that the graph window is no longer open
    }
}


- (void)drawGraphInView:(NSView *)view {
    // Set up a Bezier path to draw a simple graph
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    // Example: A simple sine wave
    CGFloat width = view.bounds.size.width;
    CGFloat height = view.bounds.size.height;
    CGFloat step = width / 100;
    
    // Start the path
    [path moveToPoint:NSMakePoint(0, height / 2)];
    
    for (CGFloat x = 0; x <= width; x += step) {
        CGFloat y = height / 2 + 100 * sin(x / width * 2 * M_PI);  // Sine wave formula
        [path lineToPoint:NSMakePoint(x, y)];
    }
    
    // Set the stroke color
    [[NSColor blueColor] setStroke];
    
    // Set the line width
    [path setLineWidth:2.0];
    
    // Draw the path
    [path stroke];
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
