//
//  DCHCategoryModel.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <500px-iOS-api/PXAPI.h>

@interface DCHCategoryModel : NSObject

@property (nonatomic, assign, readonly) PXPhotoModelCategory category;
@property (nonatomic, strong, readonly) NSArray *models;
@property (nonatomic, assign) BOOL needRefresh;

+ (NSArray *)categories;
+ (NSString *)description4Category:(PXPhotoModelCategory)category;
+ (NSUInteger)index4Category:(PXPhotoModelCategory)category;

- (instancetype)initWithCategory:(PXPhotoModelCategory)category andModels:(NSArray *)models;

@end
