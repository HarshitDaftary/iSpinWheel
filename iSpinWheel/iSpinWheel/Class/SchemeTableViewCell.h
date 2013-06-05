//
//  SchemeTableViewCell.h
//  iSpinWheel
//
//  Created by Zion on 6/5/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "SWTableViewCell.h"

@interface SchemeTableViewCell : SWTableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (strong, nonatomic) IBOutlet UIImageView *schemeUsingTick;

@property (assign, nonatomic) BOOL isInUsing;

@end
