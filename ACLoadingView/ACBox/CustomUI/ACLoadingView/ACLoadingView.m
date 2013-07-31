//
//  ACLoadingView.m
//  ACBaseProject
//
//  Created by Albert Chu on 13-7-22.
//  Copyright (c) 2013年 Albert Chu. All rights reserved.
//

#import "ACLoadingView.h"

#import <QuartzCore/QuartzCore.h>

#define ACLV_FontSize       16.f    // 提示信息字体大小
#define ACLV_Height         50.f    // 视图黑色区域高度
#define ACLV_VIEW_ALPHA     0.8f    // 视图透明度

#define ACLV_USING_TYPE ACLoadingViewTypeiOS     // 正在使用的样式

typedef enum
{
    ACLoadingViewTypeiOS = 213213,      // iOS 风格
    ACLoadingViewTypeSmooth,            // 圆角 风格
    ACLoadingViewTypeSquare             // 方形 风格
} ACLoadingViewType;


@interface ACLoadingView ()
{
    /** 背景遮罩 */
    UIControl               *_mask;
    
    /** 菊花 */
    UIActivityIndicatorView *_theIndicatorAV;
    
    /** 文字标签 */
    UILabel                 *_textLabel;
    
    /** 关闭按钮 */
    UIButton                *_closeButton;
    
    /** 背景层 */
    CALayer                 *_viewBG;
    
    /** 分割线 */
    CALayer                 *_separateLine;
}

@end


@implementation ACLoadingView


#pragma mark - Action Method

- (void)closeBtnPressed:(UIButton *)closeBtn
{
    if (nil != _delegate && [_delegate respondsToSelector:@selector(closeButtonPressed:)])
    {
        [_delegate closeButtonPressed:closeBtn];
    }
}

#pragma mark - Public Methods

- (void)showACLoadingViewOnView:(UIView *)theView withText:(NSString *)theText
{
    // iOS 风格
    if (ACLoadingViewTypeiOS == ACLV_USING_TYPE)
    {
        [self createLoadingViewAsiOSTypeOnView:theView withText:theText];
    }
    
    // 方形 风格
    else if (ACLoadingViewTypeSquare == ACLV_USING_TYPE)
    {
        [self createLoadingViewAsSquareTypeOnView:theView withText:theText];
    }
    
    // 圆角 风格
    else
    {
        [self createLoadingViewAsSmoothTypeOnView:theView withText:theText];
    }
    
}

- (void)hideLoadingView
{
    [_theIndicatorAV stopAnimating];
    
    [UIView animateWithDuration:0.25
                     animations:
                                 ^
                                 {
                                     [self setAlpha:0.f];
                                     
                                     [_mask setAlpha:0.f];
                                 }
                     completion:
                                 ^(BOOL finished)
                                 {

                                 }
     ];
}

#pragma mark - Private Method

- (void)popupAnimation:(UIView *)outView duration:(CFTimeInterval)duration
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    
    NSMutableArray * values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    [outView.layer addAnimation:animation forKey:nil];
}


