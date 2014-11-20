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

@synthesize board;
@synthesize thebrick;
@synthesize board_high,board_width;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.board_high = 15;
        self.board_width = 10;
        
        self->board = malloc(sizeof(int)* self.board_high);
        for (int i=0; i<self.board_high; i++) {
            self.board[i] = 0;
        }
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
    //TODO: Print the board for now, need to draw for real
    NSMutableString* board_ascii = [NSMutableString new];
    [board_ascii appendFormat:@"\n"];
    for (int i=0; i<board_high; i++) {
        for (int j=0; j<board_width; j++) {
            int boardpixel = (board[i]>> (board_width-j-1) & 0x1);
            int brickpixel = [thebrick pixelOnBoardForX:j Y:i];
            [board_ascii appendFormat:@"%i ", boardpixel | brickpixel];
        }
        [board_ascii appendString:@"\n"];
        if (board[i]==-1) {
            //This line was cleared and needs animation here

        }
    }
    NSLog(@"%@", board_ascii);
}

-(void)resetBoard{
    
}


-(void)resetBrickToTop{
    thebrick.pos = CGPointMake((board_width-4)/2, -1);
}

-(void)showGameOver{
    
}


-(void)checkClearLine{
    NSLog(@"%i", board[board_high-1]);
    int full_line = (1 << (board_width)) -1;//Value of a full line
    for (int i = board_high-1; i>=0; i--) {//Check from bottom to top

        if (board[i] == full_line) {
            //full
            board[i] = -1;
        }
        
    }
    
}

-(BOOL)removeEmptyLines{
    BOOL hasEmpty = NO;
    //check floating bricks from bottom to top
    int j=board_high-1;
    for (int i = board_high-1; i>=0;i--) {
        
        board[j]=board[i];
        if(board[i]==-1){

            hasEmpty = YES;
        }else if (board[i] !=0) {
            j--;
        }
    }
    for (; j>=0; j--) {
        board[j] = 0;
    }
    return hasEmpty;
}

-(BOOL)checkCollisionWithBrick:(STBrickNode *)brick{
    //Check the pixels of the brick.
    for (int x=0; x<4; x++) {
        for (int y=0; y<4; y++) {
            if ([brick pixelOnBrickForX:x Y:y]==1) {//This pixel is occupied on brick
                //Then check if this pixel is out of the board
                if (brick.pos.x+x<0 || brick.pos.x+x >board_width-1 || brick.pos.y + y> board_high-1) {
                    //Out of board
                    return YES;
                }
                
                //Check the pixel on the board
                if ((board[(int)brick.pos.y + y]>> ( board_width -1 - (int)brick.pos.x- x) & 1) == 1) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

-(BOOL)brickReachesBottom{
    STBrickNode* newbrick = [thebrick copy];
    [newbrick moveBrickDown];
    for (int x=0; x<4; x++) {
        for (int y=0; y<4; y++) {
            if ([newbrick pixelOnBrickForX:x Y:y]==1) {//This pixel is occupied on brick
                //Then check if this pixel is out of the board
                if (newbrick.pos.y + y> board_high-1) {//check with bottom board
                    //Out of board
                    return YES;
                }
                //Check the pixel on the board
                if ((board[(int)newbrick.pos.y + y]>> ( board_width -1 - (int)newbrick.pos.x- x) & 1) == 1) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

-(void)stablizeBrick:(STBrickNode *)brick{
    for (int x=0; x<4; x++) {
        for (int y=0; y<4; y++) {
            if ([brick pixelOnBrickForX:x Y:y] == 1) {
                board[(int)brick.pos.y+y] |= 1<<(board_width -1 - (int)brick.pos.x - x);
            }
        }
    }

}
@end
