//
//  STBrickNode.m
//  SimpleTetris
//
//  Created by zxd on 14-8-20.
//  Copyright (c) 2014年 jacul. All rights reserved.
//

#import "STBrickNode.h"

@implementation STBrickNode


+(STBrickNode *)createLBrick{

    STBrickNode* node = [STBrickNode new];
    node->blocks[0] = 0b00000100;
    node->blocks[1] = 0b01000110;
    [node rotateRandom];
    return node;
}

-(void)rotateRandom{
    
}

-(void)rotateLeft{
    
}

-(void)rotateRight{
    Byte new1, new2;
    new1 = ((blocks[1] & 0b00001000) << 4) | ((blocks[1] & 0b10000000) >> 1) | ((blocks[0] & 0b00001000) << 2) | ((blocks[0] & 0b10000000) >> 3) |
           ((blocks[1] & 0b00000100) << 1) | ((blocks[1] & 0b01000000) >> 4) | ((blocks[0] & 0b00000100) >> 1) | ((blocks[0] & 0b01000000) >> 6);
    new2 = ((blocks[1] & 0b00000010) << 6) | ((blocks[1] & 0b00100000) << 1) | ((blocks[0] & 0b00000010) << 4) | ((blocks[0] & 0b00100000) >> 1) |
           ((blocks[1] & 0b00000001) << 3) | ((blocks[1] & 0b00010000) >> 2) | ((blocks[0] & 0b00000001) << 1) | ((blocks[0] & 0b00010000) >> 4);
    
    blocks[0] = new1;
    blocks[1] = new2;
}

-(NSString *)description{
    NSMutableString* des = [NSMutableString new];
    for (int i=0; i<2; i++) {
        for (int j=7; j>=0; j--) {
            [des appendFormat:@"%i", (blocks[i]>>j & 1)];
            if (j==4 || j==0) {
                [des appendFormat:@"\n"];
            }
        }
    }
    return [NSString stringWithString:des];
}


@end
