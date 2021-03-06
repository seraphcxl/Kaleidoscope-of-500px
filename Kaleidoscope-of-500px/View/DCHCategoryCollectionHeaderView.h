//
//  DCHCategoryCollectionHeaderView.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/11/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCHCategoryModel;

@interface DCHCategoryCollectionHeaderView : UICollectionReusableView

+ (NSString *)viewlIdentifier;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
- (IBAction)actionForClick:(id)sender;

- (void)refreshWithCategoryModel:(DCHCategoryModel *)categoryModel;

@end
