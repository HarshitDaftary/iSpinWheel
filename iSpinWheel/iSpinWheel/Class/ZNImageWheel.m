//
//  ANImageWheel.m
//  SpinWheel
//
//  Created by Alex Nichol on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZNImageWheel.h"
#import "SWColorImageProductor.h"
#import <AudioToolbox/AudioToolbox.h>
@interface ZNImageWheel()
{
    CGFloat _segmentAngle;
    SystemSoundID _wheelSoundId;
    NSInteger _soundPlayCount;
}
@property (nonatomic, strong)    UITapGestureRecognizer *tagGusture;
@property (nonatomic, strong)    UIView *editModeCoverView;
@end

@implementation ZNImageWheel
@synthesize pointerAngle=_pointerAngle;
@synthesize buttonDiameter=_buttonDiameter;
@synthesize spinButton=_spinButton;
@synthesize maxVelocity=_maxVelocity;
@synthesize maxSegmentNumber=_maxSegmentNumber;
@synthesize segmentNumber=_segmentNumber;
@synthesize isEditMode=_isEditMode;
@synthesize delegate=_delegate;
@synthesize tagGusture=_tagGusture;
@synthesize editModeCoverView=_editModeCoverView;

- (void)setImage:(UIImage *)anImage
{
    [imageView setImage:anImage];
}

- (void)setColorImageWithSegmentNumber:(NSInteger) seg segmentColorArray:(NSArray*)array
{
    _segmentNumber=seg;
    _segmentAngle=M_PI_Double/seg;
    UIImage* image=[SWColorImageProductor imageWithSize:self.bounds.size segmentNumber:seg segmentColorArray:nil];
    [self setImage:image];
    
    _pointerAngle=-_segmentAngle/2;
    
    [self addTextLabels];
}

- (UIImage *)image
{
    return [imageView image];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (nil==newSuperview)
    {
        AudioServicesDisposeSystemSoundID(_wheelSoundId);
    }

}

- (void)initialize
{
    [self setTag:100];
    [self clipToCircus];
    
    imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.tag=200;
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:imageView];
    
    _buttonDiameter=self.frame.size.width/3;
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor=[UIColor colorWithString:@"000 191 057"];
    [button setTitle:@"X" forState:UIControlStateNormal];
    button.frame=CGRectMake(_buttonDiameter,_buttonDiameter,_buttonDiameter,_buttonDiameter);
    [button clipToCircus];
    [self addSubview:button];
    
    UILongPressGestureRecognizer* longPressGest=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)];
    longPressGest.cancelsTouchesInView=NO;
    longPressGest.minimumPressDuration=0.05;
    [self addGestureRecognizer:longPressGest];
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"wheelSound"
                                                          ofType:@"aif"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    OSStatus err = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,
                                                    &_wheelSoundId);
    if (err != kAudioServicesNoError)
    {
        SWLog(@"Could not load %@, error code: %ld", soundURL, err);
    }
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self setTag:100];
        [self clipToCircus];
        
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.tag=200;
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:imageView];
        
        _buttonDiameter=frame.size.width/3;
        UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor=[UIColor colorWithString:@"000 191 057"];
        [button setTitle:@"X" forState:UIControlStateNormal];
        button.frame=CGRectMake(_buttonDiameter,_buttonDiameter,_buttonDiameter,_buttonDiameter);
        [button clipToCircus];
        [self addSubview:button];
        
        UILongPressGestureRecognizer* longPressGest=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGesture:)];
        longPressGest.cancelsTouchesInView=NO;
        longPressGest.minimumPressDuration=0.05;
        [self addGestureRecognizer:longPressGest];
        
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"wheelSound"
                                                              ofType:@"aif"];
        NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
        OSStatus err = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,
                                                            &_wheelSoundId);
        if (err != kAudioServicesNoError)
        {
            SWLog(@"Could not load %@, error code: %ld", soundURL, err);
        }
    }
    return self;
}


- (void)addTextLabels
{
    CGFloat r=self.bounds.size.width/2;
    CGPoint center=CGPointMake(r, r);
    UILabel *label=nil;
    for (int i =0;i<_segmentNumber;i++)
    {

        label=[[UILabel alloc] initWithFrame:
        CGRectMake(
                   center.x+r/3+2*r*(cosf(i*_segmentAngle)-1)/3,
                   center.y-r*tanf(_segmentAngle/2)/3+2*r*sinf(i*_segmentAngle)/3,
                   2*r/3,
                   2*r*tanf(_segmentAngle/2)/3
                )];
        label.tag=i;
        label.transform=CGAffineTransformMakeRotation(i*_segmentAngle);
        label.backgroundColor=[UIColor clearColor];
        label.text=[NSString stringWithFormat:@"%d-%d-%d",i,i,i];
        label.textColor=[UIColor whiteColor];
        label.textAlignment=UITextAlignmentRight;
        [imageView addSubview:label];
    }
    
}


