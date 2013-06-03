//
//  BiWheelController.m
//  iWheel
//
//  Created by xunlei on 2/21/13.
//
//

#import "BiWheelController.h"
#import "ZNImageWheel.h"

@interface BiWheelController ()

@property (nonatomic, strong)    IBOutlet ZNImageWheel *imageWheel0;
@property (nonatomic, strong)    IBOutlet ZNImageWheel *imageWheel1;

@property (nonatomic, strong)    IBOutlet UILabel *label0;
@property (nonatomic, strong)    IBOutlet UILabel *label1;

@end

@implementation BiWheelController
@synthesize imageWheel0=_imageWheel0;
@synthesize imageWheel1=_imageWheel1;
@synthesize label0=_label0;
@synthesize label1=_label1;

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
    self.titleView.title.text=@"双轮";
    
    [self setTitleButtonType:TitleButtonType_Back forLeft:YES];
    [self.titleView.leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self setTitleButtonType:TitleButtonType_Edit forLeft:NO];
    [self.titleView.rightButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_imageWheel0 initialize];
    [_imageWheel0 setColorImageWithSegmentNumber:20 segmentColorArray:nil];
    [_imageWheel0 setDrag:0.4];
    [_imageWheel0 setMaxVelocity:50];
    _imageWheel0.delegate=self;
    
    [_imageWheel1 initialize];
    [_imageWheel1 setColorImageWithSegmentNumber:10 segmentColorArray:nil];
    [_imageWheel1 setDrag:0.4];
    [_imageWheel1 setMaxVelocity:50];
    _imageWheel1.delegate=self;
}

- (void)editButtonClick:(id)sender
{
    if (NO==_imageWheel0.isEditMode)
    {
        [_imageWheel0 startEditAnimationWithDelay:0];
        [_imageWheel1 startEditAnimationWithDelay:0.5];
    }
    else
    {
        [_imageWheel0 stopEditAnimation];
        [_imageWheel1 stopEditAnimation];
    }
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
@end
