//
//  STBrickNode.h
//  SimpleTetris
//
//  Created by zxd on 14-8-20.
//  Copyright (c) 2014年 jacul. All rights reserved.
//

@interface STBrickNode : NSObject{
    /***
        The block is a 8x8 pixel collection. The two lines on top would be represented by the first byte,

        The second byte represents the other two lines.
     
        @b Exp:

        blocks[0] : 0 0 0 0 1 0 0 0

        blocks[1] : 1 1 0 0 1 0 0 0

        And the overall block will look like:

        0 0 0 0
     
        1 0 0 0
     
        1 1 0 0
     
        1 0 0 0
     */
    Byte blocks[2];
}


/**
 Position of the free brick, with the anchor set to the left top of the brick.
 */
@property (nonatomic, assign) CGPoint pos;

/**
 
    0 0 0 0
 
    0 1 0 0
 
    0 1 0 0
 
    0 1 1 0
 */
+(instancetype)createLBrick;

/**
    0 0 0 0

    1 1 1 0

    0 1 0 0

    0 0 0 0
 */
+(instancetype)createTBrick;

/**
    0 0 0 0
 
    0 1 0 0
 
    0 1 1 0
 
    0 0 1 0
 */
+(instancetype)createSBrick;

/**
    0 0 0 0
 
    0 1 1 0
 
    0 1 1 0
 
    0 0 0 0
 */
+(instancetype)createDBrick;

/**
    0 0 1 0
 
    0 0 1 0
 
    0 0 1 0
 
    0 0 1 0
 */
+(instancetype)createIBrick;

/**
 Create a random type brick.
 */
+(instancetype)randomBrick;
/**

    Rotate the brick to left. Which means all current rows will be new columns from left to right.
 
 */

-(void)rotateLeft;

/**
 
    Rotate the brick to right. Which means all current rows will be new columns from right to left.
 
 */
-(void)rotateRight;

/*
    Rotate the brick by either once or twice, to either left or right.
 */
-(void)rotateRandom;

@end
