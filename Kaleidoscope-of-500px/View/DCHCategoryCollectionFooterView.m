//
//  DCHCategoryCollectionFooterView.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/11/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHCategoryCollectionFooterView.h"
#import "DCHCategoryModel.h"

@interface DCHCategoryCollectionFooterView ()

@property (nonatomic, strong) DCHCategoryModel *categoryModel;

@end

@implementation DCHCategoryCollectionFooterView

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
        if (self.categoryModel) {
            self.hidden = NO;
        } else {
            self.hidden = YES;
        }
    } while (NO);
}
@end
