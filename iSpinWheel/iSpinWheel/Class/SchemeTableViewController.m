//
//  SchemeTableViewController.m
//  iSpinWheel
//
//  Created by Zion on 6/4/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "SchemeTableViewController.h"
#import "SWTableViewCell.h"
#import "WheelSchemeManager.h"

@interface SchemeTableViewController ()
{
    CGPoint _contentOffset;
}

@property (nonatomic, assign) WheelSchemeManager *schemeManager;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleView.title.text=@"我的方案";
    
    [self setTitleButtonType:TitleButtonType_Back forLeft:YES];
    [self.titleView.leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setTitleButtonType:TitleButtonType_Edit forLeft:NO];
    [self.titleView.rightButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.schemeManager=[WheelSchemeManager shareInstanceOfSchemeType:SchemeGroupType_MonoWheel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - user interaction -
- (void)editButtonClick:(id)sender
{
    
}

#pragma mark - UITableViewDelegate -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.schemeManager schemeNameList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseId = @"Cell_In_SchemeTableViewController";
    SWTableViewCell* swcell = (SWTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:reuseId];
    if (nil==swcell)
    {
        swcell = (SWTableViewCell*)[UIView viewWithNib:@"SWTableViewCell" owner:nil];
        swcell.editDelegate=self;
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
    [swcell configureCellWithText:[[self.schemeManager schemeNameList] objectAtIndex:row] placeType:type];
    
    return swcell;
}

#pragma mark - title View animation -
#pragma mark override
- (void)hideTitleViewWithAnimation:(BOOL)animate
{
    UIView *animateView=self.titleView;
    void (^preAction)(void)=^(void)
    {
        
    };
    void (^animatingAction)(void)=^(void)
    {
        animateView.frame=CGRectMake(0, -44, 320, 44);
        animateView.alpha=0.0f;
        
        self.tableView.contentOffset=CGPointMake(0, -20);
        self.tableView.contentInset=UIEdgeInsetsMake(20, 0, 20, 0);
        
    };
    void (^finishAction)(BOOL)=^(BOOL finished)
    {
        animateView.hidden=YES;
    };
    
    preAction();
    if (animate)
    {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:animatingAction completion:finishAction];
    }
    else
    {
        animatingAction();
        finishAction(YES);
    }
}

- (void)showTitleViewWithAnimation:(BOOL)animate
{
    
    UIView *animateView=self.titleView;
    
    void (^preAction)(void)=^(void)
    {
        animateView.hidden=NO;
        animateView.alpha=0.0f;
    };
    void (^animatingAction)(void)=^(void)
    {
        animateView.frame=CGRectMake(0, 0, 320, 44);
        animateView.alpha=1.0f;
        
        self.tableView.contentOffset=CGPointMake(0, -20-44);
        self.tableView.contentInset=UIEdgeInsetsMake(20+44, 0, 20, 0);
        
    };
    void (^finishAction)(BOOL)=^(BOOL finished)
    {
    };
    
    preAction();
    if (animate)
    {
        
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:animatingAction completion:finishAction];
    }
    else
    {
        animatingAction();
        finishAction(YES);
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _contentOffset=scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (NO==scrollView.dragging)
    {
        return;
    }
    CGPoint curOffset=scrollView.contentOffset;
    CGFloat delta=curOffset.y-_contentOffset.y;
    const CGFloat threshold=60;
    if (delta>=threshold)
    {
        if (NO==self.titleView.hidden)
        {
            [self hideTitleViewWithAnimation:YES];
        }
        _contentOffset=curOffset;
    }
    else if (delta<=-threshold)
    {
        if (NO!=self.titleView.hidden)
        {
            [self showTitleViewWithAnimation:YES];
        }
        _contentOffset=curOffset;
    }
    
}

#pragma mark - SWTableViewCellDelegate -
- (void)swtableviewcellDidBeginEditing:(SWTableViewCell *)cell
{
    SWLog(@"");
}

- (void)swtableviewcellDidEndEditing:(SWTableViewCell *)cell
{
    SWLog(@"");
}



@end
