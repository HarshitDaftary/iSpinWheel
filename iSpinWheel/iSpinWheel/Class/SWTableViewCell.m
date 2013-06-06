//
//  SWTableViewCell.m
//  iSpinWheel
//
//  Created by Zion on 6/4/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "SWTableViewCell.h"

@interface SWTableViewCell ()
{
    CellPlaceType _placeType;
}

@end

@implementation SWTableViewCell
@synthesize backgroundImageView=_backgroundImageView;
@synthesize indexPath=_indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+(id)tableViewCell
{
    SWTableViewCell *cell=(SWTableViewCell*)[UIView viewWithNib:NSStringFromClass([self class]) owner:nil];
    return cell;
}


- (void)initialize
{
    
}

- (void)awakeFromNib
{
    [self initialize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    if (NO!=selected)
    {
        [self setBackgroundImageViewSelected:YES];
        [self syncTask:^{
            [self setBackgroundImageViewSelected:NO];
        }after:0.5];
    }
}

+ (UIImage*)imageBySelected:(BOOL)isSel placeType:(CellPlaceType)type
{
    NSString *imageName=nil;
    switch (type) {
        case CellPlaceType_Alone:
            imageName=@"table_cell_bk_alone";
            break;
        case CellPlaceType_Top:
            imageName=@"table_cell_bk_top";
            break;
        case CellPlaceType_Middle:
            imageName=@"table_cell_bk_center";
            break;
        case CellPlaceType_Bottom:
            imageName=@"table_cell_bk_bottom";
            break;
        case CellPlaceType_Unknown:
        default:
            NSAssert(YES, @"CellPlaceType error.");
            break;
    }
    if (isSel)
    {
        imageName=[imageName stringByAppendingString:@"_sel"];
    }
    
    return [UIImage resizeableImageNamed:imageName];
    
}

- (void)configureCellWithText:(NSString *)text placeType:(CellPlaceType)type
{
    if (_placeType!=type)
    {
        self.backgroundImageView.image=[SWTableViewCell imageBySelected:NO placeType:type];
        _placeType=type;
    }
}

/*
- (void)layoutSubviews
{
    [super layoutSubviews];
    for(UIView *subview in self.subviews)
    {
        if([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"])
        {
//            UIView *deleteButtonView=(UIView*)[subview.subviews objectAtIndex:0];
//            deleteButtonView.frame=CGRectMake(229, 12, 34, 20);
            subview.frame=CGRectMake(229, 12, 34, 20);
        }
    }
}
 */


/*
- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask)
    {
        for (UIView *subview in self.subviews)
        {
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"])
            {
                [subview removeFromSuperview];
//                subview.hidden = YES;
//                subview.alpha = 0;
//                subview.frame = CGRectMake(229,12,34,20);
            }
        }
    }
}
 */

/*
- (void)didTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask)
    {
        for (UIView *subview in self.subviews)
        {
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"])
            {
//                subview.frame = CGRectMake(subview.frame.origin.x - 10, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height);
                subview.frame = CGRectMake(229,12,34,20);
                subview.hidden = NO;
                
                [UIView beginAnimations:@"anim" context:nil];
                subview.alpha = 1;
                [UIView commitAnimations];
            }
        }
    }
}
*/

#pragma mark - user interaction -

-(void)setBackgroundImageViewSelected:(BOOL)isSel
{
    self.backgroundImageView.image=[SWTableViewCell imageBySelected:isSel placeType:_placeType];
}


@end
