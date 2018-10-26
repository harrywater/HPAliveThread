//
//  HPAliveThread.h
//  HPAliveThread
//
//  Created by 王辉平 on 2018/7/24.
//  Copyright © 2018年 王辉平. All rights reserved.
//

/**可控生命的线程 **/
#import <Foundation/Foundation.h>

@interface HPAliveThread : NSObject

//处理线程任务
- (void)doTask:(void(^)(void))task;

//停止
- (void)stop;

@end
