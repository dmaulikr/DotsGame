//
//  ViewController.m
//  DotsTest
//
//  Created by Diego on 25/03/15.
//  Copyright (c) 2015 Robosoft. All rights reserved.
//

#import "ViewController.h"
#import "DotView.h"
#import "UIColor+RandomColor.h"
#define kBallDiameter 55
#define kNumberOfBalls 4

@interface ViewController ()

@end

@implementation ViewController


- (void)dealloc
{
    [self.animator removeAllBehaviors];
    [self.animator setDelegate:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setFrame:CGRectMake(0, 0, (kBallDiameter + 10)* kNumberOfBalls, kBallDiameter * kNumberOfBalls)];

    [self.view setExclusiveTouch:YES];
    
    self.score = 0;
    [self setupAnimators];
    
    self.dotRows = [self createDotMatrixStartingFromPoint:[self.view frame].origin];
    [self.animator addBehavior:self.collissionBehavior];
    [self.animator addBehavior:self.gravityBehavior];
    [self.animator addBehavior:self.bounceBehavior];
    
    [self.animator setDelegate:self];
}

- (void)setUpCollisionBehaviorAtPoint:(CGPoint)aPoint height:(CGFloat)height
{
    [self.collissionBehavior addBoundaryWithIdentifier:NSStringFromCGPoint(aPoint) fromPoint:CGPointMake(aPoint.x,aPoint.y - 600)
                                               toPoint:CGPointMake(aPoint.x, aPoint.y + height)];

    
    [self.collissionBehavior addBoundaryWithIdentifier:[NSString stringWithFormat:@"%@%@",NSStringFromCGPoint(aPoint),@"2"] fromPoint:CGPointMake(aPoint.x + kBallDiameter  ,aPoint.y - 600)
                                               toPoint:CGPointMake(aPoint.x + kBallDiameter , aPoint.y + height)];


}

- (void)setupAnimators
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.collissionBehavior = [[UICollisionBehavior alloc] init];
    self.bounceBehavior = [[UIDynamicItemBehavior alloc] init];
    
    self.bounceBehavior.elasticity = 0.6 ;
    
    CGPoint currentPoint = CGPointMake(0, 0);
    
    for (NSInteger i = 0; i < 4; i ++) {
        [self setUpCollisionBehaviorAtPoint:currentPoint height:kBallDiameter * 5];
        
        currentPoint = CGPointApplyAffineTransform(currentPoint, CGAffineTransformMakeTranslation(70, 0));
    }
    

    
    [self.collissionBehavior addBoundaryWithIdentifier:@"Bottom" fromPoint:CGPointMake(CGRectGetMinX([self.view frame]), CGRectGetMaxY([self.view frame]))
                                               toPoint:CGPointMake(CGRectGetMaxX([self.view frame]), CGRectGetMaxY([self.view frame]))];
    
    [self.collissionBehavior setCollisionMode:UICollisionBehaviorModeEverything];
    
    self.gravityBehavior = [[UIGravityBehavior alloc] init];
}


- (NSMutableArray*)createDotMatrixStartingFromPoint:(CGPoint)currentPoint
{
    NSMutableArray *dotRows = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 4 ; i ++) {
        [dotRows addObject:[self createRowStartingFrom:currentPoint count:4 row:i]];
        currentPoint = CGPointApplyAffineTransform(currentPoint, CGAffineTransformMakeTranslation(0, kBallDiameter));
    }
    
    return dotRows;
}


- (NSMutableArray*)createRowStartingFrom:(CGPoint)currentPoint count:(NSInteger)count row:(NSInteger)row
{
    
    NSMutableArray *dots = [NSMutableArray array];
    
    for (NSInteger i = 0; i < count ; i ++) {
        
        DotView *dot = [[DotView alloc] initWithColor:[UIColor randomColor]];
        [dots addObject:dot];
        [dot setRow:row];
        [dot setColumn:i];
    
        [self configureDotViewAnimators:dot];
        
        [dot setFrame:CGRectMake(currentPoint.x, currentPoint.y, kBallDiameter - 2, kBallDiameter - 2)];
        currentPoint = CGPointApplyAffineTransform(currentPoint, CGAffineTransformMakeTranslation(kBallDiameter+10, 0));

    }
    
    return dots;
}

