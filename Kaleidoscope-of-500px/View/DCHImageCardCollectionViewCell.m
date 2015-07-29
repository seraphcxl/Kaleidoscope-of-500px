//
//  DCHImageCardCollectionViewCell.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/14/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHImageCardCollectionViewCell.h"
#import <DCHImageTurbo/DCHImageTurbo.h>
#import "DCHPhotoModel.h"
#import <Tourbillon/DCHTourbillon.h>
#import "UIImage+ImageEffects.h"
#import "UIView+DCHParallax.h"
#import "DCHLinearGradientView.h"
#import "UIImage+DCHColorArt.h"
#import <libextobjc/EXTScope.h>

const CGFloat DCHImageCardCollectionViewCell_DescLabelHeight = 100.0f;

@interface DCHImageCardCollectionViewCell ()

@property (nonatomic, strong) DCHPhotoModel *photoModel;
@property (nonatomic, strong) UIImageView *featureImageView;
@property (nonatomic, strong) UIView *featureImageContainerView;
@end

@implementation DCHImageCardCollectionViewCell

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (void)dealloc {
    do {
        [self resetParallaxViews];
        
        [self.featureImageView removeFromSuperview];
        self.featureImageView = nil;
        
        [self.featureImageContainerView removeFromSuperview];
        self.featureImageContainerView = nil;
        
        self.photoModel = nil;
    } while (NO);
}

- (void)awakeFromNib {
    // Initialization code
//    self.contentView.clipsToBounds = YES;
}

- (void)refreshWithPhotoModel:(DCHPhotoModel *)photoModel imageSize:(CGSize)imageSize {
    do {
        self.photoModel = photoModel;
        
        self.titlelabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
        self.descriptionLabel.text = @"";
        if (self.photoModel) {
            self.titlelabel.attributedText = self.photoModel.uiTitleStr;
            self.descriptionLabel.text = self.photoModel.uiDescStr;
        }
        
        if (self.featureImageView) {
            [self.featureImageView dch_cancelCurrentWebImageLoadOperation];
            self.featureImageView.image = nil;
        }
        self.backgroundImageView.image = nil;
        
        if (self.photoModel) {
            CGRect uiDisplayBounds = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
            
            if (!self.featureImageContainerView) {
                UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
                containerView.autoresizingMask = (UIViewAutoresizingNone);
                containerView.clipsToBounds = YES;
                [self.contentView insertSubview:containerView belowSubview:self.gradientView];
                self.featureImageContainerView = containerView;
            }
            self.featureImageContainerView.frame = uiDisplayBounds;
            
            if (!self.featureImageView) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.featureImageContainerView.bounds];
                imageView.autoresizingMask = (UIViewAutoresizingNone);
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                [self.featureImageContainerView addSubview:imageView];
                self.featureImageView = imageView;
            }
            [self.featureImageView resetFrameInFrame:uiDisplayBounds forParallaxOrientation:DCHParallax_Orientation_Vertial andSize:DCHParallax_Size_Middle];
            
            if (self.photoModel.fullsizedURL) {
                @weakify(self);
                [self.featureImageView dch_setImageWithURL:[NSURL URLWithString:self.photoModel.fullsizedURL] placeholderImage:nil resize:imageSize scale:[self.featureImageView dch_screenScale] completed:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL, SDImageCacheType cacheType) {
                    @strongify(self);
                    do {
                        if (error) {
                            NSLog(@"dch_setImageWithURL err:%@", error);
                            break;
                        }
                        if (!image) {
                            break;
                        }
                        
                        self.featureImageView.image = image;
                        
                        if ([self.photoModel.fullsizedURL isEqualToString:[imageURL absoluteString]]) {
                            if (!self.photoModel.backgroundImage) {
                                [self.backgroundImageView dch_setImageWithURL:[NSURL URLWithString:self.photoModel.fullsizedURL] placeholderImage:nil applyBlurWithRadius:16 tintColor:[UIColor colorWithWhite:0 alpha:0.2] saturationDeltaFactor:1 maskImage:nil completed:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL, SDImageCacheType cacheType) {
                                    if (!DCH_IsEmpty(image)) {
                                        self.photoModel.backgroundImage = image;
                                    }
                                }];
//                                [NSThread dch_runInBackground:^{
//                                    @strongify(self);
//                                    self.photoModel.backgroundImage = [UIImage dch_applyGaussianBlur:image withRadius:30.0f];
//                                    [NSThread dch_runInMain:^{
//                                        @strongify(self);
//                                        self.backgroundImageView.image = self.photoModel.backgroundImage;
//                                    }];
//                                }];
                            } else {
                                [NSThread dch_runInMain:^{
                                    @strongify(self);
                                    self.backgroundImageView.image = self.photoModel.backgroundImage;
                                }];
                            }
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
