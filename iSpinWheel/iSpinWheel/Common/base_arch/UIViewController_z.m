//
//  UIViewController_z.m
//  iSpinWheel
//
//  Created by Zion on 6/3/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "UIViewController_z.h"
#import "TitleView.h"
#import "SWNavigationController.h"

@interface UIViewController_z ()

@end

@implementation UIViewController_z
@synthesize titleView=_titleView;

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
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"lightyellow"]];
    
    self.titleView=[TitleView titleView];
    self.titleView.backgroundImageView.image=[UIImage resizeableImageNamed:@"creamcolor_bk"];
    [self.view addSubview:self.titleView];
//    [self.view bringSubviewToFront:self.titleView];
    
    [self addTapGestureRecognizer];
}

- (void)dealloc
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - user interaction -
- (void)back:(id)sender
{
    [[SWNavigationController shareNavigationController] popViewControllerAnimated:YES];
}

#pragma mark - UI -
- (void)setTitleButtonType:(TitleButtonType)type forLeft:(BOOL)left
{
    UIButton *button=left?self.titleView.leftButton:self.titleView.rightButton;
    switch (type)
    {
        case TitleButtonType_Back:
            [button setBackgroundImage:[UIImage imageNamed:@"navi_btn_icon_back"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"navi_btn_icon_back_disabled"] forState:UIControlStateHighlighted];
            break;
        case TitleButtonType_Close:
            [button setBackgroundImage:[UIImage imageNamed:@"navi_btn_icon_close"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"navi_btn_icon_close_disabled"] forState:UIControlStateHighlighted];
            break;
        case TitleButtonType_Edit:
            [button setBackgroundImage:[UIImage imageNamed:@"navi_btn_icon_edit"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"navi_btn_icon_edit_disabled"] forState:UIControlStateHighlighted];
            break;
        case TitleButtonType_Text:
            [button setBackgroundImage:[UIImage imageNamed:@"navi_btn_bk_normal"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"navi_btn_bk_down"] forState:UIControlStateHighlighted];
            break;
        default:
            NSAssert(YES, @"error type.");
            break;
    }
}

- (BOOL)shouldAnimatTitleView
{
    return YES;
}

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

#pragma - tap gesture recognizer -

- (void)addTapGestureRecognizer
{
    //content view
    UITapGestureRecognizer* tapGest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    tapGest.delegate=self;
    [self.view addGestureRecognizer:tapGest];
}

- (void)handleTapGesture:(UITapGestureRecognizer*)tagGesture
{
    if (NO==self.titleView.hidden)
    {
        [self hideTitleViewWithAnimation:YES];
    }
    else
    {
        [self showTitleViewWithAnimation:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isEqual:self.view])
    {
        return [self shouldAnimatTitleView];
    }
    return NO;
}


@end
