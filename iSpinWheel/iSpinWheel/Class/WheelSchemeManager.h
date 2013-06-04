//
//  WheelSchemeManager.h
//  iSpinWheel
//
//  Created by Zion on 6/4/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    SchemeGroupType_MonoWheel,
    SchemeGroupType_BiWheel,
    SchemeGroupType_TriWheel,
    
}SchemeGroupType;

@interface WheelSchemeManager : NSObject

- (id)initWithSchemeType:(SchemeGroupType)type;

- (void)schemeAdded;

- (void)schemeDeleted:(NSString*)schemeName;

- (void)schemeRenameFrom:(NSString*)schemeName to:(NSString*)newName;

- (void)wheelStringAddedForWheel:(NSInteger)wheelIndex ofScheme:(NSString*)schemeName;

- (void)wheelStringRenameTo:(NSString*)newName atIndex:(NSInteger)strIndex forWheel:(NSInteger)wheelIndex ofScheme:(NSString*)schemeName;

- (void)wheelStringDeletedAtIndex:(NSInteger)strIndex forWheel:(NSInteger)wheelIndex ofScheme:(NSString*)schemeName;

- (void)abandonChanging;

- (void)saveChanging;

- (NSArray*)schemeNameList;

- (NSArray*)wheelArrayOfScheme:(NSString*)schemeName;

- (NSString*)stringAtIndex:(NSInteger)strIndex forWheel:(NSInteger)wheelIndex ofScheme:(NSString*)schemeName;

@end
