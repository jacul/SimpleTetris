//
//  STViewController.m
//  SimpleTetris
//
//  Created by zxd on 14-8-19.
//  Copyright (c) 2014年 jacul. All rights reserved.
//

#import "STViewController.h"
#import "STGameScene.h"

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view = [STGameScene new];

}

-(void)viewDidAppear:(BOOL)animated{
    if (self.looper==nil) {
        self.looper = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateEverything) userInfo:nil repeats:YES];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    if (self.looper && [self.looper isValid]) {
        [self.looper invalidate];
        self.looper = nil;
    }

}

-(void)updateEverything{

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
