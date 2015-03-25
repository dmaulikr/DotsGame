//
//  MainViewController.h
//  DotsTest
//
//  Created by Diego on 25/03/15.
//  Copyright (c) 2015 Robosoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface MainViewController : UIViewController<DotsViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *gameOverLabel;
@property (weak) NSTimer* countdownTimer;
@property (assign) NSInteger timeLeft;
- (IBAction)startNewGameButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *startNewGameButton;
@property (strong) ViewController *dotViewController;
@end
