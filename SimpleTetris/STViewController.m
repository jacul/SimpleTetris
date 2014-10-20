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
        
        if ([self brickFall]) {
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
    for (int i = gamescene.board.count-1; i>=0; i--) {
        int line = [[gamescene.board objectAtIndex:i] integerValue];
        if (line == 0b1111111111) {
            //full, assume the board's width is 10 for now
            [gamescene.board setObject:@(0) atIndexedSubscript:i];
        }
        
    }

}

-(void)generateNewBrick{
    gamescene.thebrick = [STBrickNode createTBrick];
    [gamescene.thebrick rotateRandom];
    gamescene.brickpos = CGPointMake(0, 0);
}

/**
 Move all the bricks down.

 This includes both the single brick and the existing ones, since some of the bricks might be floating due to previous clear.

 @return YES if the brick has reached bottom before move. Otherwise NO.
 */
-(BOOL)brickFall{
    
    return NO;
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
