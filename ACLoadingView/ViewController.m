//
//  ViewController.m
//  ACLoadingView
//
//  Created by Apple on 13-7-22.
//  Copyright (c) 2013年 Albert Chu. All rights reserved.
//

#import "ViewController.h"

#import "ACLoadingView.h"

@interface ViewController () <ACLVCloseButtonDelegate>
{
    ACLoadingView *_theACLV;
    
    BOOL _isLoading;
}

@end


@implementation ViewController


#pragma mark - Action Methods

- (void)barButtonItemPressed:(UIButton *)sender
{
    [UIAlertView showAlertViewWithTitle:@"Notice"
                                message:@"Can't reach this button while loading."
                      cancelButtonTitle:nil
                      otherButtonTitles:[NSArray arrayWithObject:@"I see"]
                              onDismiss:^(int buttonIndex)
                                        {
                                            NSLog(@"Button Dismissed");
                                        }
                               onCancel:^{}];
}

- (IBAction)showACLVBtnPressed:(UIButton *)sender
{
    // 如果在导航视图控制器中，建议显示在 self.navigationController.view 上，因为关闭按钮的意义就在于禁用包括导航返回的操作。
    [_theACLV showACLoadingViewInView:self.navigationController.view withText:@"loading..."];
    _isLoading = YES;
}


#pragma mark - ACLVCloseButtonDelegate

- (void)closeButtonPressed:(UIButton *)closeButton
{
    [_theACLV hideLoadingView];
    _isLoading = NO;
    DLog(@"关闭时相应操作，如取消http请求等。");
}


#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"ACLVSample";
    
    //DLog(@"%f", self.view.frame.size.height);
    
    _theACLV = [[ACLoadingView alloc] init];
    _theACLV.delegate = self;
    
    
    //** barButton **************************************************************************
	UIBarButtonItem *showButtonItem =
    [[UIBarButtonItem alloc]initWithTitle:@"notice"
                                    style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(barButtonItemPressed:)];
    
    showButtonItem.tintColor = C_BarButtonItemTintColor;
    
    self.navigationItem.rightBarButtonItem = showButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
