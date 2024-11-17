#import <Cocoa/Cocoa.h>
#import "sort.h"
#import "terminal.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong) NSWindow *window;
@property (strong) NSTextField *inputTextField;
@property (strong) NSTextField *outputLabel;
@property (nonatomic, strong) NSPopUpButton *dropdown;
@property (nonatomic, strong) NSTextField *dropdownLabel; 
@property (nonatomic, strong) NSString *algorithmType;
@end

@implementation AppDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        // Set the default value for algorithmType
        _algorithmType = @"Merge";  // Default value
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Window setup
    NSRect frame = NSMakeRect(0, 0, 1000, 600);
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
    self.dropdownLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(100, 240, 200, 30)];
    [self.dropdownLabel setBezeled:NO];
    [self.dropdownLabel setDrawsBackground:NO];
    [self.dropdownLabel setEditable:NO];
    [self.dropdownLabel setSelectable:NO];
    [self.dropdownLabel setStringValue:@"Choose sort type:"];
    [self.window.contentView addSubview:self.dropdownLabel];

    // Create the dropdown menu
    self.dropdown = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(100, 200, 200, 30) pullsDown:NO];
    [self.dropdown addItemWithTitle:@"Merge"];
    [self.dropdown addItemWithTitle:@"Quick"];
    [self.dropdown addItemWithTitle:@"Heap"];
    [self.dropdown setTarget:self];
    [self.dropdown setAction:@selector(dropdownSelectionChanged:)];
    [self.window.contentView addSubview:self.dropdown];

    NSButton *sortGeneratedButton = [[NSButton alloc] initWithFrame:NSMakeRect(150, 160, 200, 30)];
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
    [sortGeneratedButton setAction:@selector(sortGererated:)];
    [self.window.contentView addSubview:sortGeneratedButton];
    
}

- (void)dropdownSelectionChanged:(id)sender {
    self.algorithmType = [self.dropdown titleOfSelectedItem];
    NSLog(@"User selected: %@", self.algorithmType);
}

- (void)sortGererated:(id)sender{
    terminal([self.algorithmType UTF8String], 0, 0); //convert to C string from Object-C string
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
