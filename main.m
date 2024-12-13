#import <Cocoa/Cocoa.h>
#import "sort.h"
#import "terminal.h"



@interface LineChartView : NSView
@property (nonatomic, strong) NSArray *mergeDataPoints;  // Y-values for Merge
@property (nonatomic, strong) NSArray *heapDataPoints;   // Y-values for Heap
@property (nonatomic, strong) NSArray *quickDataPoints;  // Y-values for Quick
@property (nonatomic, strong) NSArray *xLabels;          // X-axis labels (dataset sizes)
@property (nonatomic, strong) NSString *chartTitle;      // Title of the chart
@end

@implementation LineChartView

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        _mergeDataPoints = @[];
        _heapDataPoints = @[];
        _quickDataPoints = @[];
        _xLabels = @[];
    }
    return self;
}

- (void)setMergeDataPoints:(NSArray *)mergeDataPoints {
    _mergeDataPoints = mergeDataPoints;
    [self setNeedsDisplay:YES];
}

- (void)setHeapDataPoints:(NSArray *)heapDataPoints {
    _heapDataPoints = heapDataPoints;
    [self setNeedsDisplay:YES];
}

- (void)setQuickDataPoints:(NSArray *)quickDataPoints {
    _quickDataPoints = quickDataPoints;
    [self setNeedsDisplay:YES];
}

- (void)setXLabels:(NSArray *)xLabels {
    _xLabels = xLabels;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];
    
    // Set up drawing context
    NSColor *mergeLineColor = [NSColor systemBlueColor];
    NSColor *heapLineColor = [NSColor systemGreenColor];
    NSColor *quickLineColor = [NSColor systemRedColor];
    
    CGFloat padding = 40.0;
    CGFloat chartWidth = self.frame.size.width - 2 * padding;
    CGFloat chartHeight = self.frame.size.height - 2 * padding;
    
    // Y-axis range
    CGFloat maxY = fmax([self calculateMaxValueFromDataPoints:@[self.mergeDataPoints, self.heapDataPoints, self.quickDataPoints]], 0.1);
    CGFloat minY = 0.0; // The Y-axis will always start from 0.0
    CGFloat rangeY = maxY - minY;
    
    // Draw the lines for Merge, Heap, and Quick Sorts (on one chart)
    [self drawLineChartWithDataPoints:self.mergeDataPoints lineColor:mergeLineColor chartWidth:chartWidth chartHeight:chartHeight minY:minY rangeY:rangeY padding:padding];
    [self drawLineChartWithDataPoints:self.heapDataPoints lineColor:heapLineColor chartWidth:chartWidth chartHeight:chartHeight minY:minY rangeY:rangeY padding:padding];
    [self drawLineChartWithDataPoints:self.quickDataPoints lineColor:quickLineColor chartWidth:chartWidth chartHeight:chartHeight minY:minY rangeY:rangeY padding:padding];
    
    // Draw X-axis labels
    for (int i = 0; i < self.xLabels.count; i++) {
        CGFloat xPos = padding + (i * chartWidth / (self.xLabels.count - 1));
        NSString *label = self.xLabels[i];
        NSDictionary *attributes = @{NSFontAttributeName: [NSFont systemFontOfSize:10],
                                     NSForegroundColorAttributeName: [NSColor blackColor]};
        [label drawAtPoint:NSMakePoint(xPos, padding / 2) withAttributes:attributes];
    }
    
    // Draw Y-axis labels
    for (int i = 0; i <= 5; i++) {
        CGFloat yPos = padding + ((chartHeight / 5) * i);
        CGFloat value = minY + (rangeY / 5) * i;
        NSString *label = [NSString stringWithFormat:@"%.1f", value];
        NSDictionary *attributes = @{NSFontAttributeName: [NSFont systemFontOfSize:10],
                                     NSForegroundColorAttributeName: [NSColor blackColor]};
        [label drawAtPoint:NSMakePoint(padding / 2, yPos) withAttributes:attributes];
    }
    
    [context restoreGraphicsState];
}

// Helper function to draw a line for one set of data points
- (void)drawLineChartWithDataPoints:(NSArray *)dataPoints lineColor:(NSColor *)lineColor chartWidth:(CGFloat)chartWidth chartHeight:(CGFloat)chartHeight minY:(CGFloat)minY rangeY:(CGFloat)rangeY padding:(CGFloat)padding {
    NSBezierPath *path = [NSBezierPath bezierPath];
    [lineColor setStroke];
    
    for (int i = 0; i < dataPoints.count; i++) {
        CGFloat xPos = padding + (i * chartWidth / (dataPoints.count - 1));
        CGFloat yPos = padding + (([dataPoints[i] floatValue] - minY) / rangeY) * chartHeight;
        
        if (i == 0) {
            [path moveToPoint:NSMakePoint(xPos, yPos)];
        } else {
            [path lineToPoint:NSMakePoint(xPos, yPos)];
        }
    }
    [path stroke];
}

// Helper function to find max value from multiple data sets
- (CGFloat)calculateMaxValueFromDataPoints:(NSArray *)dataSets{
    CGFloat maxVal = 0;
    for (NSArray *dataSet in dataSets) {
        CGFloat setMax = [[dataSet valueForKeyPath:@"@max.floatValue"] floatValue];
        if (setMax > maxVal) {
            maxVal = setMax;
        }
    }
    return maxVal;
}

@end



@interface AppDelegate : NSObject <NSApplicationDelegate>
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
@property (strong) NSWindow *secondWindow;  // Second window property
@property (nonatomic) BOOL isSecondWindowOpen;  // Flag to track if second window is open


@end

