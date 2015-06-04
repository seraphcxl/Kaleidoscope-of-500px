//
//  UIImage+DCHImageEffects.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 6/4/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "UIImage+DCHImageEffects.h"
#import <CoreImage/CoreImage.h>
#import <Tourbillon/DCHTourbillon.h>

@implementation UIImage (DCHImageEffects)

- (UIImage *)dch_applyGaussianBlurWithRadius:(CGFloat)blurRadius {
    UIImage *result = nil;
    do {
        CIContext *ciContent = [CIContext contextWithOptions:nil];
        CIImage *ciImage = [CIImage imageWithCGImage:self.CGImage];
        CIFilter *ciGaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [ciGaussianBlurFilter setValue:ciImage forKey:kCIInputImageKey];
        [ciGaussianBlurFilter setValue:@(blurRadius) forKey:kCIInputRadiusKey];
        CGImageRef cgImage = [ciContent createCGImage:ciGaussianBlurFilter.outputImage fromRect:ciImage.extent];
        result = [UIImage imageWithCGImage:cgImage];
    } while (NO);
    return result;
}

- (void)dch_asyncApplyGaussianBlurWithRadius:(CGFloat)blurRadius completed:(DCHGaussianBlurCompletionBlock)completedBlock {
    do {
        if (!completedBlock) {
            break;
        }
        [NSThread runInBackground:^{
            do {
                UIImage *blurImage = [self dch_applyGaussianBlurWithRadius:blurRadius];
                [NSThread runInMain:^{
                    do {
                        if (completedBlock) {
                            completedBlock(blurImage, nil);
                        }
                    } while (NO);
                }];
            } while (NO);
        }];
    } while (NO);
}

@end
