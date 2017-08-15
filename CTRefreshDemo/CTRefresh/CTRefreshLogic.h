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


@protocol CTRefreshLogicDelegateProtocol <NSObject>

- (void)loadData:(CTRefreshType)type;

@end

@interface CTRefreshLogic : NSObject<CTRefreshLogicProtocol>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) CTScrollViewPanState panState;
@property (nonatomic, weak) id<CTRefreshLogicDelegateProtocol>delegate;
@property (nonatomic, assign) CGFloat newOffsetY;

@end
