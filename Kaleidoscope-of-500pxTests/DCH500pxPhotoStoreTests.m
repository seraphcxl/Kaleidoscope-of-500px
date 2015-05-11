//
//  DCH500pxPhotoStoreTests.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DCH500pxPhotoStore.h"
#import "DCHPhotoModel.h"
#import <Tourbillon/DCHTourbillon.h>
#import <500px-iOS-api/PXAPI.h>

@interface DCH500pxPhotoStoreTests : XCTestCase

@end

@implementation DCH500pxPhotoStoreTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    NSString *consumerKey = @"DC2To2BS0ic1ChKDK15d44M42YHf9gbUJgdFoF0m";
    NSString *consumerSecret = @"i8WL4chWoZ4kw9fh3jzHK7XzTer1y5tUNvsTFNnB";
    
    [PXRequest setConsumerKey:consumerKey consumerSecret:consumerSecret];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test4Main {
    do {
        DCH500pxPhotoStore *store = [[DCH500pxPhotoStore alloc] init];
        __block BOOL finished = NO;
        NSURLSessionDataTask *task = [store queryPhotosByFeature:PXAPIHelperPhotoFeaturePopular withCompletionHandler:^(DCH500pxPhotoStore *store, NSError *error) {
            finished = YES;
        } startImmediately:YES];
        [DCHAsyncTest expect:^BOOL{
            return [task state] == NSURLSessionTaskStateCompleted && finished;
        } withTimeout:20 andCompletionHandler:^(BOOL promiseResult, NSError *error, NSDictionary *infoDic) {
//            DCHDebugLog(@"%@", store.photoModels);
            XCTAssert(store.photoModels.count > 0);
        }];
        
        DCHPhotoModel *photoModel = [store.photoModels firstObject];
        finished = NO;
        NSURLSessionDataTask *task1 = [store queryPhotoDetails:photoModel withCompletionHandler:^(DCH500pxPhotoStore *store, NSError *error) {
            finished = YES;
        } startImmediately:YES];
        [DCHAsyncTest expect:^BOOL{
            return [task1 state] == NSURLSessionTaskStateCompleted && finished;
        } withTimeout:20 andCompletionHandler:^(BOOL promiseResult, NSError *error, NSDictionary *infoDic) {
            DCHDebugLog(@"%@", photoModel);
            XCTAssertNotNil(photoModel.fullsizedURL);
        }];
        
        finished = NO;
        NSURLSessionDataTask *task2 = [store queryPopularCategoryPhotos:PXPhotoModelCategoryLandscapes withCount:3 andCompletionHandler:^(DCH500pxPhotoStore *store, NSError *error) {
            finished = YES;
        } startImmediately:YES];
        [DCHAsyncTest expect:^BOOL{
            return [task2 state] == NSURLSessionTaskStateCompleted && finished;
        } withTimeout:20 andCompletionHandler:^(BOOL promiseResult, NSError *error, NSDictionary *infoDic) {
            DCHDebugLog(@"%@", store.categories);
            XCTAssertNotNil(store.categories);
        }];
    } while (NO);
}

@end
