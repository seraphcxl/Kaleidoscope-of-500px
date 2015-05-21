//
//  UIImage+DCHColorArt.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/18/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DCHColorArt_EdgeType) {
    DCHColorArt_EdgeType_Top,
    DCHColorArt_EdgeType_Bottom,
    DCHColorArt_EdgeType_Left,
    DCHColorArt_EdgeType_Right,
};

@interface UIImage (DCHColorArt)

- (UIColor *)findMajorColorWithAlphaEnable:(BOOL)alphaEnable;
- (UIColor *)findEdgeColorWithType:(DCHColorArt_EdgeType)type countOfLine:(NSUInteger)countOfLine alphaEnable:(BOOL)alphaEnable;
- (BOOL)isEqualToByBytes:(UIImage *)otherImage;

@end
