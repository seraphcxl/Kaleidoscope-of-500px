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

- (void)showHUDTo:(UIView *)view withText:(NSString *)text font:(UIFont *)font andBackgroundColor:(UIColor *)backgroundColor {
    do {
        if (!view || (self.baseView && self.baseView != view)) {
            break;
        }
        if (!self.shimmeringView) {
            [self createHUD];
        }
        if (DCH_IsEmpty(text)) {
            self.loadingLabel.text = @"";
        } else {
            self.loadingLabel.text = text;
        }
        if (DCH_IsEmpty(font)) {
            ;
        } else {
            self.loadingLabel.font = font;
        }
        if (backgroundColor) {
            self.shimmeringView.backgroundColor = backgroundColor;
        }
        
        self.baseView = view;
        ++self.showCount;
        self.shimmeringView.frame = view.bounds;
        [view addSubview:self.shimmeringView];
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
