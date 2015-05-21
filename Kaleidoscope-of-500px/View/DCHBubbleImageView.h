//
//  DCHBubbleImageView.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/21/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCHBubbleImageView;

@protocol DCHBubbleImageViewTapDelegate <NSObject>

- (void)view:(UIView *)view tapDetected:(UITouch *)touch;

@end

@interface DCHBubbleImageView : UIImageView

@property (nonatomic, weak) id <DCHBubbleImageViewTapDelegate> tapDelegate;

@end
