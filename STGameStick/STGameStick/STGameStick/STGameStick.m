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
    CGPoint disOffset, disToCenter, maxCenter;
    
    // calculate stick direction to the center
    maxCenter.x = disToCenter.x = disOffset.x = touchPoint.x - sCenter.x;
    maxCenter.y = disToCenter.y = disOffset.y =  touchPoint.y - sCenter.y;

    double len = sqrt(disToCenter.x*disToCenter.x + disToCenter.y*disToCenter.y);
    float largestOffset = minSizeWidth/2-(minSizeWidth/2)*RatioOfCenterAndBG;
//    NSLog(@"%f, %f",len, largestOffset);
//    NSLog(@"%f, %f",stickCenter.frame.origin.x, stickCenter.frame.origin.y);
//    disToCenter.x = (disToCenter.x<largestOffset)?((disToCenter.x<-largestOffset)?-largestOffset:disToCenter.x):largestOffset;
//    disToCenter.y = (disToCenter.y<largestOffset)?((disToCenter.y<-largestOffset)?-largestOffset:disToCenter.y):largestOffset;
//    disToCenter.x = (len<largestOffset)?((disToCenter.x<-largestOffset)?-largestOffset:disToCenter.x):largestOffset;
//    disToCenter.y = (len<largestOffset)?((disToCenter.y<-largestOffset)?-largestOffset:disToCenter.y):largestOffset;

    if(len < 1.0 && len > -1.0) {
        // on center pos
        disOffset.x = 0.0;
        disOffset.y = 0.0;
        disToCenter.x = 0;
        disToCenter.y = 0;
    } else {
        double len_inv = (1.0 / len);
        disOffset.x *= len_inv;
        disOffset.y *= len_inv;
        disToCenter.x = disOffset.x * 20;
        disToCenter.y = disOffset.y * 20;
        NSLog(@"%f,%f",disOffset.x,disOffset.y);
    }
    
//    NSLog(@"%f,%f",disToCenter.x,disToCenter.y);
//    if (len > minSizeWidth/2) {
//        
//    } else {
//        disOffset.x = disToCenter.x/largestOffset;
//        disOffset.y = disToCenter.y/largestOffset;
////        NSLog(@"%f,%f",disOffset.x,disOffset.y);
//    }
//    [self stickMoved:CGPointMake(disToCenter.x+sCenter.x, disToCenter.y+sCenter.y)];
    [self stickMoved:disToCenter];
    
    if ([self.delegate respondsToSelector:@selector(stickDidMoved:withMovedCoodinate:)]) {
        [self.delegate stickDidMoved:self withMovedCoodinate:disOffset];
    }
}

- (void)stickMoved:(CGPoint)offSetToCenter {
//    [stickCenter setCenter:offSetToCenter];
    CGRect fr = stickCenter.frame;
    fr.origin.x = offSetToCenter.x;
    fr.origin.y = offSetToCenter.y;
    stickCenter.frame = fr;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stickTouched:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stickTouched:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stickMoved:CGPointMake(0, 0)];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
