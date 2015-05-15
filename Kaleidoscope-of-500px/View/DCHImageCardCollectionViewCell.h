//
//  DCHImageCardCollectionViewCell.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/14/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCHLinearGradientView.h"

extern const CGFloat DCHImageCardCollectionViewCell_DescLabelHeight;

@class DCHPhotoModel;

@interface DCHImageCardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *featureImageContainerView;
@property (weak, nonatomic) IBOutlet DCHLinearGradientView *gradientView;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;

+ (NSString *)cellIdentifier;

- (void)refreshWithPhotoModel:(DCHPhotoModel *)photoModel;
- (void)refreshWithPhotoModel:(DCHPhotoModel *)photoModel onScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view;

- (UIImage *)image;

@end
