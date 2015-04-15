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

#import "DCHDisplayEventCreater.h"
#import "DCHDisplayEvent.h"
#import "DCH500pxEvent.h"

@interface DCH500pxPhotoStore ()

@property (nonatomic, strong) NSArray *photoModels;

@end

@implementation DCH500pxPhotoStore

DCH_DEFINE_SINGLETON_FOR_CLASS(DCH500pxPhotoStore)

- (BOOL)respondEvent:(id<DCHEvent>)event from:(id)source withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    BOOL result = NO;
    do {
        if (event == nil) {
            break;
        }
        self.inputEvent = event;
        self.outputEvent = event;
        
        if ([[self.inputEvent domain] isEqualToString:DCH500pxEventDomain]) {
            switch ([self.inputEvent code]) {
                case DC500pxEventCode_QueryPopularPhotos:
                {
                    [self queryPopularPhotosWithCompletionHandler:^(DCH500pxPhotoStore *store, NSError *error) {
                        do {
                            if (completionHandler) {
                                completionHandler(self, self.outputEvent, nil);
                            }
                            
                            DCHDisplayEvent *refreshPopularPhotosEvent = [DCHDisplayEventCreater createDisplayEventByCode:DCDisplayEventCode_RefreshPopularPhotos andPayload:nil];
                            [self emitChangeWithEvent:refreshPopularPhotosEvent inMainThread:YES withCompletionHandler:^(id eventResponder, id<DCHEvent> outputEvent, NSError *error) {
                                do {
                                    NSLog(@"refreshPopularPhotosEvent complte in %@", NSStringFromSelector(_cmd));
                                } while (NO);
                            }];
                        } while (NO);
                    } startImmediately:YES];
                    result = YES;
                }
                    break;
                case DC500pxEventCode_QueryPhotoDetails:
                {
                    if (![event payload]) {
                        break;
                    }
                    DCHPhotoModel *photoModel = [event payload][DC500pxEventCode_QueryPhotoDetails_kPhotoModel];
                    [self queryPhotoDetails:photoModel withCompletionHandler:^(DCH500pxPhotoStore *store, NSError *error) {
                        do {
                            if (completionHandler) {
                                completionHandler(self, self.outputEvent, nil);
                            }
                            
                            DCHDisplayEvent *refreshPhotoDetailsEvent = [DCHDisplayEventCreater createDisplayEventByCode:DCDisplayEventCode_RefreshPhotoDetails andPayload:@{DCDisplayEventCode_RefreshPhotoDetails_kPhotoModel: photoModel}];
                            [self emitChangeWithEvent:refreshPhotoDetailsEvent inMainThread:YES withCompletionHandler:^(id eventResponder, id<DCHEvent> outputEvent, NSError *error) {
                                do {
                                    NSLog(@"refreshPhotoDetailsEvent complte in %@", NSStringFromSelector(_cmd));
                                } while (NO);
                            }];
                        } while (NO);
                    } startImmediately:YES];
                    result = YES;
                }
                    break;
                default:
                    break;
            }
        }
    } while (NO);
    return result;
}

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
