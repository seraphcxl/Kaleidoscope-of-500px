//
//  DCHBubblePhotoBrowser.h
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DCHFluxKit/DCHFluxKit.h>

@class DCHBubblePhotoBrowserViewModel;

@interface DCHBubblePhotoBrowser : UIViewController

- (instancetype)initWithViewModel:(DCHBubblePhotoBrowserViewModel *)viewModel initialPhotoIndex:(NSUInteger)index andTitle:(NSString *)title;

@end
