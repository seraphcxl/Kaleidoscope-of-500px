//
//  DCHBubbleAnimatedTransitioning.h
//  BubbleTransition
//
//  Created by Derek Chen on 5/20/15.
//  Copyright (c) 2015 seraphcxl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DCHBubbleAnimatedTransitioning_Mode) {
    DCHBubbleAnimatedTransitioning_Mode_Present,
    DCHBubbleAnimatedTransitioning_Mode_Dismiss,
};

@interface DCHBubbleAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGPoint startingPoint;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) DCHBubbleAnimatedTransitioning_Mode transitionMode;
@property (nonatomic, assign) UIColor *bubbleColor;
@property (nonatomic, strong, readonly) UIView *bubbleView;

@end
