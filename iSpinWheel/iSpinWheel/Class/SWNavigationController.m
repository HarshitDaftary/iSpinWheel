//
//  iWNavigationController.m
//  iWheel
//
//  Created by 锡安 冯 on 13-2-7.
//  Copyright (c) 2013年 HUST. All rights reserved.
//

#import "SWNavigationController.h"
#import "SWAppDelegate.h"

@interface SWNavigationController ()

@end

@implementation SWNavigationController

+ (SWNavigationController*)shareNavigationController{
    SWAppDelegate* appdele=[UIApplication sharedApplication].delegate;
    return (SWNavigationController*)appdele.navigationController;
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
	// Do any additional setup after loading the view.
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
