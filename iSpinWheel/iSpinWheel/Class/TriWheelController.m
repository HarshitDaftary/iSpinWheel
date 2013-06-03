//
//  TriWheelController.m
//  iWheel
//
//  Created by xunlei on 2/21/13.
//
//

#import "TriWheelController.h"
#import "ZNImageWheel.h"

@interface TriWheelController ()

@property (nonatomic, strong)   IBOutlet ZNImageWheel* imageWheel0;
@property (nonatomic, strong)   IBOutlet ZNImageWheel* imageWheel1;
@property (nonatomic, strong)   IBOutlet ZNImageWheel* imageWheel2;
@property (nonatomic, strong)    IBOutlet UILabel *label0;
@property (nonatomic, strong)    IBOutlet UILabel *label1;
@property (nonatomic, strong)    IBOutlet UILabel *label2;

@end

@implementation TriWheelController
@synthesize imageWheel0=_imageWheel0;
@synthesize imageWheel1=_imageWheel1;
@synthesize imageWheel2=_imageWheel2;
@synthesize label0=_label0;
@synthesize label1=_label1;
@synthesize label2=_label2;


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
    self.titleView.title.text=@"三轮";
    
    [self setTitleButtonType:TitleButtonType_Back forLeft:YES];
    [self.titleView.leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self setTitleButtonType:TitleButtonType_Edit forLeft:NO];
    [self.titleView.rightButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_imageWheel0 initialize];
    [_imageWheel0 setColorImageWithSegmentNumber:5 segmentColorArray:nil];
    [_imageWheel0 setDrag:0.4];
    [_imageWheel0 setMaxVelocity:50];
    [_imageWheel0 setMaxSegmentNumber:5];
    _imageWheel0.delegate=self;
    
    [_imageWheel1 initialize];
    [_imageWheel1 setColorImageWithSegmentNumber:10 segmentColorArray:nil];
    [_imageWheel1 setDrag:0.4];
    [_imageWheel1 setMaxVelocity:50];
    [_imageWheel1 setMaxSegmentNumber:10];
    _imageWheel1.delegate=self;
    
    [_imageWheel2 initialize];
    [_imageWheel2 setColorImageWithSegmentNumber:20 segmentColorArray:nil];
    [_imageWheel2 setDrag:0.4];
    [_imageWheel2 setMaxVelocity:50];
    _imageWheel2.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editButtonClick:(id)sender
{
    if (NO==_imageWheel0.isEditMode)
    {
        [_imageWheel0 startEditAnimationWithDelay:0];
        [_imageWheel1 startEditAnimationWithDelay:0.5];
        [_imageWheel2 startEditAnimationWithDelay:1];
    }
    else
    {
        [_imageWheel0 stopEditAnimation];
        [_imageWheel1 stopEditAnimation];
        [_imageWheel2 stopEditAnimation];
    }
}

- (void)didStopSpinWheel:(ZNImageWheel *)imgWheel atSegment:(NSInteger)index selectedText:(NSString *)text automatic:(BOOL)isAuto
{
    if ([imgWheel isEqual:_imageWheel0])
    {
        _label0.text=text;
    }
    else if ([imgWheel isEqual:_imageWheel1])
    {
        _label1.text=text;
    }
    else
    {
        _label2.text=text;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [[DisplayTimer defaultDisplayTimer] addDisplayObserver:_imageWheel0];
    [[DisplayTimer defaultDisplayTimer] addDisplayObserver:_imageWheel1];
    [[DisplayTimer defaultDisplayTimer] addDisplayObserver:_imageWheel2];
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[DisplayTimer defaultDisplayTimer] removeDisplayObserver:_imageWheel0];
    [[DisplayTimer defaultDisplayTimer] removeDisplayObserver:_imageWheel1];
    [[DisplayTimer defaultDisplayTimer] removeDisplayObserver:_imageWheel2];
    [super viewWillDisappear:animated];
}
@end
