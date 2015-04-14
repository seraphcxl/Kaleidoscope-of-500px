//
//  DCHDisplayEventCreater.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/14/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DCHFluxKit/DCHFluxKit.h>
#import "DCHDisplayEvent.h"

@interface DCHDisplayEventCreater : NSObject <DCHEventCreater>

+ (id <DCHEvent>)createDisplayEventByCode:(DCDisplayEventCode)code andPayload:(id <NSCopying>)payload;

@end
