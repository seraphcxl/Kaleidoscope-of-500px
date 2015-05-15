//
//  DCH500pxPhotoStore.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHStore.h"
#import <Tourbillon/DCHTourbillon.h>
#import <500px-iOS-api/PXAPI.h>

extern const NSUInteger DCH500pxPhotoStore_FirstPageNum;

@class DCHPhotoModel;
@class DCH500pxPhotoStore;

typedef void(^DCH500pxPhotoStoreCompletionHandler)(DCH500pxPhotoStore *store, NSError *error);

@interface DCH500pxPhotoStore : DCHStore

DCH_DEFINE_SINGLETON_FOR_HEADER(DCH500pxPhotoStore)

@property (nonatomic, strong, readonly) NSArray *photoModels;
@property (nonatomic, strong, readonly) NSMutableDictionary *categories;

- (NSURLSessionDataTask *)queryPhotosByFeature:(PXAPIHelperPhotoFeature)feature withPage:(NSUInteger)page andCompletionHandler:(DCH500pxPhotoStoreCompletionHandler)completionHandler startImmediately:(BOOL)startImmediately;
- (NSURLSessionDataTask *)queryPhotoDetails:(DCHPhotoModel *)photoModel withCompletionHandler:(DCH500pxPhotoStoreCompletionHandler)completionHandler startImmediately:(BOOL)startImmediately;
- (NSURLSessionDataTask *)queryPopularCategoryPhotos:(PXPhotoModelCategory)category withCount:(NSUInteger)count andCompletionHandler:(DCH500pxPhotoStoreCompletionHandler)completionHandler startImmediately:(BOOL)startImmediately;

@end
