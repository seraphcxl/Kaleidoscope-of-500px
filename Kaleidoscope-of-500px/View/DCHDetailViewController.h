//
//  DCHDetailViewController.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DCHFluxKit/DCHFluxKit.h>

@class DCHDetailViewModel;

@interface DCHDetailViewController : UIViewController

@property (nonatomic, assign, readonly) NSInteger photoIndex;
@property (nonatomic, strong, readonly) DCHDetailViewModel *viewModel;

- (instancetype)initWithViewModel:(DCHDetailViewModel *)viewModel index:(NSInteger)photoIndex;

@end
