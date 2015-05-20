//
//  DCHPhotoModel.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DCHPhotoModel : NSObject

@property (nonatomic, copy) NSString *photoName;
@property (nonatomic, copy) NSNumber *identifier;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy) NSNumber *width;
@property (nonatomic, copy) NSNumber *height;
@property (nonatomic, copy) NSString *photographerName;
@property (nonatomic, copy) NSString *photographerCountry;
@property (nonatomic, copy) NSString *photographerCity;
@property (nonatomic, copy) NSNumber *rating;
@property (nonatomic, copy) NSString *camera;
@property (nonatomic, copy) NSString *lens;
@property (nonatomic, copy) NSString *aperture;
@property (nonatomic, copy) NSString *focalLength;
@property (nonatomic, copy) NSNumber *iso;
@property (nonatomic, copy) NSString *shutterSpeed;
@property (nonatomic, copy) NSString *thumbnailURL;
@property (nonatomic, copy) NSString *fullsizedURL;
@property (nonatomic, assign, getter = isVotedFor) BOOL votedFor;
@property (nonatomic, copy) NSNumber *commentsCount;
@property (nonatomic, copy) NSNumber *favoritesCount;
@property (nonatomic, copy) NSNumber *votesCount;

// UI
@property (nonatomic, copy) NSAttributedString *uiTitleStr;
@property (nonatomic, copy) NSString *uiDescStr;
@property (nonatomic, assign) CGSize uiThumbnailDisplaySize;
@property (nonatomic, assign) CGSize uiFullSizeDisplaySize;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)configureWithDictionary:(NSDictionary *)dictionary;

@end
