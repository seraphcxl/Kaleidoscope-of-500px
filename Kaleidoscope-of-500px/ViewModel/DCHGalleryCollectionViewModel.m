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

@interface DCHGalleryCollectionViewModel ()

@property (nonatomic, strong) NSArray *model;

@end

@implementation DCHGalleryCollectionViewModel

- (void)dealloc {
    do {
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] removeEventResponder:self];
    } while (NO);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] addEventResponder:self forEventDomain:DCHDisplayEventDomain code:DCDisplayEventCode_RefreshPopularPhotos];
    }
    return self;
}

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

- (void)refreshGallery {
    do {
        DCH500pxEvent *queryPopularPhotosEvent = [DCH500pxEventCreater create500pxEventByCode:DC500pxEventCode_QueryPopularPhotos andPayload:nil];
        [[DCH500pxDispatcher sharedDCH500pxDispatcher] handleEvent:queryPopularPhotosEvent inMainThread:NO withResponderCallback:^(id eventResponder, id<DCHEvent> outputEvent, NSError *error) {
            do {
                if ([eventResponder isEqual:[DCH500pxPhotoStore sharedDCH500pxPhotoStore]]) {
                    NSLog(@"queryPopularPhotosEvent complte in %@", NSStringFromSelector(_cmd));
                }
            } while (NO);
        }];
    } while (NO);
}

@end
