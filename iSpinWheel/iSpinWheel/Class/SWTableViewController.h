//
//  SWTableViewController.h
//  iSpinWheel
//
//  Created by Zion on 6/5/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "UIViewController_z.h"
#import "SWTableViewCell.h"
#import "SWSchemeManager.h"

#define CellHeight (44)
#define HeaderHeight (30)
#define FooterHeight (22)

@interface SWTableViewController : UIViewController_z<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) SWSchemeManager *schemeManager;
@property (assign, nonatomic) BOOL isEditMode;
@property (assign, nonatomic) SchemeGroupType schemeGroupType;

@end
