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

@interface DCHGalleryCollectionViewModel ()

@property (nonatomic, strong) NSArray *model;

@end

@implementation DCHGalleryCollectionViewModel

- (BOOL)respondEvent:(id<DCHEvent>)event from:(id)source withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    BOOL result = NO;
    do {
        if (event == nil) {
            break;
        }
        self.inputEvent = event;
        self.outputEvent = event;
        
        if ([[self.inputEvent domain] isEqualToString:DCHDisplayEventDomain]) {
            switch ([self.inputEvent code]) {
                case DCDisplayEventCode_RefreshPopularPhotos:
                {
                    self.model = [DCH500pxPhotoStore sharedDCH500pxPhotoStore].photoModels;
                    [self emitChange];
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

@end
