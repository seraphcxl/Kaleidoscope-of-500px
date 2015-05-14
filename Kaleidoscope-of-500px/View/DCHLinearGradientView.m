//
//  DCHLinearGradientView.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/14/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHLinearGradientView.h"

@implementation DCHLinearGradientView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    do {
        CGContextRef myContext = UIGraphicsGetCurrentContext();
        CGContextSaveGState(myContext);
        CGContextClipToRect(myContext, self.bounds);
        
        NSInteger componentCount = 2;
        CGFloat locations[2] = {0.0, 1.0};
        CGFloat components[8] = {0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0};
        CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef myGradient = CGGradientCreateWithColorComponents(myColorSpace, components, locations, componentCount);
        
        CGPoint myStartPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
        CGPoint myEndPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        CGContextDrawLinearGradient(myContext, myGradient, myStartPoint, myEndPoint, kCGGradientDrawsAfterEndLocation);
        
        CGContextRestoreGState(myContext);
    } while (NO);
}

@end
