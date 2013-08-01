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
                                            DLog(@"\r\no::{===> buttonIndex:%d", buttonIndex);
                                        }
                               onCancel:^{}];
}

- (IBAction)showACLVBtnPressed:(UIButton *)sender
{
    // 如果在导航视图控制器中，建议显示在 self.navigationController.view 上，因为关闭按钮的意义就在于禁用包括导航返回的操作。
    [_theACLV showACLoadingViewOnView:self.navigationController.view withText:@"loading... please wait bla bla bla"];
    _isLoading = YES;
    
    // 模拟 6秒 后加载完毕
    [self performSelector:@selector(loadingComplete) withObject:nil afterDelay:6.f];
    
//    double delayInSeconds = 6.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        
//        [self loadingComplete];
//        DLog(@"这个点几次按钮，就会有几个线程。");
//        // 好像 dispatch_after 没有取消的方法，所以这里用不合适
//        
//    });
    
}

#pragma mark - Private Method

- (void)loadingComplete
{
    [_theACLV hideLoadingView];
    _isLoading = NO;
    DLog(@"loadingComplete");
}


#pragma mark - ACLVCloseButtonDelegate

- (void)closeButtonPressed:(UIButton *)closeButton
{
    [_theACLV hideLoadingView];
    _isLoading = NO;
    
    // 取消延迟执行 加载完毕自动隐藏加载动画的方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadingComplete) object:nil];
    
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
