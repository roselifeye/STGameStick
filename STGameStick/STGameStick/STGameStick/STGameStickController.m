//
//  STGameStickController.m
//  STGameStick
//
//  Created by sy2036 on 2015-11-30.
//  Copyright © 2015 Sentto. All rights reserved.
//

#import "STGameStickController.h"
#import "STGameStick.h"

#define MoveBtnR 15

@interface STGameStickController () <STGameStickDelegate> {
    STGameStick *gameStick;
    UIImageView *moveBtn;
    UIPanGestureRecognizer *panGesture;
    UILongPressGestureRecognizer *longPressGes;
}

@end

@implementation STGameStickController

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initMoveBtn];
        [self initStick];
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stickMoved:)];
    }
    return self;
}

- (void)initStick {
    float minSizeWidth = (self.frame.size.width>self.frame.size.height)?self.frame.size.width-MoveBtnR:self.frame.size.height-MoveBtnR;
    gameStick = [[STGameStick alloc] initWithFrame:CGRectMake(0, 0, minSizeWidth, minSizeWidth)];
    gameStick.delegate = self;
    [self addSubview:gameStick];
}

- (void)initMoveBtn {
    moveBtn = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-MoveBtnR*2, self.frame.size.height-MoveBtnR*2, MoveBtnR*2, MoveBtnR*2)];
    [moveBtn setImage:[UIImage imageNamed:@"close"]];
    
    longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(enableMoveStickView:)];
    longPressGes.minimumPressDuration = 1.f;
    longPressGes.numberOfTouchesRequired = 1;
    [moveBtn addGestureRecognizer:longPressGes];
    moveBtn.userInteractionEnabled = YES;
    
    [self addSubview:moveBtn];
}

/**
 *  Long press the Move Button,
 *  and will call the move function which means the Pan Gesture will be added to the self.
 *
 *  In addition,
 *  the animation of the view will be called.
 *
 *  @param sender Long press gesture.
 */
- (void)enableMoveStickView:(UILongPressGestureRecognizer *)sender {
    switch ([sender state]) {
        case UIGestureRecognizerStateBegan: {
            //  Shake Animation Called.
            CABasicAnimation *animation = (CABasicAnimation *)[self.layer animationForKey:@"rotation"];
            if (animation == nil) {
                [self shakePlayView:self];
            }else {
                [self shakeResume];
            }
            //  PanGesture is added to self.
            [self addGestureRecognizer:panGesture];
            //  Forbid the touch of the gameStick to avoid the collision with PanGesture.
            gameStick.userInteractionEnabled = NO;
        }
            break;
        default:
            break;
    }
}

/**
 *  The three functions below implement the shake animation for the view.
 */
- (void)shakePause {
    self.layer.speed = 0.f;
}

- (void)shakeResume {
    self.layer.speed = 1.f;
}

- (void)shakePlayView:(UIView *)view {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [animation setDuration:0.08];
    
    animation.fromValue = @(-M_1_PI/2);
    animation.toValue = @(M_1_PI/2);
    animation.repeatCount = HUGE_VAL;
    animation.autoreverses = YES;
    view.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [view.layer addAnimation:animation forKey:@"rotation"];
}

/**
 *  Pan Gesture called.
 *
 *  @param sender PanGesture.
 */
- (void)stickMoved:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:self];
    sender.view.center = CGPointMake(sender.view.center.x + point.x, sender.view.center.y + point.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self];
}

/**
 *  Remove the PanGesture when tap to stop the shake animation.
 *  ReEnable the Touch of the GameStick.
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeGestureRecognizer:panGesture];
    gameStick.userInteractionEnabled = YES;
    longPressGes.enabled = YES;
    [self shakePause];
}

#pragma mark - STGameStick Delegate
- (void)stickDidMoved:(STGameStick *)gameStick withMovedCoodinate:(CGPoint)coordinate {
    if ([self.delegate respondsToSelector:@selector(stickValueDidChanged:withChangedCoodinate:)]) {
        [self.delegate stickValueDidChanged:self withChangedCoodinate:coordinate];
    }
}

@end
