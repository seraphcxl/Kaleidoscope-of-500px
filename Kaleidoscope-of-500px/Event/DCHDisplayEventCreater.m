//
//  DCHDisplayEventCreater.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/14/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHDisplayEventCreater.h"

@implementation DCHDisplayEventCreater

+ (id <DCHEvent>)createEventWithUUID:(NSString *)uuid Domain:(NSString *)domain code:(NSUInteger)code runningType:(DCHEventRunningType)runningType andPayload:(id <NSCopying>)payload {
    id <DCHEvent> result = nil;
    do {
        result = [[DCHDisplayEvent alloc] initWithUUID:uuid Domain:domain code:code runningType:runningType andPayload:payload];
    } while (NO);
    return result;
}

+ (id <DCHEvent>)createDisplayEventByCode:(DCDisplayEventCode)code andPayload:(id<NSCopying>)payload {
    return [self createEventWithUUID:nil Domain:DCHDisplayEventDomain code:code runningType:DCHEventRunningType_Serial andPayload:payload];
}

@end
