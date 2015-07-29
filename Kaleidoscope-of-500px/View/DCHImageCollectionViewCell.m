//
//  DCHImageCollectionViewCell.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/12/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHImageCollectionViewCell.h"
#import <DCHImageTurbo/DCHImageTurbo.h>
#import "DCHPhotoModel.h"
#import <Tourbillon/DCHTourbillon.h>
#import "UIView+DCHParallax.h"

@interface DCHImageCollectionViewCell ()

@property (nonatomic, strong) DCHPhotoModel *photoModel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DCHImageCollectionViewCell

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (void)dealloc {
    do {
        [self.imageView removeFromSuperview];
        self.imageView = nil;
        self.photoModel = nil;
    } while (NO);
}

- (void)awakeFromNib {
    // Initialization code
    self.contentView.clipsToBounds = YES;
}

- (void)refreshWithPhotoModel:(DCHPhotoModel *)photoModel imageSize:(CGSize)imageSize {
    do {
        if (!self.imageView) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            imageView.autoresizingMask = (UIViewAutoresizingNone);
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.contentView addSubview:imageView];
            self.imageView = imageView;
        }
        
        self.photoModel = photoModel;
        
        [self.imageView dch_cancelCurrentWebImageLoadOperation];
        self.imageView.image = nil;
        if (photoModel) {
            CGRect uiDisplayBounds = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
            [self.imageView resetFrameInFrame:uiDisplayBounds forParallaxOrientation:DCHParallax_Orientation_Vertial andSize:DCHParallax_Size_Middle];
            if (self.photoModel.thumbnailURL) {
                [self.imageView dch_setImageWithURL:[NSURL URLWithString:self.photoModel.thumbnailURL] placeholderImage:nil resize:uiDisplayBounds.size scale:[self.imageView dch_screenScale] completed:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL, SDImageCacheType cacheType) {
                    do {
                        if (error) {
                            NSLog(@"dch_setImageWithURL err:%@", error);
                            break;
                        }
                        if (!image) {
                            break;
                        }
                    } while (NO);
                }];
            }
        } else {
            
        }
    } while (NO);
}

- (void)refreshWithPhotoModel:(DCHPhotoModel *)photoModel imageSize:(CGSize)imageSize onScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view {
    do {
        if (!scrollView || !view) {
            break;
        }
        
        [self refreshWithPhotoModel:photoModel imageSize:imageSize];
        
        [self setParallaxView:self.imageView forOrientation:DCHParallax_Orientation_Vertial onScrollView:scrollView scrollOnView:view];
    } while (NO);
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    do {
        [super applyLayoutAttributes:layoutAttributes];
        self.contentView.frame = self.bounds;
    } while (NO);
}

- (UIImage *)image {
    UIImage *result = nil;
    do {
        if (self.imageView) {
            result = self.imageView.image;
        }
    } while (NO);
    return result;
}

@end
