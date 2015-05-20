//
//  DCHBubblePhotoBrowserViewModel.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHBubblePhotoBrowserViewModel.h"
#import "DCHPhotoModel.h"
#import <Tourbillon/DCHTourbillon.h>

@interface DCHBubblePhotoBrowserViewModel ()

@property (nonatomic, copy) NSArray *models;

@end

@implementation DCHBubblePhotoBrowserViewModel

- (void)dealloc {
    do {
        self.models = nil;
    } while (NO);
}

- (instancetype)initWithPhotoArray:(NSArray *)photoArray {
    self = [self init];
    if (self) {
        self.models = photoArray;
    }
    return self;
}

- (CGSize)calcCellSizeForCollectionLayout:(UICollectionViewLayout *)collectionViewLayout andIndexPath:(NSIndexPath *)indexPath {
    CGSize result = CGSizeZero;
    do {
        if (![collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
            break;
        }
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
        DCHPhotoModel *photoModel = nil;
        DCHArraySafeRead(self.models, indexPath.item, photoModel);
        if (photoModel) {
            photoModel.uiThumbnailDisplaySize = layout.itemSize;
            result = photoModel.uiThumbnailDisplaySize;
        }
        
    } while (NO);
    return result;
}

@end
