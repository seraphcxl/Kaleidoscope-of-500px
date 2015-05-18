//
//  DCHStickyHeaderWaterfallLayout.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/16/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHStickyHeaderWaterfallLayout.h"

@implementation DCHStickyHeaderWaterfallLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *result = [super layoutAttributesForElementsInRect:rect];
    do {
        NSMutableArray *allItems = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
        NSMutableDictionary *lastCells = [[NSMutableDictionary alloc] init];
        
        [allItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UICollectionViewLayoutAttributes *attributes = obj;
            
            if ([[obj representedElementKind] isEqualToString:UICollectionElementKindSectionHeader]) {
            } else if ([[obj representedElementKind] isEqualToString:UICollectionElementKindSectionFooter]) {
                // Not implemeneted
            } else {
                NSIndexPath *indexPath = [(UICollectionViewLayoutAttributes *)obj indexPath];
                
                UICollectionViewLayoutAttributes *currentAttribute = [lastCells objectForKey:@(indexPath.section)];
                
                // Get the bottom most cell of that section
                if ( ! currentAttribute || indexPath.row > currentAttribute.indexPath.row) {
                    [lastCells setObject:obj forKey:@(indexPath.section)];
                }
            }
            
            // For iOS 7.0, the cell zIndex should be above sticky section header
            attributes.zIndex = 1;
        }];
        
        if ( ! self.disableStickyHeaders) {
            [lastCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSIndexPath *indexPath = [obj indexPath];
                NSNumber *indexPathKey = @(indexPath.section);
                
                UICollectionViewLayoutAttributes *header = [self layoutAttributesForSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader atIndexPath:indexPath];
                // CollectionView automatically removes headers not in bounds
//                if (!header) {
//                    header = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                                                                  atIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]];
//                    
//                    if (header) {
//                        [allItems addObject:header];
//                    }
//                }
                if (header) {
                    [self updateHeaderAttributes:header lastCellAttributes:lastCells[indexPathKey]];
                }
            }];
        }
    } while (NO);
    return result;
}

- (void)updateHeaderAttributes:(UICollectionViewLayoutAttributes *)attributes lastCellAttributes:(UICollectionViewLayoutAttributes *)lastCellAttributes {
    CGRect currentBounds = self.collectionView.bounds;
    attributes.zIndex = 1024;
    attributes.hidden = NO;
    
    CGPoint origin = attributes.frame.origin;
    
    CGFloat sectionMaxY = CGRectGetMaxY(lastCellAttributes.frame) - attributes.frame.size.height;
    CGFloat y = CGRectGetMaxY(currentBounds) - currentBounds.size.height + self.collectionView.contentInset.top;
    
    CGFloat maxY = MIN(MAX(y, attributes.frame.origin.y), sectionMaxY);
    
    //    NSLog(@"%.2f, %.2f, %.2f", y, maxY, sectionMaxY);
    
    origin.y = maxY;
    
    attributes.frame = (CGRect){
        origin,
        attributes.frame.size
    };
}

@end
