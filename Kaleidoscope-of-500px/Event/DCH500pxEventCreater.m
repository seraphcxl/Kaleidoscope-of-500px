//
//  DCH500pxEventCreater.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCH500pxEventCreater.h"

@implementation DCH500pxEventCreater

+ (id <DCHEvent>)createEventWithUUID:(NSString *)uuid Domain:(NSString *)domain code:(NSUInteger)code runningType:(DCHEventRunningType)runningType andPayload:(id <NSCopying>)payload {
    id <DCHEvent> result = nil;
    do {
        result = [[DCH500pxEvent alloc] initWithUUID:uuid Domain:domain code:code runningType:runningType andPayload:payload];
    } while (NO);
    return result;
}

+ (id <DCHEvent>)create500pxEventByCode:(DC500pxEventCode)code andPayload:(id<NSCopying>)payload {
    return [self createEventWithUUID:nil Domain:DCH500pxEventDomain code:code runningType:DCHEventRunningType_Concurrent andPayload:payload];
}

@end
