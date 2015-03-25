//
//  DotView.m
//  DotsTest
//
//  Created by Diego on 25/03/15.
//  Copyright (c) 2015 Robosoft. All rights reserved.
//

#import "DotView.h"

@implementation DotView



- (id)initWithColor:(UIColor*)aColor
{
    
    self = [super initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    if (self) {
        
        self.color = aColor;
        self.shouldHighlight = false;
        
//        [self.layer setBorderColor:[UIColor redColor].CGColor];
//        [self.layer setBorderWidth:1.0];
        
        [self setUp];
    }
    
    return self;
    
}

- (void)setShouldHighlight:(BOOL)shouldHighlight
{
    _shouldHighlight = shouldHighlight;
    [self setNeedsDisplay];
}

- (BOOL)shouldHighlight
{
    return _shouldHighlight;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (self.shouldHighlight) {
        
        CGContextAddEllipseInRect(context, CGRectInset([self bounds], 2, 2));
        
        CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
        
        CGContextFillPath(context);
    }
    
    CGContextAddEllipseInRect(context, CGRectInset([self bounds], 4, 4));
    
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    
    CGContextFillPath(context);
}


- (void)setUp
{
    [self setBackgroundColor:[UIColor clearColor]];
    
}

@end
