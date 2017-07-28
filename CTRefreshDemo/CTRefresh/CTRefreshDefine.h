//
//  CTRefreshDefine.h
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/25.
//  Copyright © 2017年 Demo. All rights reserved.
//

typedef NS_ENUM(NSInteger, CTScrollViewPanState) {
    /** 无手势状态 */
    CTScrollViewPanStateNormal,
    /** 手势开始 */
    CTScrollViewPanStateBegin,
    /** 拉拽中 */
    CTScrollViewPanStatePulling,
    /** 手势松开状态 */
    CTScrollViewPanStateLoosen,
};

typedef NS_ENUM(NSInteger, CTHeaderRefreshStatus) {
    /** header正常状态 */
    CTHeaderRefreshStatusNormal,
    /** header松开可刷新状态 */
    CTHeaderRefreshStatusShouldRefresh,
    /** header刷新中 */
    CTHeaderRefreshStatusRefreshing,
    /** header刷新结果反馈 */
    CTHeaderRefreshStatusRefreshResultFeedback,
    /** header结束刷新中*/
    CTHeaderRefreshStatusRefreshEnding,
};

typedef NS_ENUM(NSInteger, CTFooterRefreshStatus) {
    /** footer正常状态 */
    CTFooterRefreshStatusNormal,
    /** footer将要出现时 */
    CTFooterRefreshStatusWillAppear,
    /** footer松开可刷新状态 */
    CTFooterRefreshStatusShouldRefresh,
    /** footer刷新中 */
    CTFooterRefreshStatusRefreshing,
    /** footer刷新结果反馈 */
    CTFooterRefreshStatusRefreshResultFeedback,
    /** footer结束刷新中*/
    CTFooterRefreshStatusRefreshEnding,
};

