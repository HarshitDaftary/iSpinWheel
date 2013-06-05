//
//  WheelMenuTableViewController.m
//  iSpinWheel
//
//  Created by Zion on 6/4/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "WheelMenuTableViewController.h"
#import "HeaderView.h"
#import "WheelMenuTableViewCell.h"

@interface WheelMenuTableViewController ()
{
}

@property (nonatomic, copy) NSString *schemeName;

@end

@implementation WheelMenuTableViewController
@synthesize schemeName=_schemeName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSchemeName:(NSString *)schemeName schemeGroupType:(SchemeGroupType)type
{
    self =[super init];
    if (self)
    {
        self.schemeName=schemeName;
        self.schemeGroupType=type;
        self.schemeManager=[SWSchemeManager shareInstanceOfSchemeType:type];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleView.title.text=self.schemeName;
    
    [self setTitleButtonType:TitleButtonType_Back forLeft:YES];
    [self setTitleButtonType:TitleButtonType_Text forLeft:NO];
    
    [self.titleView.rightButton setTitle:@"使用" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - user interaction -

-(void)titleLeftButtonClick:(id)sender
{
    [self goBack:sender];
}

-(void)titleRightButtonClick:(id)sender
{
    [self.schemeManager setSchemeInUsing:self.schemeName];
    [self goBack:sender];
}


#pragma mark - UITableViewDelegate -
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title=nil;
    switch (self.schemeGroupType) {
        case SchemeGroupType_MonoWheel:
            title=@"大圈";
            break;
        case SchemeGroupType_BiWheel:
            if (0==section)
            {
                title=@"小圈";
            }
            else
            {
                title=@"大圈";
            }
            break;
        case SchemeGroupType_TriWheel:
            if (0==section)
            {
                title=@"小圈";
            }
            else if (1==section)
            {
                title=@"中圈";
            }
            else
            {
                title=@"大圈";
            }
            break;
        default:
            break;
    }
    HeaderView *hView=[HeaderView headerView];
    hView.titleLabel.text=title;
    return hView;
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (self.schemeGroupType)
    {
        case SchemeGroupType_MonoWheel:
            return 1;
            break;
        case SchemeGroupType_BiWheel:
            return 2;
            break;
        case SchemeGroupType_TriWheel:
            return 3;
            break;
            
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.schemeManager wheelArrayOfScheme:self.schemeName] objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseId = @"Cell_In_WheelMenuTableViewController";
    WheelMenuTableViewCell* swcell = (WheelMenuTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:reuseId];
    if (nil==swcell)
    {
        swcell=[WheelMenuTableViewCell tableViewCell];
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
    [swcell configureCellWithText:[self.schemeManager stringAtIndex:row forWheel:indexPath.section ofScheme:self.schemeName] placeType:type];
    
    return swcell;
}


@end
