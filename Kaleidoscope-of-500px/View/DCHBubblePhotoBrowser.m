//
//  DCHBubblePhotoBrowser.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/20/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHBubblePhotoBrowser.h"
#import "DCHLinearGradientView.h"
#import <Shimmer/FBShimmeringView.h>
#import <Tourbillon/DCHTourbillon.h>
#import <libextobjc/EXTScope.h>
#import "DCHBubblePhotoBrowserViewModel.h"
#import "DCHImageCollectionViewCell.h"
#import "DCHPhotoModel.h"
#import <DCHImageTurbo/DCHImageTurbo.h>
#import "UIImage+DCHColorArt.h"
#import "DCHBubbleImageView.h"

const NSUInteger kDCHBubblePhotoBrowser_ThumbnailSize = 96;

@interface DCHBubblePhotoBrowser () <UICollectionViewDelegate, UICollectionViewDataSource, DCHBubbleImageViewTapDelegate, DCHBubbleImageViewSwipeDelegate>

@property (nonatomic, strong) DCHBubblePhotoBrowserViewModel *viewModel;
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
@property (nonatomic, copy) NSString *photoBrowserTitle;
@property (nonatomic, strong) UILabel *loadingLabel;

@property (nonatomic, assign) BOOL singleImageView;
@property (nonatomic, assign) BOOL loadingImage;

- (void)titleButtonClick:(id)sender;
- (void)loadingImage:(DCHPhotoModel *)photoModel;

- (void)showSingleImageView:(BOOL)show;

@end

@interface DCHBubblePhotoBrowser ()

@end

@implementation DCHBubblePhotoBrowser

- (void)dealloc {
    do {
        self.viewModel = nil;
    } while (NO);
}

- (instancetype)initWithViewModel:(DCHBubblePhotoBrowserViewModel *)viewModel currentPhotoIndex:(NSUInteger)index andTitle:(NSString *)title {
    if (!viewModel || DCH_IsEmpty(title)) {
        return nil;
    }
    self = [self init];
    if (self) {
        self.viewModel = viewModel;
        self.currentPhotoIndex = index;
        self.photoBrowserTitle = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.thumbnailCollectionView registerNib:[UINib nibWithNibName:[DCHImageCollectionViewCell cellIdentifier] bundle:nil] forCellWithReuseIdentifier:[DCHImageCollectionViewCell cellIdentifier]];
    self.thumbnailCollectionView.delegate = self;
    self.thumbnailCollectionView.dataSource = self;
    self.thumbnailCollectionView.allowsMultipleSelection = NO;
    self.thumbnailCollectionView.scrollsToTop = NO;
    
    self.titleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.titleButton setTitle:self.photoBrowserTitle forState:UIControlStateNormal];
    [self.titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.gradientView.gradientSize = 1.0f;
    
    self.shimmeringView.shimmering = NO;
    self.shimmeringView.shimmeringBeginFadeDuration = 0.2;
    self.shimmeringView.shimmeringOpacity = 0.8;
    self.shimmeringView.shimmeringSpeed = 300;
    
    self.loadingLabel = [[UILabel alloc] initWithFrame:self.shimmeringView.frame];
    self.loadingLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:24.0f];
    self.loadingLabel.textColor = [UIColor whiteColor];
    self.loadingLabel.textAlignment = NSTextAlignmentLeft;
    self.loadingLabel.backgroundColor = [UIColor clearColor];
    self.shimmeringView.contentView = self.loadingLabel;
    
    DCHPhotoModel *photoModel = nil;
    DCHArraySafeRead(self.viewModel.models, self.currentPhotoIndex, photoModel);
    self.bigImageView.clipsToBounds = YES;
    self.bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bigImageView.tapDelegate = self;
    self.bigImageView.swipeDelegate = self;
    
    [self loadingImage:photoModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    do {
        self.viewModel.eventResponder = self;
        
        self.view.backgroundColor = [UIColor tungstenColor];
        self.thumbnailCollectionView.backgroundColor = [UIColor tungstenColor];
        self.bigImageView.backgroundColor = [UIColor tungstenColor];
        
        [self.thumbnailCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPhotoIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    } while (NO);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    do {
        [self.thumbnailCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPhotoIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
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

- (void)titleButtonClick:(id)sender {
    do {
        [self dismissViewControllerAnimated:YES completion:^{
            do {
                ;
            } while (NO);
        }];
    } while (NO);
}

- (void)loadingImage:(DCHPhotoModel *)photoModel {
    do {
        if (!photoModel) {
            break;
        }
        
        [self.bigImageView dch_cancelCurrentWebImageLoadOperation];
        self.loadingLabel.text = photoModel.photoName;
        
        if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:photoModel.fullsizedURL]]) {
            ;
        } else {
            self.loadingLabel.textColor = [UIColor aquaColor];
            self.shimmeringView.shimmering = YES;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            do {
                self.bigImageView.alpha = 0.2f;
//                [self.bigImageView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5)];
            } while (NO);
        } completion:^(BOOL finished) {
            do {
                if (!self.singleImageView) {
                    self.gradientView.hidden = YES;
                }
                
                if (photoModel) {
                    @weakify(self);
                    self.loadingImage = YES;
                    [self.bigImageView dch_setImageWithURL:[NSURL URLWithString:photoModel.fullsizedURL] placeholderImage:nil completed:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL, SDImageCacheType cacheType) {
                        @strongify(self);
                        do {
                            self.loadingImage = NO;
                            [NSThread dch_runInMain:^{
                                @strongify(self);
                                
                                self.shimmeringView.shimmering = NO;
                                self.loadingLabel.textColor = [UIColor whiteColor];
                                if (!self.singleImageView) {
                                    self.gradientView.hidden = NO;
                                }
                                [UIView animateWithDuration:0.25 animations:^{
                                    do {
//                                        [self.bigImageView setTransform:CGAffineTransformIdentity];
                                        self.bigImageView.alpha = 1.0f;
                                    } while (NO);
                                } completion:^(BOOL finished) {
                                    do {
                                        ;
                                    } while (NO);
                                }];
                            }];
                        } while (NO);
                    }];
                }
            } while (NO);
        }];
    } while (NO);
}

