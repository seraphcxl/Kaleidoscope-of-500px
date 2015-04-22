//
//  DCHCategoryTableViewCell.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHCategoryTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DCHCategoryModel.h"
#import "DCHPhotoModel.h"
#import <Tourbillon/DCHTourbillon.h>

@interface DCHCategoryTableViewCell ()

@property (nonatomic, strong) DCHCategoryModel *categoryModel;

@end

@implementation DCHCategoryTableViewCell

- (void)dealloc {
    do {
        self.categoryModel = nil;
    } while (NO);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)layoutSubviews {
//    do {
//        if (!self.categoryModel) {
//            break;
//        }
//        
//        
//    } while (NO);
//}

- (void)refreshWithCategoryModel:(DCHCategoryModel *)categoryModel {
    do {
        self.categoryModel = categoryModel;
        if (!categoryModel) {
            self.nameLabel.text = @"";
            
            NSArray *imgViews = @[self.leftImgView, self.centerImgView, self.rightImgView];
            
            for (NSUInteger idx = 0; idx < imgViews.count; ++idx) {
                UIImageView *imgView = imgViews[idx];
                imgView.image = nil;
                [imgView sd_cancelCurrentImageLoad];
            }
        } else {
            self.nameLabel.text = [DCHCategoryModel description4Category:self.categoryModel.category];
            
            NSArray *imgViews = @[self.leftImgView, self.centerImgView, self.rightImgView];
            
            for (NSUInteger idx = 0; idx < imgViews.count; ++idx) {
                UIImageView *imgView = imgViews[idx];
                DCHPhotoModel *model = nil;
                DCHArraySafeRead(self.categoryModel.models, idx, model);
                if (!model) {
                    continue;
                }
                
                imgView.image = nil;
                [imgView sd_cancelCurrentImageLoad];
                if (model.thumbnailData) {
                    imgView.image = [UIImage imageWithData:model.thumbnailData];
                } else {
                    if (model.thumbnailURL) {
                        [imgView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            do {
                                if (error) {
                                    NSLog(@"sd_setImageWithURL err:%@", error);
                                    break;
                                }
                                if (!image) {
                                    break;
                                }
                                if ([model.thumbnailURL isEqualToString:[imageURL absoluteString]]) {
                                    model.thumbnailData = UIImageJPEGRepresentation(image, 0.6);
                                }
                            } while (NO);
                        }];
                    }
                }
            }
        }
        
    } while (NO);
}

@end
