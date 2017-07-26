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

- (CGFloat)refreshHeaderHeight;
- (void)refreshHeaderStatus:(CTHeaderRefreshStatus)status;
- (void)refreshHeaderScrollOffsetY:(CGFloat)offsetY;

@end

@protocol CTRefreshFooterProtocol <NSObject>

- (CGFloat)refreshFooterHeight;
- (void)refreshFooterStatus:(CTHeaderRefreshStatus)status;
- (void)refreshFooterScrollOffsetY:(CGFloat)offsetY;

@end


