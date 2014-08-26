//
//  STMyScene.h
//  SimpleTetris
//

//  Copyright (c) 2014年 jacul. All rights reserved.
//
#import "STBrickNode.h"

@interface STGameScene : UIView

@property (nonatomic, strong) STBrickNode* thebrick;
@property (nonatomic, assign) CGPoint brickpos;

/**
 Redraw the board
 */
-(void)redrawBoard;

@end
