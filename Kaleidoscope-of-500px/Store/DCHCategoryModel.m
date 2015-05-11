//
//  DCHCategoryModel.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHCategoryModel.h"
#import <Tourbillon/DCHTourbillon.h>

@interface DCHCategoryModel ()

@property (nonatomic, assign) PXPhotoModelCategory category;
@property (nonatomic, strong) NSArray *models;

@end

@implementation DCHCategoryModel

+ (NSArray *)categories {
    return @[@(PXPhotoModelCategoryUncategorized), @(PXPhotoModelCategoryAbstract), @(PXPhotoModelCategoryAnimals), @(PXPhotoModelCategoryBlackAndWhite), @(PXPhotoModelCategoryCelbrities), @(PXPhotoModelCategoryCityAndArchitecture), @(PXPhotoModelCategoryCommercial), @(PXPhotoModelCategoryConcert), @(PXPhotoModelCategoryFamily), @(PXPhotoModelCategoryFashion), @(PXPhotoModelCategoryFilm), @(PXPhotoModelCategoryFineArt), @(PXPhotoModelCategoryFood), @(PXPhotoModelCategoryJournalism), @(PXPhotoModelCategoryLandscapes), @(PXPhotoModelCategoryMacro), @(PXPhotoModelCategoryNature), /*@(PXPhotoModelCategoryNude), */@(PXPhotoModelCategoryPeople), @(PXPhotoModelCategoryPerformingArts), @(PXPhotoModelCategorySport), @(PXPhotoModelCategoryStillLife), @(PXPhotoModelCategoryStreet), @(PXPhotoModelCategoryTransportation), @(PXPhotoModelCategoryTravel), @(PXPhotoModelCategoryUnderwater), @(PXPhotoModelCategoryUrbanExploration), @(PXPhotoModelCategoryWedding)];
}

+ (NSString *)description4Category:(PXPhotoModelCategory)category {
    NSString *result = @"";
    do {
        switch (category) {
            case PXPhotoModelCategoryUncategorized:
            { result = @"Uncategorized"; }
                break;
            case PXPhotoModelCategoryAbstract:
            { result = @"Abstract"; }
                break;
            case PXPhotoModelCategoryAnimals:
            { result = @"Animals"; }
                break;
            case PXPhotoModelCategoryBlackAndWhite:
            { result = @"BlackAndWhite"; }
                break;
            case PXPhotoModelCategoryCelbrities:
            { result = @"Celbrities"; }
                break;
            case PXPhotoModelCategoryCityAndArchitecture:
            { result = @"CityAndArchitecture"; }
                break;
            case PXPhotoModelCategoryCommercial:
            { result = @"Commercial"; }
                break;
            case PXPhotoModelCategoryConcert:
            { result = @"Concert"; }
                break;
            case PXPhotoModelCategoryFamily:
            { result = @"Family"; }
                break;
            case PXPhotoModelCategoryFashion:
            { result = @"Fashion"; }
                break;
            case PXPhotoModelCategoryFilm:
            { result = @"Film"; }
                break;
            case PXPhotoModelCategoryFineArt:
            { result = @"FineArt"; }
                break;
            case PXPhotoModelCategoryFood:
            { result = @"Food"; }
                break;
            case PXPhotoModelCategoryJournalism:
            { result = @"Journalism"; }
                break;
            case PXPhotoModelCategoryLandscapes:
            { result = @"Landscapes"; }
                break;
            case PXPhotoModelCategoryMacro:
            { result = @"Macro"; }
                break;
            case PXPhotoModelCategoryNature:
            { result = @"Nature"; }
                break;
            case PXPhotoModelCategoryNude:
            { result = @"Nude"; }
                break;
            case PXPhotoModelCategoryPeople:
            { result = @"People"; }
                break;
            case PXPhotoModelCategoryPerformingArts:
            { result = @"PerformingArts"; }
                break;
            case PXPhotoModelCategorySport:
            { result = @"Sport"; }
                break;
            case PXPhotoModelCategoryStillLife:
            { result = @"StillLife"; }
                break;
            case PXPhotoModelCategoryStreet:
            { result = @"Street"; }
                break;
            case PXPhotoModelCategoryTransportation:
            { result = @"Transportation"; }
                break;
            case PXPhotoModelCategoryTravel:
            { result = @"Travel"; }
                break;
            case PXPhotoModelCategoryUnderwater:
            { result = @"Underwater"; }
                break;
            case PXPhotoModelCategoryUrbanExploration:
            { result = @"UrbanExploration"; }
                break;
            case PXPhotoModelCategoryWedding:
            { result = @"Wedding"; }
                break;
            default:
                break;
        }
    } while (NO);
    return result;
}

+ (NSUInteger)index4Category:(PXPhotoModelCategory)category {
    NSUInteger result = 0;
    DCHArraySafeIndexOfObject([self categories], @(category), result);
    return result;
}

- (instancetype)initWithCategory:(PXPhotoModelCategory)category andModels:(NSArray *)models {
    self = [self init];
    if (self) {
        self.category = category;
        self.models = models;
    }
    return self;
}

@end
