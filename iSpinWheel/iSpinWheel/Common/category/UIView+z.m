//
//  UIView+z.m
//  iWheel
//
//  Created by xunlei on 3/4/13.
//
//

#import "UIView+z.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (z)

+(id) viewWithNib:(NSString*)nib owner:(id)owner
{
    NSArray* array =[[NSBundle mainBundle] loadNibNamed:nib owner:owner options:nil];
    return [array objectAtIndex:0];
}

- (void)clipToCircus
{
    CALayer* layer=[self layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:self.frame.size.width/2];
}

@end
