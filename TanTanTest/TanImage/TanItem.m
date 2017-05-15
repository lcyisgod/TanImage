//
//  TanItem.m
//  TanTanTest
//
//  Created by LCY on 2017/5/12.
//  Copyright © 2017年 LCY. All rights reserved.
//

#import "TanItem.h"

@interface TanItem ()
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, assign)BOOL isLeft;
@property(nonatomic, assign)CGFloat currentAngle;
@property(nonatomic, assign)CGPoint originalCenter;
@property(nonatomic, copy)NSString *imageName;
@end
@implementation TanItem

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGesture];
        [self configLayer];
        [self addSubview:self.imageView];
    }
    return self;
}
-(void)layoutSubviews
{
    //获取中心点
    _originalCenter = CGPointMake(self.center.x, self.center.y);
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.imageView.layer.cornerRadius = 6;
}

-(UIImageView *)imageView
{
    if (!_imageView) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

-(void)addGesture
{
    [self setUserInteractionEnabled:YES];
    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMove:)];
    [self addGestureRecognizer:tap];
}

- (void)configLayer {
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
}

-(void)panMove:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:self];
        _isLeft = (point.x<0);
        self.center = CGPointMake(self.center.x+point.x, self.center.y+point.y);
        CGFloat angele = (self.center.x-self.frame.size.width/2.0)/self.frame.size.width/4.0;
        _currentAngle = angele;
        
        self.transform = CGAffineTransformMakeRotation(angele);
        [pan setTranslation:CGPointZero inView:self];
        
    }else if (pan.state == UIGestureRecognizerStateEnded){
        //返回拖动的速度(在x,y轴上)
        CGPoint vel = [pan velocityInView:self];
        //当拖动速度大于500时直接移除
        if (vel.x>500 || vel.x<-500) {
            [self remove];
            return;
        }
        CGFloat width = [self swipWidth];
        //当结束拖动时拖地的距离没有超过宽度的1/3复位，否则移除
        if (self.frame.origin.x<width && self.frame.origin.x>-width) {
            [UIView animateWithDuration:0.5 animations:^{
                self.center = _originalCenter;
                self.transform = CGAffineTransformMakeRotation(0);
            }];
        }else{
            [self remove];
        }
    }
}

//获取可左右滑动的范围,默认是图片宽度的1/3
-(CGFloat)swipWidth
{
    if ([self.delegate respondsToSelector:@selector(moveWidth:)]) {
        CGFloat width = [self.delegate moveWidth:self];
        if (width > self.frame.size.width) {
            return self.frame.size.width/3;
        }
        return [self.delegate moveWidth:self];
    }
    return self.frame.size.width/3;
}

-(void)remove
{
   [UIView animateWithDuration:0.5 animations:^{
       if (!_isLeft) {
           self.center = CGPointMake(self.frame.size.width + 1000, self.center.y + _currentAngle * self.frame.size.height);
       }else{
           self.center = CGPointMake(- 1000, self.center.y - _currentAngle * self.frame.size.height);
       }
   } completion:^(BOOL finished) {
       if ([self.delegate respondsToSelector:@selector(removeFromeView:)]) {
           [self.delegate removeFromeView:self];
           [[NSNotificationCenter defaultCenter] postNotificationName:@"removeDirection" object:@{@"direcion":[NSNumber numberWithBool:_isLeft],@"imgName":self.imageName}];
       }
   }];
}
-(void)upDataWithName:(NSString *)imgName
{
    self.imageName = imgName;
    self.imageView.image = [UIImage imageNamed:imgName];
}

-(void)removeFromeLeft:(BOOL)left
{
    _isLeft = left;
    [self remove];
}

@end
