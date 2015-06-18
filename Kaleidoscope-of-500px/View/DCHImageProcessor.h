//
//  DCHImageProcessor.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 6/5/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//typedef void(^DCHImageProcessCompletionBlock)(NSString *UUID, UIImage *originalImage, UIImage *image, NSDictionary *info, NSError *error);
//
//@interface DCHImageProcessOperation : NSOperation
//
//@property (nonatomic, strong, readonly) NSString *UUID;
//@property (nonatomic, strong, readonly) UIImage *originalImage;
//@property (nonatomic, copy) DCHImageProcessCompletionBlock completion;
//
//- (instancetype)initWithImage:(UIImage *)image;
//
//@end
//
//@interface DCHImageGaussianBlurOperation : DCHImageProcessOperation
//
//- (instancetype)initWithImage:(UIImage *)image;
//
//@end

@interface DCHImageProcessor : NSObject

#pragma mark - GaussianBlur
+ (NSOperationQueue *)sharedGaussianBlurQueue;
+ (UIImage *)applyGaussianBlur:(UIImage *)image withRadius:(CGFloat)blurRadius;

#pragma mark - Resize
+ (NSOperationQueue *)sharedResizeQueue;
+ (UIImage *)applyResize:(UIImage *)image toSize:(CGSize)newSize withContentMode:(UIViewContentMode)contentMode;

@end
