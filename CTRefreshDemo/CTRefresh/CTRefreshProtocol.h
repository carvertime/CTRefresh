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

/** 下拉的偏移量 */
- (void)refreshHeaderScrollOffsetY:(CGFloat)offsetY;

@required
/** 下拉刷新的高度 */
- (CGFloat)refreshHeaderHeight;

/** 返回刷新header的状态 */
- (void)refreshHeaderStatus:(CTHeaderRefreshStatus)status;



@end

@protocol CTRefreshFooterProtocol <NSObject>

@optional
/** 上拉的偏移量 */
- (void)refreshFooterScrollOffsetY:(CGFloat)offsetY;

@required

/** 上拉加载的高度 */
- (CGFloat)refreshFooterHeight;

/** 返回加载footer的状态 */
- (void)refreshFooterStatus:(CTFooterRefreshStatus)status;


@end


