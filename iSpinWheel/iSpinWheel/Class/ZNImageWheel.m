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

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self _initialize_wheel];
    }
    return self;
}

-(void)awakeFromNib
{
    [self _initialize_wheel];
    
}

- (void)_initialize_wheel
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

- (void)setImage:(UIImage *)anImage
{
    [imageView setImage:anImage];
}

- (void)setSegmentsWithTextList:(NSArray*)textList
{
    [self setSegmentsWithTextList:textList withColorArray:nil];
}

- (void)setSegmentsWithTextList:(NSArray*)textList withColorArray:(NSArray*)colorArray
{
    NSAssert(!(nil!=colorArray&&[textList count]!=[colorArray count]), @"text list count is not equal to color list count.");
    _segmentNumber=[textList count];
    _segmentAngle=M_PI_Double/_segmentNumber;
    SWLog(@"begin-1");
    UIImage* image=[SWColorImageProductor imageWithSize:self.bounds.size segmentNumber:_segmentNumber];
    SWLog(@"end-1");
    [self setImage:image];
    
//    _pointerAngle=-_segmentAngle/2;
    _pointerAngle=0;
    
    
    SWLog(@"begin-2");
    [self addTextLabels:textList];
    SWLog(@"end-2");
    
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

- (CGFloat)fontSizeFitToLabelSize:(CGSize)labelSize
{
    CGFloat minFont=0.1;
    CGFloat maxFont=25;
    const CGFloat accuracyError=0.05;
    CGFloat font;
    CGSize calcSize;
    const CGFloat widthThreshold=labelSize.width*accuracyError;
    const CGFloat heightThreshold=labelSize.height*accuracyError;
    while (maxFont>=minFont)
    {
        font=(minFont+maxFont)/2.0;
        calcSize=[@"123456789" sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat widthDelta=calcSize.width-labelSize.width;
        CGFloat heightDelta=calcSize.height-labelSize.height;
        if (widthDelta>0)
        {
            if (heightDelta>0)
            {
                if (widthDelta<=widthThreshold&&heightDelta<=heightThreshold)
                {
                    break;
                }
                else
                {
                    maxFont=font;
                }
            }
            else
            {
                if (widthDelta<=widthThreshold)
                {
                    break;
                }
                else
                {
                    maxFont=font;
                }
                
            }
        }
        else
        {
            if (heightDelta>0)
            {
                if (heightDelta<=heightThreshold)
                {
                    break;
                }
                else
                {
                    maxFont=font;
                }
                
            }
            else
            {
                if (-heightDelta<=heightThreshold||-widthDelta<=widthThreshold)
                {
                    break;
                }
                else
                {
                    minFont=font;
                }
            }
        }

    }
    return font;
 
}


- (CGFloat)fontSizeFitToWidth:(CGFloat)width
{
    CGFloat minFont=5;
    CGFloat maxFont=25;
    CGFloat accuracy=0.95;
    CGFloat font,calcWidth;
    const CGFloat threshold=width*(1-accuracy);
    while (maxFont>=minFont)
    {
        font=(minFont+maxFont)/2.0;
        calcWidth=[@"0123456789" sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].width;
        CGFloat delta=calcWidth-width;
        if (delta>0)
        {
            if (delta<=threshold)
            {
                break;
            }
            maxFont=font;
        }
        else
        {
            if (-delta<=threshold)
            {
                break;
            }
            minFont=font;
        }
    }
    return font;

}

- (void)addTextLabels:(NSArray*)textList
{
    CGFloat r=self.bounds.size.width/2;
    CGPoint center=CGPointMake(r, r);
    const CGFloat labelWidth=0.6*r;
    const CGFloat labelHeight=r*tanf((_segmentNumber<=2?M_PI_2:_segmentAngle)/2);
    CGFloat fontSize=[self fontSizeFitToLabelSize:CGSizeMake(labelWidth, labelHeight)];
    UILabel *label=nil;
    for (UIView *subView in imageView.subviews)
    {
        if ([subView isKindOfClass:[UILabel class]])
        {
            [subView removeFromSuperview];
        }
    }
    for (int i =0;i<_segmentNumber;i++)
    {

        label=[[UILabel alloc] initWithFrame:CGRectMake(0,0,labelWidth,labelHeight)];
        label.center=
            CGPointMake(
            center.x+(r-labelWidth/2)*cosf((i+0.5)*_segmentAngle),
            center.y+(r-labelWidth/2)*sinf((i+0.5)*_segmentAngle)
            );

        label.tag=i;
        label.transform=CGAffineTransformMakeRotation((i+0.5)*_segmentAngle);
        label.backgroundColor=[UIColor clearColor];
        label.text=[textList objectAtIndex:i];
        label.textColor=[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        label.textAlignment=UITextAlignmentCenter;
        label.lineBreakMode=UILineBreakModeMiddleTruncation;
        label.font=[UIFont systemFontOfSize:fontSize];
        label.clipsToBounds=NO;
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
//    NSInteger index=floorf((ang-_pointerAngle)/_segmentAngle);
//    return (_segmentNumber-((index%_segmentNumber)+_segmentNumber)%_segmentNumber)%_segmentNumber;
    while (ang<0)
    {
        ang+=M_PI*2;
    }
    return _segmentNumber-(ang-_pointerAngle)/_segmentAngle;
    
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
