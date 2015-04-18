//
//  DCHGalleryCollectionViewCell.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 4/8/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHGalleryCollectionViewCell.h"
#import "DCHPhotoModel.h"
#import <Tourbillon/DCHTourbillon.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface DCHGalleryCollectionViewCell ()

@property (nonatomic, strong) DCHPhotoModel *photoModel;
@property (nonatomic, strong) UIImageView *imageView;

- (CGFloat)calcParallaxOriginXOnScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view;
- (CGFloat)calcParallaxOriginYOnScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view;

@end

@implementation DCHGalleryCollectionViewCell

- (void)dealloc {
    do {
        [self.imageView removeFromSuperview];
        self.imageView = nil;
        self.photoModel = nil;
    } while (NO);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    // Configure self
    self.backgroundColor = [UIColor darkGrayColor];
    
    // Configure subivews
    CGRect imageFrame = self.bounds;
    
    NSInteger deltaX = imageFrame.size.width / 4;
    imageFrame.origin.x -= deltaX;
    imageFrame.size.width += deltaX * 2;
    
    NSInteger deltaY = imageFrame.size.height / 4;
    imageFrame.origin.y -= deltaY;
    imageFrame.size.height += deltaY * 2;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    imageView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    self.contentView.clipsToBounds = YES;
    
    return self;
}

- (void)refreshWithPhotoModel:(DCHPhotoModel *)photoModel onScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view {
    do {
        if (!photoModel || !scrollView || !view) {
            break;
        }
        self.photoModel = photoModel;
        
        CGRect imageRect = self.imageView.frame;
        imageRect.origin.x = [self calcParallaxOriginXOnScrollView:scrollView scrollOnView:view];
        imageRect.origin.y = [self calcParallaxOriginYOnScrollView:scrollView scrollOnView:view];
        self.imageView.frame = imageRect;
        
        if (self.photoModel.thumbnailData) {
            self.imageView.image = [UIImage imageWithData:self.photoModel.thumbnailData];
        } else {
            self.imageView.image = nil;
            if (self.photoModel.thumbnailURL) {
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.photoModel.thumbnailURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    do {
                        self.photoModel.thumbnailData = UIImageJPEGRepresentation(image, 0.6);
                    } while (NO);
                }];
            }
        }
    } while (NO);
}

// https://github.com/jberlana/JBParallaxCell
- (void)cellOnScrollView:(UIScrollView *)scrollView didScrollOnView:(UIView *)view {
    do {
        if (!scrollView || !view) {
            break;
        }
        CGRect imageRect = self.imageView.frame;
        if (DCHFloatingNumberEqualToZero(scrollView.frame.size.height + scrollView.contentOffset.y - scrollView.contentSize.height)) {
            imageRect.origin.x = [self calcParallaxOriginXOnScrollView:scrollView scrollOnView:view];
        }
        
        if (DCHFloatingNumberEqualToZero(scrollView.frame.size.width + scrollView.contentOffset.x - scrollView.contentSize.width)) {
            imageRect.origin.y = [self calcParallaxOriginYOnScrollView:scrollView scrollOnView:view];
        }
        self.imageView.frame = imageRect;
    } while (NO);
}

#pragma mark - Private
- (CGFloat)calcParallaxOriginXOnScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view {
    CGFloat result = 0.0f;
    do {
        if (!scrollView || !view) {
            break;
        }
        CGRect rectInSuperview = [scrollView convertRect:self.frame toView:view];
        float distanceFromCenter = CGRectGetWidth(view.frame) / 2 - CGRectGetMinX(rectInSuperview);
        float difference = CGRectGetWidth(self.imageView.frame) - CGRectGetWidth(self.frame);
        float move = (distanceFromCenter / CGRectGetWidth(view.frame)) * difference;
        
        result = (- (difference / 2) + move);
    } while (NO);
    return result;
}

- (CGFloat)calcParallaxOriginYOnScrollView:(UIScrollView *)scrollView scrollOnView:(UIView *)view {
    CGFloat result = 0.0f;
    do {
        if (!scrollView || !view) {
            break;
        }
        CGRect rectInSuperview = [scrollView convertRect:self.frame toView:view];
        float distanceFromCenter = CGRectGetHeight(view.frame) / 2 - CGRectGetMinY(rectInSuperview);
        float difference = CGRectGetHeight(self.imageView.frame) - CGRectGetHeight(self.frame);
        float move = (distanceFromCenter / CGRectGetHeight(view.frame)) * difference;
        
        result = (- (difference / 2) + move);
    } while (NO);
    return result;
}

@end
