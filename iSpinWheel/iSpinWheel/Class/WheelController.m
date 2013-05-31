//
//  WheelController.m
//  iSpinWheel
//
//  Created by xunlei on 3/8/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "WheelController.h"
#import <QuartzCore/QuartzCore.h>
#import "SWAppDelegate.h"
#import <objc/runtime.h>
#import "SWNavigationController.h"

@interface WheelController ()
{
    UIView* _loadingView;
}
@end

@implementation WheelController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadWheelUI];
}


- (void)loadWheelUI
{
    //content view
    UITapGestureRecognizer* tapGest=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    tapGest.delegate=self;
    [self.view addGestureRecognizer:tapGest];
}
#pragma mark -
#pragma mark user interaction

- (void)handleTapGesture:(UITapGestureRecognizer*)tagGesture
{
    if (NO==self.navigationController.navigationBar.hidden)
    {
        [self hideTitleViewWithAnimation:YES];
    }
    else
    {
        [self showTitleViewWithAnimation:YES];
    }
}


#pragma mark -
#pragma mark SpinWheelDelegate
- (void)didStopSpinWheel:(ZNImageWheel *)imgWheel atSegment:(NSInteger)index selectedText:(NSString *)text automatic:(BOOL)isAuto
{
    //implement in subclass.
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isEqual:self.view])
    {
        return YES;
    }
    return NO;
}

@end
