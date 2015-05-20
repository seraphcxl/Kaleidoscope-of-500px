//
//  UIImage+DCHColotArt.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/18/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DCHColotArt_EdgeType) {
    DCHColotArt_EdgeType_Top,
    DCHColotArt_EdgeType_Bottom,
    DCHColotArt_EdgeType_Left,
    DCHColotArt_EdgeType_Right,
};

@interface UIImage (DCHColotArt)

- (UIColor *)findMajorColor;
- (UIColor *)findEdgeColorWithType:(DCHColotArt_EdgeType)type countOfLine:(NSUInteger)countOfLine andMinimumPercentage:(CGFloat)minimumPercentage;
- (BOOL)isEqualToByBytes:(UIImage *)otherImage;

@end
