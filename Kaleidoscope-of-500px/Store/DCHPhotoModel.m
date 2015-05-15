//
//  DCHPhotoModel.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHPhotoModel.h"
#import <RXCollections/RXCollection.h>

@interface DCHPhotoModel ()

- (NSString *)urlForImageSize:(NSInteger)size inDictionary:(NSArray *)array;
- (id)checkEmpty:(id)obj;

@end

@implementation DCHPhotoModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (!dictionary) {
        return nil;
    }
    self = [self init];
    if (self) {
        [self configureWithDictionary:dictionary];
    }
    return self;
}

- (void)configureWithDictionary:(NSDictionary *)dictionary {
    do {
        if (!dictionary) {
            break;
        }
        self.photoName = [self checkEmpty:dictionary[@"name"]];
        self.identifier = [self checkEmpty:dictionary[@"id"]];
        self.width = [self checkEmpty:dictionary[@"width"]];
        self.height = [self checkEmpty:dictionary[@"height"]];
        self.photographerName = [self checkEmpty:dictionary[@"user"][@"fullname"]];
        self.photographerCountry = [self checkEmpty:dictionary[@"user"][@"country"]];
        self.photographerCity = [self checkEmpty:dictionary[@"user"][@"city"]];
        self.rating = [self checkEmpty:dictionary[@"rating"]];
        self.camera = [self checkEmpty:dictionary[@"camera"]];
        self.lens = [self checkEmpty:dictionary[@"lens"]];
        self.aperture = [self checkEmpty:dictionary[@"aperture"]];
        self.focalLength = [self checkEmpty:dictionary[@"focal_length"]];
        self.iso = [self checkEmpty:dictionary[@"iso"]];
        self.shutterSpeed = [self checkEmpty:dictionary[@"shutter_speed"]];
        self.commentsCount = [self checkEmpty:dictionary[@"comments_count"]];
        self.favoritesCount = [self checkEmpty:dictionary[@"favorites_count"]];
        self.votesCount = [self checkEmpty:dictionary[@"votes_count"]];
        
        self.thumbnailURL = [self urlForImageSize:3 inDictionary:dictionary[@"images"]];
        self.fullsizedURL = [self urlForImageSize:4 inDictionary:dictionary[@"images"]];
        if (dictionary[@"voted"]) {
            self.votedFor = [dictionary[@"voted"] boolValue];
        }
        
        // Extended attributes fetched with subsequent request
        if (dictionary[@"comments_count"]) {
            
        }
    } while (NO);
}

- (NSString *)urlForImageSize:(NSInteger)size inDictionary:(NSArray *)array {
    /*
     (
     {
     size = 3;
     url = "http://ppcdn.500px.org/49204370/b125a49d0863e0ba05d8196072b055876159f33e/3.jpg";
     }
     );
     */
    
    return [[[array rx_filterWithBlock:^BOOL(id each) {
        NSDictionary *valueDic = (NSDictionary *)each;
        return [valueDic[@"size"] integerValue] == size;
    }] rx_mapWithBlock:^id(id each) {
        NSDictionary *valueDic = (NSDictionary *)each;
        return valueDic[@"url"];
    }] firstObject];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@-name:%@ id:%@ er:%@ rating:%@ thumbURL:%@ fullSizeURL:%@", [super description], self.photoName, self.identifier, self.photographerName, self.rating, self.thumbnailURL, self.fullsizedURL];
}

- (id)checkEmpty:(id)obj {
    id result = nil;
    do {
        if (!obj || [obj isKindOfClass:[NSNull class]]) {
            break;
        }
        if ([obj isMemberOfClass:[NSString class]]) {
            if ([obj isEqualToString:@""]) {
                break;
            }
        }
        result = obj;
    } while (NO);
    return result;
}

@end
