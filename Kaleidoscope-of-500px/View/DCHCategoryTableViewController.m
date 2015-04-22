//
//  DCHCategoryTableViewController.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHCategoryTableViewController.h"
#import "DCHCategoryViewModel.h"
#import "DCHCategoryTableViewCell.h"
#import "DCH500pxEventCreater.h"
#import "DCH500pxEvent.h"
#import "DCH500pxDispatcher.h"
#import "DCHDisplayEventCreater.h"
#import "DCHDisplayEvent.h"
#import "DCH500pxPhotoStore.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <libextobjc/EXTScope.h>

@interface DCHCategoryTableViewController ()

@property (nonatomic, strong) DCHCategoryViewModel *viewModel;
@property (nonatomic, strong) NSArray *categories;

- (void)refreshCategories;

@end

@implementation DCHCategoryTableViewController

static NSString * const reuseIdentifier = @"DCHCategoryTableViewCell";

- (void)dealloc {
    do {
        [[DCH500pxPhotoStore sharedDCH500pxPhotoStore] removeEventResponder:self.viewModel];
        self.viewModel = nil;
    } while (NO);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.categories = @[@(PXPhotoModelCategoryUncategorized), @(PXPhotoModelCategoryAbstract), @(PXPhotoModelCategoryAnimals), @(PXPhotoModelCategoryBlackAndWhite), @(PXPhotoModelCategoryCelbrities), @(PXPhotoModelCategoryCityAndArchitecture), @(PXPhotoModelCategoryCommercial), @(PXPhotoModelCategoryConcert), @(PXPhotoModelCategoryFamily), @(PXPhotoModelCategoryFashion), @(PXPhotoModelCategoryFilm), @(PXPhotoModelCategoryFineArt), @(PXPhotoModelCategoryFood), @(PXPhotoModelCategoryJournalism), @(PXPhotoModelCategoryLandscapes), @(PXPhotoModelCategoryMacro), @(PXPhotoModelCategoryNature), @(PXPhotoModelCategoryNude), @(PXPhotoModelCategoryPeople), @(PXPhotoModelCategoryPerformingArts), @(PXPhotoModelCategorySport), @(PXPhotoModelCategoryStillLife), @(PXPhotoModelCategoryStreet), @(PXPhotoModelCategoryTransportation), @(PXPhotoModelCategoryTravel), @(PXPhotoModelCategoryUnderwater), @(PXPhotoModelCategoryUrbanExploration), @(PXPhotoModelCategoryWedding)];
    self.viewModel = [[DCHCategoryViewModel alloc] init];
    
    self.tabBarController.navigationItem.title = @"500px Categories";
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshCategories)];
    
    // Register cell classes
    [self.tableView registerClass:[DCHCategoryTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.backgroundColor = [UIColor ironColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark -Private
- (void)refreshCategories {
    do {
        ;
    } while (NO);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCHCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
