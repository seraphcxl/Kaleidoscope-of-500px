//
//  DCHGalleryCollectionViewController.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DCHFluxKit/DCHFluxKit.h>
#import <500px-iOS-api/PXAPI.h>

@class DCHGalleryCollectionViewModel;

@interface DCHGalleryCollectionViewController : UICollectionViewController

@property (nonatomic, strong, readonly) DCHGalleryCollectionViewModel *viewModel;
@property (nonatomic, assign, readonly) PXAPIHelperPhotoFeature feature;

@end
