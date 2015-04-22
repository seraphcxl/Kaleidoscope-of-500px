//
//  DCHCategoryTableViewCell.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCHCategoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet UIImageView *centerImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;

@end
