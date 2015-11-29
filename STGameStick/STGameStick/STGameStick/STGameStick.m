//
//  STGameStick.m
//  STGameStick
//
//  Created by sy2036 on 2015-11-29.
//  Copyright © 2015 Sentto. All rights reserved.
//

#import "STGameStick.h"

#define RatioOfCenterAndBG 68/128

#define MoveBtnR 15

@interface STGameStick () {
    UIImageView *moveBtn;
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
    moveBtn = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-MoveBtnR*2, self.frame.size.height-MoveBtnR*2, MoveBtnR*2, MoveBtnR*2)];
    [moveBtn setImage:[UIImage imageNamed:@"close"]];
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveStickView:)];
    longPressGes.minimumPressDuration = 2.f;
    longPressGes.numberOfTouchesRequired = 1;
    [moveBtn addGestureRecognizer:longPressGes];
    moveBtn.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveStickView:)];
//    [self addGestureRecognizer:panGesture];
    
    
    [self addSubview:moveBtn];
}

/**
 *  Long press the Move Button,
 *  and will call the move function.
 *
 *  @param sender Long press gesture.
 */
- (void)moveStickView:(UILongPressGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self];
    NSLog(@"%f",point.x);
//    sender.view.center = CGPointMake(sender.view.center.x + point.x, sender.view.center.y + point.y);
//    [sender setTranslation:CGPointMake(0, 0) inView:self];
    [self setCenter:point];
}

- (void)initStickController {
    minSizeWidth = (self.frame.size.width>self.frame.size.height)?self.frame.size.width-MoveBtnR:self.frame.size.height-MoveBtnR;
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

    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];

    if(view != self)
        return ;

    self.userInteractionEnabled = NO;
    CGPoint touchPoint = [touch locationInView:view];
    CGPoint disOffset, disToCenter, maxOffset, maxCenter;
    
    maxCenter.x = maxOffset.x = disToCenter.x = disOffset.x = touchPoint.x - sCenter.x;
    maxCenter.y = maxOffset.y = disToCenter.y = disOffset.y = touchPoint.y - sCenter.y;

    double len = sqrt(disToCenter.x*disToCenter.x + disToCenter.y*disToCenter.y);
    float largestOffset = minSizeWidth/2-(minSizeWidth/2)*RatioOfCenterAndBG;

    if(len < 0.1 && len > -0.10) {
        //  If the |len| is smaller than 1, the stick is considered not moved.
        maxCenter.x = maxOffset.x = disToCenter.x = disOffset.x = 0.f;
        maxCenter.y = maxOffset.y = disToCenter.y = disOffset.y = 0.f;
    } else {
        //  Calculate the Max Offset and Center.
        //  Normalize the distance.
        double len_inv = (1.0 / len);
        maxOffset.x *= len_inv;
        maxOffset.y *= len_inv;
        maxCenter.x = maxOffset.x * largestOffset;
        maxCenter.y = maxOffset.y * largestOffset;
        //  Obtain the real Center, and limite it with maxCenter.
        disToCenter.x = (len>largestOffset)?maxCenter.x:disToCenter.x;
        disToCenter.y = (len>largestOffset)?maxCenter.y:disToCenter.y;
        //  Nomarlize X and Y, and rerange the direction.
        disOffset.x = (disToCenter.x)/largestOffset;
        disOffset.y = -(disToCenter.y)/largestOffset;
    }
    
    [self stickMoved:disToCenter];
    
    if ([self.delegate respondsToSelector:@selector(stickDidMoved:withMovedCoodinate:)]) {
        [self.delegate stickDidMoved:self withMovedCoodinate:disOffset];
    }
}

/**
 *  The stick will move to the coordinate
 *
 *  @param offSetToCenter The distance to the Center of the ImageView.
 */
- (void)stickMoved:(CGPoint)offSetToCenter {
    CGRect fr = stickCenter.frame;
    fr.origin.x = offSetToCenter.x;
    fr.origin.y = offSetToCenter.y;
    stickCenter.frame = fr;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"1");
    [self stickTouched:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"2");
    [self stickTouched:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"3");
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
