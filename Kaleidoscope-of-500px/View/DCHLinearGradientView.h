//
//  DCHLinearGradientView.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/14/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DCHLinearGradientView_Orientation) {
    DCHLinearGradientView_Orientation_Top2Bottom,
    DCHLinearGradientView_Orientation_Bottom2Top,
    DCHLinearGradientView_Orientation_Left2Right,
    DCHLinearGradientView_Orientation_Right2Left,
};

@interface DCHLinearGradientView : UIView

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) DCHLinearGradientView_Orientation orientation;
@property (nonatomic, assign) CGFloat gradientSize;  // 0->1

@end
