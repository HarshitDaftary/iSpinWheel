//
//  SchemeTableViewController.h
//  iSpinWheel
//
//  Created by Zion on 6/4/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "UIViewController_z.h"
#import "SWTableViewCell.h"

@interface SchemeTableViewController : UIViewController_z<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
