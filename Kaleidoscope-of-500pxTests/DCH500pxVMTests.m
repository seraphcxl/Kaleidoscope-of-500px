//
//  DCH500pxVMTests.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <500px-iOS-api/PXRequest.h>
#import <DCHFluxKit/DCHFluxKit.h>
#import "DCH500pxDispatcher.h"
#import "DCHCategoryViewModel.h"
#import "DCHGalleryCollectionViewModel.h"
#import "DCHDetailViewModel.h"
#import "DCHFullSizeViewModel.h"
#import "DCH500pxPhotoStore.h"
#import "DCH500pxEvent.h"
#import "DCHDisplayEvent.h"

@interface DCH500pxVMTests : XCTestCase <DCHEventResponder>

@property (nonatomic, assign) BOOL funcFinished;

@end

@implementation DCH500pxVMTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    NSString *consumerKey = @"3NwAt95eJVCom1TUjKdnrn95RmKQ9mm21W3Ik95D";
    NSString *consumerSecret = @"tDAihldKr6XlFHKxcJ3s7XwRiCLYJxawQckh03NQ";
    
    [PXRequest setConsumerKey:consumerKey consumerSecret:consumerSecret];
    
    [DCH500pxPhotoStore sharedDCH500pxPhotoStore];
    [[DCH500pxDispatcher sharedDCH500pxDispatcher] addEventResponder:[DCH500pxPhotoStore sharedDCH500pxPhotoStore] forEventDomain:DCH500pxEventDomain code:DC500pxEventCode_QueryFeaturedPhotos];
    [[DCH500pxDispatcher sharedDCH500pxDispatcher] addEventResponder:[DCH500pxPhotoStore sharedDCH500pxPhotoStore] forEventDomain:DCH500pxEventDomain code:DC500pxEventCode_QueryPhotoDetails];
    [[DCH500pxDispatcher sharedDCH500pxDispatcher] addEventResponder:[DCH500pxPhotoStore sharedDCH500pxPhotoStore] forEventDomain:DCH500pxEventDomain code:DC500pxEventCode_QueryPhotoCategory];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (BOOL)respondEvent:(id <DCHEvent>)event from:(id)source withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    BOOL result = NO;
    do {
        if (event == nil) {
            break;
        }
        
        if ([[event domain] isEqualToString:DCHDisplayEventDomain]) {
            switch ([event code]) {
                case DCDisplayEventCode_RefreshPhotoCategory:
                {
                    self.funcFinished = YES;
                    result = YES;
                }
                    break;
                case DCDisplayEventCode_RefreshFeaturedPhotos:
                {
                    self.funcFinished = YES;
                    result = YES;
                }
                case DCDisplayEventCode_RefreshPhotoDetails:
                {
                    self.funcFinished = YES;
                    result = YES;
                }
                default:
                    break;
            }
        }
    } while (NO);
    return result;
}

- (void)test4Main {
    do {
        // DCHCategoryViewModel
        DCHCategoryViewModel *categoryViewModel = [[DCHCategoryViewModel alloc] init];
        categoryViewModel.eventResponder = self;
        self.funcFinished = NO;
        DCHEventOperationTicket *ticket = [categoryViewModel refreshCategory:PXPhotoModelCategoryLandscapes];
        [DCHAsyncTest expect:^BOOL{
            return self.funcFinished;
        } withTimeout:20 andCompletionHandler:^(BOOL promiseResult, NSError *error, NSDictionary *infoDic) {
            DCHDebugLog(@"%@", categoryViewModel.models);
            XCTAssertNotNil(categoryViewModel.models);
        }];
        categoryViewModel.eventResponder = nil;
        categoryViewModel = nil;
        
        // DCHGalleryCollectionViewModel
        DCHGalleryCollectionViewModel * galleryCollectionViewModel = [[DCHGalleryCollectionViewModel alloc] init];
        galleryCollectionViewModel.eventResponder = self;
        self.funcFinished = NO;
        ticket = [galleryCollectionViewModel refreshGallery:PXAPIHelperPhotoFeatureEditors];
        [DCHAsyncTest expect:^BOOL{
            return self.funcFinished;
        } withTimeout:20 andCompletionHandler:^(BOOL promiseResult, NSError *error, NSDictionary *infoDic) {
            DCHDebugLog(@"%lu", (unsigned long)galleryCollectionViewModel.models.count);
            XCTAssert(galleryCollectionViewModel.models.count > 0);
        }];
        
        DCHPhotoModel *photoModel = [galleryCollectionViewModel.models objectAtIndex:0];
        galleryCollectionViewModel.eventResponder = nil;
        galleryCollectionViewModel = nil;
        
        // DCHDetailViewModel
        DCHDetailViewModel *detailViewModel = [[DCHDetailViewModel alloc] initWithPhotoModel:photoModel];
        detailViewModel.eventResponder = self;
        self.funcFinished = NO;
        ticket = [detailViewModel loadPhotoDetails];
        [DCHAsyncTest expect:^BOOL{
            return self.funcFinished;
        } withTimeout:20 andCompletionHandler:^(BOOL promiseResult, NSError *error, NSDictionary *infoDic) {
            DCHDebugLog(@"%@", [detailViewModel photoName]);
            XCTAssertNotNil(detailViewModel.model);
        }];
        detailViewModel.eventResponder = nil;
        detailViewModel = nil;
    } while (NO);
}

@end
