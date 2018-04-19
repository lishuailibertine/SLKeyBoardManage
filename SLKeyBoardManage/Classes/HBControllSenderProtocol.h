//
//  HBControllSenderProtocol.h
//  HBStockWarning
//
//  Created by Touker on 2018/4/3.
//  Copyright © 2018年 Touker. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol HBControllSenderProtocol <NSObject>
//是否监听
@property (nonatomic, assign) BOOL hb_Listening;
//与键盘之间的距离 默认为10
@property (nonatomic, assign) CGFloat hb_KeyBoardDistance;
//需要做移动的view 默认为当前显示器的view
@property (nonatomic, weak) UIView *hb_MoveView;
@end