- (id)initWithFrame:(CGRect)frame image:(UIImage *)anImage
{
    if ((self = [self initWithFrame:frame]))
    {
        [imageView setImage:anImage];
    }
    return self;
}

#pragma mark - user interaction -

- (IBAction)buttonClick:(id)sender
{
    if (self.angularVelocity>=0)
    {
        self.angularVelocity+=10;
    }
    else
    {
        self.angularVelocity-=10;
    }
    
}

- (void)handleLongPressGesture:(UIGestureRecognizer*)gesture
{
    CGPoint loc=[gesture locationInView:self];
    CGFloat halfWidth=self.bounds.size.width/2;
    CGPoint vex=CGPointMake(loc.x-halfWidth, loc.y-halfWidth);
    if ((vex.x*vex.x+vex.y*vex.y)*4>=_buttonDiameter*_buttonDiameter&&UIGestureRecognizerStateBegan==gesture.state)
    {
        angularVelocity=0;
        NSInteger index=[self getSegmentIndexOfAngle:angle];
        [_delegate didStopSpinWheel:self atSegment:index selectedText:((UILabel*)[imageView viewWithTag:index]).text automatic:NO];
    }
    
}

#pragma mark - redefine property -
- (void)setMaxSegmentNumber:(NSInteger)maxSegmentNumber
{
    _maxSegmentNumber=maxSegmentNumber;
    _segmentNumber=MIN(_segmentNumber, _maxSegmentNumber);
}

- (void)setSegmentNumber:(NSInteger)segmentNumber
{
    _segmentNumber=MIN(segmentNumber, _maxSegmentNumber);
    
}

- (NSInteger)getSegmentIndexOfAngle:(CGFloat)ang
{
    NSInteger index=floorf((ang-_pointerAngle)/_segmentAngle);
    return (_segmentNumber-((index%_segmentNumber)+_segmentNumber)%_segmentNumber)%_segmentNumber;
    
}

- (void)setAngle:(double)anAngle
{
//    SWLog(@"---%f---",self.angularVelocity);
    /*
    if (ABS(self.angularVelocity)>5.0f)
    {
        if ((int)((anAngle-_pointerAngle)/_segmentAngle)!=(int)((angle-_pointerAngle)/_segmentAngle))
        {
            if (2<=_soundPlayCount)
            {
                _soundPlayCount=0;
                [self asyncTask:
                 ^{
                     AudioServicesPlaySystemSound(_wheelSoundId);
                 } ];
            }
            else
            {
                _soundPlayCount++;
            }
        }

    }
    else
        */
        if ((int)((anAngle-_pointerAngle)/_segmentAngle)!=(int)((angle-_pointerAngle)/_segmentAngle))
    {
        [self asyncTask:^{
            AudioServicesPlaySystemSound(_wheelSoundId);
        } ];
    }
    [super setAngle:anAngle];
    [[imageView layer] setTransform:CATransform3DMakeRotation(angle, 0, 0, 1)];
}

- (void)setAngularVelocity:(double)velocity
{
    NSInteger factor=-1;
    if (velocity>=0)
    {
        factor=1;
    }
    [super setAngularVelocity:(factor * MIN(ABS(velocity), self.maxVelocity)) ];
    if (velocity==0)
    {
        NSInteger index=[self getSegmentIndexOfAngle:angle];
        [_delegate didStopSpinWheel:self atSegment:index selectedText:((UILabel*)[imageView viewWithTag:index]).text automatic:YES];
    }
}

- (void)startEditAnimationWithDelay:(NSTimeInterval)delay
{
    if (nil==_editModeCoverView)
    {
        _editModeCoverView=[[UIView alloc] initWithFrame:self.frame];
        _editModeCoverView.backgroundColor=[UIColor clearColor];
        [self.superview addSubview:_editModeCoverView];
    }
    if (nil==_tagGusture)
    {
        _tagGusture=[[UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(gotoEdit:)];
        [_editModeCoverView addGestureRecognizer:_tagGusture];
    }
    
    //begin twinkle animation
    self.angularVelocity=0;
    [ UIView animateWithDuration:0.8
                           delay:delay
                         options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse
                      animations:^{
                          imageView.alpha=0.3f;
                      }completion:^(BOOL finished){
                          imageView.alpha=1.0f;
                      }];
    _isEditMode=YES;
}

- (void)stopEditAnimation
{
    [self removeGestureRecognizer:_tagGusture];
    _tagGusture=nil;
    [_editModeCoverView removeFromSuperview];
    _editModeCoverView=nil;
    
    //stop twinkle animation
    CALayer *objectPresentationLayer = [imageView.layer presentationLayer];
    imageView.layer.transform = objectPresentationLayer.transform;
    [imageView.layer removeAllAnimations];
    
    _isEditMode=NO;
}

- (void)gotoEdit:(UIGestureRecognizer*)tapGusture
{
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
