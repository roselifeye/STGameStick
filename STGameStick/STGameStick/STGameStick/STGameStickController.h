//
//  STGameStickController.h
//  STGameStick
//
//  Created by sy2036 on 2015-11-30.
//  Copyright © 2015 Sentto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STGameStickController;
@protocol STGameStickControllerDelegate <NSObject>

@required

- (void)stickValueDidChanged:(STGameStickController *)gameStick withChangedCoodinate:(CGPoint)coordinate;

@end

@interface STGameStickController : UIView

@property (nonatomic, assign) id<STGameStickControllerDelegate> delegate;

@end
