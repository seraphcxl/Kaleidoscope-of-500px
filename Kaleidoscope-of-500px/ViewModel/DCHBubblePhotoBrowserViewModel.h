//
//  DCHBubblePhotoBrowserViewModel.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHViewModel.h"
#import <UIKit/UIKit.h>

@interface DCHBubblePhotoBrowserViewModel : DCHViewModel

@property (nonatomic, copy, readonly) NSArray *models;

- (instancetype)initWithPhotoArray:(NSArray *)photoArray;

- (CGSize)calcCellSizeForCollectionLayout:(UICollectionViewLayout *)collectionViewLayout andIndexPath:(NSIndexPath *)indexPath;

@end
