//
//  DCHCategoryViewModel.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHViewModel.h"
#import <500px-iOS-api/PXAPI.h>

@interface DCHCategoryViewModel : DCHViewModel

@property (nonatomic, strong, readonly) NSDictionary *models;

- (void)refreshCategory:(PXPhotoModelCategory)category;

@end
