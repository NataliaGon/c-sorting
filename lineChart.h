// LineChartView.h
#ifndef LineChartView_h
#define LineChartView_h

#import <Cocoa/Cocoa.h>

// Declaring the LineChartView class as a subclass of NSView
@interface LineChartView : NSView

// Data properties to hold the Y-values and X-axis labels for the chart
@property(nonatomic, strong) NSArray *dataPoints;  // Y-values (data for the chart)
@property(nonatomic, strong) NSArray *monthLabels; // X-values (months)

@end

#endif /* LineChartView_h */
