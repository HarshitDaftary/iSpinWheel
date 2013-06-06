//
//  SchemeTableViewController.m
//  iSpinWheel
//
//  Created by Zion on 6/4/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "SchemeTableViewController.h"
#import "SWTableViewCell.h"
#import "SWSchemeManager.h"
#import "WheelMenuTableViewController.h"
#import "HeaderView.h"
#import "SchemeTableViewCell.h"

#define UIAlertViewTagRestore (100)
#define UIAlertViewTagDelete (101)

@interface SchemeTableViewController ()
{

}
@property (nonatomic, strong) NSString *schemeNameToDelete;

@end

@implementation SchemeTableViewController
@synthesize tableView=_tableView;
@synthesize schemeManager=_schemeManager;
@synthesize schemeNameToDelete=_schemeNameToDelete;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (id)initWithSchemeGroupType:(SchemeGroupType)type
{
    self=[super init];
    if (self)
    {
        self.schemeGroupType=type;
        self.schemeManager=[SWSchemeManager shareInstanceOfSchemeType:type];
        [self.schemeManager addObserver:self forKeyPath:@"schemeNameInUsing_v" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleView.title.text=@"我的方案";
    
    [self setTitleButtonType:TitleButtonType_Back forLeft:YES];
    [self setTitleButtonType:TitleButtonType_Restore forLeft:NO];
    
}

- (void)dealloc
{
    [self.schemeManager removeObserver:self forKeyPath:@"schemeNameInUsing_v"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark - User interaction -

-(void)titleLeftButtonClick:(id)sender
{
    [self goBack:sender];
}

-(void)titleRightButtonClick:(id)sender
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:@"确定恢复默认方案？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"恢复", nil];
    alertView.tag=UIAlertViewTagRestore;
    [alertView show];
}

- (void)addButtonClick:(id)sender
{
    NSString *newName_base=@"新方案";
    NSString *newName_attempt=newName_base;
    NSInteger counter=1;
    while (NSNotFound!=[[self.schemeManager schemeNameList] indexOfObject:newName_attempt])
    {
        newName_attempt=[newName_base stringByAppendingFormat:@" %02d",counter++];
    }
    [self.schemeManager schemeAdded:newName_attempt];
    [self.schemeManager commitChanging];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate -
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderView *hView=[HeaderView headerView];
    hView.titleLabel.text=@"方案列表";
    [hView.addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return hView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WheelMenuTableViewController *menuTVC=[[WheelMenuTableViewController alloc] initWithSchemeName:[[self.schemeManager schemeNameList] objectAtIndex:indexPath.row]  schemeGroupType:self.schemeGroupType];
    [[SWNavigationController shareNavigationController] pushViewController:menuTVC animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete==editingStyle)
    {
        self.schemeNameToDelete=[[self.schemeManager schemeNameList] objectAtIndex:indexPath.row];
        NSString *message=[@"确定删除" stringByAppendingFormat:@"\"%@\"?",self.schemeNameToDelete];
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        alertView.tag=UIAlertViewTagDelete;
        [alertView show];
    }
    
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.schemeManager schemeNameList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseId = @"Cell_In_SchemeTableViewController";
    SchemeTableViewCell* swcell = (SchemeTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:reuseId];
    if (nil==swcell)
    {
        swcell=(SchemeTableViewCell*)[SchemeTableViewCell tableViewCell];
    }
    
    NSInteger row=indexPath.row;
    NSInteger totalRow=[self tableView:tableView numberOfRowsInSection:indexPath.section];
    CellPlaceType type=CellPlaceType_Unknown;
    if (1==totalRow)
    {
        type=CellPlaceType_Alone;
    }
    else
    {
        if (0==row)
        {
            type=CellPlaceType_Top;
        }
        else if (totalRow-1==row)
        {
            type=CellPlaceType_Bottom;
        }
        else
        {
            type=CellPlaceType_Middle;
        }
    }
    swcell.indexPath=indexPath;
    NSString *text=[[self.schemeManager schemeNameList] objectAtIndex:row];
    swcell.isInUsing=[text isEqualToString:[self.schemeManager schemeNameInUsing]];
    [swcell configureCellWithText:text placeType:type];
    
    return swcell;
}

#pragma mark - UIAlertViewDelegate -
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (UIAlertViewTagRestore==alertView.tag)
    {
        if (1==buttonIndex)
        {
            [self.schemeManager restoreToDefault];
            [self.tableView reloadData];
        }
    }
    else if (UIAlertViewTagDelete==alertView.tag)
    {
        if (1==buttonIndex)
        {
            if ([self.schemeManager schemeDeleted:self.schemeNameToDelete])
            {
                [self.schemeManager commitChanging];
            }
            [self.tableView reloadData];
        }
        self.schemeNameToDelete=nil;
    }
}

#pragma mark - KVO -
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:self.schemeManager])
    {
        if ([keyPath isEqualToString:@"schemeNameInUsing_v"])
        {
            [self.tableView reloadData];
        }
    }
}



@end
