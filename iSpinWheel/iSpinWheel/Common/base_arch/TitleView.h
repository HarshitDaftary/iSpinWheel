//
//  TitleView.h
//  iSpinWheel
//
//  Created by Zion on 6/3/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;

+ (TitleView*)titleView;

@end
