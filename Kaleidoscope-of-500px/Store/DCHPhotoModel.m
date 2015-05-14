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
        self.photoName = dictionary[@"name"];
        self.identifier = dictionary[@"id"];
        self.width = dictionary[@"width"];
        self.height = dictionary[@"height"];
        self.photographerName = dictionary[@"user"][@"fullname"];
        self.rating = dictionary[@"rating"];
        
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

@end
