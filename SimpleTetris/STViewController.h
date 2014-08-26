//
//  STViewController.h
//  SimpleTetris
//

//  Copyright (c) 2014年 jacul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STGameScene.h"

@interface STViewController : UIViewController{
}

@property (strong, nonatomic) NSTimer* looper;
@property (strong, nonatomic) STGameScene* gamescene;

@end
