//
//  DCHCategoryCollectionViewCell.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/11/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHCategoryCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DCHPhotoModel.h"
#import <Tourbillon/DCHTourbillon.h>

@interface DCHCategoryCollectionViewCell ()

@property (nonatomic, strong) DCHPhotoModel *photoModel;

@end

@implementation DCHCategoryCollectionViewCell

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)refreshWithPhotoModel:(DCHPhotoModel *)photoModel {
    do {
        self.photoModel = photoModel;
    } while (NO);
}

@end
