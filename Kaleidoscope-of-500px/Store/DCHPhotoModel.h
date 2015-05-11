//
//  DCHPhotoModel.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCHPhotoModel : NSObject

@property (nonatomic, copy) NSString *photoName;
@property (nonatomic, copy) NSNumber *identifier;
@property (nonatomic, copy) NSNumber *width;
@property (nonatomic, copy) NSNumber *height;
@property (nonatomic, copy) NSString *photographerName;
@property (nonatomic, copy) NSNumber *rating;
@property (nonatomic, copy) NSString *thumbnailURL;
@property (nonatomic, strong) NSData *thumbnailData;
@property (nonatomic, copy) NSString *fullsizedURL;
@property (nonatomic, strong) NSData *fullsizedData;
@property (nonatomic, assign, getter = isVotedFor) BOOL votedFor;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)configureWithDictionary:(NSDictionary *)dictionary;

@end
