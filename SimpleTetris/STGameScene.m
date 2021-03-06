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
        [self resetBoard];
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

-(void)dealloc{
    free(self->board);
}

-(NSString*)redrawBoard{
    //TODO: Print the board for now, need to draw for real
    NSMutableString* board_ascii = [NSMutableString new];
    [board_ascii appendFormat:@"%i\n", self.score];
    for (int i=0; i<board_high; i++) {
        [board_ascii appendString:@"|"];
        if (board[i]==-1) {
            //This line was cleared and needs animation here
            for(int j=0;j<board_width; j++){
                [board_ascii appendString:@"- "];
            }
        }else{
            for (int j=0; j<board_width; j++) {
                int boardpixel = (board[i]>> (board_width-j-1) & 0x1);
                int brickpixel = [thebrick pixelOnBoardForX:j Y:i];
                [board_ascii appendFormat:@"%@ ", (boardpixel | brickpixel) ? @"@":@" "];
            }
        }
        [board_ascii deleteCharactersInRange:NSMakeRange(board_ascii.length-1, 1)];
        [board_ascii appendString:@"|\n"];

    }
    [board_ascii appendString:@"|"];
    for(int j=0;j<board_width-1; j++){
        [board_ascii appendString:@"= "];
    }
    [board_ascii appendString:@"=|"];
    NSLog(@"%@", board_ascii);
    [self setNeedsDisplay];
    return board_ascii;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    double screenwidth = self.bounds.size.width;
    double screenheight = self.bounds.size.height;
    double bricksize;
    if (screenheight>screenwidth) {
        bricksize = 0.8*screenwidth / board_width;
    }else{
        bricksize = 0.8*screenheight / board_high;
    }
    
    CGContextSetRGBFillColor(ctx, 0, 1, 0, 1);
    for (int i=0; i<board_high; i++) {
        for (int j=0; j<board_width; j++) {
            int boardpixel = (board[i]>> (board_width-j-1) & 0x1);
            int brickpixel = [thebrick pixelOnBoardForX:j Y:i];
            if (boardpixel | brickpixel) {
                CGRect brickrect = CGRectMake(j*bricksize, i*bricksize, bricksize, bricksize);
                CGContextFillRect(ctx, brickrect);
            }
        }
    }
    
}

-(void)resetBoard{
    for (int i=0; i<self.board_high; i++) {
        self.board[i] = 0;
    }
    self.score = 0;
    self.thebrick = nil;
}


-(void)resetBrickToTop{
    thebrick.pos = CGPointMake((board_width-4)/2, -1);
}

-(void)showGameOver{
    NSString* boardascii = [self redrawBoard];
    NSRange midrange = NSMakeRange(boardascii.length /2 + board_width - 3, 10);//(boardascii.length / (board_width*2+2) /2 * (board_width*2+2)+board_width+1 - 4, 10)
    boardascii = [boardascii stringByReplacingCharactersInRange:midrange withString:@"Game Over!"];
    NSLog(@"%@", boardascii);
}

-(BOOL)isGameOver{
    return board[0]!=0;//Something on first line
}

-(void)checkClearLine{
    int count_full = 0;
    int full_line = (1 << (board_width)) -1;//Value of a full line
    for (int i = board_high-1; i>=0; i--) {//Check from bottom to top

        if (board[i] == full_line) {
            //full
            board[i] = -1;
            count_full++;
        }
        
    }
    self.score += count_full*count_full;
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
                if (newbrick.pos.y + y> board_high-1) {//check only left and right board
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
                //Check pixel of brick
                board[(int)brick.pos.y+y] |= 1<<(board_width -1 - (int)brick.pos.x - x);
            }
        }
    }

}

#pragma mark Brick movement

-(void)moveBrickLeft{
    //Create a new brick to check movement
    STBrickNode* brick = [thebrick copy];
    [brick moveBrickLeft];

    if (![self checkCollisionWithBrick:brick]){
        thebrick = brick;
    }
}

-(void)moveBrickRight{
    //Create a new brick to check movement
    STBrickNode* brick = [thebrick copy];
    [brick moveBrickRight];
    
    if (![self checkCollisionWithBrick:brick]){
        thebrick = brick;
    }
}

-(void)moveBrickDown{
    //Create a new brick to check movement
    STBrickNode* brick = [thebrick copy];
    [brick moveBrickDown];
    
    if (![self checkCollisionWithBrick:brick]){
        thebrick = brick;
    }
}

-(void)rotateBrick{
    //Create a new brick to check rotation
    STBrickNode* brick = [thebrick copy];
    [brick rotateRight];
    
    if (![self checkCollisionWithBrick:brick]){
        thebrick = brick;
    }
}
@end
