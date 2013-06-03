//
//  MainViewController.m
//  iWheel
//
//  Created by xunlei on 2/21/13.
//
//

#import "MainViewController.h"
#import "SWNavigationController.h"
#import "MonoWheelController.h"
#import "BiWheelController.h"
#import "TriWheelController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    self.titleView.title.text=@"O(∩_∩)O";
}

- (BOOL)shouldAnimatTitleView
{
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onButtonClick:(id)sender
{
    UIButton* button=(UIButton*)sender;
    if (0==button.tag)
    {
        [[SWNavigationController shareNavigationController] pushViewController:[[MonoWheelController alloc] init] animated:YES];
    }
    else if (1==button.tag)
    {
        [[SWNavigationController shareNavigationController] pushViewController:[[BiWheelController alloc] init] animated:YES];
        
    }
    else if (2==button.tag)
    {
        [[SWNavigationController shareNavigationController] pushViewController:[[TriWheelController alloc] init] animated:YES];
        
    }
    else
    {
        NSAssert(NO, @"button tag error");
    }
}

@end
