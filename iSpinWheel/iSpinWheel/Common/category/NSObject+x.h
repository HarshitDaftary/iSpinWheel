//
//  NSObject+x.h
//  iSpinWheel
//
//  Created by 锡安 冯 on 13-3-9.
//  Copyright (c) 2013年 Zion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (x)

-(void)asyncTask:(dispatch_block_t)block ;
-(void)syncTask:(dispatch_block_t)block ;
-(void) syncTask:(dispatch_block_t)block after:(NSTimeInterval)delay ;
    
@end
