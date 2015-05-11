//
//  DCHCategoryCollectionViewCell.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/11/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCHPhotoModel;

@interface DCHCategoryCollectionViewCell : UICollectionViewCell

+ (NSString *)cellIdentifier;

- (void)refreshWithPhotoModel:(DCHPhotoModel *)photoModel;

@end
