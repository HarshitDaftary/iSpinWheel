//
//  SWColorImageProductor.m
//  iSpinWheel
//
//  Created by xunlei on 3/7/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "SWColorImageProductor.h"
#import "SWColor.h"


@implementation SWColorImageProductor

+ (UIImage*)imageWithSize:(CGSize)size segmentNumber:(NSUInteger)seg segmentColorArray:(NSArray *)array
{
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        size.width=300;
        size.height=300;
    }
    if (0==seg)
    {
        seg=5;
    }
    if (nil==array||seg>[array count])
    {
        array=colorArray;
    }
    CGFloat singleRadi=M_PI_Double/seg;
    CGFloat halfWidth=size.width/2;
    int rd=random()%seg+8;
    NSInteger colorIndex=0;
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for (NSUInteger i=0;i<seg;i++)
    {
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, halfWidth, halfWidth);
        colorIndex=(i+1)*rd%colorCount;
        CGContextSetFillColorWithColor(ctx, [[UIColor colorWithString: [array objectAtIndex:colorIndex]] CGColor]);
//        CGContextSetFillColor(ctx, CGColorGetComponents( [[UIColor colorWithString: [array objectAtIndex:i] ] CGColor]));
        CGContextAddArc(ctx, halfWidth,halfWidth, size.height/2,  (i-0.5)*singleRadi, (i+0.5)*singleRadi, 0);
        CGContextFillPath(ctx);
    }
    UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(ctx);
    return image;
    
}

+ (UIImage*)defaultImage
{
    return [SWColorImageProductor imageWithSize:CGSizeZero segmentNumber:0 segmentColorArray:nil];
}
@end
