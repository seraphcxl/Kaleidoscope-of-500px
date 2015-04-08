//
//  DCH500pxPhotoStore.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCH500pxPhotoStore.h"
#import "DCHPhotoModel.h"

#import <500px-iOS-api/PXAPI.h>
#import <Tourbillon/DCHTourbillon.h>
#import <RXCollections/RXCollection.h>
#import <libextobjc/EXTScope.h>

@interface DCH500pxPhotoStore ()

@property (nonatomic, strong) NSArray *photoModels;

@end

@implementation DCH500pxPhotoStore

- (NSURLSessionDataTask *)queryPopularPhotosWithCompletionHandler:(DCH500pxPhotoStoreCompletionHandler)completionHandler startImmediately:(BOOL)startImmediately {
    NSURLSessionDataTask *result = nil;
    do {
        NSURLRequest *request = [[PXRequest apiHelper] urlRequestForPhotoFeature:PXAPIHelperPhotoFeaturePopular resultsPerPage:100 page:0 photoSizes:PXPhotoModelSizeThumbnail sortOrder:PXAPIHelperSortOrderRating];
        @weakify(self);
        result = [[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            @strongify(self);
            do {
                if (!data) {
                    break;
                }
                id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSDictionary *rawDic = (NSDictionary *)results;
                self.photoModels = [rawDic[@"photos"] rx_mapWithBlock:^id(id each) {
                    NSDictionary *photoDictionary = (NSDictionary *)each;
                    DCHPhotoModel *model = [[DCHPhotoModel alloc] initWithDictionary:photoDictionary];
                    return model;
                }];
            } while (NO);
            if (completionHandler) {
                completionHandler(self, error);
            }
        }];
        if (startImmediately) {
            [result resume];
        }
    } while (NO);
    return result;
}

- (NSURLSessionDataTask *)queryPhotoDetails:(DCHPhotoModel *)photoModel withCompletionHandler:(DCH500pxPhotoStoreCompletionHandler)completionHandler startImmediately:(BOOL)startImmediately {
    NSURLSessionDataTask *result = nil;
    do {
        if (!photoModel) {
            break;
        }
        NSURLRequest *request = [[PXRequest apiHelper] urlRequestForPhotoID:photoModel.identifier.integerValue];
        @weakify(self);
        result = [[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            @strongify(self);
            do {
                if (!data) {
                    break;
                }
                id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSDictionary *rawDic = (NSDictionary *)results[@"photo"];
                [photoModel configureWithDictionary:rawDic];
            } while (NO);
            if (completionHandler) {
                completionHandler(self, error);
            }
        }];
        if (startImmediately) {
            [result resume];
        }
    } while (NO);
    return result;
}

@end
