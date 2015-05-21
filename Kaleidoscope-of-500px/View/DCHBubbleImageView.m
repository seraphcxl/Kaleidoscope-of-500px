//
//  DCHBubbleImageView.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/21/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHBubbleImageView.h"

@implementation DCHBubbleImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    do {
        UITouch *touch = [touches anyObject];
        if (!touch) {
            break;
        }
        NSUInteger tapCount = touch.tapCount;
        if (tapCount > 0) {
            if (self.tapDelegate && [self.tapDelegate respondsToSelector:@selector(view:tapDetected:)]) {
                [self.tapDelegate view:self tapDetected:touch];
            }
        }
    } while (NO);
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

@end
