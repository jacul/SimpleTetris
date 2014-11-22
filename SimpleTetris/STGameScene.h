//
//  STMyScene.h
//  SimpleTetris
//

//  Copyright (c) 2014年 jacul. All rights reserved.
//
#import "STBrickNode.h"

@interface STGameScene : UIView{
    
    /**
     board is an array of integers, from top to bottom, each one representing one line of the board, and right aligned. One bit per pixel.
     
     If the value of a line is -1, it means this line was just cleared.
     */
    int* board;
}

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

@property (readonly) int * board;
#pragma mark - board control
/**
 Redraw the board
 
 @return NSString The ASCII representation of the board is returned.
 */
-(NSString*)redrawBoard;

-(void)showGameOver;

/**
 Remove all the pixels, reset the brick position.
 */
-(void)resetBoard;

/**
 * Check if the game is over. Basically check if there is any pixel on first line.
 */
-(BOOL)isGameOver;

#pragma mark - brick control

/**
 Reset the brick's position to the top middle of the board.
 */
-(void)resetBrickToTop;

/**
 * Check if there is any line full. If so, mark it as "cleared".
 */
-(void)checkClearLine;

/**
 Remove the empty lines of the board,
 */
-(BOOL)removeEmptyLines;

/**
 * Check if the brick collides with other bricks in the board.
 * This method checks the brick against the walls and bottom.
 *
 * @return YES if there is a collision, otherwise NO.
 */
-(BOOL)checkCollisionWithBrick:(STBrickNode*)brick;

/**
 * @return YES if the brick is on the bottom of the board. Otherwise NO.
 */
-(BOOL)brickReachesBottom;

/**
 * The brick will be fixed onto the board.
 */
-(void)stablizeBrick:(STBrickNode*)brick;

/**
 * Move the brick left by one pixel. This action will consider the collision.
 */
-(void)moveBrickLeft;

/**
 * Move right. Check same.
 */
-(void)moveBrickRight;

/**
 * Move down. Check same.
 */
-(void)moveBrickDown;

/**
 * Rotate the brick. Will check the brick collision.
 */
-(void)rotateBrick;
@end
