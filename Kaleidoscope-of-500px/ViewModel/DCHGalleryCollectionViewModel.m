//
//  DCHGalleryCollectionViewModel.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHGalleryCollectionViewModel.h"
#import "DCHDisplayEvent.h"
#import "DCH500pxPhotoStore.h"
#import <libextobjc/EXTScope.h>
#import "DCH500pxEventCreater.h"
#import "DCH500pxEvent.h"
#import "DCH500pxDispatcher.h"
#import "DCHPhotoModel.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "DCHImageCardCollectionViewCell.h"

const NSUInteger DCHGalleryCollectionViewModel_kCountInLine = 1;

@interface DCHGalleryCollectionViewModel ()

@property (nonatomic, copy) NSArray *models;
@property (nonatomic, assign) NSUInteger currentPage;

- (NSAttributedString *)createUITitleForPhotoModel:(DCHPhotoModel *)photoModel;
- (NSString *)createUIDescForPhotoModel:(DCHPhotoModel *)photoModel;

@end

@implementation DCHGalleryCollectionViewModel

- (void)dealloc {
    do {
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] removeEventResponder:self];
        self.models = nil;
    } while (NO);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentPage = DCH500pxPhotoStore_FirstPageNum;
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] addEventResponder:self forEventDomain:DCHDisplayEventDomain code:DCDisplayEventCode_RefreshFeaturedPhotos];
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
                case DCDisplayEventCode_RefreshFeaturedPhotos:
                {
                    self.models = [DCH500pxPhotoStore sharedDCH500pxPhotoStore].photoModels;
                    [self.models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        do {
                            DCHPhotoModel *photoModel = (DCHPhotoModel *)obj;
                            photoModel.uiTitleStr = [self createUITitleForPhotoModel:photoModel];
                            photoModel.uiDescStr = [self createUIDescForPhotoModel:photoModel];
                        } while (NO);
                    }];
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

- (DCHEventOperationTicket *)refreshGallery:(PXAPIHelperPhotoFeature)feature {
    DCHEventOperationTicket *result = nil;
    do {
        NSLog(@"%@ %@", [self class], NSStringFromSelector(_cmd));
        self.currentPage = DCH500pxPhotoStore_FirstPageNum;
        DCH500pxEvent *queryFeaturedPhotosEvent = [DCH500pxEventCreater create500pxEventByCode:DC500pxEventCode_QueryFeaturedPhotos andPayload:@{DC500pxEventCode_QueryFeaturedPhotos_kFeature: @(feature), DC500pxEventCode_QueryFeaturedPhotos_kPage: @(self.currentPage)}];
        result = [[DCH500pxDispatcher sharedDCH500pxDispatcher] handleEvent:queryFeaturedPhotosEvent inMainThread:NO withResponderCallback:^(id eventResponder, id <DCHEvent> outputEvent, NSError *error) {
            do {
                if ([eventResponder isEqual:[DCH500pxPhotoStore sharedDCH500pxPhotoStore]]) {
                    NSLog(@"queryFeaturedPhotosEvent complte in %@", NSStringFromSelector(_cmd));
                }
            } while (NO);
        }];
    } while (NO);
    return result;
}

- (DCHEventOperationTicket *)loadMoreGallery:(PXAPIHelperPhotoFeature)feature {
    DCHEventOperationTicket *result = nil;
    do {
        ++self.currentPage;
        DCH500pxEvent *queryFeaturedPhotosEvent = [DCH500pxEventCreater create500pxEventByCode:DC500pxEventCode_QueryFeaturedPhotos andPayload:@{DC500pxEventCode_QueryFeaturedPhotos_kFeature: @(feature), DC500pxEventCode_QueryFeaturedPhotos_kPage: @(self.currentPage)}];
        result = [[DCH500pxDispatcher sharedDCH500pxDispatcher] handleEvent:queryFeaturedPhotosEvent inMainThread:NO withResponderCallback:^(id eventResponder, id <DCHEvent> outputEvent, NSError *error) {
            do {
                if ([eventResponder isEqual:[DCH500pxPhotoStore sharedDCH500pxPhotoStore]]) {
                    NSLog(@"queryFeaturedPhotosEvent complte in %@", NSStringFromSelector(_cmd));
                }
            } while (NO);
        }];
    } while (NO);
    return result;
}

- (CGSize)calcCellSizeForCollectionLayout:(UICollectionViewLayout *)collectionViewLayout andIndex:(NSUInteger)index {
    CGSize result = CGSizeZero;
    do {
        if (![collectionViewLayout isKindOfClass:[CHTCollectionViewWaterfallLayout class]]) {
            break;
        }
        DCHPhotoModel *photoModel = nil;
        DCHArraySafeRead(self.models, index, photoModel);
        if (photoModel) {
            CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)collectionViewLayout;
            NSUInteger width = ([UIScreen mainScreen].bounds.size.width - layout.minimumInteritemSpacing * (DCHGalleryCollectionViewModel_kCountInLine - 1) - layout.sectionInset.left - layout.sectionInset.right) / DCHGalleryCollectionViewModel_kCountInLine;
            NSUInteger height = width * [photoModel.height longValue] / [photoModel.width longValue];
            photoModel.uiGalleryThumbnailDisplaySize = CGSizeMake(width, height);
            result = CGSizeMake(width, (height + DCHImageCardCollectionViewCell_DescLabelHeight));
        }
        
    } while (NO);
    return result;
}

