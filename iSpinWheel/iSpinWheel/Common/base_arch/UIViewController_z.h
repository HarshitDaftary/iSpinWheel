//
//  UIViewController_z.h
//  iSpinWheel
//
//  Created by Zion on 6/3/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    TitleButtonType_Back,
    TitleButtonType_Close,
    TitleButtonType_Edit,
    TitleButtonType_Text,
    TitleButtonType_More
}TitleButtonType;

@class TitleView;
@interface UIViewController_z : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, strong) TitleView *titleView;

- (void)setTitleButtonType:(TitleButtonType)type forLeft:(BOOL)left;

- (BOOL)shouldAnimatTitleView;
- (void)showTitleViewWithAnimation:(BOOL)animate;
- (void)hideTitleViewWithAnimation:(BOOL)animate;

- (void)goBack:(id)sender;

- (void)titleLeftButtonClick:(id)sender;

- (void)titleRightButtonClick:(id)sender;


@end
