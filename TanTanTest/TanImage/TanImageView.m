//
//  TanImageView.m
//  TanTanTest
//
//  Created by LCY on 2017/5/12.
//  Copyright © 2017年 LCY. All rights reserved.
//

#import "TanImageView.h"
#import "TanItem.h"

@interface TanImageView ()<removeDelegate>
@property(nonatomic, strong)NSMutableArray *imageAry;
@property(nonatomic, assign)int count;
@end
@implementation TanImageView

+(TanImageView *)createTanImageViewSupView:(UIView *)sup withFrame:(CGRect)frame
{
    TanImageView *tanImage = [[TanImageView alloc] initWithFrame:frame];
    [sup addSubview:tanImage];
    return tanImage;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)reLoadData
{
    if (self.dataSource == nil) {
        return;
    }
    [self.imageAry removeAllObjects];
    if ([self.dataSource respondsToSelector:@selector(numberOfItems)]) {
        self.count = [self.dataSource numberOfItems];
    }
    [self createImageviews];
}

//创建图片
-(void)createImageviews
{
    for (TanItem *item in [self subviews]) {
        [item removeFromSuperview];
    }
    
    for (int i = 0; i < self.count; i++) {
        CGSize size = [self sizeOfItemWithRow:i];
        TanItem *item = [self creatItemWithRow:i];
        item.delegate = self;
        [self addSubview:item];
        [self.imageAry addObject:item];
        item.frame = CGRectMake(self.frame.size.width/2-size.width/2, self.frame.size.height/2-size.height/2, size.width, size.height);
        item.transform = CGAffineTransformMakeTranslation(self.frame.size.width+300, 340);
        [UIView animateKeyframesWithDuration:0.15 delay:0.05 * i options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            CGAffineTransform scaleTransfrom = CGAffineTransformMakeScale(1 - 0.005 * (10 - i), 1);
            item.transform = CGAffineTransformTranslate(scaleTransfrom, 0, 0.5 * (10 - i));
        } completion:nil];
        item.userInteractionEnabled = YES;
    }
}

//设置Item的尺寸
-(CGSize)sizeOfItemWithRow:(int)row
{
    if ([self.delegate respondsToSelector:@selector(sizeItem:inRow:)]) {
        CGSize size = [self.delegate sizeItem:self inRow:row];
        if (size.width > self.frame.size.width) {
            size.width = self.frame.size.width;
        }
        
        if (size.height > self.frame.size.height) {
            size.height = self.frame.size.height;
        }
        return size;
    }
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

//创建一个Item
-(TanItem *)creatItemWithRow:(int)row
{
    
    if ([self.delegate respondsToSelector:@selector(tanView:inRow:)]) {
        TanItem *item = [self.delegate tanView:self inRow:row];
        if (!item) {
            item = [[TanItem alloc] init];
        }
        return item;
    }else{
        return [[TanItem alloc] init];
    }
}

//存放Item的数组
-(NSMutableArray *)imageAry
{
    if (!_imageAry) {
        self.imageAry = [[NSMutableArray alloc] init];
    }
    return _imageAry;
}

//移除图片
-(void)removeImgFromeLeft:(BOOL)left
{
    TanItem *item = [self.imageAry lastObject];
    [item removeFromeLeft:left];
}


#pragma mark-removeDelegate
-(void)removeFromeView:(TanItem *)view
{
    [self.imageAry removeObject:view];
    [view removeFromSuperview];
    if (self.imageAry.count == 0) {
        [self reLoadData];
    }
}

-(CGFloat)moveWidth:(TanItem *)view
{
    if ([self.delegate respondsToSelector:@selector(sliderWidth)]) {
        return [self.delegate sliderWidth];
    }
    return view.frame.size.width/3;
}


@end
