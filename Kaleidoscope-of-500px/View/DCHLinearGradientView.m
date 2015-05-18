//
//  DCHLinearGradientView.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/14/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHLinearGradientView.h"

@implementation DCHLinearGradientView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.color = [UIColor blackColor];
        self.orientation = DCHLinearGradientView_Orientation_Bottom2Top;
        self.gradientSize = 0.5f;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.color = [UIColor blackColor];
        self.orientation = DCHLinearGradientView_Orientation_Bottom2Top;
        self.gradientSize = 0.5f;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib {
    do {
        self.color = [UIColor blackColor];
        self.orientation = DCHLinearGradientView_Orientation_Bottom2Top;
        self.gradientSize = 0.5f;
        self.backgroundColor = [UIColor clearColor];
    } while (NO);
}

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
        CGFloat components[8] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
        [self.color getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]];
        [self.color getRed:&components[4] green:&components[5] blue:&components[6] alpha:&components[7]];
        components[7] = 0.0f;
        
        CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef myGradient = CGGradientCreateWithColorComponents(myColorSpace, components, locations, componentCount);
        
        CGPoint myStartPoint = CGPointZero;
        CGPoint myEndPoint = CGPointZero;
        switch (self.orientation) {
            case DCHLinearGradientView_Orientation_Top2Bottom:
            {
                myStartPoint = CGPointMake(0.0f, 0.0f);
                myEndPoint = CGPointMake(0.0f, CGRectGetHeight(self.bounds) * self.gradientSize);
            }
                break;
            case DCHLinearGradientView_Orientation_Bottom2Top:
            {
                myStartPoint = CGPointMake(0.0f, CGRectGetHeight(self.bounds));
                myEndPoint = CGPointMake(0.0f, CGRectGetHeight(self.bounds) * (1.0f - self.gradientSize));
            }
                break;
            case DCHLinearGradientView_Orientation_Left2Right:
            {
                myStartPoint = CGPointMake(0.0f, 0.0f);
                myEndPoint = CGPointMake(CGRectGetWidth(self.bounds) * self.gradientSize, 0.0f);
            }
                break;
            case DCHLinearGradientView_Orientation_Right2Left:
            {
                myStartPoint = CGPointMake(CGRectGetWidth(self.bounds), 0.0f);
                myEndPoint = CGPointMake(CGRectGetWidth(self.bounds) * (1.0f - self.gradientSize), 0.0f);
            }
                break;
            default:
                break;
        }
        
        CGContextDrawLinearGradient(myContext, myGradient, myStartPoint, myEndPoint, kCGGradientDrawsAfterEndLocation);
        
        CGContextRestoreGState(myContext);
    } while (NO);
}

@end
