//
//  SWColorImageProductor.m
//  iSpinWheel
//
//  Created by xunlei on 3/7/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "SWColorImageProductor.h"

#define colorCount (30)

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
        NSInteger index=rand()%colorCount;
        NSInteger step=rand()%4+1;
        NSMutableArray *colorIndexList=[[NSMutableArray alloc] initWithCapacity:seg];
        for (int i=0;i<seg;i++)
        {
            [colorIndexList addObject:[NSNumber numberWithInteger:index]];
            index=(index+step)%colorCount;
        }
        array=colorIndexList;
    }
    CGFloat singleRadi=M_PI_Double/seg;
    CGFloat halfWidth=size.width/2;
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for (NSUInteger i=0;i<seg;i++)
    {
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, halfWidth, halfWidth);
        UIColor *color=[UIColor colorWithPatternImage:[UIImage imageNamed:[@"color_" stringByAppendingFormat:@"%d",[[array objectAtIndex:i] integerValue]]]];
        CGContextSetFillColorWithColor(ctx, [color CGColor]);
        CGContextAddArc(ctx, halfWidth,halfWidth, size.height/2,  (i-0.5)*singleRadi, (i+0.5)*singleRadi, 0);
        CGContextFillPath(ctx);
    }
    UIImage* image=UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(ctx);
    return image;
    
}

+ (UIImage*)imageWithSize:(CGSize)size segmentNumber:(NSUInteger)seg
{
    NSInteger test=rand()%2;
    NSString *imageName=[NSString stringWithFormat:@"seg_%d",seg];
    if (0==test)
    {
        imageName=[imageName stringByAppendingString:@"_fir_opt"];
    }
    else
    {
        imageName=[imageName stringByAppendingString:@"_fir_opt"];
//        imageName=[imageName stringByAppendingString:@"_sec_opt"];
        
    }
    return [UIImage imageNamed:imageName];
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        size.width=300;
        size.height=300;
    }
    if (0==seg)
    {
        seg=5;
    }

    CGFloat singleRadi=M_PI_Double/seg;
    CGFloat halfWidth=size.width/2;
    NSInteger index=rand()%colorCount;
    NSInteger step=rand()%4+1;
    
//    NSInteger index=0;
//    NSInteger step=1;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for (NSUInteger i=0;i<seg;i++,index=(index+step)%colorCount)
    {
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, halfWidth, halfWidth);
        UIColor *color=[UIColor colorWithPatternImage:[UIImage imageNamed:[@"light_color_" stringByAppendingFormat:@"%d",index]]];
        CGContextSetFillColorWithColor(ctx, [color CGColor]);
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
