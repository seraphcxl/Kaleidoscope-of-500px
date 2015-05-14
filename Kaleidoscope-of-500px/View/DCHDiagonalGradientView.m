//
//  DCHDiagonalGradientView.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/14/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHDiagonalGradientView.h"

@implementation DCHDiagonalGradientView

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
        
        CGFloat len = MIN(self.bounds.size.width, self.bounds.size.height) / 4;
        
        CGPoint myStartPoint1 = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds));
        CGPoint myEndPoint1 = CGPointMake(myStartPoint1.x + len, myStartPoint1.y - len);
        CGContextDrawLinearGradient(myContext, myGradient, myStartPoint1, myEndPoint1, kCGGradientDrawsAfterEndLocation);
        
        CGPoint myStartPoint2 = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMinY(self.bounds));
        CGPoint myEndPoint2 = CGPointMake(myStartPoint2.x - len, myStartPoint2.y + len);
        CGContextDrawLinearGradient(myContext, myGradient, myStartPoint2, myEndPoint2, kCGGradientDrawsAfterEndLocation);
        
        CGContextRestoreGState(myContext);
    } while (NO);
}

@end
