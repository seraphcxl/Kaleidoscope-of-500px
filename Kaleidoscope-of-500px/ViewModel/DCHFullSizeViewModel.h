//
//  DCHFullSizeViewModel.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHViewModel.h"

@class DCHPhotoModel;

@interface DCHFullSizeViewModel : DCHViewModel

@property (nonatomic, copy, readonly) NSArray *models;
@property (nonatomic, assign, readonly) NSInteger currentPhotoIndex;
@property (nonatomic, copy, readonly) NSString *initialPhotoName;

- (instancetype)initWithPhotoArray:(NSArray *)photoArray currentPhotoIndex:(NSInteger)currentPhotoIndex;
- (DCHPhotoModel *)photoModelAtIndex:(NSInteger)index;

@end
