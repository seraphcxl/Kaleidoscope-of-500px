//
//  DCHBubblePhotoBrowser.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DCHFluxKit/DCHFluxKit.h>

@class DCHBubblePhotoBrowserViewModel;
@class DCHLinearGradientView;
@class FBShimmeringView;
@class DCHBubbleImageView;

@interface DCHBubblePhotoBrowser : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *thumbnailCollectionView;
@property (weak, nonatomic) IBOutlet DCHBubbleImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet DCHLinearGradientView *gradientView;
@property (weak, nonatomic) IBOutlet FBShimmeringView *shimmeringView;

- (instancetype)initWithViewModel:(DCHBubblePhotoBrowserViewModel *)viewModel initialPhotoIndex:(NSUInteger)index andTitle:(NSString *)title;

@end
