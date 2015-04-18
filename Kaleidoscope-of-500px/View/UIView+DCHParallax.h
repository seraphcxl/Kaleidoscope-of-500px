//
//  UIView+DCHParallax.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/18/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+DCHAssociatedObjectExtension.h"

@interface UIView (DCHParallax)

DCH_DEFINE_ASSOCIATEDOBJECT_FOR_HEADER(ParallaxView)

- (void)setParallaxView:(UIView *)parallaxView OnScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view;

- (void)parallaxViewOnScrollView:(UIScrollView *)scrollView didScrollOnView:(UIView *)view;

- (CGFloat)calcParallaxOriginXOnScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view;
- (CGFloat)calcParallaxOriginYOnScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view;

@end
