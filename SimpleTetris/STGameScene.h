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
 board is an array of integers, each one representing one line of the board, and right aligned.

 If the value of a line is -1, it means this line was just cleared.
 */
@property (nonatomic, strong) NSMutableArray* board;

#pragma mark - board control
/**
 Redraw the board
 */
-(void)redrawBoard;

-(void)showGameOver;

-(void)resetBoard;

#pragma mark - brick control

-(void)moveBrickLeft;

-(void)moveBrickRight;

-(void)moveBrickDown;

-(void)rotateBrickLeft;

-(void)rotateBrickRight;

-(void)resetBrickToTop;

@end
