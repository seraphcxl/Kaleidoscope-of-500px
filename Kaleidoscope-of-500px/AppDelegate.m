//
//  AppDelegate.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 10/8/14.
//  Copyright (c) 2014 Derek Chen. All rights reserved.
//

#import "AppDelegate.h"
#import "DCH500pxPhotoStore.h"
#import "DCH500pxEventCreater.h"
#import "DCH500pxEvent.h"
#import "DCH500pxDispatcher.h"
#import <500px-iOS-api/PXAPI.h>

#ifndef __OPTIMIZE__
#import "RRFPSBar.h"
#endif

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#ifndef __OPTIMIZE__
    [RRFPSBar sharedInstance].showsAverage = YES;
    [[RRFPSBar sharedInstance] setHidden:NO];
#endif
    
    NSString *consumerKey = @"3NwAt95eJVCom1TUjKdnrn95RmKQ9mm21W3Ik95D";
    NSString *consumerSecret = @"tDAihldKr6XlFHKxcJ3s7XwRiCLYJxawQckh03NQ";
    
    [PXRequest setConsumerKey:consumerKey consumerSecret:consumerSecret];
    
    [DCH500pxPhotoStore sharedDCH500pxPhotoStore];
    [[DCH500pxDispatcher sharedDCH500pxDispatcher] addEventResponder:[DCH500pxPhotoStore sharedDCH500pxPhotoStore] forEventDomain:DCH500pxEventDomain code:DC500pxEventCode_QueryFeaturedPhotos];    
    [[DCH500pxDispatcher sharedDCH500pxDispatcher] addEventResponder:[DCH500pxPhotoStore sharedDCH500pxPhotoStore] forEventDomain:DCH500pxEventDomain code:DC500pxEventCode_QueryPhotoDetails];
    [[DCH500pxDispatcher sharedDCH500pxDispatcher] addEventResponder:[DCH500pxPhotoStore sharedDCH500pxPhotoStore] forEventDomain:DCH500pxEventDomain code:DC500pxEventCode_QueryPhotoCategory];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
