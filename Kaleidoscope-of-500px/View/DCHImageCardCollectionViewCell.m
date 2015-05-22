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
#import "DCHLinearGradientView.h"
#import "UIImage+DCHColorArt.h"

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
            [self.featureImageView sd_cancelCurrentImageLoad];
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
                [self.featureImageView sd_setImageWithURL:[NSURL URLWithString:self.photoModel.fullsizedURL] placeholderImage:nil options:(SDWebImageRetryFailed) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    do {
                        if (error) {
                            NSLog(@"sd_setImageWithURL err:%@", error);
                            break;
                        }
                        if (!image) {
                            break;
                        }
                        //                            self.gradientView.color = [image findEdgeColorWithType:DCHColorArt_EdgeType_Bottom andCountOfLine:2];
                        //                            [self.gradientView setNeedsDisplay];
                        if ([self.photoModel.fullsizedURL isEqualToString:[imageURL absoluteString]]) {
                            [NSThread runInMain:^{
                                self.backgroundImageView.image = [image applyBlurWithRadius:30.0f tintColor:[UIColor colorWithWhite:0.5f alpha:0.3f] saturationDeltaFactor:1.8f maskImage:nil];
                            }];
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
