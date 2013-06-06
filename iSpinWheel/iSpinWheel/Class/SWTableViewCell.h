//
//  SWTableViewCell.h
//  iSpinWheel
//
//  Created by Zion on 6/4/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    CellPlaceType_Unknown=0,
    CellPlaceType_Alone,
    CellPlaceType_Top,
    CellPlaceType_Middle,
    CellPlaceType_Bottom
}CellPlaceType;

//自定义背景，滑动删除，双击or长按重命名，header添加，uitextfield。
@interface SWTableViewCell : UITableViewCell

@property (assign, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) NSIndexPath *indexPath;

+ (id)tableViewCell;

- (void)configureCellWithText:(NSString*)text placeType:(CellPlaceType)type;

@end
