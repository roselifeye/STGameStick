//
//  STGameStick.h
//  STGameStick
//
//  Created by sy2036 on 2015-11-29.
//  Copyright © 2015 Sentto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STGameStick;
@protocol STGameStickDelegate <NSObject>

@required

- (void)stickDidMoved:(STGameStick *)gameStick withMovedCoodinate:(CGPoint)coordinate;

@end

@interface STGameStick : UIView

@property (nonatomic, assign) id<STGameStickDelegate> delegate;

@end
