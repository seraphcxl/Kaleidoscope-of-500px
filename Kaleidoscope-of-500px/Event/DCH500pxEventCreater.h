//
//  DCH500pxEventCreater.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DCHFluxKit/DCHFluxKit.h>
#import "DCH500pxEvent.h"

@interface DCH500pxEventCreater : NSObject <DCHEventCreater>

+ (id <DCHEvent>)create500pxEventByCode:(DC500pxEventCode)code andPayload:(id <NSCopying>)payload;

@end
