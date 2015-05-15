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
    DCDisplayEventCode_RefreshFeaturedPhotos,
    DCDisplayEventCode_RefreshPhotoDetails,
    DCDisplayEventCode_RefreshPhotoCategory,
};
#pragma mark - DCDisplayEventCode_RefreshFeaturedPhotos
extern NSString * const DCDisplayEventCode_RefreshFeaturedPhotos_kPage;

#pragma mark - DCDisplayEventCode_RefreshPhotoDetails
extern NSString * const DCDisplayEventCode_RefreshPhotoDetails_kPhotoModel;

#pragma mark - DCDisplayEventCode_RefreshPhotoCategory
extern NSString * const DCDisplayEventCode_RefreshPhotoCategory_kCategory;

@interface DCHDisplayEvent : DCHEvent

@end
