//
//  DotView.h
//  DotsTest
//
//  Created by Diego on 25/03/15.
//  Copyright (c) 2015 Robosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DotView : UIView
{
    BOOL _shouldHighlight;
}

@property (strong) UIColor* color;
@property (assign) NSInteger row;
@property (assign) NSInteger column;
@property (assign) BOOL shouldHighlight;
@property (strong) UIImageView *sphereImageView;

@property (assign) UIAttachmentBehavior *attachmentBehavior;

- (id)initWithColor:(UIColor*)aColor;



@end
