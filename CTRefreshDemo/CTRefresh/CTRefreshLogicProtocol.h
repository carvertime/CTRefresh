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

- (BOOL)headerViewShouldResponse;
- (BOOL)headerViewShouldChangeWithStatus:(CTHeaderRefreshStatus)status;
- (CTHeaderRefreshStatus)handleHeaderViewStatusWithOffsetY:(CGFloat)OffsetY
                                             refreshHeight:(CGFloat)height;

@end


