//
//  CTRefreshLogicProtocol.h
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/27.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTRefreshDefine.h"

@protocol CTRefreshLogicProtocol <NSObject>


@required

- (void)changeFooterViewFrame;

- (void)changeHeaderStatusWithOffsetY:(CGFloat)offsetY;

- (void)changeFooterStatusWithOffsetY:(CGFloat)offsetY;

- (void)beginRefresh;

- (void)endHeaderRefresh;

- (void)endFooterRefresh;

@end


