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
#import "DCHShimmeringHUD.h"
#import "DCHLinearGradientView.h"
#import "UIImage+DCHColotArt.h"

@interface DCHDetailViewController ()

@property (nonatomic, assign) NSInteger photoIndex;
@property (nonatomic, strong) DCHDetailViewModel *viewModel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) DCHShimmeringHUD *shimmeringHUD;
@property (nonatomic, strong) DCHLinearGradientView *gradientView;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation DCHDetailViewController

- (void)dealloc {
    do {
        self.viewModel = nil;
        
        [self.shimmeringHUD hardDismiss];
        self.shimmeringHUD = nil;
        
        [self.imageView removeFromSuperview];
        self.imageView = nil;
        
        [self.gradientView removeFromSuperview];
        self.gradientView = nil;
        
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil;
        
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
        self.view.backgroundColor = [UIColor tungstenColor];
        
//        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
//        self.backgroundView.backgroundColor = [UIColor clearColor];
//        [self.view addSubview:self.backgroundView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:self.imageView];
        
        // Shimmering HUD
        self.shimmeringHUD = [[DCHShimmeringHUD alloc] initWitText:nil font:nil color:[UIColor salmonColor] andBackgroundColor:[UIColor colorWithColor:[UIColor tungstenColor] andAlpha:0.8]];
        
//        self.gradientView = [[DCHLinearGradientView alloc] initWithFrame:CGRectZero];
//        self.gradientView.orientation = DCHLinearGradientView_Orientation_Bottom2Top;
//        self.gradientView.gradientSize = 1;
//        [self.view addSubview:self.gradientView];
    } while (NO);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    do {
        self.viewModel.eventResponder = self;
        [self.imageView sd_cancelCurrentImageLoad];
        if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:self.viewModel.model.fullsizedURL]]) {
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.viewModel.model.fullsizedURL] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                do {
                    ;
                } while (NO);
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                do {
                    self.imageView.image = image;
                } while (NO);
            }];
//            UIColor *clr = [image findEdgeColorWithType:DCHColotArt_EdgeType_Bottom andCountOfLine:2];
//            self.gradientView.color = clr;
//            self.backgroundView.backgroundColor = [UIColor colorWithColor:clr andAlpha:1.0f];
//            [self.gradientView setNeedsDisplay];
//            [self.backgroundView setNeedsDisplay];
        } else {
            [self.viewModel loadPhotoDetails];
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.shimmeringHUD showHUDTo:self.view andShimmeringImmediately:YES];
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
        NSUInteger width = ([UIScreen mainScreen].bounds.size.width);
        NSUInteger height = width * [self.viewModel.model.height longValue] / [self.viewModel.model.width longValue];
        self.imageView.frame = CGRectMake(0.0f, 0.0f, width, height);
        self.imageView.center = self.view.center;
        
//        self.gradientView.frame = self.imageView.frame;
//        
//        NSUInteger y = self.view.bounds.size.height - self.imageView.frame.size.height - self.imageView.frame.origin.y;
//        NSUInteger h = self.view.bounds.size.height - y;
//        self.backgroundView.frame = CGRectMake(0.0f, y, self.view.bounds.size.width, h);
    } while (NO);
}

- (void)viewWillDisappear:(BOOL)animated {
    do {
        [self.shimmeringHUD hardDismiss];
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
                        [self.imageView sd_cancelCurrentImageLoad];
                        self.imageView.image = nil;
                        if (self.viewModel.model.fullsizedURL) {
                            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.model.fullsizedURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                //                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                [self.shimmeringHUD dismiss];
                                do {
                                    if (error) {
                                        NSLog(@"sd_setImageWithURL err:%@", error);
                                        break;
                                    }
                                    if (!image) {
                                        break;
                                    }
                                    //                                        UIColor *clr = [image findEdgeColorWithType:DCHColotArt_EdgeType_Bottom andCountOfLine:2];
                                    //                                        self.gradientView.color = clr;
                                    //                                        self.backgroundView.backgroundColor = [UIColor colorWithColor:clr andAlpha:1.0f];
                                    //                                        [self.gradientView setNeedsDisplay];
                                    //                                        [self.backgroundView setNeedsDisplay];
                                } while (NO);
                            }];
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
