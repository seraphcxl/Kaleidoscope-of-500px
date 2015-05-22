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

- (instancetype)initWitText:(NSString *)text font:(UIFont *)font color:(UIColor *)color andBackgroundColor:(UIColor *)backgroundColor;
- (void)showHUDTo:(UIView *)view andShimmeringImmediately:(BOOL)shimmeringImmediately;
- (void)showHUDTo:(UIView *)view withText:(NSString *)text font:(UIFont *)font color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor andShimmeringImmediately:(BOOL)shimmeringImmediately;
- (void)dismiss;
- (void)hardDismiss;

@end
