//
//  DCHShimmeringHUD.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/15/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Shimmer/FBShimmeringView.h>

@interface DCHShimmeringHUD : NSObject

@property (nonatomic, strong, readonly) FBShimmeringView *shimmeringView;

- (void)showHUDTo:(UIView *)view withText:(NSString *)text font:(UIFont *)font andBackgroundColor:(UIColor *)backgroundColor;
- (void)dismiss;
- (void)hardDismiss;

@end
