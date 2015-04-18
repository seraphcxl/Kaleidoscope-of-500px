//
//  DCHGalleryCollectionViewCell.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHGalleryCollectionViewCell.h"
#import "DCHPhotoModel.h"
#import <Tourbillon/DCHTourbillon.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface DCHGalleryCollectionViewCell ()

@property (nonatomic, strong) DCHPhotoModel *photoModel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DCHGalleryCollectionViewCell

- (void)dealloc {
    do {
        [self.imageView removeFromSuperview];
        self.imageView = nil;
        self.photoModel = nil;
    } while (NO);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    // Configure self
    self.backgroundColor = [UIColor darkGrayColor];
    
    // Configure subivews
    CGRect imageFrame = self.bounds;
    
    NSInteger deltaX = imageFrame.size.width / 4;
    imageFrame.origin.x -= deltaX;
    imageFrame.size.width += deltaX * 2;
    
    NSInteger deltaY = imageFrame.size.height / 4;
    imageFrame.origin.y -= deltaY;
    imageFrame.size.height += deltaY * 2;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    imageView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    self.contentView.clipsToBounds = YES;
    
    return self;
}

- (void)refreshWithPhotoModel:(DCHPhotoModel *)photoModel onScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view {
    do {
        if (!photoModel || !scrollView || !view) {
            break;
        }
        self.photoModel = photoModel;
        
        [self setParallaxView:self.imageView OnScrollView:scrollView scrollOnView:view];
        
        self.imageView.image = nil;
        if (self.photoModel.thumbnailData) {
            self.imageView.image = [UIImage imageWithData:self.photoModel.thumbnailData];
        } else {
            if (self.photoModel.thumbnailURL) {
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.photoModel.thumbnailURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    do {
                        if (error) {
                            NSLog(@"sd_setImageWithURL err:%@", error);
                            break;
                        }
                        if (!image) {
                            break;
                        }
                        if ([self.photoModel.thumbnailURL isEqualToString:[imageURL absoluteString]]) {
                            self.photoModel.thumbnailData = UIImageJPEGRepresentation(image, 0.6);
                        }
                    } while (NO);
                }];
            }
        }
    } while (NO);
}

@end
