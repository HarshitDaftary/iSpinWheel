//
//  SWTableViewController.m
//  iSpinWheel
//
//  Created by Zion on 6/5/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "SWTableViewController.h"
#import "HeaderView.h"

@interface SWTableViewController ()
{
}

@end

@implementation SWTableViewController
@synthesize tableView=_tableView;
@synthesize schemeManager=_schemeManager;
@synthesize schemeGroupType=_schemeGroupType;

- (id)init
{
    self=[super initWithNibName:@"SWTableViewController" bundle:nil];
    if (self)
    {

    }
    return self;
}

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
    // Do any additional setup after loading the view from its nib.

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - user interaction -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isEqual:self.view]||[touch.view isEqual:self.tableView])
    {
        return [self shouldAnimatTitleView];
    }
    return NO;
}


#pragma mark - UITableViewDelegate -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}


#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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
        
        CGFloat viewHeight=[[UIScreen mainScreen] bounds].size.height-20;
        CGRect frame=self.tableView.frame;
        frame.origin.y=20;
        frame.size.height=viewHeight-20;
        self.tableView.frame=frame;
        
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
        
        CGFloat viewHeight=[[UIScreen mainScreen] bounds].size.height-20;
        CGRect frame=self.tableView.frame;
        frame.origin.y=64;
        frame.size.height=viewHeight-64;
        self.tableView.frame=frame;
        
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<-20)
    {
        if (NO!=self.titleView.hidden)
        {
            [self showTitleViewWithAnimation:YES];
        }
    }
    
}

@end
