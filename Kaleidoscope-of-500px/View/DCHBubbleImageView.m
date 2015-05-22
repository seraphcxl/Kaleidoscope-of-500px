//
//  DCHBubbleImageView.m
//  Kaleidoscope-of-500px
//
//  Created by Derek Chen on 5/21/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHBubbleImageView.h"

@interface DCHBubbleImageView ()

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeRecognizer;

- (void)activeForUserInteraction;
- (void)_swiped:(UISwipeGestureRecognizer *)swipeRecognizer;

@end

@implementation DCHBubbleImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    do {
        self.swipeDelegate = nil;
        self.tapDelegate = nil;
        
        [self removeGestureRecognizer:self.leftSwipeRecognizer];
        self.leftSwipeRecognizer = nil;
        [self removeGestureRecognizer:self.rightSwipeRecognizer];
        self.rightSwipeRecognizer = nil;
    } while (NO);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self activeForUserInteraction];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self activeForUserInteraction];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self activeForUserInteraction];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        [self activeForUserInteraction];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if (self) {
        [self activeForUserInteraction];
    }
    return self;
}

- (void)activeForUserInteraction {
    do {
        self.userInteractionEnabled = YES;
        
        if (self.leftSwipeRecognizer) {
            [self removeGestureRecognizer:self.leftSwipeRecognizer];
            self.leftSwipeRecognizer = nil;
        }
        
        self.leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swiped:)];
        self.leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:self.leftSwipeRecognizer];
        
        if (self.rightSwipeRecognizer) {
            [self removeGestureRecognizer:self.rightSwipeRecognizer];
            self.rightSwipeRecognizer = nil;
        }
        
        self.rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swiped:)];
        self.rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:self.rightSwipeRecognizer];
    } while (NO);
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

- (void)_swiped:(UISwipeGestureRecognizer *)swipeRecognizer {
    do {
        if (swipeRecognizer != self.leftSwipeRecognizer && swipeRecognizer != self.rightSwipeRecognizer) {
            break;
        }
        if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(view:swipeDetected:)]) {
            [self.swipeDelegate view:self swipeDetected:swipeRecognizer];
        }
    } while (NO);
}

@end
