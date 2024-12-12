#import "LineChartView.h"

@implementation LineChartView

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _monthLabels = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun"];
        _dataPoints = @[@(50), @(100), @(200), @(150), @(300), @(250)]; // Example data for months
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    [[NSColor whiteColor] setFill];  // Set background color
    NSRectFill(dirtyRect);  // Fill the view's background
    
    // Set the line color for the chart
    [[NSColor blueColor] setStroke];
    NSBezierPath *path = [NSBezierPath bezierPath];

    CGFloat padding = 30.0; // Padding from edges for the chart
    CGFloat chartWidth = self.bounds.size.width - 2 * padding;
    CGFloat chartHeight = self.bounds.size.height - 2 * padding;
    
    CGFloat xStep = chartWidth / (self.dataPoints.count - 1); // X-axis step per data point
    CGFloat yMax = [[self.dataPoints valueForKeyPath:@"@max.doubleValue"] doubleValue]; // Max Y value for scaling
    
    // Create the path for the line chart
    for (int i = 0; i < self.dataPoints.count; i++) {
        CGFloat x = padding + i * xStep; // X position based on step
        CGFloat y = padding + (yMax - [self.dataPoints[i] doubleValue]) / yMax * chartHeight; // Inverted Y-axis for graph

        if (i == 0) {
            [path moveToPoint:NSMakePoint(x, y)]; // Start the path at the first point
        } else {
            [path lineToPoint:NSMakePoint(x, y)]; // Draw lines to the next points
        }
    }
    
    // Draw the line path
    [path stroke];
    
    // Draw the X-axis labels (month names)
    [[NSColor blackColor] setFill];
    for (int i = 0; i < self.monthLabels.count; i++) {
        NSString *label = self.monthLabels[i];
        CGFloat x = padding + i * xStep;
        NSDictionary *attributes = @{NSFontAttributeName: [NSFont systemFontOfSize:12]};
        [label drawAtPoint:NSMakePoint(x - 10, padding - 20) withAttributes:attributes]; // Adjust text position
    }
    
    // Draw the Y-axis labels (data values)
    for (int i = 0; i <= 5; i++) {
        CGFloat y = padding + (yMax - (yMax / 5) * i) / yMax * chartHeight;
        NSString *yLabel = [NSString stringWithFormat:@"%d", (int)(yMax / 5) * i];
        NSDictionary *attributes = @{NSFontAttributeName: [NSFont systemFontOfSize:12]};
        [yLabel drawAtPoint:NSMakePoint(padding - 40, y - 10) withAttributes:attributes];
    }
}

@end
