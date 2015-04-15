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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    return self;
}

- (void)refresh {
    do {
        if (self.photoModel.thumbnailURL) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.photoModel.thumbnailURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                do {
                    ;
                } while (NO);
            }];
        }
    } while (NO);
}

@end
