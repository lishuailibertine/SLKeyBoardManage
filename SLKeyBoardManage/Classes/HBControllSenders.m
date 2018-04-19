//
//  HBControllSenders.m
//  HBStockWarning
//
//  Created by Touker on 2018/4/3.
//  Copyright © 2018年 Touker. All rights reserved.
//

#import "HBControllSenders.h"
#import "HBKeyBoardManage.h"
#import <objc/runtime.h>

NSString *const HBResponderGetMoveViewNotify =@"HBResponderGetMoveViewNotify";
NSString *const KResponderGetMoveViewBlock =@"KResponderGetMoveViewBlock";

static const char *KListening = "KListening";

@implementation UITextField (HBControllSender)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UITextField swizzlingInstance:self orginalMethod:NSSelectorFromString(@"dealloc") replaceMethod:NSSelectorFromString(@"textField_dealloc")];
    });
}
- (void)setHb_MoveView:(UIView *)hb_MoveView{
    objc_setAssociatedObject(self, @selector(hb_MoveView), hb_MoveView, OBJC_ASSOCIATION_ASSIGN);
    [self addTarget:[HBKeyBoardManage sharedInstance] action:NSSelectorFromString(@"hb_controlBeginEditing:") forControlEvents:UIControlEventEditingDidBegin];
}
- (UIView *)hb_MoveView{
     return objc_getAssociatedObject(self, _cmd);
}
- (void)setHb_KeyBoardDistance:(CGFloat)hb_KeyBoardDistance{
    objc_setAssociatedObject(self, @selector(hb_KeyBoardDistance), @(hb_KeyBoardDistance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)hb_KeyBoardDistance{
    id distance = objc_getAssociatedObject(self, _cmd);
    return distance?[distance floatValue]:10.0;
}
- (void)setHb_Listening:(BOOL)hb_Listening{
    if (hb_Listening) {
        __weak typeof(self) this =self;
        GetMoveViewBlock block = ^(UIView *moveView){
            this.hb_MoveView =moveView;
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:HBResponderGetMoveViewNotify object:nil userInfo:@{@"KResponderGetMoveViewBlock":block}];
    }
    objc_setAssociatedObject(self, KListening, @(hb_Listening), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)hb_Listening{
    NSNumber *number = objc_getAssociatedObject(self, KListening);;
    return  [number boolValue];
}
-(void)textField_dealloc{
    if ([self hb_Listening]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [self textField_dealloc];
}
#pragma mark -private
+(BOOL)swizzlingInstance:(Class)clz orginalMethod:(SEL)originalSelector  replaceMethod:(SEL)replaceSelector{
    
    Method original = class_getInstanceMethod(clz, originalSelector);
    Method replace = class_getInstanceMethod(clz, replaceSelector);
    BOOL didAddMethod =
    class_addMethod(clz,
                    originalSelector,
                    method_getImplementation(replace),
                    method_getTypeEncoding(replace));
    
    if (didAddMethod) {
        class_replaceMethod(clz,
                            replaceSelector,
                            method_getImplementation(original),
                            method_getTypeEncoding(original));
    } else {
        method_exchangeImplementations(original, replace);
    }
    return YES;
}
@end
