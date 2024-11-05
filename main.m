#import <Cocoa/Cocoa.h>
#import "quickSort.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong) NSWindow *window;
@property (strong) NSTextField *inputTextField;
@property (strong) NSTextField *outputLabel;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Window setup
    NSRect frame = NSMakeRect(0, 0, 400, 200);
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
