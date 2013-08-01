//
//  UIControl+DDBlockActions.m
//
//  code by :
//  http://stackoverflow.com/users/115730/dave-delong
//  http://stackoverflow.com/questions/4581782/can-i-pass-a-block-as-a-selector-with-objective-c
//

#import <UIKit/UIKit.h>

@interface UIControl (DDBlockActions)

- (void)handlerControlEvents:(UIControlEvents)controlEvents
               byBlockAction:(void(^)(void))theBlockAction;

@end
