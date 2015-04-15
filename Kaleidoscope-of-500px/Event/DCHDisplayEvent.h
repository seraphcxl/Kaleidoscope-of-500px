//
//  DCHDisplayEvent.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/14/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DCHFluxKit/DCHFluxKit.h>

extern NSString * const DCHDisplayEventDomain;

typedef NS_ENUM(NSUInteger, DCDisplayEventCode) {
    DCDisplayEventCode_RefreshPopularPhotos,
    DCDisplayEventCode_RefreshPhotoDetails,
};

@interface DCHDisplayEvent : DCHEvent

@end
