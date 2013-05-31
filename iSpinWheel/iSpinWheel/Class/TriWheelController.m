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
{
   IBOutlet ZNImageWheel* _imageWheel0;
   IBOutlet ZNImageWheel* _imageWheel1;
   IBOutlet ZNImageWheel* _imageWheel2;
    IBOutlet UILabel *_label0;
    IBOutlet UILabel *_label1;
    IBOutlet UILabel *_label2;
}
@end

@implementation TriWheelController

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
    self.title=@"三轮";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadWheelUI
{
    [super loadWheelUI];
    
    [_imageWheel0 initialize];
    [_imageWheel0 setColorImageWithSegmentNumber:5 segmentColorArray:nil];
    [_imageWheel0 startAnimating:self];
    [_imageWheel0 setDrag:0.4];
    [_imageWheel0 setMaxVelocity:50];
    [_imageWheel0 setMaxSegmentNumber:5];
    _imageWheel0.delegate=self;
    
    [_imageWheel1 initialize];
    [_imageWheel1 setColorImageWithSegmentNumber:10 segmentColorArray:nil];
    [_imageWheel1 startAnimating:self];
    [_imageWheel1 setDrag:0.4];
    [_imageWheel1 setMaxVelocity:50];
    [_imageWheel1 setMaxSegmentNumber:10];
    _imageWheel1.delegate=self;
    
    [_imageWheel2 initialize];
    [_imageWheel2 setColorImageWithSegmentNumber:20 segmentColorArray:nil];
    [_imageWheel2 startAnimating:self];
    [_imageWheel2 setDrag:0.4];
    [_imageWheel2 setMaxVelocity:50];
    _imageWheel2.delegate=self;
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

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _imageWheel0.delegate=nil;
    _imageWheel1.delegate=nil;
    _imageWheel2.delegate=nil;
    [super viewWillDisappear:animated];
}
@end
