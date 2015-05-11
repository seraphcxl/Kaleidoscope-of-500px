//
//  DCHDisplayEventCreater.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/14/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHDisplayEventCreater.h"

@implementation DCHDisplayEventCreater

+ (id <DCHEvent>)createEventWithDomain:(NSString *)domain code:(NSUInteger)code mainThreadRequired:(BOOL)mainThreadRequired runningType:(DCHEventRunningType)runningType andPayload:(id <NSCopying>)payload {
    id <DCHEvent> result = nil;
    do {
        result = [[DCHDisplayEvent alloc] initWithDomain:domain code:code mainThreadRequired:mainThreadRequired runningType:runningType andPayload:payload];
    } while (NO);
    return result;
}

+ (id <DCHEvent>)createDisplayEventByCode:(DCDisplayEventCode)code andPayload:(id <NSCopying>)payload {
    return [self createEventWithDomain:DCHDisplayEventDomain code:code mainThreadRequired:YES runningType:DCHEventRunningType_Serial andPayload:payload];
}

@end
