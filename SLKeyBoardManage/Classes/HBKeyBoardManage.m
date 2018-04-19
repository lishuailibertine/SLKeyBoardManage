//
//  HBKeyBoardManage.m
//  HBStockWarning
//
//  Created by Touker on 2018/4/3.
//  Copyright © 2018年 Touker. All rights reserved.
//

#import "HBKeyBoardManage.h"
@interface HBKeyBoardResponder()
/**
 是不是scrollView
 */
@property (nonatomic, assign) BOOL isScrollView;
/**
 原有的tranform
 */
@property (nonatomic, assign) CGAffineTransform transform;
/**
 原有的contentOffset
 */
@property (nonatomic, assign) CGPoint contentOffset;
/**
 原有的contentInset
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;
/**
 记录文本框原有的位置
 */
@property (nonatomic, assign) CGRect frame;
@end

@implementation HBKeyBoardResponder
- (void)setView:(UIView<HBControllSenderProtocol> *)view{
    if (_view.hb_MoveView==view.hb_MoveView) {
        _view =view;
        return;
    }else{
        _view =view;
    }
    if (_view) {
        self.frame = [view convertRect:view.bounds toView:[UIApplication sharedApplication].keyWindow];
    }
    self.isScrollView =(_view!=nil&&[_view isKindOfClass:[UIScrollView class]])?YES:NO;
    self.contentInset =self.isScrollView?((UIScrollView *)view.hb_MoveView).contentInset:UIEdgeInsetsZero;
    self.contentOffset =self.isScrollView?((UIScrollView *)view.hb_MoveView).contentOffset:CGPointZero;
    self.transform =self.isScrollView?CGAffineTransformIdentity:view.transform;
}
- (void)hb_keyboardShowAnimation:(NSTimeInterval)duration offset:(CGFloat)offset{
    if (self.isScrollView) {
        UIScrollView *moveV = (UIScrollView *)self.view.hb_MoveView;
        [UIView animateWithDuration:duration animations:^{
            moveV.contentInset = UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, self.contentInset.bottom + offset, self.contentInset.right);
            moveV.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + offset);
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            self.view.hb_MoveView.transform = CGAffineTransformTranslate(self.transform, 0, -(offset));
        }];
    }
}
- (void)hb_keyboardHiddenAnimation:(NSTimeInterval)duration{
    if (self.isScrollView) {
        UIScrollView *moveV = (UIScrollView *)self.view.hb_MoveView;
        [UIView animateWithDuration:duration animations:^{
            moveV.contentInset = self.contentInset;
            moveV.contentOffset = self.contentOffset;
        }completion:^(BOOL finished) {
            self.view = nil;//防止前一个view没有释放，键盘弹起的时候判断逻辑会出错(可能会crash)
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            self.view.hb_MoveView.transform = self.transform;
        }completion:^(BOOL finished) {
            self.view = nil;
        }];
    }
}
@end

@interface HBKeyBoardManage()
@property (nonatomic, strong)HBKeyBoardResponder *currentResponder;
@end

@implementation HBKeyBoardManage
HBKeyBoardManage *_keyBoardManage;
+ (HBKeyBoardManage *)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _keyBoardManage = [[HBKeyBoardManage alloc] init];
        
    } );
    return _keyBoardManage;
}
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[HBKeyBoardManage sharedInstance] addKeyBoardNotifications];
    });
}
- (HBKeyBoardResponder *)currentResponder{
    if (!_currentResponder) {
        _currentResponder =[[HBKeyBoardResponder alloc] init];
    }
    return _currentResponder;
}
- (void)addKeyBoardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hb_keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hb_keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)hb_keyBoardShow:(NSNotification *)notify{
    if (self.currentResponder.view==nil) {
        return;
    }
    // 获取键盘最终的位置
    CGRect keyBoardEndFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 记录偏移量
    CGFloat offset = [self getOffsetKeyboardWithFrame:keyBoardEndFrame];
    // 如果被遮挡
    if (offset <= 0) {
        return;
    }
    // 处理键盘弹出
    [self.currentResponder hb_keyboardShowAnimation:duration offset:offset];
}
- (void)hb_keyBoardHidden:(NSNotification *)notify{
    if (self.currentResponder.view==nil) {
        return;
    }
    // 恢复移动视图位置
    NSTimeInterval duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self.currentResponder hb_keyboardHiddenAnimation:duration];
}
- (void)hb_controlBeginEditing:(UIView<HBControllSenderProtocol> *)sender{
    if (sender.hb_MoveView==nil) {
        return;
    }
    self.currentResponder.view =sender;
}
- (CGFloat)getOffsetKeyboardWithFrame:(CGRect)frame{
    return CGRectGetMaxY(self.currentResponder.frame) - frame.origin.y  + self.currentResponder.view.hb_KeyBoardDistance;
}
@end
