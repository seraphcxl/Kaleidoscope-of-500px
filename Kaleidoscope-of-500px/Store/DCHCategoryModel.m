//
//  DCHCategoryModel.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHCategoryModel.h"

@interface DCHCategoryModel ()

@property (nonatomic, assign) PXPhotoModelCategory category;
@property (nonatomic, strong) NSArray *models;

@end

@implementation DCHCategoryModel

- (instancetype)initWithCategory:(PXPhotoModelCategory)category andModels:(NSArray *)models {
    self = [self init];
    if (self) {
        self.category = category;
        self.models = models;
    }
    return self;
}

@end
