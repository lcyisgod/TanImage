//
//  TanImageView.h
//  TanTanTest
//
//  Created by LCY on 2017/5/12.
//  Copyright © 2017年 LCY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TanItem ,TanImageView;

@protocol DateSourceDelegate <NSObject>
//图片的数目
-(int)numberOfItems;
@end

@protocol ViewDelegate <NSObject>
-(TanItem *)tanView:(TanImageView *)view inRow:(int)row;
@optional
//设置Item的尺寸
-(CGSize)sizeItem:(TanImageView *)view inRow:(int)row;
//设置Item的可滑动宽度
-(CGFloat)sliderWidth;
@end
@interface TanImageView : UIView
@property(nonatomic, assign)id<DateSourceDelegate> dataSource;
@property(nonatomic, assign)id<ViewDelegate>delegate;
+(TanImageView *)createTanImageViewSupView:(UIView *)sup withFrame:(CGRect)frame;
//加载图片
-(void)reLoadData;
//移除图片
-(void)removeImgFromeLeft:(BOOL)left;
@end
