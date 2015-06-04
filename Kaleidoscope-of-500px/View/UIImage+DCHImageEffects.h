//
//  UIImage+DCHImageEffects.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 6/4/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DCHGaussianBlurCompletionBlock)(UIImage *image, NSError *error);

@interface UIImage (DCHImageEffects)

- (UIImage *)dch_applyGaussianBlurWithRadius:(CGFloat)blurRadius;
- (void)dch_asyncApplyGaussianBlurWithRadius:(CGFloat)blurRadius completed:(DCHGaussianBlurCompletionBlock)completedBlock;

@end
