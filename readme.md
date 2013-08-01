# ACLoadingView
--------------------

带关闭按钮的加载动画

<img src="https://github.com/albertgh/ACLoadingView/raw/master/screenshot.gif"/>



# Usage

1) Drag ACLoadingView.h and ACLoadingView.m into your project.  Add QuartzCore.framework

    #import "ACLoadingView.h"
    
	

2) Create ACLoadingView
	
    _theACLV = [[ACLoadingView alloc] init];
    


3) 调用方式
	
	// 显示加载视图
    [_theACLV showACLoadingViewInView:self.view withText:@"your loading text"];

    // 隐藏加载视图
    [_theACLV hideLoadingView];
   
    

4) 关闭按钮代理回调

 	// 实现 <ACLVCloseButtonDelegate> 协议

	_theACLV.delegate = self;

 	// 加上回调方法

 	#pragma mark - ACLoadingViewCloseButtonDelegate

	- (void)closeButtonPressed:(UIButton *)closeButton
	{
		[_theACLV hideLoadingView];
	    //_isLoading = NO;
	    DLog(@"取消按钮时相应操作，取消http请求等操作。");
	}

5) 风格

	在 ACLoadingView.h 头部宏中选择
	ACLV_USING_TYPE 

	下方截图是最开始时做的几种样式
	默认使用最上方动态图中的 ACLoadingViewTypeMellow 样式
	需要改变 Cancel 字符串 请在头部宏 ACLV_Cancel_String 改

<img src="https://github.com/albertgh/ACLoadingView/raw/master/style.png"/>



## Minimum Requirements

* ARC - this project uses ARC. If you are not using ARC in your project, add '-fobjc-arc' as a compiler flag for ACLoadingView.m
* XCode 4.4 and newer (auto-synthesis required)



## Contact

Twitter、Weibo @码农白腩肚


