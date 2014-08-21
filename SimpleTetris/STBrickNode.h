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
 
    O O O O
 
    0 1 O O
 
    0 1 O O
 
    0 1 1 O
 */
+(instancetype)createLBrick;

/**
 shit
 
 */

-(void)rotateLeft;

-(void)rotateRight;

-(void)rotateRandom;

@end
