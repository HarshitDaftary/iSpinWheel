//
//  SWTableViewController.h
//  iSpinWheel
//
//  Created by Zion on 6/5/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "UIViewController_z.h"
#import "SWSchemeManager.h"

#define CellHeight (44)
#define HeaderHeight (30)
#define FooterHeight (22)

@interface SWTableViewController : UIViewController_z<UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) SWSchemeManager *schemeManager;
@property (assign, nonatomic) SchemeGroupType schemeGroupType;

@end
