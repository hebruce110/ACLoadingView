//
//  ACLoadingView.h
//  ACBaseProject
//
//  Created by Albert Chu on 13-7-22.
//  Copyright (c) 2013年 Albert Chu. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 关闭载按钮 委托协议 */
@protocol ACLoadingViewCloseButtonDelegate <NSObject>

/**
 * 关闭按钮 代理回调方法
 * @param closeButton 刷新按钮
 */
- (void)closeButtonPressed:(UIButton *)closeButton;

@end



@interface ACLoadingView : UIView

/** 关闭按钮动作 代理 */
@property (nonatomic, assign) id <ACLoadingViewCloseButtonDelegate> delegate;


/**
 * 在指定UIView上显示 加载动画
 * @param theView 指定的UIView
 * @param theText 加载提示字符串
 */
- (void)showACLoadingViewInView:(UIView *)theView withText:(NSString *)theText;

@end
