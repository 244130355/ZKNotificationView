//
//  ZKNotificationView.h
//  ZKNSNotificationView
//
//  Created by mosaic on 2017/4/29.
//  Copyright © 2017年 mosaic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKNotificationDefine.h"
typedef void (^NotificationViewFinished)();


@interface ZKNotificationView : UIView



+(void)show:(NSString*)msg block:(NotificationViewFinished)finishBlock;//需要调用hidden隐藏,点击隐藏,触发block
+(void)show:(NSString *)msg delay:(NSTimeInterval)time block:(NotificationViewFinished)finishBlock;//自定义显示时间,调用hidden可以提前结束显示

+(void)showViewName:(NSString*)showName icon:(NSString*)imageName msg:(NSString*)msg block:(NotificationViewFinished)finishBlock;//自定义显示icon 和title 默认为app的icon与name 

+(void)showViewName:(NSString*)showName icon:(NSString*)imageName msg:(NSString*)msg delay:(NSTimeInterval)time block:(NotificationViewFinished)finishBlock;

+(void)hidden;


@end
