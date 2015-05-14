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

const NSUInteger DCHGalleryCollectionViewController_kCountInLine = 1;

@interface DCHGalleryCollectionViewController () <CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, strong) DCHGalleryCollectionViewModel *viewModel;
@property (nonatomic, assign) PXAPIHelperPhotoFeature feature;

- (void)refreshGallery;
- (void)loadMoreGallery;

@end

@implementation DCHGalleryCollectionViewController

- (void)dealloc {
    do {
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] removeEventResponder:self.viewModel];
        self.viewModel = nil;
    } while (NO);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.viewModel = [[DCHGalleryCollectionViewModel alloc] init];
    self.feature = PXAPIHelperPhotoFeaturePopular;
    
    self.navigationItem.title = @"500px Gallery";
    @weakify(self)
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain handler:^(id sender) {
        @strongify(self)
        do {
            [self refreshGallery];
        } while (NO);
    }];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:[DCHImageCardCollectionViewCell cellIdentifier] bundle:nil] forCellWithReuseIdentifier:[DCHImageCardCollectionViewCell cellIdentifier]];
    self.collectionView.backgroundColor = [UIColor ironColor];
    
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.columnCount = DCHGalleryCollectionViewController_kCountInLine;
    layout.minimumColumnSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f);
    self.collectionView.collectionViewLayout = layout;
    // Do any additional setup after loading the view.
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        @strongify(self)
        do {
            [self loadMoreGallery];
        } while (NO);
    }];
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
//        if (self.viewModel.models.count == 0) {
//            [self refreshGallery];
//        }
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

#pragma mark - Private
- (void)refreshGallery {
    do {
        [NSThread runInMain:^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.viewModel refreshGallery:self.feature];
    } while (NO);
}

- (void)loadMoreGallery {
    do {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.viewModel loadMoreGallery:self.feature];
    } while (NO);
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
                    [NSThread runInMain:^{
                        @strongify(self);
                        NSUInteger page = 0;
                        NSDictionary *payloadDic = (NSDictionary *)[event payload];
                        page = [payloadDic[DCDisplayEventCode_RefreshFeaturedPhotos_kPage] unsignedIntegerValue];
                        if (page == DCH500pxPhotoStore_FirstPageNum) {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        } else {
                            [self.collectionView.infiniteScrollingView stopAnimating];
                        }
                        [self.collectionView reloadData];
                        self.navigationItem.rightBarButtonItem.enabled = YES;
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
    [cell refreshWithPhotoModel:photoModel onScrollView:self.collectionView scrollOnView:self.view];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    do {
        if (collectionView != self.collectionView || !indexPath) {
            break;
        }
        DCHFullSizeViewModel *fullSizeVM = [[DCHFullSizeViewModel alloc] initWithPhotoArray:self.viewModel.models initialPhotoIndex:indexPath.row];
        DCHFullSizeViewController *fullSizeVC = [[DCHFullSizeViewController alloc] initWithViewModel:fullSizeVM];
        [self.navigationController pushViewController:fullSizeVC animated:YES];
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
        DCHPhotoModel *photoModel = nil;
        DCHArraySafeRead(self.viewModel.models, indexPath.row, photoModel);
        if (photoModel) {
            CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)collectionViewLayout;
            NSUInteger width = ([UIScreen mainScreen].bounds.size.width - layout.minimumInteritemSpacing * (DCHGalleryCollectionViewController_kCountInLine - 1) - layout.sectionInset.left - layout.sectionInset.right) / DCHGalleryCollectionViewController_kCountInLine;
            NSUInteger height = width * [photoModel.height longValue] / [photoModel.width longValue];
            photoModel.uiDisplaySize = CGSizeMake(width, height);
            result = CGSizeMake(width, (height + DCHImageCardCollectionViewCell_DescLabelHeight));
        }
        
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
