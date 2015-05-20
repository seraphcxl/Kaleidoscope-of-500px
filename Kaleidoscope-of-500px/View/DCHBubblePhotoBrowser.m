//
//  DCHBubblePhotoBrowser.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHBubblePhotoBrowser.h"
#import <Tourbillon/DCHTourbillon.h>
#import <libextobjc/EXTScope.h>
#import "DCHBubblePhotoBrowserViewModel.h"
#import "DCHImageCollectionViewCell.h"
#import "DCHPhotoModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

const NSUInteger kDCHBubblePhotoBrowser_ThumbnailSize = 96;

@interface DCHBubblePhotoBrowser () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) DCHBubblePhotoBrowserViewModel *viewModel;

@property (nonatomic, strong) UICollectionView *thumbnailCollectionView;
@property (nonatomic, strong) UIImageView *bigImageView;
@property (nonatomic, assign) NSUInteger initialPhotoIndex;

@end

@implementation DCHBubblePhotoBrowser

- (void)dealloc {
    do {
        [self.bigImageView removeFromSuperview];
        self.bigImageView = nil;
        
        self.thumbnailCollectionView.dataSource = nil;
        self.thumbnailCollectionView.delegate = nil;
        [self.thumbnailCollectionView removeFromSuperview];
        self.thumbnailCollectionView = nil;
    } while (NO);
}

- (instancetype)initWithViewModel:(DCHBubblePhotoBrowserViewModel *)viewModel andInitialPhotoIndex:(NSUInteger)index {
    if (!viewModel) {
        return nil;
    }
    self = [self init];
    if (self) {
        self.viewModel = viewModel;
        self.initialPhotoIndex = index;
    }
    return self;
}

- (void)viewDidLoad {
    do {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 8.0f;
        layout.sectionInset = UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f);
        layout.itemSize = CGSizeMake(kDCHBubblePhotoBrowser_ThumbnailSize, kDCHBubblePhotoBrowser_ThumbnailSize);
        self.thumbnailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.thumbnailCollectionView registerNib:[UINib nibWithNibName:[DCHImageCollectionViewCell cellIdentifier] bundle:nil] forCellWithReuseIdentifier:[DCHImageCollectionViewCell cellIdentifier]];
        self.thumbnailCollectionView.delegate = self;
        self.thumbnailCollectionView.dataSource = self;
        [self.thumbnailCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.initialPhotoIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self.view addSubview:self.thumbnailCollectionView];
        
        DCHPhotoModel *photoModel = nil;
        DCHArraySafeRead(self.viewModel.models, self.initialPhotoIndex, photoModel);
        self.bigImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.bigImageView.clipsToBounds = YES;
        self.bigImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.bigImageView sd_cancelCurrentImageLoad];
        if (photoModel) {
            [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.fullsizedURL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                do {
                    ;
                } while (NO);
            }];
        }
        [self.view addSubview:self.bigImageView];
    } while (NO);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    do {
        self.viewModel.eventResponder = self;
        
        self.view.backgroundColor = [UIColor tungstenColor];
        
        CGRect bounds = self.view.bounds;
        
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.thumbnailCollectionView.collectionViewLayout;
        CGFloat thumbnailCollectionViewWidth = bounds.size.width;
        CGFloat thumbnailCollectionViewHeight = kDCHBubblePhotoBrowser_ThumbnailSize + layout.sectionInset.top + layout.sectionInset.bottom;
        self.thumbnailCollectionView.frame = CGRectMake(0.0f, bounds.size.height - thumbnailCollectionViewHeight, thumbnailCollectionViewWidth, thumbnailCollectionViewHeight);
        self.thumbnailCollectionView.backgroundColor = [UIColor aquaColor];
        
        self.bigImageView.frame = CGRectMake(0.0f, 0.0f, bounds.size.width, bounds.size.height - thumbnailCollectionViewHeight);
        self.bigImageView.backgroundColor = [UIColor salmonColor];
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

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DCHImageCollectionViewCell *result = [self.thumbnailCollectionView dequeueReusableCellWithReuseIdentifier:[DCHImageCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    
    [self.viewModel calcCellSizeForCollectionLayout:self.thumbnailCollectionView.collectionViewLayout andIndexPath:indexPath];
    
    DCHPhotoModel *photoModel = nil;
    DCHArraySafeRead(self.viewModel.models, indexPath.row, photoModel);
    [result refreshWithPhotoModel:photoModel];
    
    return result;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    do {
        [self.thumbnailCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        DCHPhotoModel *photoModel = nil;
        DCHArraySafeRead(self.viewModel.models, indexPath.row, photoModel);
        [self.bigImageView sd_cancelCurrentImageLoad];
        if (photoModel) {
            [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.fullsizedURL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                do {
                    ;
                } while (NO);
            }];
        }
    } while (NO);
}

@end
