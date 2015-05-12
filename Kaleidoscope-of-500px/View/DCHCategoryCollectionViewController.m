//
//  DCHCategoryCollectionViewController.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/11/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHCategoryCollectionViewController.h"
#import "DCHCategoryViewModel.h"
#import "DCHCategoryModel.h"
#import "DCHPhotoModel.h"
#import "DCH500pxEventCreater.h"
#import "DCH500pxEvent.h"
#import "DCH500pxDispatcher.h"
#import "DCHDisplayEventCreater.h"
#import "DCHDisplayEvent.h"
#import "DCH500pxPhotoStore.h"
#import "DCHImageCollectionViewCell.h"
#import "DCHCategoryCollectionHeaderView.h"
#import "DCHCategoryCollectionFooterView.h"
#import <Tourbillon/DCHTourbillon.h>
#import <libextobjc/EXTScope.h>
#import "UIView+DCHParallax.h"
#import <CSStickyHeaderFlowLayout/CSStickyHeaderFlowLayout.h>
#import "DCHFullSizeViewModel.h"
#import "DCHFullSizeViewController.h"

const NSUInteger DCHCategoryCollectionViewController_kCountInLine = 2;

@interface DCHCategoryCollectionViewController ()

@property (nonatomic, strong) DCHCategoryViewModel *viewModel;

@end

@implementation DCHCategoryCollectionViewController

- (void)dealloc {
    do {
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] removeEventResponder:self.viewModel];
        self.viewModel = nil;
    } while (NO);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [[DCHCategoryViewModel alloc] init];
    
    self.navigationItem.title = @"500px Categories";
    self.navigationItem.rightBarButtonItem = nil;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:[DCHImageCollectionViewCell cellIdentifier] bundle:nil] forCellWithReuseIdentifier:[DCHImageCollectionViewCell cellIdentifier]];
    [self.collectionView registerNib:[UINib nibWithNibName:[DCHCategoryCollectionHeaderView viewlIdentifier] bundle:nil] forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:[DCHCategoryCollectionHeaderView viewlIdentifier]];
    [self.collectionView registerNib:[UINib nibWithNibName:[DCHCategoryCollectionHeaderView viewlIdentifier] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[DCHCategoryCollectionHeaderView viewlIdentifier]];
    [self.collectionView registerNib:[UINib nibWithNibName:[DCHCategoryCollectionFooterView viewlIdentifier] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[DCHCategoryCollectionFooterView viewlIdentifier]];
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor ironColor];
    
    CSStickyHeaderFlowLayout *layout = [[CSStickyHeaderFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 8;
    layout.minimumLineSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f);
    layout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 32);
    layout.footerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 8);
    NSUInteger imgSize = ((NSUInteger)(self.collectionView.bounds.size.width - layout.minimumInteritemSpacing * (DCHCategoryCollectionViewController_kCountInLine - 1) - layout.sectionInset.left - layout.sectionInset.right)) / DCHCategoryCollectionViewController_kCountInLine;
    layout.itemSize = CGSizeMake(imgSize, imgSize);
