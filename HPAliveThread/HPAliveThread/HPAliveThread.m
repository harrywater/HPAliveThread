//
//  HPAliveThread.m
//  HPAliveThread
//
//  Created by 王辉平 on 2018/7/24.
//  Copyright © 2018年 王辉平. All rights reserved.
//

#import "HPAliveThread.h"

@interface HPAliveThread()
@property(nonatomic,strong)NSThread* thread;
//@property(nonatomic,assign)BOOL isStoped;
@end

@implementation HPAliveThread

//观察runLoop状态
void abserverRunLoopActivityFun(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry");
            break;
        case kCFRunLoopExit:
            NSLog(@"kCFRunLoopExit");
            break;
        default:
            break;
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.isStoped = NO;
//        __weak typeof(self)weakSelf = self;
        _thread = [[NSThread alloc]initWithBlock:^{
            //创建一个观察者
            CFRunLoopObserverContext observerContext = {0};
            CFRunLoopObserverRef abserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopEntry|kCFRunLoopExit, YES, 0, abserverRunLoopActivityFun, &observerContext);
            //添加观察者
            CFRunLoopAddObserver(CFRunLoopGetCurrent(), abserver, kCFRunLoopDefaultMode);
            CFRelease(abserver);
            
            //开启runLoop
//            NSRunLoop* loop = [NSRunLoop currentRunLoop];
//            [loop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
//
//            while (weakSelf && !weakSelf.isStoped) {
//                [loop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];//这个相当于CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, YES);也就是执行完loop里面的sources就会推出loop
//            }
            
            //简易代码 开启runLoop
            CFRunLoopSourceContext sourceContext  ={0};//需要初始化
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &sourceContext);
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            CFRelease(source);
            CFRunLoopRun();
            //CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);等价
            
            //线程即将挂掉...
            // RunLoop退出后移除自定义基于端口的源
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
        }];
    }
    return self;
}
#pragma mark --public method

- (void)doTask:(void(^)(void))task
{
    if (!self.thread.executing && task) {
        [self.thread start];
    }
    [self performSelector:@selector(__innerThreadTask:) onThread:self.thread withObject:task waitUntilDone:NO];
}

- (void)stop
{
    if (!self.thread) return;
    [self performSelector:@selector(__stop) onThread:self.thread withObject:nil waitUntilDone:YES];//注意YES 要等thread先停止后在销毁
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
    [self stop];//销毁线程
}

#pragma mark --private method

- (void)__stop
{
//    self.isStoped = YES;
    //停止runLoop 线程保活结束
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.thread = nil;
}

- (void)__innerThreadTask:(void(^)(void))task
{
    //执行task
    task();
}

@end
