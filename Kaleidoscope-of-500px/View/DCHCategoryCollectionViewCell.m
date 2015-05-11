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

- (void)dealloc {
    self.photoModel = nil;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)refreshWithPhotoModel:(DCHPhotoModel *)photoModel {
    do {
        self.photoModel = photoModel;
        [self.imgView sd_cancelCurrentAnimationImagesLoad];
        self.imgView.image = nil;
        if (photoModel) {
            if (self.photoModel.thumbnailData) {
                self.imgView.image = [UIImage imageWithData:self.photoModel.thumbnailData];
            } else {
                if (self.photoModel.thumbnailURL) {
                    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.photoModel.thumbnailURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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

@end