//    layout.parallaxHeaderAlwaysOnTop = YES;
//    layout.parallaxHeaderReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 48);
//    layout.parallaxHeaderMinimumReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 32);
    self.collectionView.collectionViewLayout = layout;
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
        ;
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [DCHCategoryModel categories].count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger result = 0;
    do {
        if (collectionView != self.collectionView) {
            break;
        }
        DCHCategoryModel *model = [self.viewModel.models objectForKey:[DCHCategoryModel categories][section]];
        if (model) {
            result = model.models.count;
        } else {
            [self.viewModel refreshCategory:[[DCHCategoryModel categories][section] integerValue]];
        }
        
    } while (NO);
    return result;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DCHImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[DCHImageCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    
    // Configure the cell
    DCHCategoryModel *model = [self.viewModel.models objectForKey:[DCHCategoryModel categories][indexPath.section]];
    if (model) {
        DCHPhotoModel *photoModel = nil;
        DCHArraySafeRead(model.models, indexPath.item, photoModel);
        [cell refreshWithPhotoModel:photoModel onScrollView:self.collectionView scrollOnView:self.view];
    } else {
        ;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *result = nil;
    do {
        DCHCategoryModel *model = [self.viewModel.models objectForKey:[DCHCategoryModel categories][indexPath.section]];
        if ([kind isEqualToString:CSStickyHeaderParallaxHeader] || [kind isEqualToString:UICollectionElementKindSectionHeader]) {
            DCHCategoryCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[DCHCategoryCollectionHeaderView viewlIdentifier] forIndexPath:indexPath];
            [headerView refreshWithCategoryModel:model];
            result = headerView;
        } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
            DCHCategoryCollectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[DCHCategoryCollectionFooterView viewlIdentifier] forIndexPath:indexPath];
            [footerView refreshWithCategoryModel:model];
            result = footerView;
        } else {
            NSAssert(0, @"Not allowed!");
        }
    } while (NO);
    return result;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    do {
        if (collectionView != self.collectionView || !indexPath) {
            break;
        }
        DCHCategoryModel *model = [self.viewModel.models objectForKey:[DCHCategoryModel categories][indexPath.section]];
        if (model) {
            DCHFullSizeViewModel *fullSizeVM = [[DCHFullSizeViewModel alloc] initWithPhotoArray:model.models initialPhotoIndex:indexPath.item];
            DCHFullSizeViewController *fullSizeVC = [[DCHFullSizeViewController alloc] initWithViewModel:fullSizeVM];
            [self.navigationController pushViewController:fullSizeVC animated:YES];
        }
        
    } while (NO);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    do {
        NSArray *cells = [self.collectionView visibleCells];
        for (DCHImageCollectionViewCell *cell in cells) {
            [cell parallaxViewOnScrollView:self.collectionView didScrollOnView:self.view];
        }
    } while (NO);
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
#pragma mark - DCHEventResponder
- (BOOL)respondEvent:(id <DCHEvent>)event from:(id)source withCompletionHandler:(DCHEventResponderCompletionHandler)completionHandler {
    BOOL result = NO;
    do {
        if (event == nil) {
            break;
        }
        
        if ([[event domain] isEqualToString:DCHDisplayEventDomain]) {
            switch ([event code]) {
                case DCDisplayEventCode_RefreshPhotoCategory:
                {
                    @weakify(self);
                    PXPhotoModelCategory category = PXPhotoModelCategoryUncategorized;
                    NSDictionary *payloadDic = (NSDictionary *)[event payload];
                    category = [payloadDic[DCDisplayEventCode_RefreshPhotoCategory_kCategory] integerValue];
                    [NSThread runInMain:^{
                        @strongify(self);
                        DCHCategoryModel *model = [self.viewModel.models objectForKey:@(category)];
                        if (model) {
                            [self.collectionView reloadData];
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

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CGSize result = CGSizeZero;
//    do {
//        if (collectionView != self.collectionView || ![collectionViewLayout isKindOfClass:[CHTCollectionViewWaterfallLayout class]]) {
//            break;
//        }
//        DCHCategoryModel *model = [self.viewModel.models objectForKey:[DCHCategoryModel categories][indexPath.section]];
//        if (model) {
//            DCHPhotoModel *photoModel = nil;
//            DCHArraySafeRead(model.models, indexPath.item, photoModel);
//            if (photoModel) {
//                CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)collectionViewLayout;
//                NSUInteger width = ([UIScreen mainScreen].bounds.size.width - layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right) / 2.0f;
//                NSUInteger height = width * [photoModel.height longValue] / [photoModel.width longValue];
//                result = CGSizeMake(width, height);
//            }
//        } else {
//            ;
//        }
//        
//    } while (NO);
//    return result;
//}

@end
