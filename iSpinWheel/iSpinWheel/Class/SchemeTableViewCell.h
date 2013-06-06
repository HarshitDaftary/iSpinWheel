//
//  SchemeTableViewCell.h
//  iSpinWheel
//
//  Created by Zion on 6/5/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "SWTableViewCell.h"

@interface SchemeTableViewCell : SWTableViewCell

@property (assign, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (assign, nonatomic) IBOutlet UIImageView *schemeUsingTick;
@property (strong, nonatomic) IBOutlet UILabel *label;

@property (assign, nonatomic) BOOL isInUsing;

@end
