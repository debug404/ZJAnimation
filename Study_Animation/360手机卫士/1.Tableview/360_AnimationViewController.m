//
//  360_AnimationViewController.m
//  Study_Animation
//
//  Created by LYY on 2016/10/8.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "360_AnimationViewController.h"
#import "ProgressView.h"
#import <pop/POP.h>

@interface _60_AnimationViewController () {
    
    UIImageView *imgView;
    CGRect imgFrame;
    CGRect layerFrame;
    UILabel *notiLab;
    BOOL isTop;
}
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong)UIScrollView *secondScrollView;
@end

@implementation _60_AnimationViewController

- (UIScrollView *)scrollView {
    
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _scrollView.contentSize = CGSizeMake(0, kScreenHeight + 10);
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIScrollView *)secondScrollView {
    
    if (_secondScrollView == nil) {
        _secondScrollView = [[UIScrollView alloc] init];
//        _secondScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _secondScrollView.contentSize = CGSizeMake(0, kScreenHeight + 10);
//        _secondScrollView.delegate = self;
        
      
    }
    return _secondScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    isTop = YES;
    imgView = [[UIImageView alloc] init];
    [imgView setImage:[UIImage imageNamed:@"top"]];
    imgView.frame = CGRectMake(0, 0, kScreenWidth, 200);
    [self.view addSubview:imgView];
    
    
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = CGRectMake(0, 0, 100, 100);
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    //设置宽度和线的颜色
    self.shapeLayer.position = imgView.center;
    layerFrame = self.shapeLayer.frame;
    self.shapeLayer.lineWidth = 5;
    self.shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    //贝塞尔曲线
    UIBezierPath *bezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 100)];
    //关联
    self.shapeLayer.path = bezier.CGPath;
    [self.view.layer addSublayer:self.shapeLayer];

    
    
    
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    UIView *topPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 200)];
    imgFrame = topPanel.frame;
    [topPanel setBackgroundColor:[UIColor blueColor]];
    [self.scrollView addSubview:topPanel];
    
    
    notiLab = [[UILabel alloc] init];
    notiLab.text = @"上拉切换页面";
    notiLab.textAlignment = NSTextAlignmentCenter;
    notiLab.frame = CGRectMake(kScreenWidth/2 - 100, kScreenHeight + 10, 200, 20);
    [self.scrollView addSubview:notiLab];
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    notiLab.text = @"继续上拉切换界面";
    CGFloat y = scrollView.contentOffset.y;
    NSLog(@"%f",y);
    
    if (y < 0) {
        
        if (isTop) {
            CGRect frame = imgFrame;
            frame.origin.x = y/2;
            frame.origin.y = 0;
            
            frame.size.height = frame.size.height - y;
            frame.size.width = frame.size.width - y;
            imgView.frame = frame;
            
            POPBasicAnimation *bAnimal = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            bAnimal.toValue  = [NSValue valueWithCGSize:CGSizeMake(1 + -y/200, 1 + -y/200)];
            bAnimal.duration = .0f;
            bAnimal.delegate = self;
            [bAnimal removedOnCompletion];
            [self.shapeLayer pop_addAnimation:bAnimal forKey:nil];
            
        } else {
            
            if (y < 20) {
                isTop = YES;
                self.scrollView.delegate = self;
                self.secondScrollView.delegate = nil;
                [UIView animateWithDuration:1 animations:^{
                    self.secondScrollView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
                }];
                
            }

            
            
        }
        

    }
    if (y > 120) {
        
        if (isTop) {
            notiLab.text = @"即将切换界面";
        }
        
    }
    if (y > 130) {
      
        
        if (isTop) {
            isTop = NO;
            self.secondScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
            [self.secondScrollView setBackgroundColor:[UIColor purpleColor]];
            [self.view addSubview:self.secondScrollView];
            self.secondScrollView.contentSize = CGSizeMake(0, kScreenHeight + 10);
            self.scrollView.delegate = nil;
            self.secondScrollView.delegate = self;
            
            
            UIButton *button = [[UIButton alloc] init];
            [button setBackgroundImage:[UIImage imageNamed:@"little_sun"] forState:0];
            button.frame = CGRectMake(kScreenWidth / 2 - 60, kScreenHeight - 180, 120, 120);
            [_secondScrollView addSubview:button];
            
            [button addTarget:self action:@selector(animationClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [UIView animateWithDuration:1 animations:^{
                self.secondScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            }];
        }
    
        
    }
    
}



- (void)animationClick:(UIButton *)sender {
    
    UILabel *l = [self getLabelWithText:@"测试"];
    l.frame = CGRectMake(kScreenWidth/2 - 25, 0, 50, 30);
    [self.secondScrollView addSubview:l];
    
    
    POPBasicAnimation *spring =[POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    spring.toValue = @(l.center.y + 400);
    spring.beginTime = CACurrentMediaTime() + 1.0f;
    spring.duration  = 2;
    [l pop_addAnimation:spring forKey:@"position"];
    
    
}


- (UILabel *)getLabelWithText:(NSString *)text {
    UILabel *lab = [[UILabel alloc] init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = text;
    return lab;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
