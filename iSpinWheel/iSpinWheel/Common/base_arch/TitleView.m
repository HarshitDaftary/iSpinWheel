//
//  TitleView.m
//  iSpinWheel
//
//  Created by Zion on 6/3/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "TitleView.h"

@implementation TitleView
@synthesize leftButton=_leftButton;
@synthesize title=_title;
@synthesize rightButton=_rightButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (TitleView*)titleView
{
    TitleView *tv=(TitleView*)[UIView viewWithNib:@"TitleView" owner:nil];
    return tv;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
