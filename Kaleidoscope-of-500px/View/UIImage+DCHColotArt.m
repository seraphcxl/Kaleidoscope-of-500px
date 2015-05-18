//
//  UIImage+DCHColotArt.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/18/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "UIImage+DCHColotArt.h"
#import <Tourbillon/DCHTourbillon.h>

@implementation UIImage (DCHColotArt)

- (UIColor *)findMajorColor {
    UIColor *result = nil;
    CFDataRef rawData = nil;
    do {
        rawData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage));
        UInt8 * buf = (UInt8 *) CFDataGetBytePtr(rawData);
        NSUInteger length = CFDataGetLength(rawData);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for(NSUInteger idx = 0; idx < length; idx += 4) {
            int r = buf[idx];
            int g = buf[idx + 1];
            int b = buf[idx + 2];
            int a = buf[idx + 3];
            UIColor *clr = [UIColor colorWithRed:DCHRGBAConvert256ToPercentage(r) green:DCHRGBAConvert256ToPercentage(g) blue:DCHRGBAConvert256ToPercentage(b) alpha:DCHRGBAConvert256ToPercentage(a)];
            NSNumber *count = [dic objectForKey:clr];
            if (count) {
                [dic setObject:@([count unsignedIntegerValue] + 1) forKey:clr];
            } else {
                [dic setObject:@(1) forKey:clr];
            }
        }
        NSArray *sortedAry = [dic keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
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

- (UIColor *)findEdgeColorWithType:(DCHColotArt_EdgeType)type andCountOfLine:(NSUInteger)countOfLine {
    UIColor *result = nil;
    CFDataRef rawData = nil;
    do {
        if (countOfLine == 0) {
            break;
        }
        CGFloat width = CGImageGetWidth(self.CGImage);
        CGFloat height = CGImageGetHeight(self.CGImage);
        CGRect cropRect = CGRectZero;
        switch (type) {
            case DCHColotArt_EdgeType_Top:
            {
                cropRect = CGRectMake(0.0f, 0.0f, width, countOfLine);
            }
                break;
            case DCHColotArt_EdgeType_Bottom:
            {
                cropRect = CGRectMake(0.0f, height - countOfLine, width, countOfLine);
            }
                break;
            case DCHColotArt_EdgeType_Left:
            {
                cropRect = CGRectMake(0.0f, 0.0f, countOfLine, height);
            }
                break;
            case DCHColotArt_EdgeType_Right:
            {
                cropRect = CGRectMake(width - countOfLine, 0.0f, countOfLine, height);
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
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for(NSUInteger idx = 0; idx < length; idx += 4) {
            int r = buf[idx];
            int g = buf[idx + 1];
            int b = buf[idx + 2];
            int a = buf[idx + 3];
            UIColor *clr = [UIColor colorWithRed:DCHRGBAConvert256ToPercentage(r) green:DCHRGBAConvert256ToPercentage(g) blue:DCHRGBAConvert256ToPercentage(b) alpha:DCHRGBAConvert256ToPercentage(a)];
            NSNumber *count = [dic objectForKey:clr];
            if (count) {
                [dic setObject:@([count unsignedIntegerValue] + 1) forKey:clr];
            } else {
                [dic setObject:@(1) forKey:clr];
            }
        }
        NSArray *sortedAry = [dic keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
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
