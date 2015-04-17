//
//  DCHGalleryCollectionViewCell.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHGalleryCollectionViewCell.h"
#import "DCHPhotoModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
    imageFrame.origin.y -= 40;
    imageFrame.size.height += 40 * 2;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    imageView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    self.contentView.clipsToBounds = YES;
    
    return self;
}

- (void)refresh {
    do {
        self.imageView.image = nil;
        if (self.photoModel.thumbnailURL) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.photoModel.thumbnailURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                do {
                    ;
                } while (NO);
            }];
        }
    } while (NO);
}

// https://github.com/jberlana/JBParallaxCell
- (void)cellOnScrollView:(UIScrollView *)scrollView didScrollOnView:(UIView *)view {
    CGRect rectInSuperview = [scrollView convertRect:self.frame toView:view];
    
    float distanceFromCenter = CGRectGetHeight(view.frame) / 2 - CGRectGetMinY(rectInSuperview);
    float difference = CGRectGetHeight(self.imageView.frame) - CGRectGetHeight(self.frame);
    float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference;
    
    CGRect imageRect = self.imageView.frame;
    imageRect.origin.y = - (difference / 2) + move;
    self.imageView.frame = imageRect;
}

@end
