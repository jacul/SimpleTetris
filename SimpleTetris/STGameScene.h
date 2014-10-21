//
//  STMyScene.h
//  SimpleTetris
//

//  Copyright (c) 2014年 jacul. All rights reserved.
//
#import "STBrickNode.h"

@interface STGameScene : UIView

/**
 Height of the board - how many lines of blocks, default 30
 */
@property (nonatomic, assign) int board_high;

/**
 Width of the board - how many blocks per line, default 10
 */
@property (nonatomic, assign) int board_width;

/**
 The free brick.
 */
@property (nonatomic, strong) STBrickNode* thebrick;

/**
 Position of the free brick
 */
@property (nonatomic, assign) CGPoint brickpos;

/**
 board is an array of integers, from bottom to up, each one representing one line of the board, and right aligned.

 If the value of a line is -1, it means this line was just cleared.
 */
@property (nonatomic, assign) int* board;

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
