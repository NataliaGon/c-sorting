#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong) NSWindow *window;
@property (strong) NSTextField *inputTextField;
@property (strong) NSTextField *outputLabel;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Window
    NSRect frame = NSMakeRect(0, 0, 400, 200);
    self.window = [[NSWindow alloc] initWithContentRect:frame
                                               styleMask:(NSWindowStyleMaskTitled |
                                                          NSWindowStyleMaskClosable |
                                                          NSWindowStyleMaskResizable)
                                                 backing:NSBackingStoreBuffered
                                                   defer:NO];
    [self.window setTitle:@"Sorting Algorithm Visualizer"];
    [self.window makeKeyAndOrderFront:nil];
    
    // Text field
    self.inputTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 120, 360, 30)];
    [self.window.contentView addSubview:self.inputTextField];
    
    // Button to submit the value
    NSButton *submitButton = [[NSButton alloc] initWithFrame:NSMakeRect(150, 70, 100, 30)];
    [submitButton setTitle:@"Sort"];
    [submitButton setButtonType:NSButtonTypeMomentaryPushIn];
    [submitButton setBezelStyle:NSBezelStyleRounded];
    [submitButton setTarget:self];
    [submitButton setAction:@selector(showText:)];
    [self.window.contentView addSubview:submitButton];
    
    // Create the label to display the text
    self.outputLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 30, 360, 30)];
    [self.outputLabel setBezeled:NO];
    [self.outputLabel setDrawsBackground:NO];
    [self.outputLabel setEditable:NO];
    [self.outputLabel setSelectable:NO];
    [self.outputLabel setStringValue:@""]; // Make sure it's empty initially
    [self.window.contentView addSubview:self.outputLabel];
}

- (void)showText:(id)sender {
    // Get the text from the input field and display it in the output label
    NSString *inputText = [self.inputTextField stringValue];
    [self.outputLabel setStringValue:inputText];
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
