//
//  DCHCategoryViewModel.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHCategoryViewModel.h"
#import "DCHDisplayEvent.h"
#import "DCH500pxPhotoStore.h"
#import <libextobjc/EXTScope.h>
#import "DCH500pxEventCreater.h"
#import "DCH500pxEvent.h"
#import "DCH500pxDispatcher.h"

@interface DCHCategoryViewModel ()

@property (nonatomic, strong) NSDictionary *models;

@end

@implementation DCHCategoryViewModel

- (void)dealloc {
    do {
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] removeEventResponder:self];
        self.models = nil;
    } while (NO);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] addEventResponder:self forEventDomain:DCHDisplayEventDomain code:DCDisplayEventCode_RefreshPhotoCategory];
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
                case DCDisplayEventCode_RefreshPhotoCategory:
                {
                    self.models = [DCH500pxPhotoStore sharedDCH500pxPhotoStore].categories;
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

- (void)refreshCategory:(PXPhotoModelCategory)category {
    do {
        DCH500pxEvent *queryPhotoCategoryEvent = [DCH500pxEventCreater create500pxEventByCode:DC500pxEventCode_QueryPhotoCategory andPayload:@{DC500pxEventCode_QueryPhotoCategory_kCategory: [NSString stringWithFormat:@"%ld", category]}];
        [[DCH500pxDispatcher sharedDCH500pxDispatcher] handleEvent:queryPhotoCategoryEvent inMainThread:NO withResponderCallback:^(id eventResponder, id<DCHEvent> outputEvent, NSError *error) {
            do {
                if ([eventResponder isEqual:[DCH500pxPhotoStore sharedDCH500pxPhotoStore]]) {
                    NSLog(@"queryPopularPhotosEvent complte in %@", NSStringFromSelector(_cmd));
                }
            } while (NO);
        }];
    } while (NO);
}

@end
