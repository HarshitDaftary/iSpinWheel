//
//  MonoWheelController.m
//  iWheel
//
//  Created by xunlei on 2/21/13.
//
//

#import "MonoWheelController.h"
#import "ZNImageWheel.h"
#import "WheelInfoViewController.h"
#import "SWNavigationController.h"

@interface MonoWheelController ()
{
    IBOutlet ZNImageWheel *_imageWheel;
    IBOutlet UILabel *_label;
}
@end

@implementation MonoWheelController

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
    self.title=@"单轮";
    SWLog(@"bar frame=%@",NSStringFromCGRect(self.navigationController.navigationBar.frame));
    
}

- (void)loadWheelUI
{
    [super loadWheelUI];
    
    
    [_imageWheel initialize];
    [_imageWheel setColorImageWithSegmentNumber:20 segmentColorArray:nil];
    [_imageWheel startAnimating:self];
    [_imageWheel setDrag:0.5];
    [_imageWheel setMaxVelocity:50];
    _imageWheel.delegate=self;
    
}

- (void)editButtonClick:(id)sender
{
    WheelInfoViewController *infoVC=[[WheelInfoViewController alloc] init];
    [[SWNavigationController shareNavigationController] pushViewController:infoVC animated:YES];
    return;
    
    if (NO==_imageWheel.isEditMode)
    {
        [_imageWheel startEditAnimationWithDelay:0];
    }
    else
    {
        [_imageWheel stopEditAnimation];
    }
}

- (void)didStopSpinWheel:(ZNImageWheel *)imgWheel atSegment:(NSInteger)index selectedText:(NSString *)text automatic:(BOOL)isAuto
{
    _label.text=text;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    _label = nil;
    _imageWheel = nil;
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _imageWheel.delegate=nil;
    [super viewWillDisappear:animated];
}
@end
