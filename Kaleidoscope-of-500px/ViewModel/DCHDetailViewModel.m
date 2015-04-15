//
//  DCHDetailViewModel.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHDetailViewModel.h"
#import "DCHPhotoModel.h"
#import "DCH500pxEventCreater.h"
#import "DCH500pxEvent.h"
#import "DCH500pxDispatcher.h"
#import "DCH500pxPhotoStore.h"
#import "DCHDisplayEvent.h"

@interface DCHDetailViewModel ()

@property (nonatomic, strong) DCHPhotoModel *model;

@end

@implementation DCHDetailViewModel

- (void)dealloc {
    do {
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] removeEventResponder:self];
        self.model = nil;
    } while (NO);
}

- (instancetype)initWithPhotoModel:(DCHPhotoModel *)photoModel {
    if (!photoModel) {
        return nil;
    }
    
    self = [super init];
    if (!self) return nil;
    
    self.model = photoModel;
    [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] addEventResponder:self forEventDomain:DCHDisplayEventDomain code:DCDisplayEventCode_RefreshPhotoDetails];
    
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
                case DCDisplayEventCode_RefreshPhotoDetails:
                {
                    DCHPhotoModel *tmpPhotoModel = [event payload][DCDisplayEventCode_RefreshPhotoDetails_kPhotoModel];
                    if ([self.model.identifier isEqualToNumber:tmpPhotoModel.identifier]) {
                        self.model = tmpPhotoModel;
                        [self emitChange];
                    }
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

- (NSString *)photoName {
    return self.model.photoName;
}

- (void)loadPhotoDetails {
    do {
        if (self.model.fullsizedData) {
            ;
        } else {
            DCH500pxEvent *queryPhotoDetailsEvent = [DCH500pxEventCreater create500pxEventByCode:DC500pxEventCode_QueryPhotoDetails andPayload:@{DC500pxEventCode_QueryPhotoDetails_kPhotoModel: self.model}];
            [[DCH500pxDispatcher sharedDCH500pxDispatcher] handleEvent:queryPhotoDetailsEvent inMainThread:NO withResponderCallback:^(id eventResponder, id<DCHEvent> outputEvent, NSError *error) {
                do {
                    if ([eventResponder isEqual:[DCH500pxPhotoStore sharedDCH500pxPhotoStore]]) {
                        NSLog(@"queryPopularPhotosEvent complte in %@", NSStringFromSelector(_cmd));
                    }
                } while (NO);
            }];
        }
    } while (NO);
}

@end
