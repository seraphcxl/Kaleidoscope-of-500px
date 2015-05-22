//
//  UIView+DCHParallax.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/18/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+DCHAssociatedObjectExtension.h"

typedef NS_ENUM(NSUInteger, DCHParallax_Orientation) {
    DCHParallax_Orientation_Both,
    DCHParallax_Orientation_Horizontal,
    DCHParallax_Orientation_Vertial,
};

typedef NS_ENUM(NSUInteger, DCHParallax_Size) {
    DCHParallax_Size_Small = 10,
    DCHParallax_Size_Middle = 8,
    DCHParallax_Size_Large = 6,
};

@interface UIView (DCHParallax)

DCH_DEFINE_ASSOCIATEDOBJECT_FOR_HEADER(ParallaxView)
DCH_DEFINE_ASSOCIATEDOBJECT_FOR_HEADER(ParallaxContainerView)
DCH_DEFINE_ASSOCIATEDOBJECT_FOR_HEADER(ParallaxBaseView)
DCH_DEFINE_ASSOCIATEDOBJECT_FOR_HEADER(ParallaxScrollView)

- (void)resetFrameInFrame:(CGRect)frame forParallaxOrientation:(DCHParallax_Orientation)orientation andSize:(DCHParallax_Size)size;

- (void)resetFrameForParallaxOrientation:(DCHParallax_Orientation)orientation andSize:(DCHParallax_Size)size;

- (void)setParallaxView:(UIView *)parallaxView forOrientation:(DCHParallax_Orientation)orientation onScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view;
- (void)setParallaxView:(UIView *)parallaxView inContainerView:(UIView *)containerView forOrientation:(DCHParallax_Orientation)orientation onScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view;

- (void)parallaxViewOnScrollView:(UIScrollView *)scrollView didScrollOnView:(UIView *)view;

- (CGFloat)calcParallaxOriginXOnScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view;
- (CGFloat)calcParallaxOriginYOnScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view;

- (void)resetParallaxViews;

@end
