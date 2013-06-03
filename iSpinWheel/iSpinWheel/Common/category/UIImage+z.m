//
//  UIImage+z.m
//  FrogFarm
//
//  Created by czh0766 on 11-11-20.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+z.h"

@implementation UIImage (z)


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

- (UIImage *)resizableImageWithCapInsets_x:(UIEdgeInsets)capInsets
{
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        return [self resizableImageWithCapInsets:capInsets];
    }
    return [self stretchableImageWithLeftCapWidth:capInsets.left
                                     topCapHeight:capInsets.top];
}

+ (UIImage *)resizeableImageNamed:(NSString *)name capLeft:(CGFloat)left capTop:(CGFloat)top
{
    UIImage *resizeImage = [UIImage imageNamed:name];
    UIEdgeInsets capInsets = UIEdgeInsetsMake(top, left,
                                              resizeImage.size.height-top-1,
                                              resizeImage.size.width-left-1);
    return [resizeImage resizableImageWithCapInsets_x:capInsets];
}

+ (UIImage *) resizeableImageNamed:(NSString *)name
                         capInsets:(UIEdgeInsets)capInsets
{
    return [[UIImage imageNamed:name] resizableImageWithCapInsets_x:capInsets];
}

+ (UIImage *)resizeableImageNamed:(NSString *)name
{
    UIImage *resizeImage = [UIImage imageNamed:name];
    CGFloat left = floorf(resizeImage.size.width/2);
    CGFloat top = floorf(resizeImage.size.height/2);
    return [UIImage resizeableImageNamed:name capLeft:left capTop:top];
}


@end
