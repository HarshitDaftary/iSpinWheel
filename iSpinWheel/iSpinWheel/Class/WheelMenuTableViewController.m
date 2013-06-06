//
//  WheelMenuTableViewController.m
//  iSpinWheel
//
//  Created by Zion on 6/4/13.
//  Copyright (c) 2013 Zion. All rights reserved.
//

#import "WheelMenuTableViewController.h"
#import "HeaderView.h"
#import "WheelMenuTableViewCell.h"

@interface WheelMenuTableViewController ()
{
}

@property (nonatomic, copy) NSString *schemeName;
@property (nonatomic, assign) SWTextField *textFieldInEditing;
@property (nonatomic, assign) BOOL shouldCommitEditing;

@end

@implementation WheelMenuTableViewController
@synthesize schemeName=_schemeName;
@synthesize textFieldInEditing=_textFieldInEditing;
@synthesize shouldCommitEditing=_shouldCommitEditing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSchemeName:(NSString *)schemeName schemeGroupType:(SchemeGroupType)type
{
    self =[super init];
    if (self)
    {
        self.schemeName=schemeName;
        self.schemeGroupType=type;
        self.schemeManager=[SWSchemeManager shareInstanceOfSchemeType:type];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleView.title.text=@"方案详情";
    
    [self setTitleButtonType:TitleButtonType_Back forLeft:YES];
    [self setTitleButtonType:TitleButtonType_Text forLeft:NO];
    
    [self.titleView.rightButton setTitle:@"使用" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - editing -
-(void)setTextFieldInEditing:(SWTextField *)textFieldInEditing
{
    if (nil==textFieldInEditing)
    {
        [self setTitleButtonType:TitleButtonType_Back forLeft:YES];
        [self.titleView.leftButton setTitle:nil forState:UIControlStateNormal];
        [self.titleView.rightButton setTitle:@"使用" forState:UIControlStateNormal];
    }
    else
    {
        [self setTitleButtonType:TitleButtonType_Text forLeft:YES];
        [self.titleView.leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.titleView.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    _textFieldInEditing=textFieldInEditing;
}

- (void)commitEditing
{
    if (nil==self.textFieldInEditing)
    {
        return;
    }
    NSString *newName=self.textFieldInEditing.text;
    if (0==self.textFieldInEditing.indexPath.section&&0==self.textFieldInEditing.indexPath.row)
    {
        if (0==[newName length])
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:@"方案名不能为空" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            if (![self.schemeName isEqualToString:newName]&&[self.schemeManager schemeRenameFrom:self.schemeName to:newName])
            {
                [self.schemeManager commitChanging];
                self.schemeName=newName;
            }
            self.shouldCommitEditing=NO;
            [self.textFieldInEditing resignFirstResponder];
        }
        return;
    }
    if (0==[newName length])
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:@"输入信息为空，该项将被删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alertView show];
    }
    else
    {
        if ([self.schemeManager wheelStringRenameTo:newName atIndex:self.textFieldInEditing.indexPath.row forWheel:self.textFieldInEditing.indexPath.section-1 ofScheme:self.schemeName])
        {
            [self.schemeManager commitChanging];
        }
        self.shouldCommitEditing=NO;
        [self.textFieldInEditing resignFirstResponder];
    }
}

#pragma mark - user interaction -
-(void)titleLeftButtonClick:(id)sender
{
    if (nil==self.textFieldInEditing)
    {
        [self goBack:sender];
    }
    else
    {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.textFieldInEditing.indexPath] withRowAnimation:NO];
        [self.textFieldInEditing resignFirstResponder];
    }
}

-(void)titleRightButtonClick:(id)sender
{
    if (nil==self.textFieldInEditing)
    {
        [self.schemeManager setSchemeNameInUsing:self.schemeName];
        [self goBack:sender];
    }
    else
    {
        [self commitEditing];
    }
}

- (void)addButtonClick:(id)sender
{
    NSInteger index=((UIButton*)sender).tag;
    
    NSString *newName_base=@"新选项";
    NSString *newName_attempt=newName_base;
    NSInteger counter=1;
    NSArray *strList=[[self.schemeManager wheelArrayOfScheme:self.schemeName] objectAtIndex:index-1];
    while (NSNotFound!=[strList indexOfObject:newName_attempt])
    {
        newName_attempt=[newName_base stringByAppendingFormat:@" %02d",counter++];
    }
 
    
    if ([self.schemeManager wheelStringAdded:newName_attempt forWheel:index-1 ofScheme:self.schemeName])
    {
        [self.schemeManager commitChanging];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:@"该转盘选项数目已达上限" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - title View animation -
-(void)showTitleViewWithAnimation:(BOOL)animate
{
    if (nil!=self.textFieldInEditing)
    {
        [self.textFieldInEditing resignFirstResponder];
    }
    [super showTitleViewWithAnimation:animate];
}

-(void)hideTitleViewWithAnimation:(BOOL)animate
{
    if (nil!=self.textFieldInEditing)
    {
        [self.textFieldInEditing resignFirstResponder];
    }
    [super hideTitleViewWithAnimation:animate];
}


#pragma mark - UITableViewDelegate -
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==[[self.schemeManager schemeNameList] count])
    {
        return 0;
    }
    return FooterHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0==section)
    {
        return 0;
    }
    return HeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0==section)
    {
        return nil;
    }
    NSString *title=nil;
    switch (self.schemeGroupType) {
        case SchemeGroupType_MonoWheel:
            title=@"选项列表";
            break;
        case SchemeGroupType_BiWheel:
            if (1==section)
            {
                title=@"小转盘选项列表";
            }
            else
            {
                title=@"大转盘选项列表";
            }
            break;
        case SchemeGroupType_TriWheel:
            if (1==section)
            {
                title=@"小转盘选项列表";
            }
            else if (2==section)
            {
                title=@"中转盘选项列表";
            }
            else
            {
                title=@"大转盘选项列表";
            }
            break;
        default:
            break;
    }
    HeaderView *hView=[HeaderView headerView];
    hView.titleLabel.text=title;
    hView.addButton.tag=section;
    [hView.addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return hView;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete==editingStyle)
    {
        if ([self.schemeManager wheelStringDeletedAtIndex:indexPath.row forWheel:indexPath.section-1 ofScheme:self.schemeName])
        {
            [self.schemeManager commitChanging];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    }
 
}
#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (self.schemeGroupType)
    {
        case SchemeGroupType_MonoWheel:
            return 2;
            break;
        case SchemeGroupType_BiWheel:
            return 3;
            break;
        case SchemeGroupType_TriWheel:
            return 4;
            break;
            
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0==section)
    {
        return 1;
    }
    return [[[self.schemeManager wheelArrayOfScheme:self.schemeName] objectAtIndex:section-1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseId = @"Cell_In_WheelMenuTableViewController";
    WheelMenuTableViewCell* swcell = (WheelMenuTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:reuseId];
    if (nil==swcell)
    {
        swcell=[WheelMenuTableViewCell tableViewCell];
        swcell.textField.delegate=self;
    }
    
    NSInteger row=indexPath.row;
    NSInteger totalRow=[self tableView:tableView numberOfRowsInSection:indexPath.section];
    CellPlaceType type=CellPlaceType_Unknown;
    if (1==totalRow)
    {
        type=CellPlaceType_Alone;
    }
    else
    {
        if (0==row)
        {
            type=CellPlaceType_Top;
        }
        else if (totalRow-1==row)
        {
            type=CellPlaceType_Bottom;
        }
        else
        {
            type=CellPlaceType_Middle;
        }
    }
    swcell.indexPath=indexPath;
    swcell.textField.indexPath=indexPath;
    if (0==indexPath.section&&0==indexPath.row)
    {
        [swcell configureCellWithText:self.schemeName placeType:type];
    }
    else
    {
        [swcell configureCellWithText:[self.schemeManager stringAtIndex:row forWheel:indexPath.section-1 ofScheme:self.schemeName] placeType:type];
    }
    
    return swcell;
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (nil!=self.textFieldInEditing)
    {
        [self.textFieldInEditing resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate -

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.shouldCommitEditing)
    {
        [self commitEditing];
    }
    return !self.shouldCommitEditing;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat textFieldMaxY=CGRectGetMaxY([textField convertRect:textField.bounds toView:self.view]);
    //keyboard origin.y is 244
    //considering the chinese keyboard addition,minus 30,but this is not the accuracy value.4 in self.view
    CGFloat delta=textFieldMaxY-(244-35);
    if (delta>0)
    {
        CGPoint offset=self.tableView.contentOffset;
        offset.y+=delta;
        self.tableView.contentOffset=offset;
        
    }
    self.textFieldInEditing=(SWTextField*)textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.shouldCommitEditing=NO;
    self.textFieldInEditing=nil;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self commitEditing];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.shouldCommitEditing=YES;
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.shouldCommitEditing=YES;
    return YES;
}

#pragma mark - UIAlertViewDelegate -
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1==buttonIndex)
    {
        [self.schemeManager wheelStringDeletedAtIndex:self.textFieldInEditing.indexPath.row forWheel:self.textFieldInEditing.indexPath.section-1 ofScheme:self.schemeName];
        [self.schemeManager commitChanging];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.textFieldInEditing.indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        self.shouldCommitEditing=NO;
        [self.textFieldInEditing resignFirstResponder];
    }
}

@end
