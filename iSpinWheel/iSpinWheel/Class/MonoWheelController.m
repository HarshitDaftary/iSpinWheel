//
//  MonoWheelController.m
//  iWheel
//
//  Created by xunlei on 2/21/13.
//
//

#import "MonoWheelController.h"
#import "ZNImageWheel.h"
#import "SchemeTableViewController.h"
#import "DisplayTimer.h"

@interface MonoWheelController ()

@property (nonatomic, strong)    IBOutlet ZNImageWheel *imageWheel;
@property (nonatomic, strong)    IBOutlet UILabel *label;

@end

@implementation MonoWheelController
@synthesize imageWheel=_imageWheel;
@synthesize label=_label;

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
    self.titleView.title.text=@"单轮";
    [self setTitleButtonType:TitleButtonType_Back forLeft:YES];
    [self setTitleButtonType:TitleButtonType_More forLeft:NO];
    
    [self.imageWheel initialize];
    [self.imageWheel setColorImageWithSegmentNumber:20 segmentColorArray:nil];
    [self.imageWheel setDrag:0.5];
    [self.imageWheel setMaxVelocity:50];
    self.imageWheel.delegate=self;
    
}

-(void)titleLeftButtonClick:(id)sender
{
    [self goBack:sender];
}

-(void)titleRightButtonClick:(id)sender
{
    SchemeTableViewController *schemeVC=[[SchemeTableViewController alloc] initWithSchemeGroupType:SchemeGroupType_MonoWheel];
    [[SWNavigationController shareNavigationController] pushViewController:schemeVC animated:YES];
    return;
    
    if (NO==self.imageWheel.isEditMode)
    {
        [self.imageWheel startEditAnimationWithDelay:0];
    }
    else
    {
        [self.imageWheel stopEditAnimation];
    }
}

- (void)didStopSpinWheel:(ZNImageWheel *)imgWheel atSegment:(NSInteger)index selectedText:(NSString *)text automatic:(BOOL)isAuto
{
    self.label.text=text;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[DisplayTimer defaultDisplayTimer] addDisplayObserver:self.imageWheel];
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[DisplayTimer defaultDisplayTimer] removeDisplayObserver:self.imageWheel];
    [super viewWillDisappear:animated];
}
@end
