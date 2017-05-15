//
//  TanItem.h
//  TanTanTest
//
//  Created by LCY on 2017/5/12.
//  Copyright © 2017年 LCY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TanItem;
@protocol removeDelegate <NSObject>
-(void)removeFromeView:(TanItem *)view;
//设定可滑动范围
-(CGFloat)moveWidth:(TanItem *)view;
@end

@interface TanItem : UIView
@property(nonatomic, assign)id<removeDelegate>delegate;
-(void)upDataWithName:(NSString *)imgName;
-(void)removeFromeLeft:(BOOL)left;
@end
