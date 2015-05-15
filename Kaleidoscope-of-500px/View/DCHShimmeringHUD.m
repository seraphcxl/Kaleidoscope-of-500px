//
//  DCHShimmeringHUD.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/15/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHShimmeringHUD.h"
#import <UIKit/UIKit.h>
#import <Tourbillon/DCHTourbillon.h>

@interface DCHShimmeringHUD ()

@property (nonatomic, strong) FBShimmeringView *shimmeringView;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, assign) NSUInteger showCount;
@property (nonatomic, weak) UIView *baseView;

- (void)createHUD;

@end

@implementation DCHShimmeringHUD

- (void)dealloc {
    do {
        self.baseView = nil;
        
        [self.loadingLabel removeFromSuperview];
        self.loadingLabel = nil;
        
        [self.shimmeringView removeFromSuperview];
        self.shimmeringView = nil;
    } while (NO);
}

- (instancetype)init {
    return [self initWitText:nil font:nil color:nil andBackgroundColor:nil];
}

- (instancetype)initWitText:(NSString *)text font:(UIFont *)font color:(UIColor *)color andBackgroundColor:(UIColor *)backgroundColor {
    self = [super init];
    if (self) {
        [self createHUD];
        if (!DCH_IsEmpty(text)) {
            self.loadingLabel.text = text;
        }
        if (!DCH_IsEmpty(font)) {
            self.loadingLabel.font = font;
        }
        if (!DCH_IsEmpty(color)) {
            self.loadingLabel.textColor = color;
        }
        if (!DCH_IsEmpty(backgroundColor)) {
            self.shimmeringView.backgroundColor = backgroundColor;
        }
    }
    return self;
}

- (void)createHUD {
    do {
        self.shimmeringView = [[FBShimmeringView alloc] init];
        self.shimmeringView.shimmering = YES;
        self.shimmeringView.shimmeringBeginFadeDuration = 0.3;
        self.shimmeringView.shimmeringOpacity = 0.3;
        self.shimmeringView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        
        self.loadingLabel = [[UILabel alloc] initWithFrame:self.shimmeringView.frame];
        self.loadingLabel.text = @"Loading";
        self.loadingLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:60.0];
        self.loadingLabel.textColor = [UIColor whiteColor];
        self.loadingLabel.textAlignment = NSTextAlignmentCenter;
        self.loadingLabel.backgroundColor = [UIColor clearColor];
        self.shimmeringView.contentView = self.loadingLabel;
    } while (NO);
}

- (void)showHUDTo:(UIView *)view andShimmeringImmediately:(BOOL)shimmeringImmediately {
    [self showHUDTo:view withText:nil font:nil color:nil backgroundColor:nil andShimmeringImmediately:shimmeringImmediately];
}

- (void)showHUDTo:(UIView *)view withText:(NSString *)text font:(UIFont *)font color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor andShimmeringImmediately:(BOOL)shimmeringImmediately {
    do {
        if (!view || (self.baseView && self.baseView != view)) {
            break;
        }
        if (!self.shimmeringView) {
            [self createHUD];
        }
        if (!DCH_IsEmpty(text)) {
            self.loadingLabel.text = text;
        }
        if (!DCH_IsEmpty(font)) {
            self.loadingLabel.font = font;
        }
        if (!DCH_IsEmpty(color)) {
            self.loadingLabel.textColor = color;
        }
        if (backgroundColor) {
            self.shimmeringView.backgroundColor = backgroundColor;
        }
        self.shimmeringView.shimmering = shimmeringImmediately;
        
        self.shimmeringView.frame = view.bounds;
        ++self.showCount;
        if (self.baseView == view) {
            ;
        } else {
            self.baseView = view;
            [view addSubview:self.shimmeringView];
        }
    } while (NO);
}

- (void)dismiss {
    do {
        --self.showCount;
        if (self.showCount == 0) {
            [self hardDismiss];
        }
    } while (NO);
}

- (void)hardDismiss {
    do {
        [self.shimmeringView removeFromSuperview];
        self.baseView = nil;
    } while (NO);
}
@end
