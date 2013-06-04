//
//  SWTableViewCell.h
//  iSpinWheel
//
//  Created by Zion on 6/4/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CellHeight (44)

typedef enum
{
    CellPlaceType_Unknown=0,
    CellPlaceType_Alone,
    CellPlaceType_Top,
    CellPlaceType_Middle,
    CellPlaceType_Bottom
}CellPlaceType;

@class SWTableViewCell;
@protocol SWTableViewCellDelegate <NSObject>

@required
- (void)swtableviewcellDidBeginEditing:(SWTableViewCell*)cell;
- (void)swtableviewcellDidEndEditing:(SWTableViewCell*)cell;

@end
//自定义背景，滑动删除，双击or长按重命名，header添加，uitextfield。
@interface SWTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (strong, nonatomic) IBOutlet UIView *coverView;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) id<SWTableViewCellDelegate> swdelegate;

- (void)configureCellWithText:(NSString*)text placeType:(CellPlaceType)type;

@end
