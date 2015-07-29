//
//  DCHGalleryCollectionViewController.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHGalleryCollectionViewController.h"
#import "DCHGalleryCollectionViewModel.h"
#import "DCH500pxEventCreater.h"
#import "DCH500pxEvent.h"
#import "DCH500pxDispatcher.h"
#import "DCHDisplayEventCreater.h"
#import "DCHDisplayEvent.h"
#import "DCH500pxPhotoStore.h"
#import "DCHPhotoModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <libextobjc/EXTScope.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import "DCHFullSizeViewModel.h"
#import "DCHFullSizeViewController.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
//#import "DCHImageCollectionViewCell.h"
#import "DCHImageCardCollectionViewCell.h"
#import "UIView+DCHParallax.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
//#import "DCHLoadingViewController.h"
#import "DCHShimmeringHUD.h"
#import <REMenu/REMenu.h>
#import "DCHBubblePhotoBrowser.h"
#import "DCHBubblePhotoBrowserViewModel.h"
#import "DCHBubbleAnimatedTransitioning.h"

@interface DCHGalleryCollectionViewController () <CHTCollectionViewDelegateWaterfallLayout, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) DCHGalleryCollectionViewModel *viewModel;
@property (nonatomic, assign) PXAPIHelperPhotoFeature feature;
@property (nonatomic, strong) DCHShimmeringHUD *shimmeringHUD;
@property (nonatomic, strong) REMenu *menu;

@property (nonatomic, strong) DCHBubbleAnimatedTransitioning *transition;
@property (nonatomic, assign) CGPoint transitionStartPoint;

- (void)refreshGallery;
- (void)loadMoreGallery;
- (void)toggleMenu;
- (void)setNaviTitle;

@end

@implementation DCHGalleryCollectionViewController

- (void)dealloc {
    do {
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] removeEventResponder:self.viewModel];
        self.viewModel = nil;
        
        [self.shimmeringHUD hardDismiss];
        self.shimmeringHUD = nil;
    } while (NO);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.viewModel = [[DCHGalleryCollectionViewModel alloc] init];
    self.feature = kPXAPIHelperDefaultFeature;
    
    @weakify(self)
    
    // Menu
    NSMutableArray *menuItemAry = [NSMutableArray array];
    for (NSUInteger idx = 0; idx < (PXAPIHelperPhotoFeatureFreshWeek + 1); ++idx) {
        PXAPIHelperPhotoFeature feature = (PXAPIHelperPhotoFeature)idx;
        REMenuItem *item = [[REMenuItem alloc] initWithTitle:[DCH500pxPhotoStore description4Feature:feature] image:nil highlightedImage:nil action:^(REMenuItem *item) {
            @strongify(self)
            do {
                if (item.tag == self.feature) {
                    ;
                } else {
                    self.feature = item.tag;
                    [self setNaviTitle];
                    [self refreshGallery];
                }
            } while (NO);
        }];
        item.tag = feature;
        [menuItemAry addObject:item];
    }
    self.menu = [[REMenu alloc] initWithItems:menuItemAry];
    
    // Blurred background in iOS 7
    //
    self.menu.liveBlur = YES;
    self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleDark;
    
    self.menu.separatorOffset = CGSizeMake(15.0, 0.0);
    self.menu.waitUntilAnimationIsComplete = NO;
    
    [self.menu setClosePreparationBlock:^{
        NSLog(@"Menu will close");
    }];
    
    [self.menu setCloseCompletionHandler:^{
        NSLog(@"Menu did close");
    }];
    
    // Navi
    [self setNaviTitle];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self)
        do {
            [self refreshGallery];
        } while (NO);
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"Menu" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self)
        do {
            [self toggleMenu];
        } while (NO);
    }];
    
    // Collection view
    [self.collectionView registerNib:[UINib nibWithNibName:[DCHImageCardCollectionViewCell cellIdentifier] bundle:nil] forCellWithReuseIdentifier:[DCHImageCardCollectionViewCell cellIdentifier]];
    self.collectionView.backgroundColor = [UIColor tungstenColor];
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.columnCount = DCHGalleryCollectionViewModel_kCountInLine;
    layout.minimumColumnSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(4.0f, 0.0f, 4.0f, 0.0f);
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        @strongify(self)
        do {
            [self loadMoreGallery];
        } while (NO);
    }];
    
    // Shimmering HUD
    self.shimmeringHUD = [[DCHShimmeringHUD alloc] initWitText:nil font:nil color:[UIColor aquaColor] andBackgroundColor:[UIColor colorWithColor:[UIColor tungstenColor] andAlpha:0.8]];
    
    self.transition = [[DCHBubbleAnimatedTransitioning alloc] init];
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
        if (self.viewModel.models.count == 0) {
            [self refreshGallery];
        }
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

#pragma mark - Private
- (void)refreshGallery {
    do {
        [NSThread dch_runInMain:^{
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.shimmeringHUD showHUDTo:self.view andShimmeringImmediately:YES];
        }];
        self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.viewModel refreshGallery:self.feature];
    } while (NO);
}

- (void)loadMoreGallery {
    do {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.viewModel loadMoreGallery:self.feature];
    } while (NO);
}

- (void)toggleMenu {
    do {
        if (self.menu.isOpen) {
            return [self.menu close];
        }
        
        [self.menu showFromNavigationController:self.navigationController];
    } while (NO);
}

