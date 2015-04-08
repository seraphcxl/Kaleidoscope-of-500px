//
//  DCH500pxPhotoStore.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHStore.h"

@class DCHPhotoModel;
@class DCH500pxPhotoStore;

typedef void(^DCH500pxPhotoStoreCompletionHandler)(DCH500pxPhotoStore *store, NSError *error);

@interface DCH500pxPhotoStore : DCHStore

@property (nonatomic, strong, readonly) NSArray *photoModels;

- (NSURLSessionDataTask *)queryPopularPhotosWithCompletionHandler:(DCH500pxPhotoStoreCompletionHandler)completionHandler startImmediately:(BOOL)startImmediately;
- (NSURLSessionDataTask *)queryPhotoDetails:(DCHPhotoModel *)photoModel withCompletionHandler:(DCH500pxPhotoStoreCompletionHandler)completionHandler startImmediately:(BOOL)startImmediately;

@end
