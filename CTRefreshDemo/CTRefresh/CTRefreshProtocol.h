//
//  CTRefreshProtocol.h
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/25.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTRefreshDefine.h"

@protocol CTRefreshHeaderProtocol <NSObject>

@optional;
- (UIView *)refreshHeaderView;
- (CGFloat)refreshHeaderHeight;
- (void)refreshHeaderStatus:(CTHeaderRefreshStatus)status;

@end


