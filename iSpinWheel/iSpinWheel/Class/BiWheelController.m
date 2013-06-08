//
//  BiWheelController.m
//  iWheel
//
//  Created by xunlei on 2/21/13.
//
//

#import "BiWheelController.h"
#import "ZNImageWheel.h"
#import "SchemeTableViewController.h"
#import "SWSchemeManager.h"

@interface BiWheelController ()

@property (nonatomic, strong)    IBOutlet ZNImageWheel *imageWheel0;
@property (nonatomic, strong)    IBOutlet ZNImageWheel *imageWheel1;

@property (nonatomic, strong)    IBOutlet UILabel *label0;
@property (nonatomic, strong)    IBOutlet UILabel *label1;

@property (nonatomic, assign)   SWSchemeManager *schemeManager;

@end

@implementation BiWheelController
@synthesize imageWheel0=_imageWheel0;
@synthesize imageWheel1=_imageWheel1;
@synthesize label0=_label0;
@synthesize label1=_label1;
@synthesize schemeManager=_schemeManager;

- (void)_init_WheelController
{
    self.schemeManager=[SWSchemeManager shareInstanceOfSchemeType:SchemeGroupType_BiWheel];
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
    self.titleView.title.text=@"双轮";
    
    [self setTitleButtonType:TitleButtonType_Back forLeft:YES];
    [self setTitleButtonType:TitleButtonType_More forLeft:NO];
    
    NSString *usingName=[self.schemeManager schemeNameInUsing];
    NSArray *textList=[[self.schemeManager wheelArrayOfScheme:usingName] objectAtIndex:0];
    [_imageWheel0 setSegmentsWithTextList:textList];
    [_imageWheel0 setDrag:0.4];
    [_imageWheel0 setMaxVelocity:50];
    _imageWheel0.delegate=self;
    
    textList=[[self.schemeManager wheelArrayOfScheme:usingName] objectAtIndex:1];
    [_imageWheel1 setSegmentsWithTextList:textList];
    [_imageWheel1 setDrag:0.4];
    [_imageWheel1 setMaxVelocity:50];
    _imageWheel1.delegate=self;
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
    SchemeTableViewController *schemeVC=[[SchemeTableViewController alloc] initWithSchemeGroupType:SchemeGroupType_BiWheel];
    [[SWNavigationController shareNavigationController] pushViewController:schemeVC animated:YES];
    return;
    
//    if (NO==_imageWheel0.isEditMode)
//    {
//        [_imageWheel0 startEditAnimationWithDelay:0];
//        [_imageWheel1 startEditAnimationWithDelay:0.5];
//    }
//    else
//    {
//        [_imageWheel0 stopEditAnimation];
//        [_imageWheel1 stopEditAnimation];
//    }
}

- (void)didStopSpinWheel:(ZNImageWheel *)imgWheel atSegment:(NSInteger)index selectedText:(NSString *)text automatic:(BOOL)isAuto
{
    if ([imgWheel isEqual:_imageWheel0])
    {
        _label0.text=text;
    }
    else
    {
        _label1.text=text;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[DisplayTimer defaultDisplayTimer] addDisplayObserver:_imageWheel0];
    [[DisplayTimer defaultDisplayTimer] addDisplayObserver:_imageWheel1];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[DisplayTimer defaultDisplayTimer] removeDisplayObserver:_imageWheel0];
    [[DisplayTimer defaultDisplayTimer] removeDisplayObserver:_imageWheel1];
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
