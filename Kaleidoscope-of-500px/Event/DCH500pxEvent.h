//
//  DCH500pxEvent.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DCHFluxKit/DCHFluxKit.h>

extern NSString * const DCH500pxEventDomain;

typedef NS_ENUM(NSUInteger, DC500pxEventCode) {
    DC500pxEventCode_QueryPopularPhotos,
    DC500pxEventCode_QueryPhotoDetails,
};

extern NSString * const DC500pxEventCode_QueryPhotoDetails_kPhotoModel;

@interface DCH500pxEvent : DCHEvent

@end