- (void)showSingleImageView:(BOOL)show {
    do {
        if (self.loadingImage) {
            break;
        }
        self.singleImageView = show;
        if (show) {
            self.gradientView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                do {
                    CGRect thumbnailFrame = self.thumbnailCollectionView.frame;
                    
                    self.bigImageView.frame = self.view.bounds;
                    self.bigImageView.contentMode = UIViewContentModeScaleAspectFit;
                    
                    CGRect loadingFrame = self.loadingLabel.frame;
                    loadingFrame.origin.y += thumbnailFrame.size.height;
                    self.loadingLabel.frame = loadingFrame;
                    
                    thumbnailFrame.origin.y = self.view.bounds.size.height;
                    self.thumbnailCollectionView.frame = thumbnailFrame;
                    self.thumbnailCollectionView.alpha = 0.0f;
                } while (NO);
            } completion:^(BOOL finished) {
                do {
                    self.thumbnailCollectionView.hidden = YES;
                } while (NO);
            }];
        } else {
            self.thumbnailCollectionView.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                do {
                    CGRect bigImgFrame = self.bigImageView.frame;
                    CGRect thumbnailFrame = self.thumbnailCollectionView.frame;
                    
                    bigImgFrame.size.height -= thumbnailFrame.size.height;
                    self.bigImageView.frame = bigImgFrame;
                    self.bigImageView.contentMode = UIViewContentModeScaleAspectFill;
                    
                    CGRect loadingFrame = self.loadingLabel.frame;
                    loadingFrame.origin.y -= thumbnailFrame.size.height;
                    self.loadingLabel.frame = loadingFrame;
                    
                    thumbnailFrame.origin.y = self.view.bounds.size.height - thumbnailFrame.size.height;
                    self.thumbnailCollectionView.frame = thumbnailFrame;
                    self.thumbnailCollectionView.alpha = 1.0f;
                } while (NO);
            } completion:^(BOOL finished) {
                do {
                    self.gradientView.hidden = NO;
                } while (NO);
            }];
        }
    } while (NO);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DCHImageCollectionViewCell *result = [self.thumbnailCollectionView dequeueReusableCellWithReuseIdentifier:[DCHImageCollectionViewCell cellIdentifier] forIndexPath:indexPath];
    
    [self.viewModel calcCellSizeForCollectionLayout:self.thumbnailCollectionView.collectionViewLayout andIndexPath:indexPath];
    
    DCHPhotoModel *photoModel = nil;
    DCHArraySafeRead(self.viewModel.models, indexPath.row, photoModel);
    [result refreshWithPhotoModel:photoModel imageSize:photoModel.uiBubbleThumbnailDisplaySize];
    
    return result;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    do {
        [self.thumbnailCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        self.currentPhotoIndex = indexPath.item;
        DCHPhotoModel *photoModel = nil;
        DCHArraySafeRead(self.viewModel.models, indexPath.row, photoModel);
        [self loadingImage:photoModel];
    } while (NO);
}

#pragma mark - DCHBubbleImageViewTapDelegate
- (void)view:(UIView *)view tapDetected:(UITouch *)touch {
    do {
        if (!view || !touch) {
            break;
        }
        NSUInteger tapCount = touch.tapCount;
        switch (tapCount) {
            case 1:
            {
                [self showSingleImageView:!self.thumbnailCollectionView.hidden];
            }
                break;
                
            default:
                break;
        }
    } while (NO);
}

#pragma mark - DCHBubbleImageViewSwipeDelegate
- (void)view:(UIView *)view swipeDetected:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
    do {
        if (!view || !swipeGestureRecognizer) {
            break;
        }
        if (self.singleImageView) {
            break;
        }
        NSArray *selectedItems = [self.thumbnailCollectionView indexPathsForSelectedItems];
        if (selectedItems.count == 0) {
            break;
        }
        NSInteger numberOfItems = [self.thumbnailCollectionView numberOfItemsInSection:0];
        NSIndexPath *selectedIndexPath = [selectedItems dch_safe_objectAtIndex:0];
        NSIndexPath *newSelectedIndexPath = nil;
        switch (swipeGestureRecognizer.direction) {
            case UISwipeGestureRecognizerDirectionLeft:
            {
                if (selectedIndexPath.item < numberOfItems - 1) {
                    newSelectedIndexPath = [NSIndexPath indexPathForItem:(selectedIndexPath.item + 1) inSection:selectedIndexPath.section];
                }
            }
                break;
            case UISwipeGestureRecognizerDirectionRight:
            {
                if (selectedIndexPath.item > 0) {
                    newSelectedIndexPath = [NSIndexPath indexPathForItem:(selectedIndexPath.item - 1) inSection:selectedIndexPath.section];
                }
            }
                break;
                
            default:
                break;
        }
        if (newSelectedIndexPath) {
            [self.thumbnailCollectionView selectItemAtIndexPath:newSelectedIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            DCHPhotoModel *photoModel = nil;
            DCHArraySafeRead(self.viewModel.models, newSelectedIndexPath.item, photoModel);
            [self loadingImage:photoModel];
        }
    } while (NO);
}
@end
