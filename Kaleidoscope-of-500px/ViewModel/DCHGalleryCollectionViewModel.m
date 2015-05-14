//
//  DCHGalleryCollectionViewModel.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHGalleryCollectionViewModel.h"
#import "DCHDisplayEvent.h"
#import "DCH500pxPhotoStore.h"
#import <libextobjc/EXTScope.h>
#import "DCH500pxEventCreater.h"
#import "DCH500pxEvent.h"
#import "DCH500pxDispatcher.h"
#import "DCHPhotoModel.h"

@interface DCHGalleryCollectionViewModel ()

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, assign) NSUInteger currentPage;

- (NSString *)createUIDescForPhotoModel:(DCHPhotoModel *)photoModel;

@end

@implementation DCHGalleryCollectionViewModel

- (void)dealloc {
    do {
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] removeEventResponder:self];
        self.models = nil;
    } while (NO);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentPage = DCH500pxPhotoStore_FirstPageNum;
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] addEventResponder:self forEventDomain:DCHDisplayEventDomain code:DCDisplayEventCode_RefreshFeaturedPhotos];
    }
    return self;
}

- (BOOL)respondEvent:(id <DCHEvent>)event from:(id)source withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    BOOL result = NO;
    do {
        if (event == nil) {
            break;
        }
        if ([[event domain] isEqualToString:DCHDisplayEventDomain]) {
            switch ([event code]) {
                case DCDisplayEventCode_RefreshFeaturedPhotos:
                {
                    self.models = [DCH500pxPhotoStore sharedDCH500pxPhotoStore].photoModels;
                    [self.models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        do {
                            DCHPhotoModel *photoModel = (DCHPhotoModel *)obj;
                            photoModel.uiDescStr = [self createUIDescForPhotoModel:photoModel];
                        } while (NO);
                    }];
                    [self emitChangeWithEvent:event];
                    result = YES;
                }
                    break;
                    
                default:
                    break;
            }
        }
        if (completionHandler) {
            completionHandler(self, event, nil);
        }
    } while (NO);
    return result;
}

- (DCHEventOperationTicket *)refreshGallery:(PXAPIHelperPhotoFeature)feature {
    DCHEventOperationTicket *result = nil;
    do {
        self.currentPage = DCH500pxPhotoStore_FirstPageNum;
        DCH500pxEvent *queryFeaturedPhotosEvent = [DCH500pxEventCreater create500pxEventByCode:DC500pxEventCode_QueryFeaturedPhotos andPayload:@{DC500pxEventCode_QueryFeaturedPhotos_kFeature: @(feature), DC500pxEventCode_QueryFeaturedPhotos_kPage: @(self.currentPage)}];
        result = [[DCH500pxDispatcher sharedDCH500pxDispatcher] handleEvent:queryFeaturedPhotosEvent inMainThread:NO withResponderCallback:^(id eventResponder, id <DCHEvent> outputEvent, NSError *error) {
            do {
                if ([eventResponder isEqual:[DCH500pxPhotoStore sharedDCH500pxPhotoStore]]) {
                    NSLog(@"queryFeaturedPhotosEvent complte in %@", NSStringFromSelector(_cmd));
                }
            } while (NO);
        }];
    } while (NO);
    return result;
}

- (DCHEventOperationTicket *)loadMoreGallery:(PXAPIHelperPhotoFeature)feature {
    DCHEventOperationTicket *result = nil;
    do {
        ++self.currentPage;
        DCH500pxEvent *queryFeaturedPhotosEvent = [DCH500pxEventCreater create500pxEventByCode:DC500pxEventCode_QueryFeaturedPhotos andPayload:@{DC500pxEventCode_QueryFeaturedPhotos_kFeature: @(feature), DC500pxEventCode_QueryFeaturedPhotos_kPage: @(self.currentPage)}];
        result = [[DCH500pxDispatcher sharedDCH500pxDispatcher] handleEvent:queryFeaturedPhotosEvent inMainThread:NO withResponderCallback:^(id eventResponder, id <DCHEvent> outputEvent, NSError *error) {
            do {
                if ([eventResponder isEqual:[DCH500pxPhotoStore sharedDCH500pxPhotoStore]]) {
                    NSLog(@"queryFeaturedPhotosEvent complte in %@", NSStringFromSelector(_cmd));
                }
            } while (NO);
        }];
    } while (NO);
    return result;
}

- (NSString *)createUIDescForPhotoModel:(DCHPhotoModel *)photoModel {
    NSString *result = nil;
    do {
        if (!photoModel) {
            break;
        }
        NSMutableString *desc = [NSMutableString string];
        NSMutableString *desc0 = [NSMutableString string];
        NSMutableString *desc1 = [NSMutableString string];
        NSMutableString *desc2 = [NSMutableString string];
        
        if (photoModel.photographerName) {
            [desc0 appendString:photoModel.photographerName];
        }
        if (photoModel.rating) {
            if (![desc0 isEqualToString:@""]) {
                [desc0 appendString:@" "];
            }
            [desc0 appendFormat:@"Rating:%.2f", [photoModel.rating floatValue]];
        }
        
        if (photoModel.camera) {
            [desc1 appendString:photoModel.camera];
        }
//        if (photoModel.lens) {
//            if (![desc1 isEqualToString:@""]) {
//                [desc1 appendString:@" "];
//            }
//            [desc1 appendString:photoModel.lens];
//        }
        
        if (photoModel.aperture) {
            [desc2 appendFormat:@"f:%@", photoModel.aperture];
        }
        if (photoModel.focalLength) {
            if (![desc2 isEqualToString:@""]) {
                [desc2 appendString:@" "];
            }
            [desc2 appendFormat:@"%@mm", photoModel.focalLength];
        }
        if (photoModel.iso) {
            if (![desc2 isEqualToString:@""]) {
                [desc2 appendString:@" "];
            }
            [desc2 appendFormat:@"iso:%d", [photoModel.iso intValue]];
        }
        if (photoModel.shutterSpeed) {
            if (![desc2 isEqualToString:@""]) {
                [desc2 appendString:@" "];
            }
            [desc2 appendString:photoModel.shutterSpeed];
        }
        
        if (desc0) {
            [desc appendString:desc0];
        }
        if (desc1) {
            if (![desc isEqualToString:@""]) {
                [desc appendFormat:@"\n"];
            }
            [desc appendString:desc1];
        }
        if (desc2) {
            if (![desc isEqualToString:@""]) {
                [desc appendFormat:@"\n"];
            }
            [desc appendString:desc2];
        }
        
        result = desc;
    } while (NO);
    return result;
}
@end
