//
//  MainViewController.m
//  DotsTest
//
//  Created by Diego on 25/03/15.
//  Copyright (c) 2015 Robosoft. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setUpGame];

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setUpGame
{
    self.dotViewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    
    
    [self.view addSubview:self.dotViewController.view];
    
    
    [self.dotViewController.view setCenter:self.view.center];
    
    self.dotViewController.delegate = self;
    
    self.timeLeft = 30;
    
    [self userScoreUpdatedWithScore:0];
    
    
}

- (void)updateTimeWithValue:(NSInteger)aValue
{
    self.timeLeft = aValue;
    self.timeLabel.text = [NSString stringWithFormat:@"%d",self.timeLeft];
}

- (void)userScoreUpdatedWithScore:(NSInteger)aScore
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",aScore];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self startTimer];
    [self.gameOverLabel setHidden:YES];
    [self.startNewGameButton setHidden:YES];

}

- (void)startTimer
{
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)tick
{
    [self updateTimeWithValue:self.timeLeft - 1];
    
    if (self.timeLeft <= 0) {
        [self.dotViewController.view setUserInteractionEnabled:NO];
        [self.dotViewController.view removeFromSuperview];
        [self.countdownTimer invalidate];
        
        [self.gameOverLabel setHidden:NO];
        [self.startNewGameButton setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startNewGameButtonTapped:(id)sender {
    
    [self.gameOverLabel setHidden:YES];
    [self.startNewGameButton setHidden:YES];
    [self setUpGame];
    [self startTimer];
}
@end
