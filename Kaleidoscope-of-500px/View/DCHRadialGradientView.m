//
//  DCHRadialGradientView.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/14/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHRadialGradientView.h"

@implementation DCHRadialGradientView

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
        CGFloat components[8] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8};
        CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef myGradient = CGGradientCreateWithColorComponents(myColorSpace, components, locations, componentCount);
        
        CGPoint myCenterPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
//        CGFloat radius = self.bounds.size.width > self.bounds.size.height ? self.bounds.size.width / 2 : self.bounds.size.height / 2;
        CGFloat radius = powf(self.bounds.size.width, 2) + powf(self.bounds.size.height, 2);
        radius = sqrtf(radius) / 2;
        CGFloat endRadius = radius;
        CGFloat startRadius = endRadius * 0.8;
        CGContextDrawRadialGradient(myContext, myGradient, myCenterPoint, startRadius, myCenterPoint, endRadius, kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(myContext);
    } while (NO);
}

@end
