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
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>

@interface DCHCategoryCollectionViewController () <CHTCollectionViewDelegateWaterfallLayout>

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
    
    self.tabBarController.navigationItem.title = @"500px Categories";
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:[DCHImageCollectionViewCell cellIdentifier] bundle:nil] forCellWithReuseIdentifier:[DCHImageCollectionViewCell cellIdentifier]];
    [self.collectionView registerNib:[UINib nibWithNibName:[DCHCategoryCollectionHeaderView viewlIdentifier] bundle:nil] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:[DCHCategoryCollectionHeaderView viewlIdentifier]];
    [self.collectionView registerNib:[UINib nibWithNibName:[DCHCategoryCollectionFooterView viewlIdentifier] bundle:nil] forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter withReuseIdentifier:[DCHCategoryCollectionFooterView viewlIdentifier]];
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor ironColor];
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.columnCount = 2;
    layout.minimumColumnSpacing = 4;
    layout.minimumInteritemSpacing = 4;
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, 8.0f);
//    layout.minimumContentHeight = 96;
    layout.headerHeight = 32;
    layout.footerHeight = 16;
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
        [cell refreshWithPhotoModel:photoModel];
    } else {
        ;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *result = nil;
    do {
        DCHCategoryModel *model = [self.viewModel.models objectForKey:[DCHCategoryModel categories][indexPath.section]];
        if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
            DCHCategoryCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[DCHCategoryCollectionHeaderView viewlIdentifier] forIndexPath:indexPath];
            [headerView refreshWithCategoryModel:model];
            result = headerView;
        } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize result = CGSizeZero;
    do {
        if (collectionView != self.collectionView || ![collectionViewLayout isKindOfClass:[CHTCollectionViewWaterfallLayout class]]) {
            break;
        }
        DCHCategoryModel *model = [self.viewModel.models objectForKey:[DCHCategoryModel categories][indexPath.section]];
        if (model) {
            DCHPhotoModel *photoModel = nil;
            DCHArraySafeRead(model.models, indexPath.item, photoModel);
            if (photoModel) {
                CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)collectionViewLayout;
                NSUInteger width = ([UIScreen mainScreen].bounds.size.width - layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right) / 2.0f;
                NSUInteger height = width * [photoModel.height longValue] / [photoModel.width longValue];
                result = CGSizeMake(width, height);
            }
        } else {
            ;
        }
        
    } while (NO);
    return result;
}

@end
