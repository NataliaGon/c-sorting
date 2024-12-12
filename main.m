#import <Cocoa/Cocoa.h>
#import "sort.h"
#import "terminal.h"


// LineChartView: Custom View for Drawing a Simple Line Chart
@interface LineChartView : NSView
@property (nonatomic, strong) NSArray *dataPoints; // Y-values for the chart
@property (nonatomic, strong) NSArray *monthLabels; // X-axis labels (months)
@end

@implementation LineChartView

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        _dataPoints = @[]; // Default empty array
        _monthLabels = @[]; // Default empty labels
    }
    return self;
}

- (void)setDataPoints:(NSArray *)dataPoints {
    _dataPoints = dataPoints;
    [self setNeedsDisplay:YES];  // Redraw when data changes
}

- (void)setMonthLabels:(NSArray *)monthLabels {
    _monthLabels = monthLabels;
    [self setNeedsDisplay:YES];  // Redraw when labels change
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Set up drawing context
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];
    
    // Drawing setup
    NSColor *lineColor = [NSColor systemBlueColor];
    [lineColor setStroke];
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    CGFloat padding = 30.0;
    CGFloat maxY = [[self.dataPoints valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat minY = [[self.dataPoints valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat rangeY = maxY - minY;
    
    if (rangeY == 0) rangeY = 1;  // Prevent division by zero
    
    CGFloat chartWidth = self.frame.size.width - 2 * padding;
    CGFloat chartHeight = self.frame.size.height - 2 * padding;
    
    // Plot data points
    for (int i = 0; i < self.dataPoints.count; i++) {
        CGFloat xPos = padding + (i * chartWidth / (self.dataPoints.count - 1));
        CGFloat yPos = padding + (([self.dataPoints[i] floatValue] - minY) / rangeY) * chartHeight;
        
        if (i == 0) {
            [path moveToPoint:NSMakePoint(xPos, yPos)];
        } else {
            [path lineToPoint:NSMakePoint(xPos, yPos)];
        }
    }
    
    [path stroke];
    
    // Draw X-axis labels (Months)
    if (self.monthLabels.count > 0) {
        for (int i = 0; i < self.monthLabels.count; i++) {
            CGFloat xPos = padding + (i * chartWidth / (self.monthLabels.count - 1));
            NSString *label = self.monthLabels[i];
            NSDictionary *attributes = @{NSFontAttributeName: [NSFont systemFontOfSize:10],
                                         NSForegroundColorAttributeName: [NSColor blackColor]};
            [label drawAtPoint:NSMakePoint(xPos, padding / 2) withAttributes:attributes];
        }
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

// Toggle second window to show the chart
- (void)toggleSecondWindow:(id)sender {
    if (self.isSecondWindowOpen) {
        // If the second window is already open, bring it to the front
        if (self.secondWindow) {
            [self.secondWindow makeKeyAndOrderFront:nil];
        }
    } else {
        // Create the second window only once, if not already created
        if (!self.secondWindow) {
            // Create the second window with frame and properties
            NSRect frame = NSMakeRect(0, 0, 400, 300);
            self.secondWindow = [[NSWindow alloc] initWithContentRect:frame
                                                           styleMask:(NSWindowStyleMaskTitled |
                                                                        NSWindowStyleMaskClosable |
                                                                        NSWindowStyleMaskResizable)
                                                             backing:NSBackingStoreBuffered
                                                               defer:NO];
            [self.secondWindow setTitle:@"Second Window"];
            
            // Add the line chart view to the second window
            LineChartView *chartView = [[LineChartView alloc] initWithFrame:NSMakeRect(0, 0, 400, 300)];
            [self.secondWindow.contentView addSubview:chartView];
            
            // Provide some dummy data points for the chart (for example: random data)
            NSArray *dummyData = @[@10, @30, @50, @20, @40, @60, @70, @90];
            chartView.dataPoints = dummyData;
        }
        
        // Make the window visible and bring it to the front
        [self.secondWindow makeKeyAndOrderFront:nil];
        self.isSecondWindowOpen = YES;
    }
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
