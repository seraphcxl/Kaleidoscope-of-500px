//
//  DCHCategoryCollectionHeaderView.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/11/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHCategoryCollectionHeaderView.h"
#import "DCHCategoryModel.h"

@interface DCHCategoryCollectionHeaderView ()

@property (nonatomic, strong) DCHCategoryModel *categoryModel;

@end

@implementation DCHCategoryCollectionHeaderView

+ (NSString *)viewlIdentifier {
    return NSStringFromClass([self class]);
}

- (void)dealloc {
    self.categoryModel = nil;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)refreshWithCategoryModel:(DCHCategoryModel *)categoryModel {
    do {
        self.categoryModel = categoryModel;
        self.titleLabel.text = @"";
        if (self.categoryModel) {
            self.hidden = NO;
            self.titleLabel.text = [DCHCategoryModel description4Category:self.categoryModel.category];
        } else {
            self.hidden = YES;
        }
    } while (NO);
}

@end
