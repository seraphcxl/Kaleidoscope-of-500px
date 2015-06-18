//
//  DCHImageProcessor.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 6/5/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHImageProcessor.h"
#import <Tourbillon/DCHTourbillon.h>

//@interface DCHImageProcessOperation ()
//
//@property (nonatomic, strong) NSString *UUID;
//@property (nonatomic, strong) UIImage *originalImage;
//
//@end
//
//@implementation DCHImageProcessOperation
//
//- (void)dealloc {
//    do {
//        self.originalImage = nil;
//        self.completion = nil;
//        self.UUID = nil;
//    } while (NO);
//}
//
//- (instancetype)initWithImage:(UIImage *)image {
//    if (!image) {
//        return nil;
//    }
//    self = [self init];
//    if (self) {
//        self.UUID = [NSString dch_createUUID];
//        self.originalImage = image;
//    }
//    return self;
//}
//
//@end
//
//@implementation DCHImageGaussianBlurOperation
//
//- (void)main {
//    do {
//        if (!self.originalImage) {
//            break;
//        }
//    } while (NO);
//}
//
//@end

@implementation DCHImageProcessor

+ (NSOperationQueue *)sharedGaussianBlurQueue {
    static dispatch_once_t onceToken;
    static NSOperationQueue *gDCHImageProcessorSharedGaussianBlurQueue;
    dispatch_once(&onceToken, ^{
        gDCHImageProcessorSharedGaussianBlurQueue = [[NSOperationQueue alloc] init];
        gDCHImageProcessorSharedGaussianBlurQueue.maxConcurrentOperationCount = 2;
    });
    return gDCHImageProcessorSharedGaussianBlurQueue;
}

+ (UIImage *)applyGaussianBlur:(UIImage *)image withRadius:(CGFloat)blurRadius {
    UIImage *result = nil;
    do {
        if (!image) {
            break;
        }
        CIContext *ciContent = [CIContext contextWithOptions:nil];
        CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
        CIFilter *ciGaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [ciGaussianBlurFilter setValue:ciImage forKey:kCIInputImageKey];
        [ciGaussianBlurFilter setValue:@(blurRadius) forKey:kCIInputRadiusKey];
        CGImageRef cgImage = [ciContent createCGImage:ciGaussianBlurFilter.outputImage fromRect:ciImage.extent];
        result = [UIImage imageWithCGImage:cgImage];
    } while (NO);
    return result;
}

+ (NSOperationQueue *)sharedResizeQueue {
    static dispatch_once_t onceToken;
    static NSOperationQueue *gDCHImageProcessorSharedResizeQueue;
    dispatch_once(&onceToken, ^{
        gDCHImageProcessorSharedResizeQueue = [[NSOperationQueue alloc] init];
        gDCHImageProcessorSharedResizeQueue.maxConcurrentOperationCount = 2;
    });
    return gDCHImageProcessorSharedResizeQueue;
}

+ (UIImage *)applyResize:(UIImage *)image toSize:(CGSize)newSize withContentMode:(UIViewContentMode)contentMode {
    UIImage *result = nil;
    CGContextRef bitmapContext = nil;
    CGImageRef scaledImageRef = nil;
    CGColorSpaceRef colourSpace = nil;
    do {
        if (!image) {
            break;
        }
        if (CGSizeEqualToSize(newSize, CGSizeZero)) {
            break;
        }
        
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        CGFloat imageScale = image.scale;
        CGFloat contextWidth = newSize.width * imageScale;
        CGFloat contextHeight = newSize.height * imageScale;
        
        switch (contentMode) {
            case UIViewContentModeCenter: {
                x = (newSize.width - width) / 2;
                y = (newSize.height - height) / 2;
            }
                break;
            case UIViewContentModeTop: {
                x = (newSize.width - width) / 2;
                y = (newSize.height - height);
            }
                break;
            case UIViewContentModeBottom: {
                x = (newSize.width - width) / 2;
            }
                break;
            case UIViewContentModeLeft: {
                y = (newSize.height - height) / 2;
            }
                break;
            case UIViewContentModeRight: {
                x = (newSize.width - width);
                y = (newSize.height - height) / 2;;
            }
                break;
            case UIViewContentModeTopLeft: {
                y = (newSize.height - height);
            }
                break;
            case UIViewContentModeTopRight: {
                x = (newSize.width - width);
                y = (newSize.height - height);
            }
                break;
            case UIViewContentModeBottomLeft:
                break;
            case UIViewContentModeBottomRight: {
                x = (newSize.width - width);
            }
                break;
            case UIViewContentModeScaleAspectFit: {
                CGFloat ratio = MIN((newSize.width / width), (newSize.height / height));
                width *= ratio;
                height *= ratio;
                x = (newSize.width - width) / 2;
                y = (newSize.height - height) / 2;
            }
                break;
            case UIViewContentModeScaleAspectFill: {
                CGFloat ratio = MAX((newSize.width / width), (newSize.height / height));
                width *= ratio;
                height *= ratio;
                x = (newSize.width - width) / 2;
                y = (newSize.height - height) / 2;
            }
                break;
            case UIViewContentModeScaleToFill:
            default: {
                width = newSize.width;
                height = newSize.height;
            }
                break;
        }
        
        colourSpace = CGColorSpaceCreateDeviceRGB();
        bitmapContext = CGBitmapContextCreate(NULL, contextWidth, contextHeight, 8, 0, colourSpace, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrderDefault);
        
        CGContextSetShouldAntialias(bitmapContext, true);
        CGContextSetAllowsAntialiasing(bitmapContext, true);
        CGContextSetInterpolationQuality(bitmapContext, kCGInterpolationHigh);
        
        CGContextDrawImage(bitmapContext, CGRectMake(x * imageScale, y * imageScale, width * imageScale, height * imageScale), image.CGImage);
        
        scaledImageRef = CGBitmapContextCreateImage(bitmapContext);
        result = [UIImage imageWithCGImage:scaledImageRef scale:imageScale orientation:image.imageOrientation];
    } while (NO);
    if (colourSpace) {
        CGColorSpaceRelease(colourSpace);
        colourSpace = nil;
    }
    if (scaledImageRef) {
        CGImageRelease(scaledImageRef);
        scaledImageRef = nil;
    }
    if (bitmapContext) {
        CGContextRelease(bitmapContext);
        bitmapContext = nil;
    }
    return result;
}

@end

