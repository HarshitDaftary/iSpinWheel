//
//  WheelInfoViewController.m
//  iSpinWheel
//
//  Created by xunlei on 3/30/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "WheelInfoViewController.h"

@interface WheelInfoViewController ()
{
    UIBarButtonItem *_itemAdd;
    UIBarButtonItem *_itemEdit;
}

@end

@implementation WheelInfoViewController
@synthesize tableViewController=_tableViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=@"我的方案";
    _tableViewController=[[EditableTableViewController alloc] init];
    [self.view addSubview:_tableViewController.tableView];
    
    _itemAdd=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTableViewCell:)];
    _itemAdd.tintColor=[UIColor colorWithRed:0.1 green:0.1 blue:1.0 alpha:0.1];
    
    _itemEdit=self.navigationItem.rightBarButtonItem;
    _itemEdit.tag=0;
    
}

- (void)addTableViewCell:(id)sender
{
    
}

- (void)editButtonClick:(id)sender
{
    UIBarButtonItem *item=(UIBarButtonItem*)sender;
    if (0==item.tag)
    {
        item.title=@"完成";
        item.tag=1;
        item.tintColor=[UIColor colorWithRed:1.0 green:1.0 blue:0.1 alpha:0.1];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:_itemEdit,_itemAdd, nil] animated:YES];
    }
    else
    {
        item.title=@"编辑";
        item.tag=0;
        item.tintColor=nil;
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:_itemEdit, nil] animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
