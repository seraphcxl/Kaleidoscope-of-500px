//
//  UIImage+DCHImageEffects.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 6/4/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DCHGaussianBlurCompletionBlock)(NSString *identifer, UIImage *image, NSError *error);

@interface UIImage (DCHImageEffects)

- (UIImage *)dch_applyGaussianBlurWithRadius:(CGFloat)blurRadius;
- (NSString *)dch_asyncApplyGaussianBlurWithRadius:(CGFloat)blurRadius completed:(DCHGaussianBlurCompletionBlock)completedBlock;

@end
