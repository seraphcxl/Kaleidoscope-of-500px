//
//  DCHDetailViewModel.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCHViewModel.h"

@class DCHPhotoModel;

@interface DCHDetailViewModel : DCHViewModel

@property (nonatomic, strong, readonly) DCHPhotoModel *model;

- (instancetype)initWithPhotoModel:(DCHPhotoModel *)photoModel;

- (NSString *)photoName;
- (void)loadPhotoDetails;

@end
