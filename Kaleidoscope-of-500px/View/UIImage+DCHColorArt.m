//
//  UIImage+DCHColorArt.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/18/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "UIImage+DCHColorArt.h"
#import <Tourbillon/DCHTourbillon.h>
#import <RXCollections/RXCollection.h>

@implementation UIImage (DCHColorArt)

- (UIColor *)findMajorColorWithAlphaEnable:(BOOL)alphaEnable {
    return [self findEdgeColorWithType:DCHColorArt_EdgeType_Top countOfLine:self.size.height alphaEnable:alphaEnable];
}

- (UIColor *)findEdgeColorWithType:(DCHColorArt_EdgeType)type countOfLine:(NSUInteger)countOfLine alphaEnable:(BOOL)alphaEnable {
    UIColor *result = nil;
    CFDataRef rawData = nil;
    do {
        if (countOfLine == 0) {
            break;
        }
        CGFloat width = CGImageGetWidth(self.CGImage);
        CGFloat height = CGImageGetHeight(self.CGImage);
        CGRect cropRect = CGRectZero;
        CGFloat pixels = countOfLine;
        switch (type) {
            case DCHColorArt_EdgeType_Top:
            {
                cropRect = CGRectMake(0.0f, 0.0f, width, countOfLine);
                pixels *= width;
            }
                break;
            case DCHColorArt_EdgeType_Bottom:
            {
                cropRect = CGRectMake(0.0f, height - countOfLine, width, countOfLine);
                pixels *= width;
            }
                break;
            case DCHColorArt_EdgeType_Left:
            {
                cropRect = CGRectMake(0.0f, 0.0f, countOfLine, height);
                pixels *= height;
            }
                break;
            case DCHColorArt_EdgeType_Right:
            {
                cropRect = CGRectMake(width - countOfLine, 0.0f, countOfLine, height);
                pixels *= height;
            }
                break;
            default:
                break;
        }
        if (CGRectIsEmpty(cropRect)) {
            break;
        }
        rawData = CGDataProviderCopyData(CGImageGetDataProvider(CGImageCreateWithImageInRect(self.CGImage, cropRect)));
        UInt8 * buf = (UInt8 *) CFDataGetBytePtr(rawData);
        NSUInteger length = CFDataGetLength(rawData);
        
        NSCountedSet *colorSet = [[NSCountedSet alloc] init];
        for(NSUInteger idx = 0; idx < length; idx += 4) {
            int r = buf[idx];
            int g = buf[idx + 1];
            int b = buf[idx + 2];
            int a = buf[idx + 3];
            if (!alphaEnable) {
                a = 255;
            }
            UIColor *clr = [UIColor colorWithRed:DCHRGBAConvert256ToPercentage(r) green:DCHRGBAConvert256ToPercentage(g) blue:DCHRGBAConvert256ToPercentage(b) alpha:DCHRGBAConvert256ToPercentage(a)];
            [colorSet addObject:clr];
        }
        
        NSCountedSet *selectedColorSet = [colorSet rx_filterWithBlock:^BOOL(id each) {
            return [colorSet countForObject:each] > pixels * 0.01f;
        }];
        
        NSArray *selectedColorSortedAry = [selectedColorSet.allObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSUInteger obj1Count = [colorSet countForObject:obj1];
            NSUInteger obj2Count = [colorSet countForObject:obj2];
            if (obj1Count > obj2Count) {
                return NSOrderedAscending;
            } else if (obj1Count < obj2Count) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }];
        
        NSMutableDictionary *colorDic = [NSMutableDictionary dictionary];
        [selectedColorSortedAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            do {
                UIColor *currentClr = (UIColor *)obj;
                NSArray *colorAry = [colorDic allKeys];
                __block BOOL needInsert = YES;
                if (colorAry.count == 0) {
                    ;
                } else {
                    
                    [colorAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        do {
                            UIColor *otherClr = (UIColor *)obj;
                            if ([currentClr isEqualTo:otherClr bySingleVectorDiff:(2.0f / 255.0f) andTotleDiff:(4.0f / 255.0f)]) {
                                NSNumber *num = [colorDic DCH_safe_objectForKey:otherClr];
                                [colorDic DCH_safe_setObject:@([num unsignedIntegerValue] + [colorSet countForObject:currentClr]) forKey:otherClr];
                                needInsert = NO;
                                *stop = YES;
                            }
                        } while (NO);
                    }];
                }
                if (needInsert) {
                    [colorDic DCH_safe_setObject:@([colorSet countForObject:currentClr]) forKey:currentClr];
                }
            } while (NO);
        }];
        
        NSArray *sortedAry = [colorDic keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            if ([obj1 unsignedIntegerValue] > [obj2 unsignedIntegerValue]) {
                return NSOrderedAscending;
            } else if ([obj1 unsignedIntegerValue] < [obj2 unsignedIntegerValue]) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }];
        
        if (sortedAry.count > 0) {
            result = [sortedAry objectAtIndex:0];
        }
    } while (NO);
    if (rawData) {
        CFRelease(rawData);
        rawData = nil;
    }
    return result;
}

- (BOOL)isEqualToByBytes:(UIImage *)otherImage {
    BOOL result = NO;
    NSData *imagePixelsData = nil;
    NSData *otherImagePixelsData = nil;
    do {
        imagePixelsData = (NSData *)CFBridgingRelease(CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage)));
        otherImagePixelsData = (NSData *)CFBridgingRelease(CGDataProviderCopyData(CGImageGetDataProvider(otherImage.CGImage)));
        result = [imagePixelsData isEqualToData:otherImagePixelsData];
    } while (NO);
    CGDataProviderRelease((CGDataProviderRef)imagePixelsData);
    CGDataProviderRelease((CGDataProviderRef)otherImagePixelsData);
    return result;
}

@end
