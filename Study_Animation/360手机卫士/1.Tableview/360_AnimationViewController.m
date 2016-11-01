//
//  360_AnimationViewController.m
//  Study_Animation
//
//  Created by LYY on 2016/10/8.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "360_AnimationViewController.h"
#import <pop/POP.h>

@interface _60_AnimationViewController () {
    
   
    CGRect imgFrame;
    CGRect layerFrame;
    UILabel *notiLab;
    BOOL isTop;
}

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
    self.imgView = [[UIImageView alloc] init];
    [self.imgView setImage:[UIImage imageNamed:@"top"]];
    self.imgView.frame = CGRectMake(0, 0, kScreenWidth, 200);
    [self.view addSubview:self.imgView];
    
    
    //顶部圆环
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = CGRectMake(0, 0, 100, 100);
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    //设置宽度和线的颜色
    self.shapeLayer.position = self.imgView.center;
    layerFrame = self.shapeLayer.frame;
    self.shapeLayer.lineWidth = 5;
    self.shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    //贝塞尔曲线
    UIBezierPath *bezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 100)];
    //关联
    self.shapeLayer.path = bezier.CGPath;
//    [self.view.layer addSublayer:self.shapeLayer];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth, 40, 60, 60)];
    [btn setBackgroundImage:[UIImage imageNamed:@"sun"] forState:UIControlStateNormal];
    
    
    
    
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
    
    
    UIButton *upBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 18, kScreenHeight - 25, 36, 36)];
    [upBtn setBackgroundImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    [self.scrollView addSubview:upBtn];
    
    [upBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
            self.imgView.frame = frame;
            
            POPBasicAnimation *bAnimal = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
            bAnimal.toValue  = [NSValue valueWithCGSize:CGSizeMake(1 + -y/200, 1 + -y/200)];
            bAnimal.duration = .0f;
            bAnimal.delegate = self;
            [bAnimal removedOnCompletion];
            [self.shapeLayer pop_addAnimation:bAnimal forKey:nil];
            
        } else {
            
            if (y < 20) {
                [self swapToUpView];
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
           
            [self swapView];
        }
    
        
    }
    
}


- (void)upBtnClick:(UIButton *)sender {

    [self swapView];
    
}
- (void)downClick:(UIButton *)sender {
    
    [self swapToUpView];
    
}




//上下抖动动画 -- 较为复杂...
- (void)animationClick:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    POPBasicAnimation *spring =[POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    spring.toValue = @(sender.center.y - 60);
    spring.beginTime = CACurrentMediaTime() + .0f;
    spring.duration  = .2;
    [sender pop_addAnimation:spring forKey:@"position"];
    [spring setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        POPBasicAnimation *spring2 =[POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        spring2.toValue = @(sender.center.y + 60);
        spring2.beginTime = CACurrentMediaTime() + .0f;
        spring2.duration  = .2;
        [sender pop_addAnimation:spring2 forKey:@"position"];
        [spring2 setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            POPBasicAnimation *spring2 =[POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
            spring2.toValue = @(sender.center.y - 20);
            spring2.beginTime = CACurrentMediaTime() + .0f;
            spring2.duration  = .1;
            [sender pop_addAnimation:spring2 forKey:@"position"];
            [spring2 setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                POPBasicAnimation *spring2 =[POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
                spring2.toValue = @(sender.center.y + 20);
                spring2.beginTime = CACurrentMediaTime() + .0f;
                spring2.duration  = .1;
                [sender pop_addAnimation:spring2 forKey:@"position"];
                [spring2 setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                    POPBasicAnimation *spring2 =[POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
                    spring2.toValue = @(sender.center.y - 10);
                    spring2.beginTime = CACurrentMediaTime() + .0f;
                    spring2.duration  = .05;
                    [sender pop_addAnimation:spring2 forKey:@"position"];
                    [spring2 setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                        POPBasicAnimation *spring2 =[POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
                        spring2.toValue = @(sender.center.y + 10);
                        spring2.beginTime = CACurrentMediaTime() + .0f;
                        spring2.duration  = .05;
                        [sender pop_addAnimation:spring2 forKey:@"position"];
                        sender.userInteractionEnabled = YES;
                    }];
                }];
            }];
        }];

        
    }];
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


- (void)swapView {
     isTop = NO;
    self.secondScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    [self.secondScrollView setBackgroundColor:[UIColor purpleColor]];
    [self.view addSubview:self.secondScrollView];
    self.secondScrollView.contentSize = CGSizeMake(0, kScreenHeight + 10);
    self.scrollView.delegate = nil;
    self.secondScrollView.delegate = self;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 18, 0, 36, 36)];
    [btn setBackgroundImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [self.secondScrollView addSubview:btn];
    [btn addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"sun"] forState:0];
    button.frame = CGRectMake(kScreenWidth / 2 - 60, kScreenHeight - 180, 120, 120);
    [_secondScrollView addSubview:button];
    
    [button addTarget:self action:@selector(animationClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:1 animations:^{
        self.secondScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
    
}

-(void) swapToUpView {
    
    isTop = YES;
    self.scrollView.delegate = self;
    self.secondScrollView.delegate = nil;
    [UIView animateWithDuration:1 animations:^{
        self.secondScrollView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    }];
}

@end
