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
    BOOL _isKeyBoardShowing;
}

@end

@implementation SWTableViewController
@synthesize tableView=_tableView;
@synthesize schemeManager=_schemeManager;
@synthesize isEditMode=_isEditMode;
@synthesize schemeGroupType=_schemeGroupType;

- (id)init
{
    self=[super initWithNibName:@"SWTableViewController" bundle:nil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    if (_isKeyBoardShowing)
    {
        return;
    }
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
    if (_isKeyBoardShowing)
    {
        return;
    }
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

#pragma mark - SWTableViewCellDelegate -
- (void)swtableviewcellDidBeginEditing:(SWTableViewCell *)cell
{
    SWLog(@"");
    _isEditMode=YES;
}

- (void)swtableviewcellDidEndEditing:(SWTableViewCell *)cell
{
    SWLog(@"");
}

- (void)swtableviewcellBeSelected:(SWTableViewCell *)cell
{
    SWLog(@"");
    if (_isEditMode)
    {
        
    }
    else
    {

    }
}

#pragma mark - keyboard -
- (void)keyboardWillShow:(NSNotification *)notification
{
	CGRect endFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve animationCurve	= [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
	NSTimeInterval animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView beginAnimations:@"showKeyboardAnimation" context:nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect frame=self.tableView.frame;
    if (self.titleView.hidden)
    {
        frame.origin.y=20;
    }
    else
    {
        frame.origin.y=64;
    }
    frame.size.height=endFrame.origin.y-20-frame.origin.y;
    self.tableView.frame=frame;
    
    [UIView commitAnimations];
    
    _isKeyBoardShowing=YES;

}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSTimeInterval animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	UIViewAnimationCurve animationCurve	= [[[notification userInfo] valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView beginAnimations:@"hideKeyboardAnimation" context:nil];
	[UIView setAnimationCurve:animationCurve];
	[UIView setAnimationDuration:animationDuration];
	
    CGRect frame=self.tableView.frame;
    if (self.titleView.hidden)
    {
        frame.origin.y=20;
    }
    else
    {
        frame.origin.y=64;
    }
    frame.size.height=[[UIScreen mainScreen] bounds].size.height-20-frame.origin.y;
    self.tableView.frame=frame;
	
	[UIView commitAnimations];
    
    _isKeyBoardShowing=NO;

}

@end
