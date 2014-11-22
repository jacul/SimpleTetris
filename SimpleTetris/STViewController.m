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
    //Maybe to load from the checkpoint in later versions
    gamePaused = NO;
    
    //Default 0
    accumulatedFrames = 0;
    
    //Speed default
    gameSpeed = 2;
    
    //Add gesture recognizer
    //It sucks to create four gesture recognizer
    //But that's what Apple wants
    UISwipeGestureRecognizer* swipegesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeAction:)];
    [swipegesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipegesture];
    
    swipegesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeAction:)];
    [swipegesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipegesture];
    
    swipegesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeAction:)];
    [swipegesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipegesture];
    
    swipegesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeAction:)];
    [swipegesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipegesture];
    
    //Add a tap gesture recognizer
    UITapGestureRecognizer* tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapAction:)];
    [tapgesture setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:tapgesture];
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
        
        if (![self checkGameOver]) {
            //Game continues, do all things related to bricks
            [self handleBricks];
            
            //Increament the frame counter
            accumulatedFrames++;
            
            //Redraw the board
            [self.gamescene redrawBoard];
        }else{
            //game over
            [self.gamescene showGameOver];
            gamePaused = YES;
        }
    }
}

/**
 @return YES if the game is over. Otherwise NO.
 */
-(BOOL)checkGameOver{

    return [gamescene isGameOver];
}

/**
 Brick stuff, including drop the next brick, generate new backups and clear the lined bricks.
 */
-(void)handleBricks{
    if (accumulatedFrames >= FPS / gameSpeed) {
        //Time to deal with that brick!
        //Reset frames
        accumulatedFrames = 0;
        
        if (gamescene.thebrick == nil) {
            //Generating a new brick
            [self generateNewBrick];

        }
        
        if ([gamescene brickReachesBottom]) {
            
            //Reaches bottom, add the brick to board
            [gamescene stablizeBrick:gamescene.thebrick];
            
            //Eliminate this brick so that a new one will be generated next round
            gamescene.thebrick = nil;

        }
        
        if (![gamescene removeEmptyLines]){
            //No empty line was removed
            //move down the brick
            [self brickFall];
        }
        
        //Check if there is one or more complete lines.
        [self.gamescene checkClearLine];
        
        
    }
    
}



/**
 Generate a new brick
 */
-(void)generateNewBrick{
    gamescene.thebrick = [STBrickNode randomBrick];
    [gamescene.thebrick rotateRandom];
    [gamescene resetBrickToTop];
    NSLog(@"%@", gamescene.thebrick);
}

/**
 Move all the bricks down.

 This includes both the single brick and the existing ones, since some of the bricks might be floating due to previous clear.

 */
-(BOOL)brickFall{
    BOOL result = NO;
    if (gamescene.thebrick==nil) {
        //No brick now
        return result;
    }
    STBrickNode* newbrick = [gamescene.thebrick copy];
    [newbrick moveBrickDown];
    result = [gamescene checkCollisionWithBrick:newbrick]; //check ability to move forward
    if (!result) {
        //No problem to move down
        [gamescene.thebrick moveBrickDown];
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

/**
 Handles swipe actions. Those actions are for brick movements.
 */
- (void)handleSwipeAction:(UISwipeGestureRecognizer*)gesture {
    if (gamePaused || [self checkGameOver]) {
        //Game is over or paused, no movement
        return;
    }
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            [gamescene moveBrickLeft];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            [gamescene moveBrickRight];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            [gamescene moveBrickDown];
            break;
        case UISwipeGestureRecognizerDirectionUp:
            //Swipe up means to rotate
            [gamescene rotateBrick];//right?
            break;
        default:
            break;
    }
}

/**
 * Handles tap actions. Those actions are for game scene logic: Pause/Resume, or Restart game.
 */
-(void)handleTapAction:(UITapGestureRecognizer*)gesture{
    if (gamePaused) {
        gamePaused = NO;
    }
    if ([self checkGameOver]) {
        [gamescene resetBoard];
    }
}
@end