@implementation AppDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        _algorithmType = @"Merge";  
        _dataSize = @"1000"; 
        _dataType=@"Integer";
         _arrayInteger = NULL;
        _arrayReal = NULL;
        _isSecondWindowOpen = NO;
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    double executionTime = 0.0;
    int swapCounter=0;

    NSRect frame = NSMakeRect(0, 0, 2000, 600);
    // Inside applicationDidFinishLaunching
   [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(windowWillClose:)
                                             name:NSWindowWillCloseNotification
                                           object:nil];

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

    NSButton *toggleSecondWindowButton = [[NSButton alloc] initWithFrame:NSMakeRect(350, 300, 200, 30)];
    [toggleSecondWindowButton setTitle:@"Open Second Window"];
    [toggleSecondWindowButton setButtonType:NSButtonTypeMomentaryPushIn];
    [toggleSecondWindowButton setBezelStyle:NSBezelStyleRounded];
    [toggleSecondWindowButton setTarget:self];
    [toggleSecondWindowButton setAction:@selector(toggleSecondWindow:)];
    [self.window.contentView addSubview:toggleSecondWindowButton];

    // Initialize the flag for the second window
    self.isSecondWindowOpen = NO;
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

-(void)generateArray:(id)sender {
    NSLog(@"Data type in generate array: %@", self.dataType);
    
    // Update the notification text
    [self.arrayNotification setStringValue: @"Array is generating. Please wait."];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];  // Allow UI updates with notification
    
    NSInteger size = [self.dataSize intValue]; // Get the array size as an integer

    // If array is already allocated, free it before reallocating
    if ([self.dataType isEqualToString:@"Integer"]) {
        if (self.arrayInteger != NULL) {
            free(self.arrayInteger);  // Free previous integer array if it exists
        }
        
        // Allocate new memory for the integer array
        self.arrayInteger = malloc(size * sizeof(int));
        if (self.arrayInteger == NULL) {
            NSLog(@"Memory allocation failed for integer array.");
            return;
        }

        // Generate random values for the integer array
        for (int i = 0; i < size; i++) {
            self.arrayInteger[i] = rand() % 1000000;  // Random integer between 0 and 999999
        }

        [self.arrayNotification setStringValue: @"Integer array is generated"];
        
        // Optional: Print the generated array to check if it's correct
        NSLog(@"Generated integer array:");
        for (int i = 0; i < size; i++) {
            NSLog(@"%d", self.arrayInteger[i]);
        }
    }
    
    if ([self.dataType isEqualToString:@"Real"]) {
        if (self.arrayReal != NULL) {
            free(self.arrayReal);  // Free previous real array if it exists
        }

        // Allocate new memory for the real array
        self.arrayReal = malloc(size * sizeof(double));
        if (self.arrayReal == NULL) {
            NSLog(@"Memory allocation failed for real array.");
            return;
        }

        // Generate random real numbers for the array
        for (int i = 0; i < size; i++) {
            double randomNum = (double)(rand() % 1000000) / 1000.0;  // Random float value
            if (rand() % 2 == 0) {
                randomNum = -randomNum;  // 50% chance to make it negative
            }
            self.arrayReal[i] = randomNum;
        }

        [self.arrayNotification setStringValue: @"Real array is generated"];
        
        // Optional: Print the generated array to check if it's correct
        NSLog(@"Generated real array:");
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


- (void)toggleSecondWindow:(id)sender {
    if (self.isSecondWindowOpen) {
        [self.secondWindow makeKeyAndOrderFront:nil];
    } else {
        if (!self.secondWindow) {
            NSRect frame = NSMakeRect(0, 0, 1200, 600);  // Single window for one chart
            self.secondWindow = [[NSWindow alloc] initWithContentRect:frame
                                                           styleMask:(NSWindowStyleMaskTitled |
                                                                        NSWindowStyleMaskClosable |
                                                                        NSWindowStyleMaskResizable)
                                                             backing:NSBackingStoreBuffered
                                                               defer:NO];
            [self.secondWindow setTitle:@"Sorting Algorithm Chart"];

            // Create one chart (with 3 lines)
            LineChartView *chart = [[LineChartView alloc] initWithFrame:NSMakeRect(0, 0, 1200, 600)];
            [self.secondWindow.contentView addSubview:chart];

            // Set the chart title
            chart.chartTitle = @"Sorting Algorithms Comparison";

            // Provide dummy data for each algorithm
            NSArray *mergeSortData = @[@0.1, @0.5, @1.0, @0.7, @1.5];
            chart.mergeDataPoints = mergeSortData;

            NSArray *quickSortData = @[@0.3, @0.6, @0.9, @0.8, @1.2];
            chart.quickDataPoints = quickSortData;

            NSArray *heapSortData = @[@0.2, @0.4, @0.8, @1.1, @1.3];
            chart.heapDataPoints = heapSortData;

            // X-axis labels (dataset sizes)
            NSArray *xLabels = @[@"100", @"500", @"1000", @"5000", @"10000"];
            chart.xLabels = xLabels;
        }

        [self.secondWindow makeKeyAndOrderFront:nil];
    }
    self.isSecondWindowOpen = !self.isSecondWindowOpen;
}


- (void)windowWillClose:(NSNotification *)notification {
    if (notification.object == self.secondWindow) {
        // Log window closure
        NSLog(@"Second window closed, resetting flag.");
        
        // Reset the flag
        self.isSecondWindowOpen = NO;
        
        // Remove the observer for window closure notification
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSWindowWillCloseNotification
                                                      object:self.secondWindow];
        
        // Deallocate the second window reference
        self.secondWindow = nil;
    }
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