/** iOS样式 */
- (void)createLoadingViewAsiOSTypeOnView:(UIView *)theView withText:(NSString *)theText
{
    // 字符串显示的宽度
    CGSize lableSize = [theText sizeWithFont:[UIFont boldSystemFontOfSize:ACLV_FontSize]
                           constrainedToSize:CGSizeMake(200.f, MAXFLOAT)
                               lineBreakMode:LINE_BREAK_WORD_WRAP];
    
    CGFloat closeBtn_w_h = 20.f;
    
    // (x) 20x20 的 关闭按钮以左上角为中点， 所以 view 宽高 加 20.f 相当于 10.f 的透明边框，便于计算
    
    //  20   20   15    lableSize.width   10                    |
    //  [ ]  *    []    _______________   [ ]                   |>  高度 50
    //  间距 菊花  间距   字符显示长度        间距                   |
    
        
    // 得出 背景色 的 显示宽度
    CGFloat bg_width = 20 + 20 + 10 + lableSize.width + 10;
    
    [_viewBG setCornerRadius:(5.f)];
    [_viewBG setMasksToBounds:YES];
    
    [_viewBG setFrame:CGRectMake(closeBtn_w_h / 2.f,
                                 closeBtn_w_h / 2.f,
                                 bg_width,
                                 ACLV_Height)];
    
    
    // 得出 self 的 显示宽度
    CGFloat view_width = bg_width + closeBtn_w_h;
    //DLog(@"%f", view_width);
    
    CGFloat view_height = ACLV_Height + closeBtn_w_h;
    
    [self setBounds:CGRectMake(0,
                               0,
                               view_width,
                               view_height)];
    
    //-- 旋转动画 -----------------------------------------------------------------------------------
    _theIndicatorAV.frame = CGRectMake(20.f,
                                       (view_height - 20) / 2.f,
                                       20.f,
                                       20.f);
    
    [_theIndicatorAV setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    
    //UIActivityIndicatorViewStyleWhiteLarge,
    //UIActivityIndicatorViewStyleWhite,
    //UIActivityIndicatorViewStyleGray,
    
    [_theIndicatorAV startAnimating];
    //---------------------------------------------------------------------------------------------;
    
    
    //-- 文字标签 -----------------------------------------------------------------------------------
    [_textLabel setFrame:CGRectMake(20 + 20 + 10.f,
                                    (view_height - lableSize.height) / 2,
                                    lableSize.width,
                                    lableSize.height)];
    
    [_textLabel setFont:[UIFont boldSystemFontOfSize:ACLV_FontSize]];
    [_textLabel setText:theText];
    //---------------------------------------------------------------------------------------------;
    
    
    //-- 关闭按钮 -----------------------------------------------------------------------------------
    //[_closeButton setBackgroundColor:[UIColor clearColor]];
    [_closeButton setBackgroundImage:PNGIMAGE(@"btn_close") forState:UIControlStateNormal];
    
    [_closeButton setFrame:CGRectMake(0.f,
                                      0.f,
                                      closeBtn_w_h,
                                      closeBtn_w_h)];
    //---------------------------------------------------------------------------------------------;
    
    //DLog(@"%f----%f", theView.frame.size.height, theView.bounds.size.height);
    
    //** 开始显示 ***********************************************************************************
    //[self setCenter:theView.center];
    
    [self setFrame:CGRectMake((theView.frame.size.width - view_width) / 2.f,
                              (theView.frame.size.height - view_height) / 2.f,
                              view_width,
                              view_height)];
    
    [theView addSubview:_mask];
    [theView addSubview:(UIView *)self];
    [theView bringSubviewToFront:self];
    
    [_mask setAlpha:.2f];
    [self setAlpha:ACLV_VIEW_ALPHA];
    
    [self popupAnimation:self duration:0.5];
    
}

/** 圆角风格 （关闭按钮在左） */
- (void)createLoadingViewAsSmoothTypeOnView:(UIView *)theView withText:(NSString *)theText
{
    // 字符串显示的宽度
    CGSize lableSize = [theText sizeWithFont:[UIFont boldSystemFontOfSize:ACLV_FontSize]
                           constrainedToSize:CGSizeMake(200.f, MAXFLOAT)
                               lineBreakMode:LINE_BREAK_WORD_WRAP];
    
    //    50        15       lableSize.width   10      20     15       |
    //    x         []       _______________   []      *      []       |>  高度 50
    //  关闭按钮     间距      字符显示长度        间距    菊花    间距      |
    
    // 得出 self 的 显示宽度
    CGFloat view_width = ACLV_Height + 15 + lableSize.width + 10 + 20 + 15.f;
    
    // 背景色 的 显示宽度 与 self 大小一致
    [_viewBG setCornerRadius:(5.f)];
    [_viewBG setMasksToBounds:YES];
    [_viewBG setFrame:CGRectMake(0.f,
                                 0.f,
                                 view_width,
                                 ACLV_Height)];
    
    
    //-- 关闭按钮 -----------------------------------------------------------------------------------
    [_closeButton setBackgroundColor:[UIColor clearColor]];
    _closeButton.titleLabel.font = [UIFont systemFontOfSize:20.f];
    [_closeButton setTitle:@"x" forState:UIControlStateNormal];
    
    CGFloat closeBtn_w = ACLV_Height;
    CGFloat closeBtn_h = closeBtn_w;
    CGFloat closeBtn_x = 0.f;
    CGFloat closeBtn_y = 0.f;
    [_closeButton setFrame:CGRectMake(closeBtn_x,
                                      closeBtn_y,
                                      closeBtn_w,
                                      closeBtn_h)];
    //---------------------------------------------------------------------------------------------;
    
    
    // 白色分割线
    _separateLine.hidden = NO;
    [_separateLine setFrame:CGRectMake(ACLV_Height,
                                       0.f,
                                       1.f,
                                       ACLV_Height)];
    
    
    //-- 文字标签 -----------------------------------------------------------------------------------
    [_textLabel setFrame:CGRectMake(ACLV_Height + 15,
                                    (ACLV_Height - lableSize.height) / 2,
                                    lableSize.width,
                                    lableSize.height)];
    
    [_textLabel setFont:[UIFont boldSystemFontOfSize:ACLV_FontSize]];
    [_textLabel setText:theText];
    //---------------------------------------------------------------------------------------------;
    
    //-- 旋转动画 -----------------------------------------------------------------------------------
    _theIndicatorAV.frame = CGRectMake(view_width - 35.f,
                                       (ACLV_Height - 20) / 2.f,
                                       20.f,
                                       20.f);
    
    [_theIndicatorAV setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        
    [_theIndicatorAV startAnimating];
    //---------------------------------------------------------------------------------------------;
    
        
    //** 开始显示 ***********************************************************************************    
    [self setFrame:CGRectMake((theView.frame.size.width - view_width) / 2.f,
                              (theView.frame.size.height - ACLV_Height) / 2.f,
                              view_width,
                              ACLV_Height)];
    
    [theView addSubview:_mask];
    [theView addSubview:(UIView *)self];
    [theView bringSubviewToFront:self];
    
    [_mask setAlpha:.2f];
    [self setAlpha:ACLV_VIEW_ALPHA];
    
    [self popupAnimation:self duration:0.5];
}

/** 方形风格 */
- (void)createLoadingViewAsSquareTypeOnView:(UIView *)theView withText:(NSString *)theText
{
    // 字符串显示的宽度
    CGSize lableSize = [theText sizeWithFont:[UIFont boldSystemFontOfSize:ACLV_FontSize]
                           constrainedToSize:CGSizeMake(200.f, MAXFLOAT)
                               lineBreakMode:LINE_BREAK_WORD_WRAP];
    
    
    //DLog(@"W:%f-----H:%f", lableSize.width, lableSize.height);
    
    
    //  10   20   5    lableSize.width   15      50              |
    //  [ ]  *   []    _______________   [ ]      x              |>  高度 50
    //  间距 菊花  间距   字符显示长度      间距     关闭按钮          |
    
    
    // 得出 self 的 显示宽度
    CGFloat view_width = 10 + 20 + 5 + lableSize.width + 15 + ACLV_Height;
    //DLog(@"%f", view_width);
    
//    [self setBounds:CGRectMake(0,
//                               0,
//                               view_width,
//                               ACLV_Height)];
    
    // 背景色 的 显示宽度 与 self 大小一致
    [_viewBG setFrame:CGRectMake(0.f,
                                 0.f,
                                 view_width,
                                 ACLV_Height)];
    
    //-- 旋转动画 -----------------------------------------------------------------------------------
    _theIndicatorAV.frame = CGRectMake(10.f,
                                       (ACLV_Height - 20) / 2.f,
                                       20.f,
                                       20.f);
    
    [_theIndicatorAV setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    
    //UIActivityIndicatorViewStyleWhiteLarge,
    //UIActivityIndicatorViewStyleWhite,
    //UIActivityIndicatorViewStyleGray,
    
    
    [_theIndicatorAV startAnimating];
    //---------------------------------------------------------------------------------------------;
    
    
    //-- 文字标签 -----------------------------------------------------------------------------------
    [_textLabel setFrame:CGRectMake(10 + 20 + 5.f,
                                    (ACLV_Height - lableSize.height) / 2,
                                    lableSize.width,
                                    lableSize.height)];
    
    [_textLabel setFont:[UIFont boldSystemFontOfSize:ACLV_FontSize]];
    [_textLabel setText:theText];
    //---------------------------------------------------------------------------------------------;
    
    
    // 白色分割线
    _separateLine.hidden = NO;
    [_separateLine setFrame:CGRectMake(view_width - ACLV_Height - 1.f,
                                       0.f,
                                       1.f,
                                       ACLV_Height)];
    
    
    //-- 关闭按钮 -----------------------------------------------------------------------------------
    [_closeButton setBackgroundColor:[UIColor clearColor]];
    _closeButton.titleLabel.font = [UIFont systemFontOfSize:20.f];
    [_closeButton setTitle:@"x" forState:UIControlStateNormal];
    //[_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[_closeButton setTitleColor:[UIColor grayColor] forState:UIControlEventTouchUpInside];
    
    CGFloat closeBtn_w = ACLV_Height;
    CGFloat closeBtn_h = closeBtn_w;
    CGFloat closeBtn_x = view_width - ((ACLV_Height - closeBtn_w) / 2) - closeBtn_w;
    CGFloat closeBtn_y = 0.f;
    [_closeButton setFrame:CGRectMake(closeBtn_x,
                                      closeBtn_y,
                                      closeBtn_w,
                                      closeBtn_h)];
    //---------------------------------------------------------------------------------------------;
    
    
    //DLog(@"%f----%f", theView.frame.size.height, theView.bounds.size.height);
    
    //** 开始显示 ***********************************************************************************
    //[self setCenter:theView.center];
    
    [self setFrame:CGRectMake((theView.frame.size.width - view_width) / 2.f,
                              (theView.frame.size.height - ACLV_Height) / 2.f,
                              view_width,
                              ACLV_Height)];
    
    [theView addSubview:_mask];
    [theView addSubview:(UIView *)self];
    [theView bringSubviewToFront:self];
    
    [_mask setAlpha:.2f];
    [self setAlpha:ACLV_VIEW_ALPHA];
    
    [self popupAnimation:self duration:0.5];
}



#pragma mark - Life Cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code
        
        //-- 遮罩 view -----------------------------------------------------------------------------
        _mask = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        [_mask setBackgroundColor:[UIColor blackColor]];
        //[_mask addTarget:self action:@selector(maskTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_mask setAlpha:0.f];
        //-----------------------------------------------------------------------------------------;
        
        [self setAlpha:0];
        
        // 清楚原背景色
        [self setBackgroundColor:[UIColor clearColor]];
        
        // 背景色层
        _viewBG = [[CALayer alloc] init];
        [_viewBG setBackgroundColor:[UIColor blackColor].CGColor];
        [self.layer addSublayer:_viewBG];
                
        // 菊花
        _theIndicatorAV = [[UIActivityIndicatorView alloc] init];
        [self addSubview:_theIndicatorAV];
        
        // 文本标签
        _textLabel = [[UILabel alloc] init];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [_textLabel setTextColor:[UIColor whiteColor]];
        [_textLabel setTextAlignment:TextAlignmentCenter];
        [self addSubview:_textLabel];
                
        // 关闭按钮
        _closeButton = [[UIButton alloc] init];
        [_closeButton addTarget:self action:@selector(closeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_closeButton];
        
        // 白色分割线
        _separateLine = [[CALayer alloc] init];
        [_separateLine setBackgroundColor:[UIColor grayColor].CGColor];
        _separateLine.hidden = YES;
        [self.layer addSublayer:_separateLine];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
