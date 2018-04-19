//
//  HBKeyBoardManage.h
//  HBStockWarning
//
//  Created by Touker on 2018/4/3.
//  Copyright © 2018年 Touker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBControllSenderProtocol.h"

@interface HBKeyBoardResponder : NSObject
@property (nonatomic, weak) UIView<HBControllSenderProtocol> *view;
@end

@interface HBKeyBoardManage : NSObject

+ (HBKeyBoardManage *)sharedInstance;
@end
