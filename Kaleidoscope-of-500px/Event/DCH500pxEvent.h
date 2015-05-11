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
    DC500pxEventCode_QueryFeaturedPhotos,
    DC500pxEventCode_QueryPhotoDetails,
    DC500pxEventCode_QueryPhotoCategory,
};

#pragma mark - DC500pxEventCode_QueryFeaturedPhotos
extern NSString * const DC500pxEventCode_QueryFeaturedPhotos_kFeature;

#pragma mark - DC500pxEventCode_QueryPhotoDetails
extern NSString * const DC500pxEventCode_QueryPhotoDetails_kPhotoModel;

#pragma mark - DC500pxEventCode_QueryPhotoCategory
extern NSString * const DC500pxEventCode_QueryPhotoCategory_kCategory;

@interface DCH500pxEvent : DCHEvent

@end
