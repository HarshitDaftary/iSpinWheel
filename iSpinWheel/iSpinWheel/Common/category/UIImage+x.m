//
//  UIImage+UIImagex.m
//  FrogFarm
//
//  Created by czh0766 on 11-11-20.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+x.h"

@implementation UIImage (x)


+ (UIImage*)localPngNamed:(NSString *)name
{
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]];
}

+ (UIImage*)localImageNamed:(NSString *)name
{
    NSInteger seploc=[name rangeOfString:@"." options:NSBackwardsSearch].location;
    if (NSNotFound==seploc||0==seploc||[name length]-1==seploc){
        return nil;
    }
    NSString* exp=[name substringFromIndex:seploc+1];
    NSString* pureName=[name substringToIndex:seploc];
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pureName ofType:exp]];
}


- (UIImage*)transformToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* transformedImg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return transformedImg;
}


@end
