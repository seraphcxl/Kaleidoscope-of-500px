//
//  DCHCategoryViewModel.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHViewModel.h"
#import <500px-iOS-api/PXAPI.h>
#import <UIKit/UIKit.h>

extern const NSUInteger DCHCategoryCollectionViewModel_kCountInLine;

@interface DCHCategoryViewModel : DCHViewModel

@property (nonatomic, copy, readonly) NSDictionary *models;

- (DCHEventOperationTicket *)refreshCategory:(PXPhotoModelCategory)category;

- (void)setNeedRefreshCategories;

- (CGSize)calcCellSizeForCollectionLayout:(UICollectionViewLayout *)collectionViewLayout andIndexPath:(NSIndexPath *)indexPath;

@end
