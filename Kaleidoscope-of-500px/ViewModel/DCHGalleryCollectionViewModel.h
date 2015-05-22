//
//  DCHGalleryCollectionViewModel.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHViewModel.h"
#import <500px-iOS-api/PXAPI.h>
#import <UIKit/UIKit.h>

extern const NSUInteger DCHGalleryCollectionViewModel_kCountInLine;

@interface DCHGalleryCollectionViewModel : DCHViewModel

@property (nonatomic, copy, readonly) NSArray *models;
@property (nonatomic, assign, readonly) NSUInteger currentPage;

- (DCHEventOperationTicket *)refreshGallery:(PXAPIHelperPhotoFeature)feature;
- (DCHEventOperationTicket *)loadMoreGallery:(PXAPIHelperPhotoFeature)feature;

- (CGSize)calcCellSizeForCollectionLayout:(UICollectionViewLayout *)collectionViewLayout andIndex:(NSUInteger)index;

@end
