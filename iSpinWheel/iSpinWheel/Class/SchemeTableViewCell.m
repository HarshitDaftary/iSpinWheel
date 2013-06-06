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


-(void)setIsInUsing:(BOOL)isInUsing
{
    if (isInUsing==_isInUsing)
    {
        return;
    }
    self.schemeUsingTick.hidden=!isInUsing;
    _isInUsing=isInUsing;

}

- (void)configureCellWithText:(NSString *)text placeType:(CellPlaceType)type
{
    self.label.text=text;
    [super configureCellWithText:text placeType:type];
    
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
