//
//  SchemeTableViewCell.m
//  iSpinWheel
//
//  Created by Zion on 6/5/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "SchemeTableViewCell.h"

@implementation SchemeTableViewCell
@synthesize isInUsing=_isInUsing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - UITextFieldDelegate -
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.arrowImageView.hidden=YES;
    [super textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.arrowImageView.hidden=NO;
    [super textFieldDidEndEditing:textField];
}

-(void)setIsInUsing:(BOOL)isInUsing
{
    if (isInUsing==_isInUsing)
    {
        return;
    }
    self.schemeUsingTick.hidden=!isInUsing;
    _isInUsing=isInUsing;

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
