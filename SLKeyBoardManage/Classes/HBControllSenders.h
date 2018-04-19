//
//  HBControllSenders.h
//  HBStockWarning
//
//  Created by Touker on 2018/4/3.
//  Copyright © 2018年 Touker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBControllSenderProtocol.h"

//获取滚动view的通知
UIKIT_EXTERN NSString *const HBResponderGetMoveViewNotify;
//block
extern NSString * const KResponderGetMoveViewBlock;

typedef void(^GetMoveViewBlock)(UIView *moveView);
@interface UITextField (HBControllSender)<HBControllSenderProtocol>
@end
