//
//  SWViewController.m
//  iSpinWheel
//
//  Created by xunlei on 3/29/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "SWViewController.h"
#import "SWNavigationController.h"


@interface SWViewController ()

@end

@implementation SWViewController

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
    self.navigationController.navigationBarHidden=NO;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonClick:)];
    
}

- (void)hideTitleViewWithAnimation:(BOOL)animate
{
    if (animate)
    {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.navigationController.navigationBar.frame=CGRectMake(0, -44, 320, 44);
            self.navigationController.navigationBar.alpha=0.0f;
        }completion:^(BOOL finished){
            self.navigationController.navigationBar.hidden=YES;
        }];
    }
    else
    {
            self.navigationController.navigationBar.hidden=YES;
    }
}

- (void)showTitleViewWithAnimation:(BOOL)animate
{
    UIView *animateView=self.navigationController.navigationBar;
    if (animate)
    {
        
        animateView.hidden=NO;
        animateView.alpha=0.0f;
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            animateView.frame=CGRectMake(0, 20, 320, 44);
            animateView.alpha=1.0f;
        }completion:^(BOOL finished){
        }];
    }
    else
    {
        animateView.frame=CGRectMake(0, 20, 320, 44);
        animateView.hidden=NO;
        animateView.alpha=1.0f;
        
    }
}


- (void)editButtonClick:(id)sender
{
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
