//
//  SchemeTableViewController.h
//  iSpinWheel
//
//  Created by Zion on 6/4/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "SWTableViewController.h"
#import "SWSchemeManager.h"

@interface SchemeTableViewController : SWTableViewController <UIAlertViewDelegate>

- (id)initWithSchemeGroupType:(SchemeGroupType)type;

@end
