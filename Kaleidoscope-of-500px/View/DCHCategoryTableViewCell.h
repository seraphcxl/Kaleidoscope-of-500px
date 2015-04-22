//
//  DCHCategoryTableViewCell.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <500px-iOS-api/PXAPI.h>

@class DCHCategoryModel;

@interface DCHCategoryTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) DCHCategoryModel *categoryModel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UIImageView *centerImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;

- (void)refreshWithCategoryModel:(DCHCategoryModel *)categoryModel;

@end
