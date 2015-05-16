//
//  DCHFullSizeViewController.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHFullSizeViewController.h"
#import "DCHFullSizeViewModel.h"
#import "DCHDetailViewModel.h"
#import "DCHDetailViewController.h"
#import <Tourbillon/DCHTourbillon.h>

@interface DCHFullSizeViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) DCHFullSizeViewModel *viewModel;
@property (nonatomic, strong) UIPageViewController *pageViewController;

- (DCHDetailViewController *)photoViewControllerForIndex:(NSInteger)index;

@end

@implementation DCHFullSizeViewController

- (void)dealloc {
    do {
        self.viewModel = nil;
    } while (NO);
}

- (instancetype)initWithViewModel:(DCHFullSizeViewModel *)viewModel {
    if (!viewModel) {
        return nil;
    }
    
    self = [super init];
    if (!self) return nil;
    
    self.viewModel = viewModel;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    do {
        self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey: @(30)}];
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
        [self addChildViewController:self.pageViewController];
        
        [self.pageViewController setViewControllers:@[[self photoViewControllerForIndex:self.viewModel.initialPhotoIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            ;
        }];
        
        self.view.backgroundColor = [UIColor salmonColor];
        self.title = self.viewModel.initialPhotoName;
        self.pageViewController.view.frame = self.view.bounds;
        [self.view addSubview:self.pageViewController.view];
    } while (NO);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    do {
        self.viewModel.eventResponder = self;
    } while (NO);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    do {
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

#pragma mark - Private
- (DCHDetailViewController *)photoViewControllerForIndex:(NSInteger)index {
    DCHDetailViewController *result = nil;
    do {
        DCHPhotoModel *photoModel = [self.viewModel photoModelAtIndex:index];
        if (photoModel) {
            DCHDetailViewModel *detailVM = [[DCHDetailViewModel alloc] initWithPhotoModel:photoModel];
            result = [[DCHDetailViewController alloc] initWithViewModel:detailVM index:index];
        }
    } while (NO);
    return result;
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(DCHDetailViewController *)viewController {
    return [self photoViewControllerForIndex:viewController.photoIndex - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(DCHDetailViewController *)viewController {
    return [self photoViewControllerForIndex:viewController.photoIndex + 1];
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.title = [((DCHDetailViewController *)self.pageViewController.viewControllers.firstObject).viewModel photoName];
}

@end
