//
//  WheelMenuTableViewCell.h
//  iSpinWheel
//
//  Created by Zion on 6/5/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "SWTableViewCell.h"

@interface SWTextField : UITextField

@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@interface WheelMenuTableViewCell : SWTableViewCell

@property (strong, nonatomic) IBOutlet SWTextField *textField;

@end
