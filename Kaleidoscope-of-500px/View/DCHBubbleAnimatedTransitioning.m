//
//  DCHBubbleAnimatedTransitioning.m
//  BubbleTransition
//
//  Created by Derek Chen on 5/20/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import "DCHBubbleAnimatedTransitioning.h"

@interface DCHBubbleAnimatedTransitioning ()

@property (nonatomic, strong) UIView *bubbleView;

@end

@implementation DCHBubbleAnimatedTransitioning

- (void)dealloc {
    do {
        self.bubbleView = nil;
    } while (NO);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.startingPoint = CGPointZero;
        self.duration = 0.5f;
        self.transitionMode = DCHBubbleAnimatedTransitioning_Mode_Present;
        self.bubbleColor = [UIColor whiteColor];
        self.bubbleView = nil;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    do {
        if (!transitionContext) {
            break;
        }
        UIView *containerView = [transitionContext containerView];
        switch (self.transitionMode) {
            case DCHBubbleAnimatedTransitioning_Mode_Present:
            {
//                UIViewController *presentedController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
                UIView *presentedControllerView = [transitionContext viewForKey:UITransitionContextToViewKey];
                
                CGPoint originalCenter = presentedControllerView.center;
                CGSize originalSize = presentedControllerView.frame.size;
                CGFloat lengthX = fmax(self.startingPoint.x, originalSize.width - self.startingPoint.x);
                CGFloat lengthY = fmax(self.startingPoint.y, originalSize.height - self.startingPoint.y);
                CGFloat offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2;
                CGSize size = CGSizeMake(offset, offset);
                
                if (self.bubbleView) {
                    [self.bubbleView removeFromSuperview];
                    self.bubbleView = nil;
                }
                self.bubbleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
                self.bubbleView.layer.cornerRadius = size.height / 2;
                self.bubbleView.center = self.startingPoint;
                self.bubbleView.transform = CGAffineTransformMakeScale(0.001, 0.001);
                self.bubbleView.backgroundColor = self.bubbleColor;
                [containerView addSubview:self.bubbleView];
                
                presentedControllerView.center = self.startingPoint;
                presentedControllerView.transform = CGAffineTransformMakeScale(0.001, 0.001);
                presentedControllerView.alpha = 0.0f;
                [containerView addSubview:presentedControllerView];
                
                [UIView animateWithDuration:self.duration animations:^{
                    do {
                        do {
                            self.bubbleView.transform = CGAffineTransformIdentity;
                            presentedControllerView.transform = CGAffineTransformIdentity;
                            presentedControllerView.alpha = 1.0f;
                            presentedControllerView.center = originalCenter;
                        } while (NO);
                    } while (NO);
                } completion:^(BOOL finished) {
                    do {
                        [transitionContext completeTransition:true];
                    } while (NO);
                }];
            }
                break;
            case DCHBubbleAnimatedTransitioning_Mode_Dismiss:
            {
//                UIViewController *returningController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
                UIView *returningControllerView = [transitionContext viewForKey:UITransitionContextFromViewKey];
                
                [UIView animateWithDuration:self.duration animations:^{
                    do {
                        self.bubbleView.transform = CGAffineTransformMakeScale(0.001, 0.001);
                        returningControllerView.transform = CGAffineTransformMakeScale(0.001, 0.001);
                        returningControllerView.center = self.startingPoint;
                        returningControllerView.alpha = 0.0f;
                    } while (NO);
                } completion:^(BOOL finished) {
                    do {
                        [returningControllerView removeFromSuperview];
                        if (self.bubbleView) {
                            [self.bubbleView removeFromSuperview];
                        }
                        [transitionContext completeTransition:true];
                    } while (NO);
                }];
            }
                break;
            default:
                break;
        }
    } while (NO);
}

@end
