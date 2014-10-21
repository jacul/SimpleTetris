//
//  STMyScene.m
//  SimpleTetris
//
//  Created by zxd on 14-8-19.
//  Copyright (c) 2014年 jacul. All rights reserved.
//

#import "STGameScene.h"
#import "STBrickNode.h"

@implementation STGameScene

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.board_high = 30;
        self.board_width = 10;
        
        self.board = alloca(sizeof(int)* self.board_width);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)redrawBoard{
    
}

-(void)resetBoard{
    
}

-(void)moveBrickDown{
    
}

-(void)moveBrickLeft{
    
}

-(void)moveBrickRight{
    
}

-(void)rotateBrickLeft{
    
}

-(void)rotateBrickRight{
    
}

-(void)resetBrickToTop{
    
}

-(void)showGameOver{
    
}

@end
