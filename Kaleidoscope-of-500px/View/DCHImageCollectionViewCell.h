//
//  DCHImageCollectionViewCell.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/12/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCHPhotoModel;

@interface DCHImageCollectionViewCell : UICollectionViewCell

+ (NSString *)cellIdentifier;

- (void)refreshWithPhotoModel:(DCHPhotoModel *)photoModel;
- (void)refreshWithPhotoModel:(DCHPhotoModel *)photoModel onScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view;

@end