- (void)setNaviTitle {
    @weakify(self)
    [NSThread dch_runInMain:^{
        @strongify(self)
        self.navigationItem.title = [NSString stringWithFormat:@"500px %@", [DCH500pxPhotoStore description4Feature:self.feature]];
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    id <UIViewControllerAnimatedTransitioning> result = nil;
    do {
        self.transition.transitionMode = DCHBubbleAnimatedTransitioning_Mode_Present;
        self.transition.startingPoint = self.transitionStartPoint;
        self.transition.bubbleColor = [UIColor clearColor];
        result = self.transition;
    } while (NO);
    return result;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    id <UIViewControllerAnimatedTransitioning> result = nil;
    do {
        if (dismissed && [dismissed isKindOfClass:[DCHBubblePhotoBrowser class]]) {
            DCHBubblePhotoBrowser *bubblePhotoBrowser = (DCHBubblePhotoBrowser *)dismissed;
            NSInteger currentPhotoIdx = bubblePhotoBrowser.currentPhotoIndex;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPhotoIdx inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        }
        
        self.transition.transitionMode = DCHBubbleAnimatedTransitioning_Mode_Dismiss;
        self.transition.startingPoint = self.transitionStartPoint;
        self.transition.bubbleColor = [UIColor clearColor];
        result = self.transition;
    } while (NO);
    return result;
}

#pragma mark - DCHEventResponder
- (BOOL)respondEvent:(id <DCHEvent>)event from:(id)source withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    BOOL result = NO;
    do {
        if (event == nil) {
            break;
        }
        
        if ([[event domain] isEqualToString:DCHDisplayEventDomain]) {
            switch ([event code]) {
                case DCDisplayEventCode_RefreshFeaturedPhotos:
                {
                    @weakify(self);
                    [NSThread dch_runInMain:^{
                        @strongify(self);
                        NSUInteger page = 0;
                        NSDictionary *payloadDic = (NSDictionary *)[event payload];
                        page = [payloadDic[DCDisplayEventCode_RefreshFeaturedPhotos_kPage] unsignedIntegerValue];
                        [self.collectionView reloadData];
                        if (page == DCH500pxPhotoStore_FirstPageNum) {
//                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            [self.shimmeringHUD dismiss];
                            if (self.viewModel.models.count > 0) {
                                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                            }
                        } else {
                            [self.collectionView.infiniteScrollingView stopAnimating];
                        }
                        
                        
                        self.navigationItem.leftBarButtonItem.enabled = self.navigationItem.rightBarButtonItem.enabled = YES;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the section
    NSLog(@"CollectionView count: %lu", (unsigned long)self.viewModel.models.count);
    return self.viewModel.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DCHImageCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[DCHImageCardCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    
    // Configure the cell
//    [cell refreshWithPhotoModel:self.viewModel.models[indexPath.row] onScrollView:self.collectionView scrollOnView:self.view];
    DCHPhotoModel *photoModel = nil;
    DCHArraySafeRead(self.viewModel.models, indexPath.row, photoModel);
//    [cell refreshWithPhotoModel:photoModel];
    [cell refreshWithPhotoModel:photoModel imageSize:photoModel.uiGalleryThumbnailDisplaySize onScrollView:self.collectionView scrollOnView:self.view];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    do {
        if (collectionView != self.collectionView || !indexPath) {
            break;
        }
//        DCHFullSizeViewModel *fullSizeVM = [[DCHFullSizeViewModel alloc] initWithPhotoArray:self.viewModel.models currentPhotoIndex:indexPath.row];
//        DCHFullSizeViewController *fullSizeVC = [[DCHFullSizeViewController alloc] initWithViewModel:fullSizeVM];
//        [self.navigationController pushViewController:fullSizeVC animated:YES];
        DCHBubblePhotoBrowserViewModel *bubblePhotoBrowserViewModel = [[DCHBubblePhotoBrowserViewModel alloc] initWithPhotoArray:self.viewModel.models];
        DCHBubblePhotoBrowser *bubblePhotoBrowser = [[DCHBubblePhotoBrowser alloc] initWithViewModel:bubblePhotoBrowserViewModel currentPhotoIndex:indexPath.item andTitle:[DCH500pxPhotoStore description4Feature:self.feature]];
        
        DCHImageCardCollectionViewCell *cell = (DCHImageCardCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        CGRect rectCellInCollectionView = [collectionView convertRect:cell.frame toView:self.view];
        CGRect rectContainerInSelf = [cell convertRect:cell.featureImageView.frame toView:cell];
        CGRect rect = CGRectMake(rectContainerInSelf.origin.x + rectCellInCollectionView.origin.x, rectContainerInSelf.origin.y + rectCellInCollectionView.origin.y, CGRectGetWidth(rectContainerInSelf), CGRectGetHeight(rectContainerInSelf));
        
        self.transitionStartPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        
        bubblePhotoBrowser.transitioningDelegate = self;
        bubblePhotoBrowser.modalPresentationStyle = UIModalPresentationCustom;
        bubblePhotoBrowser.view.frame = CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        [self presentViewController:bubblePhotoBrowser animated:YES completion:^{
            do {
                ;
            } while (NO);
        }];
    } while (NO);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    do {
        NSArray *cells = [self.collectionView visibleCells];
        for (DCHImageCardCollectionViewCell *cell in cells) {
            [cell parallaxViewOnScrollView:self.collectionView didScrollOnView:self.view];
        }
    } while (NO);
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize result = CGSizeZero;
    do {
        if (collectionView != self.collectionView || ![collectionViewLayout isKindOfClass:[CHTCollectionViewWaterfallLayout class]]) {
            break;
        }
        result = [self.viewModel calcCellSizeForCollectionLayout:collectionViewLayout andIndex:indexPath.item];
    } while (NO);
    return result;
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
