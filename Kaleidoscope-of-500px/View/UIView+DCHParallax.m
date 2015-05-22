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

DCH_DEFINE_ASSOCIATEDOBJECT_FOR_CLASS(ParallaxView, UIView_DCHParallax_kParallaxView, OBJC_ASSOCIATION_ASSIGN)
DCH_DEFINE_ASSOCIATEDOBJECT_FOR_CLASS(ParallaxContainerView, UIView_DCHParallax_kParallaxContainerView, OBJC_ASSOCIATION_ASSIGN)
DCH_DEFINE_ASSOCIATEDOBJECT_FOR_CLASS(ParallaxBaseView, UIView_DCHParallax_kParallaxBaseView, OBJC_ASSOCIATION_ASSIGN)
DCH_DEFINE_ASSOCIATEDOBJECT_FOR_CLASS(ParallaxScrollView, UIView_DCHParallax_kParallaxScrollView, OBJC_ASSOCIATION_ASSIGN)

- (void)resetFrameInFrame:(CGRect)frame forParallaxOrientation:(DCHParallax_Orientation)orientation andSize:(DCHParallax_Size)size {
    do {
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
            NSInteger deltaX = frame.size.width / (int)size;
            frame.origin.x -= deltaX;
            frame.size.width += deltaX * 2;
        }
        if (needCalcY) {
            NSInteger deltaY = frame.size.height / (int)size;
            frame.origin.y -= deltaY;
            frame.size.height += deltaY * 2;
        }
        
        self.frame = frame;
    } while (NO);
}

- (void)resetFrameForParallaxOrientation:(DCHParallax_Orientation)orientation andSize:(DCHParallax_Size)size {
    [self resetFrameInFrame:self.bounds forParallaxOrientation:orientation andSize:size];
}

- (void)setParallaxView:(UIView *)parallaxView forOrientation:(DCHParallax_Orientation)orientation onScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view {
    [self setParallaxView:parallaxView inContainerView:self forOrientation:orientation onScrollView:scrollView scrollOnView:view];
}

- (void)setParallaxView:(UIView *)parallaxView inContainerView:(UIView *)containerView forOrientation:(DCHParallax_Orientation)orientation onScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view {
    do {
        if (!parallaxView || !containerView || !scrollView || !view) {
            break;
        }
        [self setParallaxView:parallaxView];
        [self setParallaxContainerView:containerView];
        
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
        UIView *parallaxContainerView = (UIView *)[self getParallaxContainerView];
        
        CGRect rectSelfInSuperview = [scrollView convertRect:self.frame toView:view];
        CGRect rectContainerInSelf = [self convertRect:parallaxContainerView.frame toView:self];
        CGRect rect = CGRectMake(rectContainerInSelf.origin.x + rectSelfInSuperview.origin.x, rectContainerInSelf.origin.y + rectSelfInSuperview.origin.y, CGRectGetWidth(rectContainerInSelf), CGRectGetHeight(rectContainerInSelf));
        
        float distanceFromCenter = CGRectGetWidth(view.frame) / 2 - CGRectGetMinX(rect);
        float difference = CGRectGetWidth(parallaxView.frame) - CGRectGetWidth(parallaxContainerView.frame);
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
        UIView *parallaxContainerView = (UIView *)[self getParallaxContainerView];
        
        CGRect rectSelfInSuperview = [scrollView convertRect:self.frame toView:view];
        CGRect rectContainerInSelf = [self convertRect:parallaxContainerView.frame toView:self];
        CGRect rect = CGRectMake(rectContainerInSelf.origin.x + rectSelfInSuperview.origin.x, rectContainerInSelf.origin.y + rectSelfInSuperview.origin.y, CGRectGetWidth(rectContainerInSelf), CGRectGetHeight(rectContainerInSelf));
        
        float distanceFromCenter = CGRectGetHeight(view.frame) / 2 - CGRectGetMinY(rect);
        float difference = CGRectGetHeight(parallaxView.frame) - CGRectGetHeight(parallaxContainerView.frame);
        float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference;
        
        result = (- (difference / 2) + move);
    } while (NO);
    return result;
}

- (void)resetParallaxViews {
    do {
        [self setParallaxView:nil];
        [self setParallaxContainerView:nil];
    } while (NO);
}
@end
