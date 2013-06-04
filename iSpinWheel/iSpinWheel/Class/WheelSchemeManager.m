//
//  WheelSchemeManager.m
//  iSpinWheel
//
//  Created by Zion on 6/4/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "WheelSchemeManager.h"


@interface WheelSchemeManager ()
{
    SchemeGroupType _schemeGroupType;
}

@property (strong, nonatomic) NSMutableDictionary *schemeDictionary;
@end

@implementation WheelSchemeManager
@synthesize schemeDictionary=_schemeDictionary;

#pragma mark - public -
- (id)initWithSchemeType:(SchemeGroupType)type
{
    self=[super init];
    if (self)
    {
        _schemeGroupType=type;
        [self loadSchemeOfType:type];
    }
    return self;
}

- (void)schemeAdded
{
    NSArray *wheelArray;
    switch (_schemeGroupType) {
        case SchemeGroupType_MonoWheel:
            wheelArray=[NSArray arrayWithObjects:
                        [[NSMutableArray alloc] initWithCapacity:3],
                        nil];
            break;
        case SchemeGroupType_BiWheel:
            wheelArray=[NSArray arrayWithObjects:
                        [[NSMutableArray alloc] initWithCapacity:3],
                        [[NSMutableArray alloc] initWithCapacity:3],
                        nil];
            break;
        case SchemeGroupType_TriWheel:
            wheelArray=[NSArray arrayWithObjects:
                        [[NSMutableArray alloc] initWithCapacity:3],
                        [[NSMutableArray alloc] initWithCapacity:3],
                        [[NSMutableArray alloc] initWithCapacity:3],
                        nil];
            break;
        default:
            break;
    }
    
    
}

- (void)schemeDeleted:(NSString*)schemeName
{
    
}

- (void)schemeRenameFrom:(NSString*)schemeName to:(NSString*)newName
{
    
}

- (void)wheelStringAddedForWheel:(NSInteger)wheelIndex ofScheme:(NSString*)schemeName
{
    
}

- (void)wheelStringRenameTo:(NSString*)newName atIndex:(NSInteger)strIndex forWheel:(NSInteger)wheelIndex ofScheme:(NSString*)schemeName
{
    
}

- (void)wheelStringDeletedAtIndex:(NSInteger)strIndex forWheel:(NSInteger)wheelIndex ofScheme:(NSString*)schemeName
{
    
}

- (void)abandonChanging
{
    [self loadSchemeOfType:_schemeGroupType];
}

- (void)saveChanging
{
    [[NSUserDefaults standardUserDefaults] setObject:self.schemeDictionary forKey:[self schemeGroupNameOfType:_schemeGroupType]];
}

- (NSArray*)schemeNameList
{
    NSEnumerator *enumerator=[self.schemeDictionary keyEnumerator];
    NSMutableArray *nameList=[[NSMutableArray alloc] initWithCapacity:3];
    id key;
    while (key=[enumerator nextObject])
    {
        [nameList addObject:(NSString*)key];
    }
    return nameList;
}

- (NSArray*)wheelArrayOfScheme:(NSString*)schemeName
{
    return [self.schemeDictionary objectForKey:schemeName];
}

- (NSString*)stringAtIndex:(NSInteger)strIndex forWheel:(NSInteger)wheelIndex ofScheme:(NSString*)schemeName
{
    return [[[self wheelArrayOfScheme:schemeName] objectAtIndex:wheelIndex] objectAtIndex:strIndex];
}

#pragma mark - private -
- (void)loadSchemeFromPlistFileOfType:(SchemeGroupType)type
{
    NSDictionary *tempSchemeDic=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[self schemeGroupNameOfType:type] ofType:@"plist"]];
    self.schemeDictionary=[[NSMutableDictionary alloc] initWithCapacity:[tempSchemeDic count]];
    
    [tempSchemeDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         NSArray *tempWheelArray=(NSArray*)obj;
         NSArray *wheelArray;
         
         switch (type)
         {
             case SchemeGroupType_MonoWheel:
                 wheelArray=[NSArray arrayWithObjects:
                             [[tempWheelArray objectAtIndex:0] mutableCopy],
                             nil];
                 break;
             case SchemeGroupType_BiWheel:
                 wheelArray=[NSArray arrayWithObjects:
                             [[tempWheelArray objectAtIndex:0] mutableCopy],
                             [[tempWheelArray objectAtIndex:1] mutableCopy],
                             nil];
                 break;
             case SchemeGroupType_TriWheel:
                 wheelArray=[NSArray arrayWithObjects:
                             [[tempWheelArray objectAtIndex:0] mutableCopy],
                             [[tempWheelArray objectAtIndex:1] mutableCopy],
                             [[tempWheelArray objectAtIndex:2] mutableCopy],
                             nil];
                 break;
             default:
                 break;
         }
         
         [self.schemeDictionary setObject:wheelArray forKey:(NSString*)key];
         
     }];
}

- (void)loadSchemeOfType:(SchemeGroupType)type
{
    NSDictionary *tempSchemeDic=[[NSUserDefaults standardUserDefaults] objectForKey:[self schemeGroupNameOfType:type]];
    if (nil!=tempSchemeDic)
    {
        self.schemeDictionary=[tempSchemeDic mutableCopy];
        return;
    }
    [self loadSchemeFromPlistFileOfType:type];

}

- (NSString*)schemeGroupNameOfType:(SchemeGroupType)type
{
    switch (type)
    {
        case SchemeGroupType_MonoWheel:
            return @"MonoWheelSchemeGroup";
            break;
        case SchemeGroupType_BiWheel:
            return @"BiWheelSchemeGroup";
            break;
        case SchemeGroupType_TriWheel:
            return @"TriWheelSchemeGroup";
            break;
        default:
            break;
    }
    return nil;
    
}

@end
