//
//  DCH500pxEventCreater.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCH500pxEventCreater.h"

@implementation DCH500pxEventCreater

+ (id <DCHEvent>)createEventWithDomain:(NSString *)domain code:(NSUInteger)code mainThreadRequired:(BOOL)mainThreadRequired runningType:(DCHEventRunningType)runningType andPayload:(id<NSCopying>)payload {
    id <DCHEvent> result = nil;
    do {
        result = [[DCH500pxEvent alloc] initWithDomain:domain code:code mainThreadRequired:mainThreadRequired runningType:runningType andPayload:payload];
    } while (NO);
    return result;
}

+ (id <DCHEvent>)create500pxEventByCode:(DC500pxEventCode)code andPayload:(id<NSCopying>)payload {
    return [self createEventWithDomain:DCH500pxEventDomain code:code mainThreadRequired:NO runningType:DCHEventRunningType_Concurrent andPayload:payload];
}

@end
