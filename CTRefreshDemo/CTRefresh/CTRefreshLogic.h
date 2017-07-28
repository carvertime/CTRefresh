//
//  CTRefreshLogic.h
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/27.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTRefreshDefine.h"
#import "CTRefreshLogicProtocol.h"

@interface CTRefreshLogic : NSObject<CTRefreshLogicProtocol>

@property (nonatomic, assign) CTScrollViewPanState panState;



@property (nonatomic, assign) CTHeaderRefreshStatus headerRefreshState;

@property (nonatomic, assign) CGFloat newOffsetY;

@property (nonatomic, assign) CGFloat originInsetTop;


@property (nonatomic, assign) CTFooterRefreshStatus footerRefreshState;

@property (nonatomic, assign) CGFloat originInsetBottom;

@property (nonatomic, assign) CGFloat contentSizeHeight;

@property (nonatomic, assign) CGFloat scrollViewHeight;

- (id)initWithInsetTop:(CGFloat)top insetBottom:(CGFloat)bottom;

@end
