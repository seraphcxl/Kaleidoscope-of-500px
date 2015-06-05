//
//  DCHCategoryViewModel.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHCategoryViewModel.h"
#import "DCHDisplayEvent.h"
#import "DCH500pxPhotoStore.h"
#import <libextobjc/EXTScope.h>
#import "DCH500pxEventCreater.h"
#import "DCH500pxEvent.h"
#import "DCH500pxDispatcher.h"
#import "DCHCategoryModel.h"
#import <CSStickyHeaderFlowLayout/CSStickyHeaderFlowLayout.h>
//#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "DCHPhotoModel.h"

const NSUInteger DCHCategoryCollectionViewModel_kCountInLine = 2;

@interface DCHCategoryViewModel ()

@property (nonatomic, copy) NSDictionary *models;
@property (nonatomic, strong) NSMutableDictionary *loadingStatusDic;

@end

@implementation DCHCategoryViewModel

- (void)dealloc {
    do {
        [[self.loadingStatusDic allValues] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            do {
                DCHEventOperationTicket *ticket = (DCHEventOperationTicket *)obj;
                ticket.canceled = YES;
            } while (NO);
        }];
        self.loadingStatusDic = nil;
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] removeEventResponder:self];
        self.models = nil;
    } while (NO);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] addEventResponder:self forEventDomain:DCHDisplayEventDomain code:DCDisplayEventCode_RefreshPhotoCategory];
        self.loadingStatusDic = [NSMutableDictionary dictionary];
    }
    return self;
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
                    self.models = [DCH500pxPhotoStore sharedDCH500pxPhotoStore].categories;
                    [self emitChangeWithEvent:event];
                    result = YES;
                }
                    break;
                    
                default:
                    break;
            }
        }
        if (completionHandler) {
            completionHandler(self, event, nil);
        }
    } while (NO);
    return result;
}

- (DCHEventOperationTicket *)refreshCategory:(PXPhotoModelCategory)category {
    DCHEventOperationTicket *result = nil;
    do {
        if ([self.loadingStatusDic objectForKey:@(category)]) {
            break;
        }
        @weakify(self)
        DCH500pxEvent *queryPhotoCategoryEvent = [DCH500pxEventCreater create500pxEventByCode:DC500pxEventCode_QueryPhotoCategory andPayload:@{DC500pxEventCode_QueryPhotoCategory_kCategory: @(category)}];
        result = [[DCH500pxDispatcher sharedDCH500pxDispatcher] handleEvent:queryPhotoCategoryEvent inMainThread:NO withResponderCallback:^(id eventResponder, id <DCHEvent> outputEvent, NSError *error) {
            @strongify(self)
            do {
                if ([eventResponder isEqual:[DCH500pxPhotoStore sharedDCH500pxPhotoStore]]) {
                    NSLog(@"queryPhotoCategoryEvent complte in %@ Category:%@", NSStringFromSelector(_cmd), [outputEvent payload][DC500pxEventCode_QueryPhotoCategory_kCategory]);
                }
            } while (NO);
            [self.loadingStatusDic removeObjectForKey:@(category)];
        }];
        [self.loadingStatusDic setObject:result forKey:@(category)];
    } while (NO);
    return result;
}

- (void)setNeedRefreshCategories {
    do {
        [self.models enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            do {
                DCHCategoryModel *categoryModel = (DCHCategoryModel *)obj;
                categoryModel.needRefresh = YES;
            } while (NO);
        }];
    } while (NO);
}

- (CGSize)calcCellSizeForCollectionLayout:(UICollectionViewLayout *)collectionViewLayout andIndexPath:(NSIndexPath *)indexPath {
    CGSize result = CGSizeZero;
    do {
//        if (![collectionViewLayout isKindOfClass:[CHTCollectionViewWaterfallLayout class]]) {
//            break;
//        }
//        DCHCategoryModel *model = [self.models objectForKey:[DCHCategoryModel categories][indexPath.section]];
//        if (model) {
//            DCHPhotoModel *photoModel = nil;
//            DCHArraySafeRead(model.models, indexPath.item, photoModel);
//            if (photoModel) {
//                CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)collectionViewLayout;
//                NSUInteger width = ([UIScreen mainScreen].bounds.size.width - layout.minimumInteritemSpacing * (DCHCategoryCollectionViewModel_kCountInLine - 1) - layout.sectionInset.left - layout.sectionInset.right) / DCHCategoryCollectionViewModel_kCountInLine;
//                NSUInteger height = width * [photoModel.height longValue] / [photoModel.width longValue];
//                photoModel.uiThumbnailDisplaySize = CGSizeMake(width, height);
//                result = CGSizeMake(width, height);
//            }
//        }
        
        if (![collectionViewLayout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
            break;
        }
        CSStickyHeaderFlowLayout *layout = (CSStickyHeaderFlowLayout *)collectionViewLayout;
        DCHCategoryModel *model = [self.models objectForKey:[DCHCategoryModel categories][indexPath.section]];
        if (model) {
            DCHPhotoModel *photoModel = nil;
            DCHArraySafeRead(model.models, indexPath.item, photoModel);
            if (photoModel) {
                photoModel.uiCategoryThumbnailDisplaySize = layout.itemSize;
                result = photoModel.uiCategoryThumbnailDisplaySize;
            }
        }
        
    } while (NO);
    return result;
}
@end
