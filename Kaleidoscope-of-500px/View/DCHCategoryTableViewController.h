//
//  DCHCategoryTableViewController.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DCHFluxKit/DCHFluxKit.h>

@class DCHCategoryViewModel;

@interface DCHCategoryTableViewController : UITableViewController

@property (nonatomic, strong, readonly) DCHCategoryViewModel *viewModel;

@end
