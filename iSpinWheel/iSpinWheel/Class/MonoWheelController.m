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
#import "SWSchemeManager.h"

@interface MonoWheelController ()

@property (nonatomic, strong)    IBOutlet ZNImageWheel *imageWheel;
@property (nonatomic, strong)    IBOutlet UILabel *label;
@property (nonatomic, assign)    SWSchemeManager *schemeManager;

@end

@implementation MonoWheelController
@synthesize imageWheel=_imageWheel;
@synthesize label=_label;

- (void)_init_WheelController
{
    self.schemeManager=[SWSchemeManager shareInstanceOfSchemeType:SchemeGroupType_MonoWheel];
    [self.schemeManager addObserver:self forKeyPath:@"schemeNameInUsing_v" options:NSKeyValueObservingOptionNew context:nil];
}

- (id)init
{
    self=[super init];
    if (self)
    {
        [self _init_WheelController];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        [self _init_WheelController];
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
}

- (void)setImageWheel
{
    NSString *usingName=[self.schemeManager schemeNameInUsing];
    NSArray *textList=[[self.schemeManager wheelArrayOfScheme:usingName] objectAtIndex:0];
    SWLog(@"begin");
    [self.imageWheel setSegmentsWithTextList:textList];
    SWLog(@"end");
    
    [self.imageWheel setDrag:0.5];
    [self.imageWheel setMaxVelocity:50];
    self.imageWheel.delegate=self;

}

- (void)dealloc
{
    [self.schemeManager removeObserver:self forKeyPath:@"schemeNameInUsing_v"];
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
    
    [self setImageWheel];


    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    self.imageWheel.angularVelocity=0.0;
    [[DisplayTimer defaultDisplayTimer] removeDisplayObserver:self.imageWheel];
    [super viewWillDisappear:animated];
}

#pragma mark - KVO -
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:self.schemeManager])
    {
        if ([keyPath isEqualToString:@"schemeNameInUsing_v"])
        {
        }
    }
}

@end
