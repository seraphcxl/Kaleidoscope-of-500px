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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *consumerKey = @"DC2To2BS0ic1ChKDK15d44M42YHf9gbUJgdFoF0m";
    NSString *consumerSecret = @"i8WL4chWoZ4kw9fh3jzHK7XzTer1y5tUNvsTFNnB";
    
    [PXRequest setConsumerKey:consumerKey consumerSecret:consumerSecret];
    
    [DCH500pxPhotoStore sharedDCH500pxPhotoStore];
    DCH500pxEvent *queryPopularPhotosEvent = [DCH500pxEventCreater create500pxEventByCode:DC500pxEventCode_QueryPopularPhotos andPayload:nil];
    [[DCH500pxDispatcher sharedDCH500pxDispatcher] addEventResponder:[DCH500pxPhotoStore sharedDCH500pxPhotoStore] forEvent:queryPopularPhotosEvent];
    
    DCH500pxEvent *queryPhotoDetailsEvent = [DCH500pxEventCreater create500pxEventByCode:DC500pxEventCode_QueryPhotoDetails andPayload:nil];
    [[DCH500pxDispatcher sharedDCH500pxDispatcher] addEventResponder:[DCH500pxPhotoStore sharedDCH500pxPhotoStore] forEvent:queryPhotoDetailsEvent];
    
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
