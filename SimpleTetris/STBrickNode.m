//
//  STBrickNode.m
//  SimpleTetris
//
//  Created by zxd on 14-8-20.
//  Copyright (c) 2014年 jacul. All rights reserved.
//

#import "STBrickNode.h"

@implementation STBrickNode

@synthesize pos;

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

+(instancetype)randomBrick{
    int type = arc4random() %5;
    switch (type) {
        case 0:
            return [self createDBrick];
            break;
        case 1:
            return [self createIBrick];
            break;
        case 2:
            return [self createLBrick];
            break;
        case 3:
            return [self createSBrick];
            break;
        case 4:
            return [self createTBrick];
            break;
        default:
            break;
    }
    return nil;
}

-(id)copy{
    STBrickNode* nodecopy = [STBrickNode new];
    nodecopy.pos = self.pos;
    nodecopy->blocks[0]=self->blocks[0];
    nodecopy->blocks[1]=self->blocks[1];
    return nodecopy;
}

//TODO: Unit test this funtion
-(void)rotateRandom{
    int count = arc4random()%4;//result will be one of 0, 1, 2, 3
    switch (count) {
        case 0://left rotate twice
            [self rotateLeft];
            break;
            
        case 1://left rotate once
            [self rotateLeft];
            break;
            
        case 2://right rotate once = left rotate three times
            [self rotateRight];
            break;
            
        case 3://doesn't rotate
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


-(void)moveBrickDown{
    self.pos = CGPointMake(self.pos.x, self.pos.y+1);
}

-(void)moveBrickLeft{
    self.pos = CGPointMake(self.pos.x-1, self.pos.y);
}

-(void)moveBrickRight{
    self.pos = CGPointMake(self.pos.x+1, self.pos.y);
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

-(int)pixelOnBoardForX:(int)x Y:(int)y{
    if (x<pos.x+4 && x>=pos.x && y>=pos.y && y< pos.y+4) {
        int px = x-pos.x;
        int py = y-pos.y;
        int value = 0;
        switch (py) {
            case 0:
                value = blocks[0]>>(7-px) & 1;
                break;
            case 1:
                value = blocks[0]>>(3-px) & 1;
                break;
            case 2:
                value = blocks[1]>>(7-px) & 1;
                break;
            case 3:
                value = blocks[1]>>(3-px) & 1;
                break;
            default:
                break;
        }
        return value;
    }else{
        return 0;
    }
}
@end
