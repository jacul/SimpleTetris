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
 board is an array of integers, from top to bottom, each one representing one line of the board, and right aligned.

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

/**
 * Check if the brick collides with other bricks in the board.
 * @return YES if there is a collision, otherwise NO.
 */
-(BOOL)collisionWithBrick:(STBrickNode*)brick;

@end
