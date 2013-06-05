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

@interface SchemeTableViewController ()
{

}

@end

@implementation SchemeTableViewController
@synthesize tableView=_tableView;
@synthesize schemeManager=_schemeManager;

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
    [self setTitleButtonType:TitleButtonType_Edit forLeft:NO];
    
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

#pragma mark - User interaction -

-(void)titleLeftButtonClick:(id)sender
{
    [self goBack:sender];
}

-(void)titleRightButtonClick:(id)sender
{
    
}

#pragma mark - UITableViewDelegate -
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderView *hView=[HeaderView headerView];
    hView.titleLabel.text=@"方案列表";
    return hView;
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning test code
//    return [[self.schemeManager schemeNameList] count];
    NSInteger count=[[self.schemeManager schemeNameList] count];
    if (self.schemeGroupType==SchemeGroupType_MonoWheel)
    {
        count*=10;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseId = @"Cell_In_SchemeTableViewController";
    SchemeTableViewCell* swcell = (SchemeTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:reuseId];
    if (nil==swcell)
    {
        swcell=(SchemeTableViewCell*)[SchemeTableViewCell tableViewCell];
        swcell.swcellDelegate=self;
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
#warning test code
//    NSString *text=[[self.schemeManager schemeNameList] objectAtIndex:row];
    NSString *text=[[self.schemeManager schemeNameList] objectAtIndex:row%[[self.schemeManager schemeNameList] count]];
    swcell.isInUsing=[text isEqualToString:[self.schemeManager schemeNameInUsing]];
    [swcell configureCellWithText:text placeType:type];
    
    return swcell;
}

#pragma mark - SWTableViewCellDelegate -
- (void)swtableviewcellDidBeginEditing:(SWTableViewCell *)cell
{
    [super swtableviewcellDidBeginEditing:cell];
}

- (void)swtableviewcellDidEndEditing:(SWTableViewCell *)cell
{
    [super swtableviewcellDidEndEditing:cell];
}

- (void)swtableviewcellBeSelected:(SWTableViewCell *)cell
{
    SWLog(@"");
    if (self.isEditMode)
    {
        
    }
    else
    {
        WheelMenuTableViewController *menuTVC=[[WheelMenuTableViewController alloc] initWithSchemeName:[[self.schemeManager schemeNameList] objectAtIndex:cell.indexPath.row]  schemeGroupType:self.schemeGroupType];
        [[SWNavigationController shareNavigationController] pushViewController:menuTVC animated:YES];

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
