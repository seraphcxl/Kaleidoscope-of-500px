//
//  DCHGalleryCollectionViewModel.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHViewModel.h"
#import <500px-iOS-api/PXAPI.h>

@interface DCHGalleryCollectionViewModel : DCHViewModel

@property (nonatomic, strong, readonly) NSArray *models;

- (void)refreshGallery:(PXAPIHelperPhotoFeature)feature;

@end
