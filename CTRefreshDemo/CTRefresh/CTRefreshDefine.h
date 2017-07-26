//
//  CTRefreshDefine.h
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/25.
//  Copyright © 2017年 Demo. All rights reserved.
//

typedef NS_ENUM(NSInteger, CTHeaderRefreshStatus) {
    /** header正常状态 */
    CTHeaderRefreshStatusNormal,
    /** header松开可刷新状态 */
    CTHeaderRefreshStatusShouldRefresh,
    /** header刷新中 */
    CTHeaderRefreshStatusRefreshing,
};

typedef NS_ENUM(NSInteger, CTFooterRefreshStatus) {
    /** footer正常状态 */
    CTFooterRefreshStatusNormal,
    /** footer松开可刷新状态 */
    CTFooterRefreshStatusShouldRefresh,
    /** footer刷新中 */
    CTFooterRefreshStatusRefreshing,
};

