//
//  DCHCategoryTableViewCell.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHCategoryTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DCHCategoryModel.h"
#import "DCHPhotoModel.h"
#import <Tourbillon/DCHTourbillon.h>

@interface DCHCategoryTableViewCell ()

@property (nonatomic, strong) DCHCategoryModel *categoryModel;

@end

@implementation DCHCategoryTableViewCell

- (void)dealloc {
    do {
        self.categoryModel = nil;
    } while (NO);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)layoutSubviews {
//    do {
//        if (!self.categoryModel) {
//            break;
//        }
//        
//        
//    } while (NO);
//}

- (void)refreshWithCategoryModel:(DCHCategoryModel *)categoryModel {
    do {
        self.categoryModel = categoryModel;
        self.gradientView.backgroundColor = [UIColor clearColor];
        if (!categoryModel) {
            self.nameLabel.text = @"";
            
            NSArray *imgViews = @[self.leftImgView, self.centerImgView, self.rightImgView];
            
            for (NSUInteger idx = 0; idx < imgViews.count; ++idx) {
                UIImageView *imgView = imgViews[idx];
                imgView.image = nil;
                [imgView sd_cancelCurrentImageLoad];
            }
        } else {
            self.nameLabel.text = [DCHCategoryModel description4Category:self.categoryModel.category];
            
            NSArray *imgViews = @[self.leftImgView, self.centerImgView, self.rightImgView];
            
            for (NSUInteger idx = 0; idx < imgViews.count; ++idx) {
                UIImageView *imgView = imgViews[idx];
                DCHPhotoModel *model = nil;
                DCHArraySafeRead(self.categoryModel.models, idx, model);
                if (!model) {
                    continue;
                }
                
                imgView.image = nil;
                [imgView sd_cancelCurrentImageLoad];
                if (model.thumbnailData) {
                    imgView.image = [UIImage imageWithData:model.thumbnailData];
                } else {
                    if (model.thumbnailURL) {
                        [imgView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            do {
                                if (error) {
                                    NSLog(@"sd_setImageWithURL err:%@", error);
                                    break;
                                }
                                if (!image) {
                                    break;
                                }
                                if ([model.thumbnailURL isEqualToString:[imageURL absoluteString]]) {
                                    model.thumbnailData = UIImageJPEGRepresentation(image, 0.6);
                                }
                            } while (NO);
                        }];
                    }
                }
//                imgView.hidden = YES;
            }
            
//            [self drawGradient];
        }
        
    } while (NO);
}

- (void)drawRect:(CGRect)rect {
    return;
    do {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGImageRef backgroundimage = CGBitmapContextCreateImage(context);
        CGContextClearRect(context, rect);
        //        CGContextDrawImage(context, rect, backgroundimage);
        
        // save state
        CGContextSaveGState(context);
        
        // flip the context (right-sideup)
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        // colors/components/locations
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        CGFloat black[4] = {0.0f, 0.0f, 0.0f, 0.7f};
        CGFloat white[4] = {1.0f, 1.0f, 1.0f, 1.0f};//clear
        
        CGFloat components[8] = {
            black[0],black[1],black[2],black[3],
            white[0],white[1],white[2],white[3],
            
        };
        
        CGFloat colorLocations[2] = {0.25f, 0.5f};
        CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorspace, components, colorLocations, 2);
        CGPoint startPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
        CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y);
        CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, 0);
        CGColorSpaceRelease(colorspace);
        CGContextRestoreGState(context);
        
        //convert drawing to image for masking
        CGImageRef maskImage = CGBitmapContextCreateImage(context);
        CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskImage),
                                            CGImageGetHeight(maskImage),
                                            CGImageGetBitsPerComponent(maskImage),
                                            CGImageGetBitsPerPixel(maskImage),
                                            CGImageGetBytesPerRow(maskImage),
                                            CGImageGetDataProvider(maskImage), NULL, FALSE);
        
        
        //mask the background image
        CGImageRef masked = CGImageCreateWithMask(backgroundimage, mask);
        CGImageRelease(backgroundimage);
        //remove the spotlight gradient now that we have it as image
        CGContextClearRect(context, rect);
        
        //draw the transparent background with the mask
        CGContextDrawImage(context, rect, masked);
        
        CGImageRelease(maskImage);
        CGImageRelease(mask);
        CGImageRelease(masked);
    } while (NO);
}

- (void)drawGradient {
    do {
        CGRect rect = self.gradientView.frame;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGImageRef backgroundimage = CGBitmapContextCreateImage(context);
        CGContextClearRect(context, rect);
//        CGContextDrawImage(context, rect, backgroundimage);
        
        // save state
        CGContextSaveGState(context);
        
        // flip the context (right-sideup)
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        // colors/components/locations
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        CGFloat black[4] = {0.0f, 0.0f, 0.0f, 0.7f};
        CGFloat white[4] = {1.0f, 1.0f, 1.0f, 1.0f};//clear
        
        CGFloat components[8] = {
            black[0],black[1],black[2],black[3],
            white[0],white[1],white[2],white[3],
            
        };
        
        CGFloat colorLocations[2] = {0.25f, 0.5f};
        CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorspace, components, colorLocations, 2);
        CGPoint startPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
        CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y);
        CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, 0);
        CGColorSpaceRelease(colorspace);
        CGContextRestoreGState(context);
        
        //convert drawing to image for masking
        CGImageRef maskImage = CGBitmapContextCreateImage(context);
        CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskImage),
                                            CGImageGetHeight(maskImage),
                                            CGImageGetBitsPerComponent(maskImage),
                                            CGImageGetBitsPerPixel(maskImage),
                                            CGImageGetBytesPerRow(maskImage),
                                            CGImageGetDataProvider(maskImage), NULL, FALSE);
        
        
        //mask the background image
        CGImageRef masked = CGImageCreateWithMask(backgroundimage, mask);
        CGImageRelease(backgroundimage);
        //remove the spotlight gradient now that we have it as image
        CGContextClearRect(context, rect);
        
        //draw the transparent background with the mask
        CGContextDrawImage(context, rect, masked);
        
        CGImageRelease(maskImage);
        CGImageRelease(mask);
        CGImageRelease(masked);
    } while (NO);
}

@end
