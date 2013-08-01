//
//  UIControl+DDBlockActions.m
//
//  code by :
//  http://stackoverflow.com/users/115730/dave-delong
//  http://stackoverflow.com/questions/4581782/can-i-pass-a-block-as-a-selector-with-objective-c
//

#import "UIControl+DDBlockActions.h"

#import <objc/runtime.h>


@interface DDBlockActionWrapper : NSObject

@property (nonatomic, copy) void (^blockAction)(void);

- (void)invokeBlock:(id)sender;

@end

@implementation DDBlockActionWrapper

@synthesize blockAction = _blockAction;

- (void)dealloc
{
    [self setBlockAction:nil];
    [super dealloc];
}

- (void)invokeBlock:(id)sender
{
    [self blockAction]();
}

@end


@implementation UIControl (DDBlockActions)

static const char *UIControlDDBlockActions = "unique";

- (void)handlerControlEvents:(UIControlEvents)controlEvents
               byBlockAction:(void(^)(void))theBlockAction
{
    
    NSMutableArray *blockActions =
    objc_getAssociatedObject(self, &UIControlDDBlockActions);
    
    if (blockActions == nil)
    {
        blockActions = [NSMutableArray array];
        objc_setAssociatedObject(self, &UIControlDDBlockActions,
                                 blockActions, OBJC_ASSOCIATION_RETAIN);
    }
    
    DDBlockActionWrapper *target = [[DDBlockActionWrapper alloc] init];
    [target setBlockAction:theBlockAction];
    [blockActions addObject:target];
    
    [self addTarget:target action:@selector(invokeBlock:) forControlEvents:controlEvents];
    [target release];
}

@end
