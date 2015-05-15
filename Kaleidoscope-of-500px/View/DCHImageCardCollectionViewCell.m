//
//  DCHImageCardCollectionViewCell.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/14/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHImageCardCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DCHPhotoModel.h"
#import <Tourbillon/DCHTourbillon.h>
#import "UIImage+ImageEffects.h"
#import "UIView+DCHParallax.h"

const CGFloat DCHImageCardCollectionViewCell_DescLabelHeight = 100.0f;

@interface DCHImageCardCollectionViewCell ()

@property (nonatomic, strong) DCHPhotoModel *photoModel;
@property (nonatomic, strong) UIImageView *featureImageView;

@end

@implementation DCHImageCardCollectionViewCell

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (void)dealloc {
    do {
        [self.featureImageView removeFromSuperview];
        self.featureImageView = nil;
        
        self.photoModel = nil;
    } while (NO);
}

- (void)awakeFromNib {
    // Initialization code
    self.contentView.clipsToBounds = YES;
}

- (void)refreshWithPhotoModel:(DCHPhotoModel *)photoModel {
    do {
        self.photoModel = photoModel;
        
        if (!self.featureImageView) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.featureImageContainerView.bounds];
            imageView.autoresizingMask = (UIViewAutoresizingNone);
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.featureImageContainerView addSubview:imageView];
            self.featureImageView = imageView;
        }
        
        self.titlelabel.text = @"";
        self.descriptionLabel.text = @"";
        if (self.photoModel) {
            self.titlelabel.text = self.photoModel.photoName;
            self.descriptionLabel.text = self.photoModel.uiDescStr;
        }
        
        [self.featureImageView sd_cancelCurrentAnimationImagesLoad];
        self.featureImageView.image = nil;
        self.backgroundImageView.image = nil;
        
        if (self.photoModel) {
            CGRect uiDisplayBounds = CGRectMake(0.0f, 0.0f, self.photoModel.uiDisplaySize.width, self.photoModel.uiDisplaySize.height);
            [self.featureImageView resetFrameInFrame:uiDisplayBounds forParallaxOrientation:DCHParallax_Orientation_Vertial andSize:DCHParallax_Size_Middle];
            if (self.photoModel.thumbnailData) {
                UIImage *featureImage = [UIImage imageWithData:self.photoModel.thumbnailData];
                self.featureImageView.image = featureImage;
                self.backgroundImageView.image = [featureImage applyBlurWithRadius:30.0f tintColor:[UIColor colorWithWhite:0.5f alpha:0.3f] saturationDeltaFactor:1.8f maskImage:nil];
            } else {
                if (self.photoModel.thumbnailURL) {
                    [self.featureImageView sd_setImageWithURL:[NSURL URLWithString:self.photoModel.thumbnailURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
                                [NSThread runInMain:^{
                                    self.backgroundImageView.image = [image applyBlurWithRadius:30.0f tintColor:[UIColor colorWithWhite:0.5f alpha:0.3f] saturationDeltaFactor:1.8f maskImage:nil];
                                }];
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
        
        [self setParallaxView:self.featureImageView inContainerView:self.featureImageContainerView forOrientation:DCHParallax_Orientation_Vertial onScrollView:scrollView scrollOnView:view];
    } while (NO);
}

- (UIImage *)image {
    UIImage *result = nil;
    do {
        if (self.featureImageView) {
            result = self.featureImageView.image;
        }
    } while (NO);
    return result;
}

@end
