//
//  ViewController.h
//  DotsTest
//
//  Created by Diego on 25/03/15.
//  Copyright (c) 2015 Robosoft. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol DotsViewDelegate <NSObject,UIDynamicAnimatorDelegate>


- (void)userScoreUpdatedWithScore:(NSInteger)aScore;

@end


@interface ViewController : UIViewController



@property (strong) NSMutableArray *dotRows;
@property (strong) UIGravityBehavior *gravityBehavior;
@property (strong) UICollisionBehavior *collissionBehavior;
@property (strong) UIDynamicAnimator *animator;
@property (assign) NSInteger score;

@property (strong) NSMutableArray *touchedDots;
@property (assign) id<DotsViewDelegate> delegate;

@end

