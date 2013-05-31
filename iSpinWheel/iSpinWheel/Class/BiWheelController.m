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
{
    IBOutlet ZNImageWheel *_imageWheel0;
    IBOutlet ZNImageWheel *_imageWheel1;

    IBOutlet UILabel *_label0;
    IBOutlet UILabel *_label1;
}

@end

@implementation BiWheelController

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
    self.title=@"双轮";
}

- (void)loadWheelUI
{
    [super loadWheelUI];
    
    [_imageWheel0 initialize];
    [_imageWheel0 setColorImageWithSegmentNumber:20 segmentColorArray:nil];
    [_imageWheel0 startAnimating:self];
    [_imageWheel0 setDrag:0.4];
    [_imageWheel0 setMaxVelocity:50];
//    [_imageWheel0 setMaxSegmentNumber:10];
    _imageWheel0.delegate=self;
    
    [_imageWheel1 initialize];
    [_imageWheel1 setColorImageWithSegmentNumber:10 segmentColorArray:nil];
    [_imageWheel1 startAnimating:self];
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

- (void)viewDidUnload {
    _label0 = nil;
    _label1 = nil;
    _imageWheel0 = nil;
    _imageWheel1 = nil;
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _imageWheel0.delegate=nil;
    _imageWheel1.delegate=nil;
    [super viewWillDisappear:animated];
}
@end
