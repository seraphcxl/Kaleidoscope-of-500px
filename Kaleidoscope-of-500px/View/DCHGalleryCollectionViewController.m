//
//  DCHGalleryCollectionViewController.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHGalleryCollectionViewController.h"
#import "DCHGalleryCollectionViewModel.h"
#import "DCHGalleryCollectionViewCell.h"
#import "DCH500pxEventCreater.h"
#import "DCH500pxEvent.h"
#import "DCH500pxDispatcher.h"
#import "DCHDisplayEventCreater.h"
#import "DCHDisplayEvent.h"
#import "DCH500pxPhotoStore.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <libextobjc/EXTScope.h>
#import "DCHFullSizeViewModel.h"
#import "DCHFullSizeViewController.h"

const NSUInteger DCHGalleryCollectionViewController_kCountInLine = 2;

@interface DCHGalleryCollectionViewController ()

@property (nonatomic, strong) DCHGalleryCollectionViewModel *viewModel;

- (void)refreshGallery;

@end

@implementation DCHGalleryCollectionViewController

static NSString * const reuseIdentifier = @"DCHGalleryCollectionViewCell";

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
    
    self.tabBarController.navigationItem.title = @"500px Gallery";
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshGallery)];
    
    // Register cell classes
    [self.collectionView registerClass:[DCHGalleryCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor ironColor];
    
    if ([self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
        NSUInteger imgSize = ((NSUInteger)(self.collectionView.bounds.size.width - layout.minimumInteritemSpacing * (DCHGalleryCollectionViewController_kCountInLine - 1) - layout.sectionInset.left - layout.sectionInset.right)) / DCHGalleryCollectionViewController_kCountInLine / 4 * 4;
        layout.itemSize = CGSizeMake(imgSize, imgSize);
    }
    
    // Do any additional setup after loading the view.
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
        [self.viewModel refreshGallery:PXAPIHelperPhotoFeaturePopular];
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
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
    DCHGalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    [cell refreshWithPhotoModel:self.viewModel.models[indexPath.row] onScrollView:self.collectionView scrollOnView:self.view];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    do {
        if (collectionView != self.collectionView || !indexPath) {
            break;
        }
        DCHFullSizeViewModel *fullSizeVM = [[DCHFullSizeViewModel alloc] initWithPhotoArray:self.viewModel.models initialPhotoIndex:indexPath.item];
        DCHFullSizeViewController *fullSizeVC = [[DCHFullSizeViewController alloc] initWithViewModel:fullSizeVM];
        [self.navigationController pushViewController:fullSizeVC animated:YES];
    } while (NO);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    do {
        NSArray *cells = [self.collectionView visibleCells];
        for (DCHGalleryCollectionViewCell *cell in cells) {
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

@end
