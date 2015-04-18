//
//  DCHDetailViewController.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHDetailViewController.h"
#import "DCHDetailViewModel.h"
#import "DCH500pxPhotoStore.h"
#import "DCHDisplayEvent.h"
#import <libextobjc/EXTScope.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "DCHPhotoModel.h"

@interface DCHDetailViewController ()

@property (nonatomic, assign) NSInteger photoIndex;
@property (nonatomic, strong) DCHDetailViewModel *viewModel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DCHDetailViewController

- (void)dealloc {
    do {
        self.viewModel = nil;
    } while (NO);
}

- (instancetype)initWithViewModel:(DCHDetailViewModel *)viewModel index:(NSInteger)photoIndex {
    self = [self init];
    if (!self) return nil;
    
    self.viewModel = viewModel;
    self.photoIndex = photoIndex;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    do {
        self.view.backgroundColor = [UIColor aquaColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        self.imageView = imageView;
    } while (NO);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    do {
        self.viewModel.eventResponder = self;
        if (self.viewModel.model.fullsizedData) {
            self.imageView.image = [UIImage imageWithData:self.viewModel.model.fullsizedData];
        } else {
            [self.viewModel loadPhotoDetails];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
    } while (NO);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    do {
//        self.imageView.frame = self.view.bounds;
    } while (NO);
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    do {
        self.imageView.frame = self.view.bounds;
    } while (NO);
}

- (void)viewWillDisappear:(BOOL)animated {
    do {
        ;
    } while (NO);
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    do {
        self.viewModel.eventResponder = nil;
    } while (NO);
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - DCHEventResponder
- (BOOL)respondEvent:(id <DCHEvent>)event from:(id)source withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    BOOL result = NO;
    do {
        if (event == nil) {
            break;
        }
        
        if ([[event domain] isEqualToString:DCHDisplayEventDomain]) {
            switch ([event code]) {
                case DCDisplayEventCode_RefreshPhotoDetails:
                {
                    @weakify(self);
                    [NSThread runInMain:^{
                        @strongify(self);
                        if (self.viewModel.model.fullsizedData) {
                            ;
                        } else {
                            if (self.viewModel.model.fullsizedURL) {
                                [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.fullsizedURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    do {
                                        if (error) {
                                            NSLog(@"sd_setImageWithURL err:%@", error);
                                            break;
                                        }
                                        if (!image) {
                                            break;
                                        }
                                        if ([self.viewModel.model.fullsizedURL isEqualToString:[imageURL absoluteString]]) {
                                            self.viewModel.model.fullsizedData = UIImageJPEGRepresentation(image, 0.6);
                                        }
                                    } while (NO);
                                }];
                            }
                        }
                    }];
                    result = YES;
                }
                    break;
                    
                default:
                    break;
            }
        }
    } while (NO);
    return result;
}

@end
