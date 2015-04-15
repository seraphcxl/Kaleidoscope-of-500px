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
    
    self.title = @"Popular on 500px";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshGallery)];
    
    // Register cell classes
    [self.collectionView registerClass:[DCHGalleryCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    do {
        DCHDisplayEvent *refreshPopularPhotosEvent = [DCHDisplayEventCreater createDisplayEventByCode:DCDisplayEventCode_RefreshPopularPhotos andPayload:nil];
        
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] addEventResponder:self.viewModel forEvent:refreshPopularPhotosEvent];
        self.viewModel.eventResponder = self;
    } while (NO);
}

- (void)viewDidAppear:(BOOL)animated {
    do {
        [self refreshGallery];
    } while (NO);
}

- (void)viewWillDisappear:(BOOL)animated {
    do {
        ;
    } while (NO);
}

- (void)viewDidDisappear:(BOOL)animated {
    do {
        self.viewModel.eventResponder = nil;
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] removeEventResponder:self.viewModel];
    } while (NO);
}

- (void)refreshGallery {
    do {
        DCH500pxEvent *queryPopularPhotosEvent = [DCH500pxEventCreater create500pxEventByCode:DC500pxEventCode_QueryPopularPhotos andPayload:nil];
        [[DCH500pxDispatcher sharedDCH500pxDispatcher] handleEvent:queryPopularPhotosEvent inMainThread:NO withResponderCallback:^(id eventResponder, id<DCHEvent> outputEvent, NSError *error) {
            do {
                NSLog(@"queryPopularPhotosEvent complte in %@", NSStringFromSelector(_cmd));
            } while (NO);
        }];
    } while (NO);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                case DCDisplayEventCode_RefreshPopularPhotos:
                {
                    [NSThread runInMain:^{
                        [self.collectionView reloadData];
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
    NSLog(@"CollectionView count: %lu", (unsigned long)self.viewModel.model.count);
    return self.viewModel.model.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DCHGalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.photoModel = self.viewModel.model[indexPath.row];
    [cell refresh];
    
    return cell;
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

@end
