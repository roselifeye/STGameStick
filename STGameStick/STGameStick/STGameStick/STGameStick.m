//
//  STGameStick.m
//  STGameStick
//
//  Created by sy2036 on 2015-11-29.
//  Copyright © 2015 Sentto. All rights reserved.
//

#import "STGameStick.h"

#define RatioOfCenterAndBG 68/128

@interface STGameStick () {
    UIImageView *stickBG;
    UIImageView *stickCenter;
    
    float minSizeWidth;
    
    CGPoint sCenter;
}

@end

@implementation STGameStick

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initStickController];
        [self initMoveBtn];
    }
    return self;
}

- (void)initMoveBtn {
    UIImageView *moveBtn = [[UIImageView alloc] initWithFrame:CGRectMake(minSizeWidth, minSizeWidth, 20, 20)];
    [moveBtn setImage:[UIImage imageNamed:@"close"]];
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveStickView:)];
    longPressGes.minimumPressDuration = 2.f;
    longPressGes.numberOfTouchesRequired = 1;
    [moveBtn addGestureRecognizer:longPressGes];
    moveBtn.userInteractionEnabled = YES;
    
    [self addSubview:moveBtn];
}

- (void)moveStickView:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Stick View Moved.");
    }
}

- (void)initStickController {
    minSizeWidth = (self.frame.size.width>self.frame.size.height)?self.frame.size.width-20:self.frame.size.height-20;
    sCenter = CGPointMake(minSizeWidth/2, minSizeWidth/2);
    
    stickCenter = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, minSizeWidth, minSizeWidth)];
    [stickCenter setImage:[UIImage imageNamed:@"round_center"]];
    [stickCenter setCenter:sCenter];
    
    stickBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, minSizeWidth, minSizeWidth)];
    [stickBG setImage:[UIImage imageNamed:@"stick_BG"]];
    [stickBG addSubview:stickCenter];
    
    [self addSubview:stickBG];
}


- (void)stickTouched:(NSSet<UITouch *> *)touches {
    if([touches count] != 1)
        return ;

    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];

    if(view != self)
        return ;

    CGPoint touchPoint = [touch locationInView:view];
    CGPoint disOffset, disToCenter;
    
    // calculate stick direction to the center
    disToCenter.x = touchPoint.x - sCenter.x;
    disToCenter.y = touchPoint.y - sCenter.y;

    double len = sqrt(disToCenter.x*disToCenter.x + disToCenter.y*disToCenter.y);
    float largestOffset = minSizeWidth/2-(minSizeWidth/2)*RatioOfCenterAndBG;
    NSLog(@"%f, %f",len, largestOffset);
    disToCenter.x = (disToCenter.x<largestOffset)?((disToCenter.x<-largestOffset)?-largestOffset:disToCenter.x):largestOffset;
    disToCenter.y = (disToCenter.y<largestOffset)?((disToCenter.y<-largestOffset)?-largestOffset:disToCenter.y):largestOffset;
//    NSLog(@"%f",len);
//    if(len < 10.0 && len > -10.0) {
//        // on center pos
//        disOffset.x = 0.0;
//        disOffset.y = 0.0;
//        disToCenter.x = 0;
//        disToCenter.y = 0;
//    } else {
//        double len_inv = (1.0 / len);
//        disToCenter.x = len_inv;
//        disToCenter.y = len_inv;
//        disOffset.x = disToCenter.x * STICK_CENTER_TARGET_POS_LEN;
//        disOffset.y = disToCenter.y * STICK_CENTER_TARGET_POS_LEN;
//    }
    
//    NSLog(@"%f,%f",disToCenter.x,disToCenter.y);
    if (len > minSizeWidth/2) {
        
    } else {
        disOffset.x = disToCenter.x/largestOffset;
        disOffset.y = disToCenter.y/largestOffset;
//        NSLog(@"%f,%f",disOffset.x,disOffset.y);
    }
    [self stickMoved:CGPointMake(disToCenter.x+sCenter.x, disToCenter.y+sCenter.y)];
    
    if ([self.delegate respondsToSelector:@selector(stickDidMoved:withMovedCoodinate:)]) {
        [self.delegate stickDidMoved:self withMovedCoodinate:disOffset];
    }
}

- (void)stickMoved:(CGPoint)offSetToCenter {
    [stickCenter setCenter:offSetToCenter];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stickTouched:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stickTouched:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stickMoved:sCenter];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
