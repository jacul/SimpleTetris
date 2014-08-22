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
    return node;
}

+(instancetype)createIBrick{
    STBrickNode* node = [STBrickNode new];
    node->blocks[0] = 0b00100010;
    node->blocks[1] = 0b00100010;
    return node;
}

+(instancetype)createDBrick{
    STBrickNode* node = [STBrickNode new];
    node->blocks[0] = 0b00000110;
    node->blocks[1] = 0b01100000;
    return node;
}

+(instancetype)createSBrick{
    STBrickNode* node = [STBrickNode new];
    node->blocks[0] = 0b00000100;
    node->blocks[1] = 0b01100010;
    return node;
}

+(instancetype)createTBrick{
    STBrickNode* node = [STBrickNode new];
    node->blocks[0] = 0b00001110;
    node->blocks[1] = 0b01000000;
    return node;
}

//TODO: Unit test this funtion
-(void)rotateRandom{
    int count = arc4random()%3;//result will be one of 0, 1, 2
    switch (count) {
        case 0://left rotate twice
            [self rotateLeft];
            
        case 1://left rotate once
            [self rotateLeft];
            break;
            
        case 2://right rotate once = left rotate three times
            [self rotateRight];
            break;
            
        default:
            break;
    }
}

-(void)rotateLeft{
    Byte new1, new2;
    //Calculate line by line
    //New rows were the same as the old columns, r1 was c4, r2 was c3, r3 was c2, r4 was c1
    new1 = ((blocks[0] & 0b00010000) << 3) | ((blocks[0] & 0b00000001) >> 6) | ((blocks[1] & 0b00010000) << 1) | ((blocks[1] & 0b00000001) >> 4) |
    ((blocks[0] & 0b00100000) >> 2) | ((blocks[0] & 0b00000010) << 1) | ((blocks[1] & 0b00100000) >> 4) | ((blocks[1] & 0b00000010) >> 1);
    new2 = ((blocks[0] & 0b01000000) << 1) | ((blocks[0] & 0b00000100) << 4) | ((blocks[1] & 0b01000000) >>1) | ((blocks[1] & 0b00000100) << 2) |
    ((blocks[0] & 0b10000000) >> 4) | ((blocks[0] & 0b00001000) >> 1) | ((blocks[1] & 0b10000000) >> 6) | ((blocks[1] & 0b00001000) >> 3);
    
    blocks[0] = new1;
    blocks[1] = new2;
}

-(void)rotateRight{
    Byte new1, new2;
    //Calculate line by line
    //New rows were the same as the old columns, r1 was c1, r2 was c2, r3 was c3, r4 was c4
    new1 = ((blocks[1] & 0b00001000) << 4) | ((blocks[1] & 0b10000000) >> 1) | ((blocks[0] & 0b00001000) << 2) | ((blocks[0] & 0b10000000) >> 3) |
           ((blocks[1] & 0b00000100) << 1) | ((blocks[1] & 0b01000000) >> 4) | ((blocks[0] & 0b00000100) >> 1) | ((blocks[0] & 0b01000000) >> 6);
    new2 = ((blocks[1] & 0b00000010) << 6) | ((blocks[1] & 0b00100000) << 1) | ((blocks[0] & 0b00000010) << 4) | ((blocks[0] & 0b00100000) >> 1) |
           ((blocks[1] & 0b00000001) << 3) | ((blocks[1] & 0b00010000) >> 2) | ((blocks[0] & 0b00000001) << 1) | ((blocks[0] & 0b00010000) >> 4);
    
    blocks[0] = new1;
    blocks[1] = new2;
}

/**
    Print the brick as ASCII characters. Starting and ending with line breaks.
 */
-(NSString *)description{
    NSMutableString* des = [NSMutableString new];
    [des appendString:@"\n"];
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