- (void)configureDotViewAnimators:(DotView*)dot
{
  
    [self.view addSubview:dot];
    [self.collissionBehavior addItem:dot];
    [self.gravityBehavior addItem:dot];
    [self.bounceBehavior addItem:dot];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touchedDots = [NSMutableArray array];
    [self handleTouch:[touches anyObject]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleTouch:[touches anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleTouch:[touches anyObject]];
    BOOL didScore = [self attemptRowRemoval] || [self attemptColumnRemoval];
    
    
    for (DotView* view in self.touchedDots) {
        
        [view setShouldHighlight:NO];
    }
    
    if (didScore) {
        [self incrementScore];
    }
}

- (void)incrementScore
{
    self.score += 10;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(userScoreUpdatedWithScore:)]) {
        [self.delegate userScoreUpdatedWithScore:self.score];
    }
}

- (void)handleTouch:(UITouch*)touch
{
    CGPoint touchPoint =  [touch locationInView:self.view];
    
    UIView *view = [self.view hitTest:touchPoint withEvent:nil];
    
    if ([view class] == [DotView class]) {
        
        if (![self.touchedDots containsObject:view]) {
            
            [(DotView*)view setShouldHighlight:YES];
            [self.touchedDots addObject:view];
        }
    }

}

- (BOOL)attemptRowRemoval
{
    if (self.touchedDots.count <= 1) {
        return false;
    }
    
    DotView *firstDot = self.touchedDots[0];

    for (NSInteger i = 1; i < self.touchedDots.count ; i ++) {
        
        DotView *view = self.touchedDots[i];
        
        if ([view color] != [firstDot color] || [view row] != [firstDot row]) {
            
            return false;
        }
    }

    NSInteger index = 0;
    for (DotView *view in self.touchedDots) {
        
        [self removeDotAtRow:view.row column:view.column];
        [self addDotAboveColumn:view.column offset:1];
        index ++;
    }
    

    return true;
}

- (BOOL)attemptColumnRemoval
{
    if (self.touchedDots.count <= 1) {
        return false;
    }
    
    DotView *firstDot = self.touchedDots[0];
    
    for (NSInteger i = 1; i < self.touchedDots.count ; i ++) {
        
        DotView *view = self.touchedDots[i];
        
        if ([view color] != [firstDot color] || [view column] != [firstDot column]) {
            
            return false;
        }
    }
    
    
    [self.touchedDots sortUsingComparator:^NSComparisonResult(DotView* obj1,DotView* obj2) {
     
        if ([obj1 row] < [obj2 row]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 row] > [obj2 row]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;

        
    }];
    
    NSInteger index = 0;
    
    for (DotView *view in self.touchedDots) {
        
        [self removeDotAtRow:view.row column:view.column];
        [self addDotAboveColumn:view.column offset:index+1];
        index++;
    }
    
    
    return true;
}

- (void)removeDotAnimators:(DotView*)view
{
    [self.collissionBehavior removeItem:view];
    [self.gravityBehavior removeItem:view];
    [self.bounceBehavior removeItem:view];

}

- (void)addDotAboveColumn:(NSInteger)column offset:(NSInteger)offset
{
    DotView *dot = [[DotView alloc] initWithColor:[UIColor randomColor]];
    [self.dotRows[0] replaceObjectAtIndex:column withObject:dot];
    [self.view addSubview:dot];
    [dot setFrame:CGRectMake(column* (kBallDiameter+15), -(kBallDiameter)*offset - (column * 10), kBallDiameter - 2, kBallDiameter - 2)];
    [dot setRow:0];
    [dot setColumn:column];
    [self configureDotViewAnimators:dot];
    [self.animator updateItemUsingCurrentState:dot];
}

- (void)removeDotAtRow:(NSInteger)row column:(NSInteger)column
{
    // first remove the dot
    
    NSMutableArray *dotRow = self.dotRows[row];
    DotView *view = dotRow[column];
    
    
    if ([view row] != row && [view column] != column) {
        return;
    }
    
    [self removeDotAnimators:view];
    
    [UIView animateWithDuration:0.25 animations:^{
    
        [view setAlpha:0.0];
        [view setCenter:CGPointMake(view.center.x, view.center.y + 10)];
        
                } completion:^(BOOL finished){
        
                        [view removeFromSuperview];
    }];
    
    

    [dotRow replaceObjectAtIndex:column withObject:[NSNull null]];
    
    // adjust everyone above
    
    if (row > 0) {
        for (NSInteger i = row - 1 ; i >= 0 ; i --) {
            
            NSArray *dotRow = self.dotRows[i];
            DotView *view = dotRow[column];
            [view setRow:view.row + 1];
            [self.dotRows[i+1] replaceObjectAtIndex:column withObject:view];
        }

    }
    
}



@end
