//
//  DCHImageCollectionViewCell.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/12/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHImageCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
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

- (void)refreshWithPhotoModel:(DCHPhotoModel *)photoModel {
    do {
        if (!self.imageView) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            imageView.autoresizingMask = (UIViewAutoresizingNone);
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.contentView addSubview:imageView];
            self.imageView = imageView;
        }
        
        self.photoModel = photoModel;
        
        [self.imageView sd_cancelCurrentAnimationImagesLoad];
        self.imageView.image = nil;
        if (photoModel) {
            CGRect uiDisplayBounds = CGRectMake(0.0f, 0.0f, self.photoModel.uiDisplaySize.width, self.photoModel.uiDisplaySize.height);
            [self.imageView resetFrameInFrame:uiDisplayBounds forParallaxOrientation:DCHParallax_Orientation_Vertial andSize:DCHParallax_Size_Middle];
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
        } else {
            
        }
    } while (NO);
}

- (void)refreshWithPhotoModel:(DCHPhotoModel *)photoModel onScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view {
    do {
        if (!scrollView || !view) {
            break;
        }
        
        [self refreshWithPhotoModel:photoModel];
        
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
