//
//  HPSetViewController.m
//  HPAliveThread
//
//  Created by 王辉平 on 2018/7/24.
//  Copyright © 2018年 王辉平. All rights reserved.
//

#import "HPSetViewController.h"
#import "HPAliveThread.h"
@interface HPSetViewController ()
@property(nonatomic,strong)HPAliveThread* aliveThread;
@end

@implementation HPSetViewController

- (void)dealloc
{
    NSLog(@"%s",__func__);
    self.aliveThread = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.aliveThread = [[HPAliveThread alloc]init];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.aliveThread doTask:^{
        
        NSLog(@"HPAliveThread-我要开始工作啦");
    }];
}

- (IBAction)stopThreadAction:(id)sender {
    
    [self.aliveThread stop];
}

@end
