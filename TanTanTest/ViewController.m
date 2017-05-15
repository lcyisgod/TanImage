//
//  ViewController.m
//  TanTanTest
//
//  Created by LCY on 2017/5/12.
//  Copyright © 2017年 LCY. All rights reserved.
//

#import "ViewController.h"
#import "TanImageView.h"
#import "TanItem.h"

@interface ViewController ()<DateSourceDelegate,ViewDelegate>
@property(nonatomic, strong)NSMutableArray *dataAry;
@property(nonatomic, strong)TanImageView *tanView;
@property(nonatomic, strong)UIButton *leftBtn;
@property(nonatomic, strong)UIButton *reloadBtn;
@property(nonatomic, strong)UIButton *rightBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self resignNotification];
    [self creatViews];
    [self.tanView reLoadData];
}

-(void)resignNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDirection:) name:@"removeDirection" object:nil];
}

-(void)getDirection:(NSNotification *)notificaion
{
    
}

-(void)creatViews
{
    self.tanView = [TanImageView createTanImageViewSupView:self.view withFrame:CGRectMake(self.view.center.x-150, self.view.center.y-150, 300, 400)];
    self.tanView.dataSource = self;
    self.tanView.delegate = self;
    
    self.leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.tanView.frame), CGRectGetMaxY(self.tanView.frame)+20, 80, 30)];
    [self.leftBtn setTitle:@"不喜欢" forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:self.leftBtn];
    
    self.reloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.tanView.center.x-20, CGRectGetMaxY(self.tanView.frame)+20, 40, 30)];
    [self.reloadBtn setTitle:@"重置" forState:UIControlStateNormal];
    [self.reloadBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.reloadBtn addTarget:self action:@selector(reLoadData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.reloadBtn];
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tanView.frame)-40, CGRectGetMaxY(self.tanView.frame)+20, 40, 30)];
    [self.rightBtn setTitle:@"喜欢" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:self.rightBtn];
}

-(NSMutableArray *)dataAry
{
    if (!_dataAry) {
        self.dataAry = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i++) {
            [self.dataAry addObject:[NSString stringWithFormat:@"img%d",i+1]];
        }
    }
    return _dataAry;
}

-(void)clickEvent:(UIButton *)sender
{
    if (sender == self.leftBtn) {
        [self.tanView removeImgFromeLeft:YES];
    }else{
        [self.tanView removeImgFromeLeft:NO];
    }
}

-(void)reLoadData:(UIButton *)sender
{
    [self.tanView reLoadData];
}

#pragma mark-DataSourceDelegta
-(int)numberOfItems
{
    return (int)self.dataAry.count;
}


#pragma mark-ViewDelegate
-(TanItem *)tanView:(TanImageView *)view inRow:(int)row
{
    TanItem *item = [[TanItem alloc] init];
    [item upDataWithName:[self.dataAry objectAtIndex:row]];
    return item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