- (NSAttributedString *)createUITitleForPhotoModel:(DCHPhotoModel *)photoModel {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@""];
    do {
        if (!photoModel) {
            break;
        }
        NSShadow *titleShdow = [[NSShadow alloc] init];
        titleShdow.shadowColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.3];
        titleShdow.shadowOffset = CGSizeMake(0, 2);
        titleShdow.shadowBlurRadius = 3;
        if (!DCH_IsEmpty(photoModel.photoName)) {
            [result appendAttributedString:[[NSAttributedString alloc] initWithString:photoModel.photoName attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Heavy" size:17], NSForegroundColorAttributeName: [UIColor whiteColor], NSBackgroundColorAttributeName: [UIColor clearColor], NSShadowAttributeName: titleShdow}]];
        }
        if (!DCH_IsEmpty(result)) {
            [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n    -"]];
        }
        if (!DCH_IsEmpty(photoModel.photographerName)) {
            [result appendAttributedString:[[NSAttributedString alloc] initWithString:photoModel.photographerName attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:13], NSForegroundColorAttributeName: [UIColor whiteColor], NSBackgroundColorAttributeName: [UIColor clearColor], NSShadowAttributeName: titleShdow}]];
        }
    } while (NO);
    return result;
}

- (NSString *)createUIDescForPhotoModel:(DCHPhotoModel *)photoModel {
    NSString *result = nil;
    do {
        if (!photoModel) {
            break;
        }
        NSMutableString *desc = [NSMutableString string];
        NSMutableString *desc0 = [NSMutableString string];
        NSMutableString *desc1 = [NSMutableString string];
        NSMutableString *desc2 = [NSMutableString string];
        NSMutableString *desc3 = [NSMutableString string];
        
        if (!DCH_IsEmpty(photoModel.createdAt)) {
            [desc0 appendString:photoModel.createdAt];
        }
        if (!DCH_IsEmpty(photoModel.photographerCity)) {
            if (![desc0 isEqualToString:@""]) {
                [desc0 appendString:@" "];
            }
            [desc0 appendString:photoModel.photographerCity];
        }
        if (!DCH_IsEmpty(photoModel.photographerCountry)) {
            if (![desc0 isEqualToString:@""]) {
                [desc0 appendString:@" "];
            }
            [desc0 appendString:photoModel.photographerCountry];
        }
        
        if (!DCH_IsEmpty(photoModel.camera)) {
            [desc1 appendString:photoModel.camera];
        }
        if (photoModel.lens) {
            if (![desc1 isEqualToString:@""]) {
                [desc1 appendString:@" "];
            }
            [desc1 appendString:photoModel.lens];
        }
        
        if (!DCH_IsEmpty(photoModel.aperture)) {
            [desc2 appendFormat:@"f:%@", photoModel.aperture];
        }
        if (!DCH_IsEmpty(photoModel.focalLength)) {
            if (![desc2 isEqualToString:@""]) {
                [desc2 appendString:@" "];
            }
            [desc2 appendFormat:@"%@mm", photoModel.focalLength];
        }
        if (photoModel.iso) {
            if (![desc2 isEqualToString:@""]) {
                [desc2 appendString:@" "];
            }
            [desc2 appendFormat:@"iso:%d", [photoModel.iso intValue]];
        }
        if (!DCH_IsEmpty(photoModel.shutterSpeed)) {
            if (![desc2 isEqualToString:@""]) {
                [desc2 appendString:@" "];
            }
            [desc2 appendFormat:@"%@s", photoModel.shutterSpeed];
        }
        
        if (photoModel.rating) {
            [desc3 appendFormat:@"Rating:%.2f", [photoModel.rating floatValue]];
        }
        if (photoModel.commentsCount) {
            if (![desc3 isEqualToString:@""]) {
                [desc3 appendString:@" "];
            }
            [desc3 appendFormat:@"Comments:%d", [photoModel.commentsCount intValue]];
        }
        if (photoModel.favoritesCount) {
            if (![desc3 isEqualToString:@""]) {
                [desc3 appendString:@" "];
            }
            [desc3 appendFormat:@"Favs:%d", [photoModel.favoritesCount intValue]];
        }
        if (photoModel.votesCount) {
            if (![desc3 isEqualToString:@""]) {
                [desc3 appendString:@" "];
            }
            [desc3 appendFormat:@"Votes:%d", [photoModel.votesCount intValue]];
        }
        
        if (desc0) {
            [desc appendString:desc0];
        }
        if (desc1) {
            if (![desc isEqualToString:@""]) {
                [desc appendFormat:@"\n"];
            }
            [desc appendString:desc1];
        }
        if (desc2) {
            if (![desc isEqualToString:@""]) {
                [desc appendFormat:@"\n"];
            }
            [desc appendString:desc2];
        }
        if (desc3) {
            if (![desc isEqualToString:@""]) {
                [desc appendFormat:@"\n"];
            }
            [desc appendString:desc3];
        }
        
        result = desc;
    } while (NO);
    return result;
}
@end
