//
//  UIColor+RandomColor.m
//  DotsTest
//
//  Created by Diego on 25/03/15.
//  Copyright (c) 2015 Robosoft. All rights reserved.
//

#import "UIColor+RandomColor.h"

@implementation UIColor (RandomColor)


+ (UIColor*)randomColor
{
    
     NSArray *colorList = [NSArray arrayWithObjects:[UIColor redColor], [UIColor blueColor], [UIColor blackColor],nil];
    return colorList[arc4random_uniform(colorList.count)];
}
@end
