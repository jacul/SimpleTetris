//
//  STViewController.m
//  SimpleTetris
//
//  Created by zxd on 14-8-19.
//  Copyright (c) 2014年 jacul. All rights reserved.
//

#import "STViewController.h"

#define FPS 10.0

@implementation STViewController{
    /***
     Indidates if the game is paused
     */
    BOOL gamePaused;
    
    /***
     Speed of the game ,which is the count of the brick moves per second.
     */
    int gameSpeed;
    
    /***
     The amount of frames passed within one second.
     */
    int accumulatedFrames;
}

@synthesize gamescene;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.gamescene = [STGameScene new];
    self.view = self.gamescene;
    
    //Game starts without being paused
    gamePaused = NO;
    
    //Default 0
    accumulatedFrames = 0;
    
    //Speed default 2
    gameSpeed = 2;
}

/**
 * When the game is loaded, start the main looper
 */
-(void)viewDidAppear:(BOOL)animated{
    if (self.looper==nil) {
        //Schedule event at 10 FPS
        self.looper = [NSTimer scheduledTimerWithTimeInterval: 1.0/FPS target:self selector:@selector(updateEverything) userInfo:nil repeats:YES];
    }
}

/**
 * Pause the main looper when the game is stopped
 */
-(void)viewDidDisappear:(BOOL)animated{
    if (self.looper && [self.looper isValid]) {
        [self.looper invalidate];
        self.looper = nil;
    }
}

/**
 Main thread, game logic defined here.
 */
-(void)updateEverything{
    if(!gamePaused){
        //Game not paused
        
        if ([self checkGameOver]) {
            //Game continues, do all things related to bricks
            [self handleBricks];
            
            //Increament the frame counter
            accumulatedFrames++;
            
            //Redraw the board
            [self.gamescene redrawBoard];
        }else{
            //game over
            [self.gamescene showGameOver];
        }
    }
}

/**
 @return YES if the game is over. Otherwise NO.
 */
-(BOOL)checkGameOver{
    return NO;
}

/**
 Brick stuff, including drop the next brick, generate new backups and clear the lined bricks.
 */
-(void)handleBricks{
    if (accumulatedFrames * FPS == gameSpeed) {
        //Time to move that brick!
        
        if (![self brickFall]) {
            //Brick reaches the bottom
            //Check if there is one or more complete lines.
            [self checkClearLine];
            
            [self generateNewBrick];
        }
        
    }
    
}

/**
 Check if there is any line full. If so, mark it as "cleared".
 */
-(void)checkClearLine{
    int full_line = (1 << (gamescene.board_width+1)) -1;
    for (int i = gamescene.board_high-1; i>=0; i--) {
        int line = gamescene.board[i];
        if (line == full_line) {
            //full
            gamescene.board[i] = -1;
        }
        
    }

}

/**
 Generate a new brick
 */
-(void)generateNewBrick{
    gamescene.thebrick = [STBrickNode randomBrick];
    [gamescene.thebrick rotateRandom];
    gamescene.thebrick.pos = CGPointMake(gamescene.board_width/2, 0);
}

/**
 Move all the bricks down.

 This includes both the single brick and the existing ones, since some of the bricks might be floating due to previous clear.

 @return YES if the brick moves. Otherwise NO.
 */
-(BOOL)brickFall{
    BOOL result = NO;
    STBrickNode* newbrick = [gamescene.thebrick copy];
    newbrick.pos = CGPointMake(newbrick.pos.x, newbrick.pos.y+1);
    result = [gamescene collisionWithBrick:newbrick]; //can't move forward
    
    //check other floating bricks, remove the empty lines.
    int j=gamescene.board_high-1;
    for (int i = gamescene.board_high-1; i>=0;i--) {
        
        gamescene.board[j]=gamescene.board[i];
        if (gamescene.board[i]!=0) {
            j--;
        }
    }
    for (; j>=0; j--) {
        gamescene.board[j] = 0;
    }
    return result;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
