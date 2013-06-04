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
@synthesize textField=_textField;
@synthesize arrowImageView=_arrowImageView;
@synthesize coverView=_coverView;
@synthesize swdelegate=_swdelegate;
@synthesize indexPath=_indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initialize
{
    self.textField.delegate=self;
    
    UITapGestureRecognizer *tapGestRcgr=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureResponder:)];
    tapGestRcgr.numberOfTapsRequired=2;
    tapGestRcgr.numberOfTouchesRequired=1;
    [self.coverView addGestureRecognizer:tapGestRcgr];
    
    UILongPressGestureRecognizer *longGestRcgr=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureResponder:)];
    [self.coverView addGestureRecognizer:longGestRcgr];
    
}

- (void)awakeFromNib
{
    [self initialize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.backgroundImageView.image=[SWTableViewCell imageBySelected:selected placeType:_placeType];
    if (NO==selected)
    {
        [self setTextFieldEditing:selected];
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
    self.textField.text=text;
    if (_placeType!=type)
    {
        self.backgroundImageView.image=[SWTableViewCell imageBySelected:NO placeType:type];
        _placeType=type;
    }
}

#pragma mark - user interaction -
- (void)setTextFieldEditing:(BOOL)edit
{
    if (edit)
    {
        [self.textField becomeFirstResponder];
        self.coverView.hidden=YES;
        if (self.swdelegate&&[self.swdelegate respondsToSelector:@selector(swtableviewcellDidBeginEditing:)])
        {
            [self.swdelegate swtableviewcellDidBeginEditing:self];
        }
    }
    else
    {
        [self.textField resignFirstResponder];
        self.coverView.hidden=NO;
        if (self.swdelegate&&[self.swdelegate respondsToSelector:@selector(swtableviewcellDidEndEditing:)])
        {
            [self.swdelegate swtableviewcellDidEndEditing:self];
        }
    }

    
}

- (void)doubleTapGestureResponder:(UITapGestureRecognizer*)tapGestureRcgr
{
    [self setTextFieldEditing:YES];
}

- (void)longPressGestureResponder:(UILongPressGestureRecognizer*)longPressGestureRcgr
{
    [self setTextFieldEditing:YES];
    
}

#pragma mark - UITextFieldDelegate -
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.arrowImageView.hidden=YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.arrowImageView.hidden=NO;
}


@end
