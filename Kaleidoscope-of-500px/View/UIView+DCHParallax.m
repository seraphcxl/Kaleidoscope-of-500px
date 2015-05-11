//
//  UIView+DCHParallax.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/18/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "UIView+DCHParallax.h"
#import "DCHCommonConstants.h"

@implementation UIView (DCHParallax)

DCH_DEFINE_ASSOCIATEDOBJECT_FOR_CLASS(ParallaxView, UIView_DCHParallax_kParallaxView, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

- (void)resetFrameForParallax:(DCHParallax_Orientation)orientation {
    do {
        CGRect frame = self.bounds;
        
        BOOL needCalcX = NO;
        BOOL needCalcY = NO;
        
        switch (orientation) {
            case DCHParallax_Orientation_Both:
            { needCalcX = needCalcY = YES; }
                break;
            case DCHParallax_Orientation_Horizontal:
            { needCalcX = YES; }
                break;
            case DCHParallax_Orientation_Vertial:
            { needCalcY = YES; }
                break;
            default:
                break;
        }
        
        if (needCalcX) {
            NSInteger deltaX = frame.size.width / 4;
            frame.origin.x -= deltaX;
            frame.size.width += deltaX * 2;
        }
        if (needCalcY) {
            NSInteger deltaY = frame.size.height / 4;
            frame.origin.y -= deltaY;
            frame.size.height += deltaY * 2;
        }
        
        self.frame = frame;
    } while (NO);
}

- (void)setParallaxView:(UIView *)parallaxView forOrientation:(DCHParallax_Orientation)orientation onScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view {
    do {
        if (!parallaxView || !scrollView || !view) {
            break;
        }
        [self setParallaxView:parallaxView];
        
        BOOL needCalcX = NO;
        BOOL needCalcY = NO;
        
        switch (orientation) {
            case DCHParallax_Orientation_Both:
            { needCalcX = needCalcY = YES; }
                break;
            case DCHParallax_Orientation_Horizontal:
            { needCalcX = YES; }
                break;
            case DCHParallax_Orientation_Vertial:
            { needCalcY = YES; }
                break;
            default:
                break;
        }
        
        CGRect parallaxViewRect = parallaxView.frame;
        if (needCalcX) {
            parallaxViewRect.origin.x = [self calcParallaxOriginXOnScrollView:scrollView scrollOnView:view];
        }
        if (needCalcY) {
            parallaxViewRect.origin.y = [self calcParallaxOriginYOnScrollView:scrollView scrollOnView:view];
        }
        parallaxView.frame = parallaxViewRect;
    } while (NO);
}

// github.com/jberlana/JBParallaxCell
- (void)parallaxViewOnScrollView:(UIScrollView *)scrollView didScrollOnView:(UIView *)view {
    do {
        if (!scrollView || !view) {
            break;
        }
        if (![[self getParallaxView] isKindOfClass:[UIView class]]) {
            break;
        }
        UIView *parallaxView = (UIView *)[self getParallaxView];
        CGRect parallaxViewRect = parallaxView.frame;
        if (DCHFloatingNumberEqualToZero(scrollView.frame.size.height + scrollView.contentOffset.y - scrollView.contentSize.height)) {
            parallaxViewRect.origin.x = [self calcParallaxOriginXOnScrollView:scrollView scrollOnView:view];
        }
        
        if (DCHFloatingNumberEqualToZero(scrollView.frame.size.width + scrollView.contentOffset.x - scrollView.contentSize.width)) {
            parallaxViewRect.origin.y = [self calcParallaxOriginYOnScrollView:scrollView scrollOnView:view];
        }
        parallaxView.frame = parallaxViewRect;
    } while (NO);
}

- (CGFloat)calcParallaxOriginXOnScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view {
    CGFloat result = 0.0f;
    do {
        if (!scrollView || !view) {
            break;
        }
        if (![[self getParallaxView] isKindOfClass:[UIView class]]) {
            break;
        }
        UIView *parallaxView = (UIView *)[self getParallaxView];
        CGRect rectInSuperview = [scrollView convertRect:self.frame toView:view];
        float distanceFromCenter = CGRectGetWidth(view.frame) / 2 - CGRectGetMinX(rectInSuperview);
        float difference = CGRectGetWidth(parallaxView.frame) - CGRectGetWidth(self.frame);
        float move = (distanceFromCenter / CGRectGetWidth(view.frame)) * difference;
        
        result = (- (difference / 2) + move);
    } while (NO);
    return result;
}

- (CGFloat)calcParallaxOriginYOnScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view {
    CGFloat result = 0.0f;
    do {
        if (!scrollView || !view) {
            break;
        }
        if (![[self getParallaxView] isKindOfClass:[UIView class]]) {
            break;
        }
        UIView *parallaxView = (UIView *)[self getParallaxView];
        CGRect rectInSuperview = [scrollView convertRect:self.frame toView:view];
        float distanceFromCenter = CGRectGetHeight(view.frame) / 2 - CGRectGetMinY(rectInSuperview);
        float difference = CGRectGetHeight(parallaxView.frame) - CGRectGetHeight(self.frame);
        float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference;
        
        result = (- (difference / 2) + move);
    } while (NO);
    return result;
}

@end
